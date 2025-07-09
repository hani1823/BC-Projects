codeunit 50131 "Foodics Integration Mgr"
{
    SingleInstance = true;

    trigger OnRun()
    var
        BusinessDate: Date;
    begin
        BusinessDate := CalcDate('-1D', Today);

        // 1) Run every import for that date
        ImportOrdersForDate(BusinessDate);
        ImportPurchasingForDate(BusinessDate);
        ImportConsumptionForDate(BusinessDate);
        ImportTransferReceivingForDate(BusinessDate);
        ImportTransferSendingForDate(BusinessDate);
        ImportQuantityAdjustmentForDate(BusinessDate);
        ImportReturnfromOrderForDate(BusinessDate);
        ImportInventoryCountsForDate(BusinessDate);
        ImportCostAdjustmentsForDate(BusinessDate);

        // 2) post the journals
        PostGeneralJournalBatch('GENERAL', 'CONS 001', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'CONS 002', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'COST ADJ', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'INV.COUNTS', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'QUA.ADJUST', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'RETURN FRO', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'SALES 001', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'SALES 002', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'TRS RECEV', BusinessDate);
        PostGeneralJournalBatch('GENERAL', 'TRS SEND', BusinessDate);
    end;

    local procedure PostGeneralJournalBatch(TemplateName: Code[10]; BatchName: Code[10]; BusinessDate: Date)
    var
        PostBatch: Codeunit "Gen. Jnl.-Post Batch";
        GenJnlLine: Record "Gen. Journal Line";
        CheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", TemplateName);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);
        GenJnlLine.SetRange("Posting Date", BusinessDate);

        if not GenJnlLine.FindFirst() then
            exit;

        CheckLine.RunCheck(GenJnlLine);

        PostBatch.Run(GenJnlLine);
    end;

    procedure ImportOrdersForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        if not Branch.FindSet() then
            Error('No Foodics branches defined.');

        repeat
            ImportBranch(Setup, Branch, BusinessDate);
            Sleep(500);
        until Branch.Next() = 0;
    end;

    procedure ImportPurchasingForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Purchase Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        ImportPurchases(Setup, Branch, BusinessDate);
    end;

    procedure ImportConsumptionForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Consumption Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        if not Branch.FindSet() then
            Error('No Foodics branches defined.');

        repeat
            ImportConsumption(Setup, Branch, BusinessDate);
            Sleep(500);
        until Branch.Next() = 0;
    end;

    procedure ImportTransferReceivingForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Purchase Branch";
        OtherBranch: Record "Foodics Purchase Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        ImportTransferReceiving(Setup, Branch, OtherBranch, BusinessDate);
    end;

    procedure ImportTransferSendingForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Purchase Branch";
        OtherBranch: Record "Foodics Purchase Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        ImportTransferSending(Setup, Branch, OtherBranch, BusinessDate);
    end;

    procedure ImportQuantityAdjustmentForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Purchase Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        ImportQuantityAdjustment(Setup, Branch, BusinessDate);
    end;

    procedure ImportReturnfromOrderForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Purchase Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        ImportReturnfromOrder(Setup, Branch, BusinessDate);
    end;

    procedure ImportInventoryCountsForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Purchase Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        ImportInventoryCounts(Setup, Branch, BusinessDate);
    end;

    procedure ImportCostAdjustmentsForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Purchase Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        ImportCostAdjustments(Setup, Branch, BusinessDate);
    end;


    local procedure SendWithRetry(var BaseUrl: Text; Setup: Record "Foodics Setup"; Client: HttpClient; var Response: HttpResponseMessage)
    var
        Request: HttpRequestMessage;
        Headers: HttpHeaders;
        RespHeaders: HttpHeaders;
        RetryVals: List of [Text];
        RetryTxt: Text;
        RetrySec: Integer;
        MaxAttempts: Integer;
    begin
        MaxAttempts := 2;          // المحاولة الأولى + إعادة واحدة
        repeat
            // --- أنشئ رسالة جديدة كل مرة ---
            Clear(Request);
            Request.Method := 'GET';
            Request.SetRequestUri(BaseUrl);
            Request.GetHeaders(Headers);
            Headers.Add('Authorization', 'Bearer ' + DELCHR(Setup."API Token", '<>', ' '));
            Headers.Add('Accept', 'application/json');


            if not Client.Send(Request, Response) then
                Error('Connection error.');

            if (Response.HttpStatusCode <> 429) or (MaxAttempts = 1) then
                exit;              // نجاح أو استهلكنا كل المحاولات

            // ----- 429: اقرأ Retry-After -----
            RespHeaders := Response.Headers();
            if RespHeaders.GetValues('Retry-After', RetryVals) then begin
                RetryVals.Get(1, RetryTxt);
                if Evaluate(RetrySec, RetryTxt) then
                    Sleep(RetrySec * 1000)
                else
                    Sleep(10000);
            end else
                Sleep(10000);

            MaxAttempts -= 1;      // حاول مرة أخرى برسالة جديدة
        until false;

        // لو خرج من اللوب بدون Exit نرمي خطأ
        Error('Foodics still returns 429 after retry.');
    end;

    local procedure setAccounts(PayName: Text; Branch: Record "Foodics Branch"; var AccType: Enum "Gen. Journal Account Type"; var AccNo: Code[20])
    var
        FA: Record "Foodics Accounts";
    begin
        FA.SetRange("Account Name", PayName);
        FA.SetRange("Branch Name", Branch."Branch Id");
        if not FA.FindFirst() then begin
            // 2) لم يوجد – ابحث عن السطر العام
            FA.Reset();
            FA.SetRange("Account Name", PayName);
            FA.SetRange("Branch Name", '');   // سطر بدون فرع
            if not FA.FindFirst() then
                Error('Foodics Account "%1" غير مُعرَّف فى الإعدادات.', PayName);
        end;

        AccType := FA."Account Type";
        AccNo := FA."Account No.";
    end;

    //======================= Import Orders =======================================
    local procedure ImportBranch(
    Setup: Record "Foodics Setup";
    var Branch: Record "Foodics Branch";
    BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        SubTok: JsonToken;
        VATTok: JsonToken;
        MetaTok: JsonToken;
        PayArr: JsonArray;
        PayObj: JsonObject;
        PayTok, PItemTok : JsonToken;
        PayNameTok, AmtTok : JsonToken;

        Total: Decimal;
        VatTotal: Decimal;
        DiscountTotal: Decimal;
        NetLine, VatLine : Decimal;
        Subtotal, Discount, Gross, NetTotal : Decimal;


        Sign: Integer;
        BaseUrl: Text;
        CurrUrl: Text;
        MTxt, DTxt, DateTxt : Text[10];
        PaymentSums: Dictionary of [Text, Decimal];   // Key = payment name   Value = total

        // متغيرات الـ Retry-After
        RetryTxt: Text;
        RetrySec: Integer;
        RetryVals: List of [Text];
        RespHeaders: HttpHeaders;

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        DocNo: Code[20];
        PayDocNo: Code[20];
        DiscountDocNo: Code[20];
        PayName: Text;
        AmtDec: Decimal;
        AmtDecTmp: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;
        KeyList: List of [Text];
    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/orders?filter[branch_id]=%2&filter[business_date]=%3&include=payments.payment_method&page=',
                              Setup."Base URL", Branch."Branch Id", DateTxt);


        Total := 0;
        VatTotal := 0;
        pageNo := 1;
        LastPage := 1;
        Clear(PaymentSums);

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // -------- data[] ------------------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    Sign := 1;
                    if OneTok.AsObject().Get('status', ValTok) and ValTok.IsValue() then begin
                        if (ValTok.AsValue().AsInteger() = 5) then
                            Sign := -1;

                        // 2.1  add order-level subtotal_price
                        if OneTok.AsObject().Get('subtotal_price', ValTok) and ValTok.IsValue() then
                            Total += Sign * ValTok.AsValue().AsDecimal();

                        // 2.2 Discount  = subtotal_price - discount_amount
                        if OneTok.AsObject().Get('tax_exclusive_discount_amount', ValTok) and ValTok.IsValue() and (ValTok.AsValue().AsDecimal() <> 0) then
                            DiscountTotal += Sign * ValTok.AsValue().AsDecimal();

                        // 2.3 VAT  = total_price – subtotal_price
                        if OneTok.AsObject().Get('total_price', ValTok) and ValTok.IsValue()
                          and OneTok.AsObject().Get('subtotal_price', SubTok) and SubTok.IsValue() then
                            if OneTok.AsObject().Get('tax_exclusive_discount_amount', VATTok) and VATTok.IsValue() and (VATTok.AsValue().AsDecimal() = 0) then
                                VatTotal += Sign * (ValTok.AsValue().AsDecimal() - SubTok.AsValue().AsDecimal())
                            else
                                VatTotal += Sign * (ValTok.AsValue().AsDecimal() - VATTok.AsValue().AsDecimal());

                        // 2.4  NEW ► handle payments[]
                        // --- داخل foreach OneTok in Arr do begin  (تأكّد أنها داخل الحلقة!)
                        if OneTok.AsObject().Get('payments', PayTok) then begin
                            PayArr := PayTok.AsArray();
                            foreach PItemTok in PayArr do begin
                                if PItemTok.IsObject() then begin
                                    PayObj := PItemTok.AsObject();

                                    // ===== المبلغ =====
                                    AmtDec := 0;

                                    // 1) meta.amount
                                    if PayObj.Get('meta', MetaTok) and MetaTok.IsObject() then
                                        if MetaTok.AsObject().Get('amount', AmtTok) and AmtTok.IsValue() then
                                            Evaluate(AmtDec, AmtTok.AsValue().AsText());

                                    // 2) fallback amount مباشر
                                    if (AmtDec = 0) and PayObj.Get('amount', AmtTok) and AmtTok.IsValue() then
                                        Evaluate(AmtDec, AmtTok.AsValue().AsText());

                                    // ===== اسم وسيلة الدفع =====
                                    PayName := 'Unknown';
                                    if PayObj.Get('payment_method', PayTok) and PayTok.IsObject() then
                                        if PayTok.AsObject().Get('name', PayNameTok) and PayNameTok.IsValue() then
                                            PayName := PayNameTok.AsValue().AsText();

                                    // ===== تجميع في القاموس =====
                                    if PaymentSums.ContainsKey(PayName) then begin
                                        PaymentSums.Get(PayName, AmtDecTmp);          // القيمة السابقة
                                        PaymentSums.Set(PayName, AmtDecTmp + AmtDec); // تحديث
                                    end else
                                        PaymentSums.Add(PayName, AmtDec);
                                end;
                            end;
                        end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;


        if (Total = 0) or (VatTotal = 0) then
            exit;

        DocNo := NoSeries.GetNextNo('GJNL-GEN');

        Total := ROUND(Total, 0.01, '=');
        VatTotal := ROUND(VatTotal, 0.01, '=');
        DiscountTotal := ROUND(DiscountTotal, 0.01, '=');

        GL.Reset();
        GL.SetRange("Journal Template Name", Branch."Journal Template Name");
        GL.SetRange("Journal Batch Name", Branch."Journal Batch Name");

        // Foodics Sales Journal
        GL.Init();
        GL.Validate("Document Type", GL."Document Type"::Invoice);
        GL."Document No." := DocNo;
        GL."Journal Template Name" := Branch."Journal Template Name";
        GL."Journal Batch Name" := Branch."Journal Batch Name";
        GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
        GL."Posting Date" := BusinessDate;
        GL."Document Date" := BusinessDate;
        GL.Description := StrSubstNo('Foodics Sales for %1 %2', Branch.Name, DateTxt);
        GL.Validate("Currency Code", 'SAR');
        setAccounts('Foodics Sales', branch, GL."Account Type", GL."Account No.");
        GL.Validate(Amount, -Total);
        GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
        GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
        GL.Insert(true);

        // --- VAT ---
        GL.Init();
        GL.Validate("Document Type", GL."Document Type"::Invoice);
        GL."Document No." := DocNo;
        GL."Journal Template Name" := Branch."Journal Template Name";
        GL."Journal Batch Name" := Branch."Journal Batch Name";
        GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
        GL."Posting Date" := BusinessDate;
        GL."Document Date" := BusinessDate;
        GL.Description := StrSubstNo('VAT for %1 %2', Branch.Name, DateTxt);
        GL.Validate("Currency Code", 'SAR');
        setAccounts('Foodics Sales VAT', Branch, GL."Account Type", GL."Account No.");
        GL.Validate(Amount, -(VatTotal));
        GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
        GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
        GL.Insert(true);

        // ------- Debit AR (positive) -------
        GL.Init();
        GL.Validate("Document Type", GL."Document Type"::Invoice);
        GL."Document No." := DocNo;
        GL."Journal Template Name" := Branch."Journal Template Name";
        GL."Journal Batch Name" := Branch."Journal Batch Name";
        GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
        GL."Posting Date" := BusinessDate;
        GL.Description := StrSubstNo('Account Receivable %1 %2', Branch.Name, DateTxt);
        GL.Validate("Currency Code", 'SAR');
        setAccounts('Account Receivable Foodics', Branch, GL."Account Type", GL."Account No.");
        GL.Validate(Amount, (Total + VatTotal) - DiscountTotal);
        GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
        GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
        GL.Insert(true);

        // --- Discount ---
        if DiscountTotal <> 0 then begin
            GL.Init();
            GL.Validate("Document Type", GL."Document Type"::Invoice);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := Branch."Journal Template Name";
            GL."Journal Batch Name" := Branch."Journal Batch Name";
            GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
            GL."Posting Date" := BusinessDate;
            GL."Document Date" := BusinessDate;
            GL.Description := StrSubstNo('Foodics Discount for %1 %2', Branch.Name, DateTxt);
            GL.Validate("Currency Code", 'SAR');
            setAccounts('Foodics Discount', Branch, GL."Account Type", GL."Account No.");
            GL.Validate(Amount, DiscountTotal);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);
        end;

        KeyList := PaymentSums.Keys;
        foreach PayName in KeyList do begin
            PaymentSums.Get(PayName, AmtDec);
            if AmtDec <> 0 then begin
                PayDocNo := NoSeries.GetNextNo('GJNL-GEN');

                // ------- Debit AR (positive) -------
                GL.Init();
                GL.Validate("Document Type", GL."Document Type"::Invoice);
                GL."Document No." := PayDocNo;
                GL."Journal Template Name" := Branch."Journal Template Name";
                GL."Journal Batch Name" := Branch."Journal Batch Name";
                GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
                GL."Posting Date" := BusinessDate;
                GL.Description := StrSubstNo('Account Receivable for %1 %2 %3', PayName, Branch.Name, DateTxt);
                GL.Validate("Currency Code", 'SAR');
                setAccounts('Account Receivable Foodics', Branch, GL."Account Type", GL."Account No.");
                GL.Validate(Amount, -AmtDec);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);

                // ------- Credit AR (Negative) -------
                GL.Init();
                GL.Validate("Document Type", GL."Document Type"::Invoice);
                GL."Document No." := PayDocNo;
                GL."Journal Template Name" := Branch."Journal Template Name";
                GL."Journal Batch Name" := Branch."Journal Batch Name";
                GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
                GL."Posting Date" := BusinessDate;
                GL.Description := StrSubstNo('%1 %2 %3', PayName, Branch.Name, DateTxt);
                GL.Validate("Currency Code", 'SAR');
                setAccounts(PayName, Branch, GL."Account Type", GL."Account No.");
                GL.Validate(Amount, AmtDec);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);
            end;
        end;
    end;

    ///////////// Purchase Orders //////////////////////
    local procedure ImportPurchases(
    Setup: Record "Foodics Setup";
    var Branch: Record "Foodics Purchase Branch";
    BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok, vendorTok : JsonToken;

        BranchName: Text;
        BranchID: Text[100];
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        PurchCost: Dictionary of [Text, Decimal];
        PurchVAT: Dictionary of [Text, Decimal];
        PurchVend: Dictionary of [Text, Code[20]];
        PurchBrID: Dictionary of [Text, Text[100]];

        GL: Record "Gen. Journal Line";
        PurcInvHeader: Record "Purchase Header";
        PurcInvLine: Record "Purchase line";
        VendorRec: Record Vendor;
        NoSeries: Codeunit "No. Series";
        "Purchase No.": Text;
        PaidTax: Decimal;
        VendorCode: code[20];
        VendorName: Text[100];
        VendorPhone: Text[30];
        costWithoutVAT: Decimal;
        VatTotal: Decimal;
        NetTotal: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;

    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/inventory_transactions?filter[type]=1&filter[business_date]=%2&include=items, branch, supplier&page=',
                              Setup."Base URL", DateTxt);


        pageNo := 1;
        LastPage := 1;

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // ----------------------- data[] --------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    PaidTax := 0;
                    VendorCode := '';
                    "Purchase No." := '';
                    BranchID := '';
                    costWithoutVAT := 0;

                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Vendor Details
                    if OneTok.AsObject().Get('supplier', vendorTok) then begin
                        if vendorTok.AsObject().Get('code', ValTok) and ValTok.IsValue() then
                            VendorCode := ValTok.AsValue().AsText();

                        if vendorTok.AsObject().Get('name', ValTok) and ValTok.IsValue() then
                            VendorName := ValTok.AsValue().AsText();

                        if vendorTok.AsObject().Get('phone', ValTok) and ValTok.IsValue() then
                            VendorPhone := ValTok.AsValue().AsText();
                    end;

                    if not VendorRec.Get(VendorCode) then begin
                        VendorRec.Init();
                        VendorRec.Validate("No.", VendorCode);
                        VendorRec.Validate(Name, VendorName);
                        VendorRec."Phone No." := VendorPhone;
                        VendorRec.Validate("Gen. Bus. Posting Group", 'DOMESTIC');
                        VendorRec.Validate("Vendor Posting Group", 'DOMESTIC');
                        VendorRec.Validate("VAT Bus. Posting Group", 'DOMESTIC');
                        VendorRec."Currency Code" := 'SAR';
                        VendorRec.Insert();
                    end;

                    // 2.3  Purchase Order Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Purchase No." := ValTok.AsValue().AsText();

                    if OneTok.AsObject().Get('paid_tax', ValTok) and ValTok.IsValue() then
                        PaidTax := ValTok.AsValue().AsDecimal();

                    if not PurchVend.ContainsKey("Purchase No.") then begin
                        PurchVend.Add("Purchase No.", VendorCode);
                        PurchBrID.Add("Purchase No.", BranchID);
                    end;

                    if PurchVAT.ContainsKey("Purchase No.") then begin
                        PurchVAT.Get("Purchase No.", VatTotal);
                        PurchVAT.Set("Purchase No.", VatTotal + ROUND(PaidTax, 0.01, '='));
                    end else
                        PurchVAT.Add("Purchase No.", ROUND(PaidTax, 0.01, '='));

                    // 2.4  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin
                                    if PivotTok.AsObject().Get('cost', ValTok) and ValTok.IsValue() then begin
                                        costWithoutVAT := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                        if PurchCost.ContainsKey("Purchase No.") then begin
                                            PurchCost.Get("Purchase No.", NetTotal);
                                            PurchCost.Set("Purchase No.", NetTotal + costWithoutVAT);
                                        end else
                                            PurchCost.Add("Purchase No.", costWithoutVAT);
                                    end;
                                end;
                            end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        foreach "Purchase No." in PurchCost.Keys do begin
            PurchCost.Get("Purchase No.", NetTotal);
            PurchBrID.Get("Purchase No.", BranchID);
            PurchVend.Get("Purchase No.", VendorCode);

            if PurchVAT.ContainsKey("Purchase No.") then
                PurchVAT.Get("Purchase No.", VatTotal)
            else
                VatTotal := 0;

            if not Branch.Get(BranchID) then
                Error('Branch with ID %1 not found in Foodics Branches.', BranchID);

            // Purchase Invoice Header
            Clear(PurcInvHeader);
            PurcInvHeader.Init();
            PurcInvHeader.Validate("Document Type", PurcInvHeader."Document Type"::Invoice);
            PurcInvHeader."No." := NoSeries.GetNextNo('P-INV');
            PurcInvHeader.Validate("Posting Date", BusinessDate);
            //PurcInvHeader.Validate("Document Date", BusinessDate);
            PurcInvHeader.Validate("Buy-from Vendor No.", VendorCode);
            PurcInvHeader.Validate("Currency Code", 'SAR');
            PurcInvHeader.Insert(true);

            //Purchase Invoice Lines
            Clear(PurcInvLine);
            PurcInvLine.Init();
            PurcInvLine.Validate("Document Type", PurcInvLine."Document Type"::Invoice);
            PurcInvLine."Document No." := PurcInvHeader."No.";
            PurcInvLine.Type := PurcInvLine.Type::"G/L Account";
            PurcInvLine.Validate("No.", '11400121');
            PurcInvLine.Description := StrSubstNo('Foodics Purchasing for %1', "Purchase No.");
            PurcInvLine.Validate(Quantity, 1);
            PurcInvLine.Validate("Unit of Measure Code", 'PCS');
            PurcInvLine.Validate("Direct Unit Cost", NetTotal);
            if VatTotal <> 0 then
                PurcInvLine.Validate("Gen. Prod. Posting Group", 'MISC')
            else
                PurcInvLine.Validate("Gen. Prod. Posting Group", 'NO VAT');
            PurcInvLine.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            PurcInvLine.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            PurcInvLine.Insert(true);

        end;
    end;


    ///////////// Consumption //////////////////////
    local procedure ImportConsumption(
    Setup: Record "Foodics Setup";
    var Branch: Record "Foodics Consumption Branch";
    BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok, vendorTok : JsonToken;

        BranchName: Text;
        BranchID: Text;
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        BranchRec: Record "Foodics Branch";
        DocNo: Code[20];
        "Consumption No.": Text;
        ItemName: Text;
        quantity: Decimal;
        costWithoutVAT: Decimal;
        TotalCostWithoutVAT: Decimal;
        ItemNames: List of [Text];
        ItemTotalsQty: Dictionary of [Text, Decimal];
        ItemTotalsCost: Dictionary of [Text, Decimal];
        q, c : Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;
    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/inventory_transactions?filter[branch_id]=%2&filter[type]=8&filter[business_date]=%3&include=items, branch&page=',
                              Setup."Base URL", Branch."Branch Id", DateTxt);

        pageNo := 1;
        LastPage := 1;
        Clear(ItemTotalsQty);
        Clear(ItemTotalsCost);

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // -------- data[] ------------------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin


                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Consumption Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Consumption No." := ValTok.AsValue().AsText();

                    // 2.3  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do begin
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('name', ValTok) and ValTok.IsValue() then
                                    ItemName := ValTok.AsValue().AsText();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin
                                    if PivotTok.AsObject().Get('quantity', ValTok) and ValTok.IsValue() then
                                        quantity := ValTok.AsValue().AsDecimal();

                                    if PivotTok.AsObject().Get('cost', ValTok) and ValTok.IsValue() then begin
                                        costWithoutVAT := ValTok.AsValue().AsDecimal();

                                        if ItemTotalsQty.ContainsKey(ItemName) then begin
                                            ItemTotalsQty.Get(ItemName, q);
                                            ItemTotalsQty.Set(ItemName, q + quantity);

                                            ItemTotalsCost.Get(ItemName, c);
                                            ItemTotalsCost.Set(ItemName, c + costWithoutVAT);
                                        end else begin
                                            ItemTotalsQty.Add(ItemName, quantity);
                                            ItemTotalsCost.Add(ItemName, costWithoutVAT);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        DocNo := NoSeries.GetNextNo('GJNL-GEN');

        GL.Reset();
        GL.SetRange("Journal Template Name", Branch."Journal Template Name");
        GL.SetRange("Journal Batch Name", Branch."Journal Batch Name");

        TotalCostWithoutVAT := 0;
        Clear(ItemNames);
        ItemNames := ItemTotalsQty.Keys;
        foreach ItemName in ItemNames do begin
            ItemTotalsQty.Get(ItemName, q);
            ItemTotalsCost.Get(ItemName, c);
            c := ROUND(c, 0.01, '=');
            TotalCostWithoutVAT += c;

            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := Branch."Journal Template Name";
            GL."Journal Batch Name" := Branch."Journal Batch Name";
            GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
            GL."Posting Date" := BusinessDate;
            setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 with quantity %2', ItemName, q);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, -c);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);
        end;

        // Foodics Consumption Journal
        GL.Init();
        //GL.Validate("Document Type", GL."Document Type"::Payment);
        GL."Document No." := DocNo;
        GL."Journal Template Name" := Branch."Journal Template Name";
        GL."Journal Batch Name" := Branch."Journal Batch Name";
        GL."Line No." := GL.GetNewLineNo(Branch."Journal Template Name", Branch."Journal Batch Name");
        GL."Posting Date" := BusinessDate;
        setAccounts('Foodics Consumption', BranchRec, GL."Account Type", GL."Account No.");
        GL.Description := StrSubstNo('Foodics Total Consumption for %1 %2', Branch.Name, DateTxt);
        GL.Validate("Currency Code", 'SAR');
        GL.Validate(Amount, TotalCostWithoutVAT);
        GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
        GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
        GL.Insert(true);

    end;

    ///////////// Transfer Receiving //////////////////////
    local procedure ImportTransferReceiving(
    Setup: Record "Foodics Setup";
    var Branch: Record "Foodics Purchase Branch";
    var OtherBranch: Record "Foodics Purchase Branch";
    BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok, otherBranchTok : JsonToken;

        BranchName: Text;
        BranchID: Text[100];
        OtherBranchID: Text[100];
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        PurchCost: Dictionary of [Text, Decimal];
        PurchOtherBrID: Dictionary of [Text, Text[100]];
        PurchBrID: Dictionary of [Text, Text[100]];

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        BranchRec: Record "Foodics Branch";
        DocNo: Code[20];
        "Reference No.": Text;
        costWithoutVAT: Decimal;
        NetTotal: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;

    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/inventory_transactions?filter[type]=6&filter[business_date]=%2&include=items, branch, other_branch&page=',
                              Setup."Base URL", DateTxt);


        pageNo := 1;
        LastPage := 1;

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // ----------------------- data[] --------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    "Reference No." := '';
                    BranchID := '';
                    OtherBranchID := '';
                    NetTotal := 0;
                    costWithoutVAT := 0;

                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Other Branch Id
                    if OneTok.AsObject().Get('other_branch', otherBranchTok) then
                        if otherBranchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            OtherBranchID := ValTok.AsValue().AsText();

                    // 2.3  Purchase Order Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Reference No." := ValTok.AsValue().AsText();

                    if not PurchOtherBrID.ContainsKey("Reference No.") then begin
                        PurchOtherBrID.Add("Reference No.", OtherBranchID);
                        PurchBrID.Add("Reference No.", BranchID);
                    end;

                    // 2.4  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin
                                    if PivotTok.AsObject().Get('cost', ValTok) and ValTok.IsValue() then begin
                                        costWithoutVAT := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                        if PurchCost.ContainsKey("Reference No.") then begin
                                            PurchCost.Get("Reference No.", NetTotal);
                                            PurchCost.Set("Reference No.", NetTotal + costWithoutVAT);
                                        end else
                                            PurchCost.Add("Reference No.", costWithoutVAT);
                                    end;
                                end;
                            end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        DocNo := NoSeries.GetNextNo('GJNL-GEN');

        GL.Reset();
        GL.SetRange("Journal Template Name", 'GENERAL');
        GL.SetRange("Journal Batch Name", 'TRS RECEV');

        foreach "Reference No." in PurchCost.Keys do begin
            PurchCost.Get("Reference No.", NetTotal);
            PurchBrID.Get("Reference No.", BranchID);
            PurchOtherBrID.Get("Reference No.", OtherBranchID);

            if not Branch.Get(BranchID) then
                Error('Branch with ID %1 not found in Foodics Branches.', BranchID);

            if not OtherBranch.Get(OtherBranchID) then
                Error('Other Branch with ID %1 not found in Foodics Branches.', OtherBranchID);

            DocNo := NoSeries.GetNextNo('GJNL-GEN');

            // Foodics Transfer Receiving Journal
            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'TRS RECEV';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'TRS RECEV');
            GL."Posting Date" := BusinessDate;
            setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);

            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'TRS RECEV';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'TRS RECEV');
            GL."Posting Date" := BusinessDate;
            setAccounts('Foodics Transfer Receiving', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", OtherBranch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, -NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", OtherBranch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", OtherBranch."Branch Code");
            GL.Insert(true);
        end;
    end;

    ///////////// Transfer Sending //////////////////////
    local procedure ImportTransferSending(
        Setup: Record "Foodics Setup";
        var Branch: Record "Foodics Purchase Branch";
        var OtherBranch: Record "Foodics Purchase Branch";
        BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok, otherBranchTok : JsonToken;

        BranchName: Text;
        BranchID: Text[100];
        OtherBranchID: Text[100];
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        PurchCost: Dictionary of [Text, Decimal];
        PurchOtherBrID: Dictionary of [Text, Text[100]];
        PurchBrID: Dictionary of [Text, Text[100]];

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        BranchRec: Record "Foodics Branch";
        DocNo: Code[20];
        "Reference No.": Text;
        costWithoutVAT: Decimal;
        NetTotal: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;

    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/inventory_transactions?filter[type]=2&filter[business_date]=%2&include=items, branch, other_branch&page=',
                              Setup."Base URL", DateTxt);


        pageNo := 1;
        LastPage := 1;

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // ----------------------- data[] --------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    "Reference No." := '';
                    BranchID := '';
                    OtherBranchID := '';
                    NetTotal := 0;
                    costWithoutVAT := 0;

                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Other Branch Id
                    if OneTok.AsObject().Get('other_branch', otherBranchTok) then
                        if otherBranchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            OtherBranchID := ValTok.AsValue().AsText();

                    // 2.3  Purchase Order Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Reference No." := ValTok.AsValue().AsText();

                    if not PurchOtherBrID.ContainsKey("Reference No.") then begin
                        PurchOtherBrID.Add("Reference No.", OtherBranchID);
                        PurchBrID.Add("Reference No.", BranchID);
                    end;

                    // 2.4  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin
                                    if PivotTok.AsObject().Get('cost', ValTok) and ValTok.IsValue() then begin
                                        costWithoutVAT := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                        if PurchCost.ContainsKey("Reference No.") then begin
                                            PurchCost.Get("Reference No.", NetTotal);
                                            PurchCost.Set("Reference No.", NetTotal + costWithoutVAT);
                                        end else
                                            PurchCost.Add("Reference No.", costWithoutVAT);
                                    end;
                                end;
                            end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        DocNo := NoSeries.GetNextNo('GJNL-GEN');

        GL.Reset();
        GL.SetRange("Journal Template Name", 'GENERAL');
        GL.SetRange("Journal Batch Name", 'TRS SEND');

        foreach "Reference No." in PurchCost.Keys do begin
            PurchCost.Get("Reference No.", NetTotal);
            PurchBrID.Get("Reference No.", BranchID);
            PurchOtherBrID.Get("Reference No.", OtherBranchID);

            if not Branch.Get(BranchID) then
                Error('Branch with ID %1 not found in Foodics Branches.', BranchID);

            if not OtherBranch.Get(OtherBranchID) then
                Error('Other Branch with ID %1 not found in Foodics Branches.', OtherBranchID);

            DocNo := NoSeries.GetNextNo('GJNL-GEN');

            // Foodics Transfer Sending Journal

            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'TRS SEND';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'TRS SEND');
            GL."Posting Date" := BusinessDate;
            setAccounts('Foodics Transfer Sending', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", OtherBranch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", OtherBranch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", OtherBranch."Branch Code");
            GL.Insert(true);

            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'TRS SEND';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'TRS SEND');
            GL."Posting Date" := BusinessDate;
            setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, -NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);


        end;
    end;

    ///////////// Quantity Adjustment //////////////////////
    local procedure ImportQuantityAdjustment(
        Setup: Record "Foodics Setup";
        var Branch: Record "Foodics Purchase Branch";
        BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok : JsonToken;

        BranchName: Text;
        BranchID: Text[100];
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        PurchCost: Dictionary of [Text, Decimal];
        PurchBrID: Dictionary of [Text, Text[100]];

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        BranchRec: Record "Foodics Branch";
        DocNo: Code[20];
        "Reference No.": Text;
        costWithoutVAT: Decimal;
        NetTotal: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;

    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/inventory_transactions?filter[type]=3&filter[business_date]=%2&include=items, branch &page=',
                              Setup."Base URL", DateTxt);


        pageNo := 1;
        LastPage := 1;

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // ----------------------- data[] --------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    "Reference No." := '';
                    BranchID := '';
                    NetTotal := 0;
                    costWithoutVAT := 0;

                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Quantity Adjustment Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Reference No." := ValTok.AsValue().AsText();

                    if not PurchBrID.ContainsKey("Reference No.") then begin
                        PurchBrID.Add("Reference No.", BranchID);
                    end;

                    // 2.4  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin
                                    if PivotTok.AsObject().Get('cost', ValTok) and ValTok.IsValue() then begin
                                        costWithoutVAT := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                        if PurchCost.ContainsKey("Reference No.") then begin
                                            PurchCost.Get("Reference No.", NetTotal);
                                            PurchCost.Set("Reference No.", NetTotal + costWithoutVAT);
                                        end else
                                            PurchCost.Add("Reference No.", costWithoutVAT);
                                    end;
                                end;
                            end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        GL.Reset();
        GL.SetRange("Journal Template Name", 'GENERAL');
        GL.SetRange("Journal Batch Name", 'QUA.ADJUST');

        foreach "Reference No." in PurchCost.Keys do begin
            PurchCost.Get("Reference No.", NetTotal);
            PurchBrID.Get("Reference No.", BranchID);

            if not Branch.Get(BranchID) then
                Error('Branch with ID %1 not found in Foodics Branches.', BranchID);

            DocNo := NoSeries.GetNextNo('GJNL-GEN');

            // Foodics Quantity Adjustment Journal
            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'QUA.ADJUST';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'QUA.ADJUST');
            GL."Posting Date" := BusinessDate;
            setAccounts('Foodics Quantity Adjustment', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);

            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'QUA.ADJUST';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'QUA.ADJUST');
            GL."Posting Date" := BusinessDate;
            setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, -NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);
        end;
    end;

    ///////////// Return from Order //////////////////////
    local procedure ImportReturnfromOrder(
        Setup: Record "Foodics Setup";
        var Branch: Record "Foodics Purchase Branch";
        BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok : JsonToken;

        BranchName: Text;
        BranchID: Text[100];
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        PurchCost: Dictionary of [Text, Decimal];
        PurchBrID: Dictionary of [Text, Text[100]];

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        BranchRec: Record "Foodics Branch";
        DocNo: Code[20];
        "Reference No.": Text;
        costWithoutVAT: Decimal;
        NetTotal: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;

    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/inventory_transactions?filter[type]=9&filter[business_date]=%2&include=items, branch &page=',
                              Setup."Base URL", DateTxt);


        pageNo := 1;
        LastPage := 1;

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // ----------------------- data[] --------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    "Reference No." := '';
                    BranchID := '';
                    NetTotal := 0;
                    costWithoutVAT := 0;

                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Return from Order Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Reference No." := ValTok.AsValue().AsText();

                    if not PurchBrID.ContainsKey("Reference No.") then begin
                        PurchBrID.Add("Reference No.", BranchID);
                    end;

                    // 2.4  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin
                                    if PivotTok.AsObject().Get('cost', ValTok) and ValTok.IsValue() then begin
                                        costWithoutVAT := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                        if PurchCost.ContainsKey("Reference No.") then begin
                                            PurchCost.Get("Reference No.", NetTotal);
                                            PurchCost.Set("Reference No.", NetTotal + costWithoutVAT);
                                        end else
                                            PurchCost.Add("Reference No.", costWithoutVAT);
                                    end;
                                end;
                            end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        GL.Reset();
        GL.SetRange("Journal Template Name", 'GENERAL');
        GL.SetRange("Journal Batch Name", 'RETURN FRO');

        foreach "Reference No." in PurchCost.Keys do begin
            PurchCost.Get("Reference No.", NetTotal);
            PurchBrID.Get("Reference No.", BranchID);

            if not Branch.Get(BranchID) then
                Error('Branch with ID %1 not found in Foodics Branches.', BranchID);

            DocNo := NoSeries.GetNextNo('GJNL-GEN');

            // Foodics Return from Order Journal
            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'RETURN FRO';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'RETURN FRO');
            GL."Posting Date" := BusinessDate;
            setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);

            GL.Init();
            //GL.Validate("Document Type", GL."Document Type"::Payment);
            GL."Document No." := DocNo;
            GL."Journal Template Name" := 'GENERAL';
            GL."Journal Batch Name" := 'RETURN FRO';
            GL."Line No." := GL.GetNewLineNo('GENERAL', 'RETURN FRO');
            GL."Posting Date" := BusinessDate;
            setAccounts('Foodics Return from Order', BranchRec, GL."Account Type", GL."Account No.");
            GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
            GL.Validate("Currency Code", 'SAR');
            GL.Validate(Amount, -NetTotal);
            GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
            GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
            GL.Insert(true);
        end;
    end;

    ///////////// Inventory Counts //////////////////////
    local procedure ImportInventoryCounts(
        Setup: Record "Foodics Setup";
        var Branch: Record "Foodics Purchase Branch";
        BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok : JsonToken;

        BranchName: Text;
        BranchID: Text[100];
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        PurchCost: Dictionary of [Text, Decimal];
        PurchBrID: Dictionary of [Text, Text[100]];

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        BranchRec: Record "Foodics Branch";
        DocNo: Code[20];
        "Reference No.": Text;
        VarianceCost: Decimal;
        NetTotal: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;

    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/inventory_counts?filter[business_date]=%2&include=items, branch &page=',
                              Setup."Base URL", DateTxt);


        pageNo := 1;
        LastPage := 1;

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // ----------------------- data[] --------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    "Reference No." := '';
                    BranchID := '';
                    NetTotal := 0;
                    VarianceCost := 0;

                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Return from Order Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Reference No." := ValTok.AsValue().AsText();

                    if not PurchBrID.ContainsKey("Reference No.") then begin
                        PurchBrID.Add("Reference No.", BranchID);
                    end;

                    // 2.4  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin
                                    if PivotTok.AsObject().Get('variance_cost', ValTok) and ValTok.IsValue() then begin
                                        VarianceCost := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                        if PurchCost.ContainsKey("Reference No.") then begin
                                            PurchCost.Get("Reference No.", NetTotal);
                                            PurchCost.Set("Reference No.", NetTotal + VarianceCost);
                                        end else
                                            PurchCost.Add("Reference No.", VarianceCost);
                                    end;
                                end;
                            end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        GL.Reset();
        GL.SetRange("Journal Template Name", 'GENERAL');
        GL.SetRange("Journal Batch Name", 'INV.COUNTS');

        foreach "Reference No." in PurchCost.Keys do begin
            PurchCost.Get("Reference No.", NetTotal);
            PurchBrID.Get("Reference No.", BranchID);

            if not Branch.Get(BranchID) then
                Error('Branch with ID %1 not found in Foodics Branches.', BranchID);

            DocNo := NoSeries.GetNextNo('GJNL-GEN');

            if NetTotal > 0 then begin

                // Foodics Inventory Counts Journal
                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'INV.COUNTS';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'INV.COUNTS');
                GL."Posting Date" := BusinessDate;
                setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);

                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'INV.COUNTS';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'INV.COUNTS');
                GL."Posting Date" := BusinessDate;
                setAccounts('Foodics Inventory Counts', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, -NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);

            end else begin

                // Foodics Inventory Counts Journal
                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'INV.COUNTS';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'INV.COUNTS');
                GL."Posting Date" := BusinessDate;
                setAccounts('Foodics Inventory Counts', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, -NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);

                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'INV.COUNTS';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'INV.COUNTS');
                GL."Posting Date" := BusinessDate;
                setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);
            end;
        end;
    end;

    ///////////// Cost Adjustments //////////////////////
    local procedure ImportCostAdjustments(
        Setup: Record "Foodics Setup";
        var Branch: Record "Foodics Purchase Branch";
        BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        Arr: JsonArray;
        OneTok: JsonToken;
        ValTok: JsonToken;
        MetaTok: JsonToken;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        PivotTok: JsonToken;
        branchTok, ItemsTok, ItemTok : JsonToken;

        BranchName: Text;
        BranchID: Text[100];
        BaseUrl: Text;
        CurrUrl: Text;
        DateTxt: Text[10];

        PurchCost: Dictionary of [Text, Decimal];
        PurchBrID: Dictionary of [Text, Text[100]];

        GL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        BranchRec: Record "Foodics Branch";
        DocNo: Code[20];
        "Reference No.": Text;
        PreviousCost: Decimal;
        NewCost: Decimal;
        TotalCost: Decimal;
        NetTotal: Decimal;
        Quantity: Decimal;
        LineNo: Integer;
        pageNo: Integer;
        LastPage: Integer;

    begin
        DateTxt := Format(BusinessDate, 0, '<Year4>-<Month,2>-<Day,2>');
        BaseUrl := StrSubstNo('%1/cost_adjustments?filter[business_date]=%2&include=items, branch &page=',
                              Setup."Base URL", DateTxt);


        pageNo := 1;
        LastPage := 1;

        repeat
            CurrUrl := BaseUrl + Format(pageNo);
            SendWithRetry(CurrUrl, Setup, Client, Response);
            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);           //Parse

            // ----------------------- data[] --------------------------------------
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();

                foreach OneTok in Arr do begin
                    "Reference No." := '';
                    BranchID := '';
                    NetTotal := 0;
                    PreviousCost := 0;
                    NewCost := 0;
                    TotalCost := 0;

                    // 2.1  Branch Id
                    if OneTok.AsObject().Get('branch', branchTok) then
                        if branchTok.AsObject().Get('id', ValTok) and ValTok.IsValue() then
                            BranchID := ValTok.AsValue().AsText();

                    // 2.2  Return from Order Details
                    if OneTok.AsObject().Get('reference', ValTok) and ValTok.IsValue() then
                        "Reference No." := ValTok.AsValue().AsText();

                    if not PurchBrID.ContainsKey("Reference No.") then begin
                        PurchBrID.Add("Reference No.", BranchID);
                    end;

                    // 2.4  Items Details
                    if OneTok.AsObject().Get('items', ItemsTok) then begin
                        ItemsArr := ItemsTok.AsArray();
                        foreach ItemTok in ItemsArr do
                            if ItemTok.IsObject() then begin
                                ItemObj := ItemTok.AsObject();

                                if ItemObj.Get('pivot', PivotTok) and PivotTok.IsObject() then begin

                                    if PivotTok.AsObject().Get('previous_cost_per_unit', ValTok) and ValTok.IsValue() then
                                        PreviousCost := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                    if PivotTok.AsObject().Get('cost_per_unit', ValTok) and ValTok.IsValue() then
                                        NewCost := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                    if PivotTok.AsObject().Get('quantity', ValTok) and ValTok.IsValue() then
                                        Quantity := ROUND(ValTok.AsValue().AsDecimal(), 0.01, '=');

                                    TotalCost := Quantity * (NewCost - PreviousCost);

                                    if PurchCost.ContainsKey("Reference No.") then begin
                                        PurchCost.Get("Reference No.", NetTotal);
                                        PurchCost.Set("Reference No.", NetTotal + TotalCost);
                                    end else
                                        PurchCost.Add("Reference No.", TotalCost);
                                end;
                            end;
                    end;
                end;
            end;


            // read how many pages we actually have
            //-------- meta.last_page --
            if RootObj.Get('meta', MetaTok) then
                if MetaTok.AsObject().Get('last_page', ValTok) and ValTok.IsValue() then
                    LastPage := ValTok.AsValue().AsInteger();

            pageNo += 1;
        until pageNo > LastPage;

        GL.Reset();
        GL.SetRange("Journal Template Name", 'GENERAL');
        GL.SetRange("Journal Batch Name", 'COST ADJ');

        foreach "Reference No." in PurchCost.Keys do begin
            PurchCost.Get("Reference No.", NetTotal);
            PurchBrID.Get("Reference No.", BranchID);

            if not Branch.Get(BranchID) then
                Error('Branch with ID %1 not found in Foodics Branches.', BranchID);

            DocNo := NoSeries.GetNextNo('GJNL-GEN');

            if NetTotal > 0 then begin

                // Foodics Cost Adjustments Journal
                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'COST ADJ';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'COST ADJ');
                GL."Posting Date" := BusinessDate;
                setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);

                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'COST ADJ';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'COST ADJ');
                GL."Posting Date" := BusinessDate;
                setAccounts('Foodics Cost Adjustments', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, -NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);

            end else begin

                // Foodics Cost Adjustments Journal
                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'COST ADJ';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'COST ADJ');
                GL."Posting Date" := BusinessDate;
                setAccounts('Foodics Cost Adjustments', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, -NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);

                GL.Init();
                //GL.Validate("Document Type", GL."Document Type"::Payment);
                GL."Document No." := DocNo;
                GL."Journal Template Name" := 'GENERAL';
                GL."Journal Batch Name" := 'COST ADJ';
                GL."Line No." := GL.GetNewLineNo('GENERAL', 'COST ADJ');
                GL."Posting Date" := BusinessDate;
                setAccounts('Untract Inventory', BranchRec, GL."Account Type", GL."Account No.");
                GL.Description := StrSubstNo('%1 for %2', "Reference No.", Branch.Name);
                GL.Validate("Currency Code", 'SAR');
                GL.Validate(Amount, NetTotal);
                GL.Validate("Shortcut Dimension 1 Code", Branch."Department Code");
                GL.Validate("Shortcut Dimension 2 Code", Branch."Branch Code");
                GL.Insert(true);
            end;
        end;
    end;
}