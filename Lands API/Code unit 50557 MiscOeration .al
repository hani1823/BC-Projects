codeunit 50557 "MiscOperations"
{
    procedure Ping(input: Integer): Integer
    begin
        exit(-input);
    end;

    procedure Delay(delayMilliseconds: Integer)
    begin
        Sleep(delayMilliseconds);
    end;

    procedure GetLengthOfStringWithConfirmation(inputJson: Text): Integer
    var
        c: JsonToken;
        input: JsonObject;
    begin
        input.ReadFrom(inputJson);
        if input.Get('confirm', c) and c.AsValue().AsBoolean() = true and input.Get('str', c) then
            exit(StrLen(c.AsValue().AsText()))
        else
            exit(-1);
    end;

    procedure RunReport(reportNO: Integer; parameters: text): text
    var
        OutS: OutStream;
        Inst: InStream;
        TempBlob: codeunit "Temp Blob";
        Base64: codeunit "base64 Convert";
        rep: ReportFormat;
        para: Text;
    begin
        //para := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Blanket Purchase Order" id="410"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="ArchiveDocument">true</Field><Field name="LogInteraction">true</Field></Options><DataItems><DataItem name="Purchase Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(4),Field3=1(PR-000002))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Purchase Line">VERSION(1) SORTING(Field1,Field3,Field4)</DataItem><DataItem name="RoundLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total3">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        //para := parameters;
        Tempblob.CreateOutStream(OutS);
        Report.SaveAs(reportNO, parameters, rep::Pdf, OutS);
        TempBlob.CreateInStream(Inst);
        exit(Base64.ToBase64(Inst));
    end;

    procedure CreateSalesOrder(customerNO: text; pieceNumber: Text; planName: text[100])
    var
        salesHeader: Record "Sales Header";
        salesLine: Record "Sales Line";
        DimValue: Record "Dimension Value";
        DimCode: Code[20];
    begin
        salesHeader.Init();

        salesHeader."Document Type" := Enum::"Sales Document Type"::Order;
        salesHeader."bill-to Customer No." := customerNO;
        salesHeader."sell-to Customer No." := customerNO;
        salesHeader."Posting Date" := Today;
        salesHeader."Plan Name" := planName;
        salesHeader.Validate("Shortcut Dimension 1 Code", 'REAL-ESTATE');
        salesHeader.Validate("sell-to Customer No.");
        salesHeader.Validate("bill-to Customer No.");
        salesHeader.Validate("Posting Date");

        salesHeader.InitInsert();
        salesHeader.insert();


        // ***** SALES LINES *****
        salesLine."Document Type" := Enum::"Sales Document Type"::Order;
        salesLine."Document No." := salesHeader."No.";
        salesLine."Line No." := 10000;
        salesLine.Type := Enum::"Sales Line Type"::Item;
        salesLine."No." := pieceNumber;
        salesLine.Quantity := 1;
        salesLine.Validate(Quantity);
        salesLine.Validate("No.");


        salesLine.Insert();

    end;

    procedure CreateSalesOrderMarketerForm(

     planName: text;
     ownerName: text;
     saleType: Text;
     saleSource: Text;
     clientName: Text;
     phoneNumber: Text;
     idNumber: Text;
     birthDate: Text;
     email: Text;
     propertyType: Text;
     usage: Text;
     blockNumber: Text;
     plotNumber: Text;
     deedNumber: Text;
     deedImage: Text;
     streetName: Text;
     landArea: Text;
     netSalePrice: Text;
     totalSalePrice: Text;
     netLandValue: Text;
     tax: Text;
     commission: Text;
     totalAmount: Text;
     transferReceipt: Text;
     fullNameExternalMarketing: Text;
     phoneExternalMarketing: Text;
     emailExternalMarketing: Text;
     commisibanExternalMarketingsion: Text;
     marketers: Text;
     marketer: Text;
     receiptAtt: Text;
     newCutomer: Text;
     newMarketer: Text

     ): text



    var
        salesHeader: Record "Sales Header";
        salesLine: Record "Sales Line";
        salesLine1: Record "Sales Line";
        cust: Record Customer;
        newCust: Record Customer;
        defDimension: Record "Default Dimension";
        TextLine: Text;
        MarketerNOs: array[20] of Text;
        MarketerNOList: array[20] of Record Marketer;
        thereIsExtMarketer: Boolean;
        I: Integer;
        counter: Integer;
        NoSeri: Codeunit "No. Series";
        vendCreated: Record Vendor;
        vendNameFind: Record Vendor;
        vend2: Record Vendor;
        land: Record Land;




    begin

        /// find customer 
        salesHeader.Init();
        salesHeader.IDs := receiptAtt;

        /*      salesHeader.desc :=
          'planName: ' + planName + ' - ' +
          'saleType: ' + saleType + ' - ' +
          'saleSource: ' + saleSource + ' - ' +
          'clientName: ' + clientName + ' - ' +
          'phoneNumber: ' + phoneNumber + ' - ' +
          'idNumber: ' + idNumber + ' - ' +
          'birthDate: ' + birthDate + ' - ' +
          'email: ' + email + ' - ' +
          'propertyType: ' + propertyType + ' - ' +
          'usage: ' + usage + ' - ' +
          'plotNumber: ' + plotNumber + ' - ' +
          'deedNumber: ' + deedNumber + ' - ' +
          'deedImage: ' + deedImage + ' - ' +
          'streetName: ' + streetName + ' - ' +
          'landArea: ' + landArea + ' - ' +
          'netSalePrice: ' + netSalePrice + ' - ' +
          'totalSalePrice: ' + totalSalePrice + ' - ' +
          'netLandValue: ' + netLandValue + ' - ' +
          'tax: ' + tax + ' - ' +
          'commission: ' + commission + ' - ' +
          'totalAmount: ' + totalAmount + ' - ' +
          'transferReceipt: ' + transferReceipt + ' - ' +
          'fullNameExternalMarketing: ' + fullNameExternalMarketing + ' - ' +
          'emailExternalMarketing: ' + emailExternalMarketing + ' - ' +
          'commisibanExternalMarketingsion: ' + commisibanExternalMarketingsion + ' - ' +
          'marketers: ' + marketers + ' - ' +
          'marketer: ' + marketer + ' -  the end';

      */

        /// find or create customer



        if newCutomer <> '' then begin
            cust.SetRange("No.", newCutomer);
            if cust.FindSet() then begin
                salesHeader."sell-to Customer No." := cust."No.";
                salesHeader."bill-to Customer No." := cust."No.";
            end;
        end else begin
            // customer not fount --Create new one 
            newCust.Init();
            newCust."No." := NoSeri.GetNextNo('CUST');
            newCust.Name := clientName;
            newCust."Phone No." := phoneNumber;
            newCust."E-Mail" := email;
            newCust."Gen. Bus. Posting Group" := 'DOMESTIC';
            newCust."VAT Bus. Posting Group" := 'DOMESTIC';
            newCust."Customer Posting Group" := 'DOMESTIC';
            newCust."Currency Code" := 'SAR';
            newCust."Payment Terms Code" := '14 DAYS';
            newCust."Payment Method Code" := 'CASH';
            newCust."Zatca Customer Type HAC" := newCust."Zatca Customer Type HAC"::Individual;
            newCust."Zatca Identification Type HAC" := newCust."Zatca Identification Type HAC"::CRN;
            newCust."Customer ID" := idNumber;
            Evaluate(newCust."Date of Birth", birthDate);
            //newCust.Validate(Name);

            newCust.Insert();

            // Create Default Dimensions for the new customer
            CreateDefaultDimensionsForCustomer(newCust."No.");
            salesHeader."sell-to Customer No." := newCust."No.";
            salesHeader."bill-to Customer No." := newCust."No.";
        end;


        salesHeader."Document Type" := Enum::"Sales Document Type"::Order;
        salesHeader."Posting Date" := Today;



        land.SetRange("Instrument number", deedNumber);
        if land.FindSet() then begin
            salesHeader."Owner Name" := land."Owner Name";
            salesHeader."Plan Name" := land."Plan Name";
        end;

        salesHeader.Validate("sell-to Customer No.");
        salesHeader.Validate("bill-to Customer No.");
        salesHeader.Validate("Posting Date");
        /// Sales source

        case saleSource of
            'Owner':
                salesHeader."Sale Source" := Enum::SaleSourceEnum::"المالك";
            'Sales office':
                salesHeader."Sale Source" := Enum::SaleSourceEnum::"مكتب المبيعات";
            'Real estate platforms':
                salesHeader."Sale Source" := Enum::SaleSourceEnum::"منصة سهيل";
            else
                salesHeader."Sale Source" := Enum::SaleSourceEnum::" ";
        end;


        /// Sales Type

        case saleType of
            'Bank':
                salesHeader."Payment Method" := Enum::PaymentMethod::"بنك";
            'Cash':
                salesHeader."Payment Method" := Enum::PaymentMethod::"كاش";
            else
                salesHeader."Payment Method" := Enum::PaymentMethod::" ";
        end;
        salesHeader.InitInsert();
        salesHeader.insert();

        salesLine."Document Type" := Enum::"Sales Document Type"::Order;
        salesLine."Document No." := salesHeader."No.";
        salesLine."Line No." := 10000;
        salesLine.Type := Enum::"Sales Line Type"::Item;
        salesLine."No." := deedNumber;
        salesLine.Quantity := 1;

        salesLine.Validate(Quantity);
        salesLine.Validate("No.");
        Evaluate(salesLine."Price Per Meter", netSalePrice);
        salesLine.Insert();

        ///*********create External markter 
        /// 
        case newMarketer of
            '':
                begin
                    receiptAtt := receiptAtt;
                end;
            'new':
                begin
                    vendCreated.Init();
                    vendCreated."No." := NoSeri.GetNextNo('VEND');
                    vendCreated.Name := fullNameExternalMarketing;
                    vendCreated."Phone No." := phoneExternalMarketing;
                    vendCreated."E-Mail" := emailExternalMarketing;
                    vendCreated."Gen. Bus. Posting Group" := 'DOMESTIC';
                    vendCreated."Vendor Posting Group" := 'DOMESTIC';
                    vendCreated."VAT Bus. Posting Group" := 'AGENT';
                    vendCreated.Insert();

                end;
            else begin
                vend2.SetRange("No.", newMarketer);
                if vend2.FindSet() then
                    receiptAtt := receiptAtt;
            end;


        end;





        ///*** create marketer list 
        /////
        /// 
        /// 
        case saleSource of
            'Owner':
                begin
                    // Parse the `marketer` string to see if we have any “other” (internal) marketers
                    TextLine := marketer;
                    counter := STRLEN(DELCHR(TextLine, '=', DELCHR(TextLine, '=', ',')));

                    // ============== CASES 1–3: NO OTHER (INTERNAL) MARKETERS ==============
                    if counter = 0 then begin
                        // 1) No External Marketer, No “other” Marketers
                        if (newMarketer = '') then begin
                            // "RV10099" = 0.4350, "RV10079" = 0.005, "RV10061" = 0.01

                            // Marketer 1 (Sons)
                            MarketerNOList[1].Init();
                            MarketerNOList[1]."No." := 'RV10099';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[1].Name := vendNameFind.Name;
                            MarketerNOList[1]."Document No." := salesHeader."No.";
                            MarketerNOList[1].Percentage := 0.4350;
                            MarketerNOList[1].Insert();

                            // Marketer 2 (Suleiman)
                            MarketerNOList[2].Init();
                            MarketerNOList[2]."No." := 'RV10061';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[2]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[2].Name := vendNameFind.Name;
                            MarketerNOList[2]."Document No." := salesHeader."No.";
                            MarketerNOList[2].Percentage := 0.01;
                            MarketerNOList[2].Insert();

                            // Marketer 3 (Abdelwahab)
                            MarketerNOList[3].Init();
                            MarketerNOList[3]."No." := 'RV10079';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[3].Name := vendNameFind.Name;
                            MarketerNOList[3]."Document No." := salesHeader."No.";
                            MarketerNOList[3].Percentage := 0.005;
                            MarketerNOList[3].Insert();
                        end
                        // 2) NEW External Marketer, No “other” Marketers
                        else if (newMarketer = 'new') then begin
                            // "RV10099" = 0.2350, External = 0.50, "RV10079" = 0.005, "RV10061" = 0.01

                            // Marketer 1 (Sons)
                            MarketerNOList[1].Init();
                            MarketerNOList[1]."No." := 'RV10099';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[1].Name := vendNameFind.Name;
                            MarketerNOList[1]."Document No." := salesHeader."No.";
                            MarketerNOList[1].Percentage := 0.235;
                            MarketerNOList[1].Insert();

                            // Marketer 2 (External)
                            MarketerNOList[2].Init();
                            MarketerNOList[2]."No." := vendCreated."No.";  // newly created vendor
                            MarketerNOList[2].Name := vendCreated.Name;
                            MarketerNOList[2]."Document No." := salesHeader."No.";
                            MarketerNOList[2].Percentage := 0.50;
                            MarketerNOList[2].Insert();

                            // Marketer 3 (Abdelwahab)
                            MarketerNOList[3].Init();
                            MarketerNOList[3]."No." := 'RV10079';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[3].Name := vendNameFind.Name;
                            MarketerNOList[3]."Document No." := salesHeader."No.";
                            MarketerNOList[3].Percentage := 0.005;
                            MarketerNOList[3].Insert();

                            // Marketer 4 (Suleiman)
                            MarketerNOList[4].Init();
                            MarketerNOList[4]."No." := 'RV10061';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[4]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[4].Name := vendNameFind.Name;
                            MarketerNOList[4]."Document No." := salesHeader."No.";
                            MarketerNOList[4].Percentage := 0.01;
                            MarketerNOList[4].Insert();
                        end
                        // 3) EXISTING External Marketer, No “other” Marketers
                        else begin
                            // "RV10099" = 0.2350, External = 0.50, "RV10079" = 0.005, "RV10061" = 0.01

                            // Marketer 1 (Sons)
                            MarketerNOList[1].Init();
                            MarketerNOList[1]."No." := 'RV10099';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[1].Name := vendNameFind.Name;
                            MarketerNOList[1]."Document No." := salesHeader."No.";
                            MarketerNOList[1].Percentage := 0.235;
                            MarketerNOList[1].Insert();

                            // Marketer 2 (External)
                            MarketerNOList[2].Init();
                            MarketerNOList[2]."No." := vend2."No.";  // existing vendor
                            MarketerNOList[2].Name := vend2.Name;
                            MarketerNOList[2]."Document No." := salesHeader."No.";
                            MarketerNOList[2].Percentage := 0.50;
                            MarketerNOList[2].Insert();

                            // Marketer 3 (Abdelwahab)
                            MarketerNOList[3].Init();
                            MarketerNOList[3]."No." := 'RV10079';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[3].Name := vendNameFind.Name;
                            MarketerNOList[3]."Document No." := salesHeader."No.";
                            MarketerNOList[3].Percentage := 0.005;
                            MarketerNOList[3].Insert();

                            // Marketer 4 (Suleiman)
                            MarketerNOList[4].Init();
                            MarketerNOList[4]."No." := 'RV10061';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[4]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[4].Name := vendNameFind.Name;
                            MarketerNOList[4]."Document No." := salesHeader."No.";
                            MarketerNOList[4].Percentage := 0.01;
                            MarketerNOList[4].Insert();
                        end;
                    end
                    // ============== CASES 4A/4B: WE HAVE “OTHER” (INTERNAL) MARKETERS ==============
                    else begin
                        // 4B) NO external marketer but we do have other marketers:
                        //   "RV10099" = 0.29, "RV10079" = 0.005, "RV10061" = 0.01, leftover=0.445 shared by “other marketers”
                        if (newMarketer = '') then begin
                            // Marketer 1 (Sons)
                            MarketerNOList[1].Init();
                            MarketerNOList[1]."No." := 'RV10099';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[1].Name := vendNameFind.Name;
                            MarketerNOList[1]."Document No." := salesHeader."No.";
                            MarketerNOList[1].Percentage := 0.29;
                            MarketerNOList[1].Insert();

                            // Marketer 2 (Abdelwahab)
                            MarketerNOList[2].Init();
                            MarketerNOList[2]."No." := 'RV10079';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[2]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[2].Name := vendNameFind.Name;
                            MarketerNOList[2]."Document No." := salesHeader."No.";
                            MarketerNOList[2].Percentage := 0.005;
                            MarketerNOList[2].Insert();

                            // Marketer 3 (Suleiman)
                            MarketerNOList[3].Init();
                            MarketerNOList[3]."No." := 'RV10061';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[3].Name := vendNameFind.Name;
                            MarketerNOList[3]."Document No." := salesHeader."No.";
                            MarketerNOList[3].Percentage := 0.01;
                            MarketerNOList[3].Insert();

                            // “Other” Marketers share 0.445 / counter
                            for I := 1 to counter do begin
                                MarketerNOList[3 + I].Init();
                                MarketerNOList[3 + I]."No." := SelectStr(I, TextLine);
                                vendNameFind.Reset();
                                vendNameFind.SetRange("No.", MarketerNOList[3 + I]."No.");
                                if vendNameFind.FindFirst() then
                                    MarketerNOList[3 + I].Name := vendNameFind.Name;
                                MarketerNOList[3 + I]."Document No." := salesHeader."No.";
                                MarketerNOList[3 + I].Percentage := 0.445 / counter;
                                MarketerNOList[3 + I].Insert();
                            end;
                        end
                        // 4A) WITH external marketer + “other” marketers:
                        //   "RV10099"=0.2350, External=0.25, "RV10079"=0.005, "RV10061"=0.01, leftover=0.25 shared by “other marketers”
                        else begin
                            // Marketer 1 (Sons)
                            MarketerNOList[1].Init();
                            MarketerNOList[1]."No." := 'RV10099';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[1].Name := vendNameFind.Name;
                            MarketerNOList[1]."Document No." := salesHeader."No.";
                            MarketerNOList[1].Percentage := 0.235;
                            MarketerNOList[1].Insert();

                            // Marketer 2 (External)
                            MarketerNOList[2].Init();
                            if (newMarketer = 'new') then begin
                                // newly created external vendor
                                MarketerNOList[2]."No." := vendCreated."No.";
                                MarketerNOList[2].Name := vendCreated.Name;
                            end else begin
                                // existing external vendor
                                MarketerNOList[2]."No." := vend2."No.";
                                MarketerNOList[2].Name := vend2.Name;
                            end;
                            MarketerNOList[2]."Document No." := salesHeader."No.";
                            MarketerNOList[2].Percentage := 0.25;
                            MarketerNOList[2].Insert();

                            // Marketer 3 (Abdelwahab)
                            MarketerNOList[3].Init();
                            MarketerNOList[3]."No." := 'RV10079';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[3].Name := vendNameFind.Name;
                            MarketerNOList[3]."Document No." := salesHeader."No.";
                            MarketerNOList[3].Percentage := 0.005;
                            MarketerNOList[3].Insert();

                            // Marketer 4 (Suleiman)
                            MarketerNOList[4].Init();
                            MarketerNOList[4]."No." := 'RV10061';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[4]."No.");
                            if vendNameFind.FindFirst() then
                                MarketerNOList[4].Name := vendNameFind.Name;
                            MarketerNOList[4]."Document No." := salesHeader."No.";
                            MarketerNOList[4].Percentage := 0.01;
                            MarketerNOList[4].Insert();

                            // “Other” Marketers share 0.25 / counter
                            for I := 1 to counter do begin
                                MarketerNOList[4 + I].Init();
                                MarketerNOList[4 + I]."No." := SelectStr(I, TextLine);
                                vendNameFind.Reset();
                                vendNameFind.SetRange("No.", MarketerNOList[4 + I]."No.");
                                if vendNameFind.FindFirst() then
                                    MarketerNOList[4 + I].Name := vendNameFind.Name;
                                MarketerNOList[4 + I]."Document No." := salesHeader."No.";
                                MarketerNOList[4 + I].Percentage := 0.25 / counter;
                                MarketerNOList[4 + I].Insert();
                            end;
                        end;
                    end;
                end;

            'Sales office':
                case newMarketer of
                    '':
                        begin
                            // Create Ahmed And Mohamed 
                            MarketerNOList[1].Init();
                            MarketerNOList[1]."No." := 'RV10099';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                            if vendNameFind.FindFirst() then MarketerNOList[1].Name := vendNameFind.Name;
                            MarketerNOList[1]."Document No." := salesHeader."No.";
                            MarketerNOList[1].Percentage := 0.29;
                            MarketerNOList[1].Insert();
                            //Creatr Suliman
                            MarketerNOList[2].Init();
                            MarketerNOList[2]."No." := 'RV10061';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[2]."No.");
                            if vendNameFind.FindFirst() then MarketerNOList[2].Name := vendNameFind.Name;
                            MarketerNOList[2]."Document No." := salesHeader."No.";
                            MarketerNOList[2].Percentage := 0.01;
                            MarketerNOList[2].Insert();
                            // abdelwahab
                            MarketerNOList[3].Init();
                            MarketerNOList[3]."No." := 'RV10079';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                            if vendNameFind.FindFirst() then MarketerNOList[3].Name := vendNameFind.Name;
                            MarketerNOList[3]."Document No." := salesHeader."No.";
                            MarketerNOList[3].Percentage := 0.005;
                            MarketerNOList[3].Insert();
                            /// Other Marketer
                            TextLine := marketer;
                            counter := STRLEN(DELCHR(TextLine, '=', DELCHR(TextLine, '=', ',')));
                            for I := 1 to counter do begin
                                MarketerNOList[3 + I].Init();
                                MarketerNOList[3 + I]."No." := SelectStr(I, TextLine);
                                vendNameFind.Reset();
                                vendNameFind.SetRange("No.", MarketerNOList[3 + I]."No.");
                                if vendNameFind.FindFirst() then MarketerNOList[3 + I].Name := vendNameFind.Name;
                                MarketerNOList[3 + I]."Document No." := salesHeader."No.";
                                MarketerNOList[3 + I].Percentage := 0.4450 / counter;
                                MarketerNOList[3 + I].Insert();
                            end;

                        end;
                    'new':
                        begin
                            // Create Ahmed And Mohamed 
                            MarketerNOList[1].Init();
                            MarketerNOList[1]."No." := 'RV10099';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                            if vendNameFind.FindFirst() then MarketerNOList[1].Name := vendNameFind.Name;
                            MarketerNOList[1]."Document No." := salesHeader."No.";
                            MarketerNOList[1].Percentage := 0.235;
                            MarketerNOList[1].Insert();
                            //Creatr Suliman
                            MarketerNOList[2].Init();
                            MarketerNOList[2]."No." := 'RV10061';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[2]."No.");
                            if vendNameFind.FindFirst() then MarketerNOList[2].Name := vendNameFind.Name;
                            MarketerNOList[2]."Document No." := salesHeader."No.";
                            MarketerNOList[2].Percentage := 0.01;
                            MarketerNOList[2].Insert();
                            // abdelwahab
                            MarketerNOList[3].Init();
                            MarketerNOList[3]."No." := 'RV10079';
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                            if vendNameFind.FindFirst() then MarketerNOList[3].Name := vendNameFind.Name;
                            MarketerNOList[3]."Document No." := salesHeader."No.";
                            MarketerNOList[3].Percentage := 0.005;
                            MarketerNOList[3].Insert();
                            // External Marketer Createrd
                            MarketerNOList[4].Init();
                            MarketerNOList[4]."No." := vendCreated."No.";
                            MarketerNOList[4].Name := vendCreated.Name;
                            MarketerNOList[4]."Document No." := salesHeader."No.";
                            MarketerNOList[4].Percentage := 0.25;
                            MarketerNOList[4].Insert();
                            /// Other Marketer
                            TextLine := marketer;
                            counter := STRLEN(DELCHR(TextLine, '=', DELCHR(TextLine, '=', ',')));
                            for I := 1 to counter do begin
                                MarketerNOList[4 + I].Init();
                                MarketerNOList[4 + I]."No." := SelectStr(I, TextLine);
                                vendNameFind.Reset();
                                vendNameFind.SetRange("No.", MarketerNOList[4 + I]."No.");
                                if vendNameFind.FindFirst() then MarketerNOList[4 + I].Name := vendNameFind.Name;
                                MarketerNOList[4 + I]."Document No." := salesHeader."No.";
                                MarketerNOList[4 + I].Percentage := 0.25 / counter;
                                MarketerNOList[4 + I].Insert();
                            end;
                        end;
                    else begin
                        // Create Ahmed And Mohamed 
                        MarketerNOList[1].Init();
                        MarketerNOList[1]."No." := 'RV10099';
                        vendNameFind.Reset();
                        vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                        if vendNameFind.FindFirst() then MarketerNOList[1].Name := vendNameFind.Name;
                        MarketerNOList[1]."Document No." := salesHeader."No.";
                        MarketerNOList[1].Percentage := 0.235;
                        MarketerNOList[1].Insert();
                        //Creatr Suliman
                        MarketerNOList[2].Init();
                        MarketerNOList[2]."No." := 'RV10061';
                        vendNameFind.Reset();
                        vendNameFind.SetRange("No.", MarketerNOList[2]."No.");
                        if vendNameFind.FindFirst() then MarketerNOList[2].Name := vendNameFind.Name;
                        MarketerNOList[2]."Document No." := salesHeader."No.";
                        MarketerNOList[2].Percentage := 0.01;
                        MarketerNOList[2].Insert();
                        // abdelwahab
                        MarketerNOList[3].Init();
                        MarketerNOList[3]."No." := 'RV10079';
                        vendNameFind.Reset();
                        vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                        if vendNameFind.FindFirst() then MarketerNOList[3].Name := vendNameFind.Name;
                        MarketerNOList[3]."Document No." := salesHeader."No.";
                        MarketerNOList[3].Percentage := 0.005;
                        MarketerNOList[3].Insert();
                        // External Marketer Found
                        MarketerNOList[4].Init();
                        MarketerNOList[4]."No." := vend2."No.";
                        MarketerNOList[4].Name := vend2.Name;
                        MarketerNOList[4]."Document No." := salesHeader."No.";
                        MarketerNOList[4].Percentage := 0.25;
                        MarketerNOList[4].Insert();
                        /// Other Marketer
                        TextLine := marketer;
                        counter := STRLEN(DELCHR(TextLine, '=', DELCHR(TextLine, '=', ',')));
                        for I := 1 to counter do begin
                            MarketerNOList[4 + I].Init();
                            MarketerNOList[4 + I]."No." := SelectStr(I, TextLine);
                            vendNameFind.Reset();
                            vendNameFind.SetRange("No.", MarketerNOList[4 + I]."No.");
                            if vendNameFind.FindFirst() then MarketerNOList[4 + I].Name := vendNameFind.Name;
                            MarketerNOList[4 + I]."Document No." := salesHeader."No.";
                            MarketerNOList[4 + I].Percentage := 0.25 / counter;
                            MarketerNOList[4 + I].Insert();
                        end;
                    end;


                end;
            'Real estate platforms':
                begin
                    // Create Ahmed And Mohamed 
                    MarketerNOList[1].Init();
                    MarketerNOList[1]."No." := 'RV10099';
                    vendNameFind.Reset();
                    vendNameFind.SetRange("No.", MarketerNOList[1]."No.");
                    if vendNameFind.FindFirst() then MarketerNOList[1].Name := vendNameFind.Name;
                    MarketerNOList[1]."Document No." := salesHeader."No.";
                    MarketerNOList[1].Percentage := 0.335;
                    MarketerNOList[1].Insert();
                    //Creatr Suliman
                    MarketerNOList[2].Init();
                    MarketerNOList[2]."No." := 'RV10061';
                    vendNameFind.Reset();
                    vendNameFind.SetRange("No.", MarketerNOList[2]."No.");
                    if vendNameFind.FindFirst() then MarketerNOList[2].Name := vendNameFind.Name;
                    MarketerNOList[2]."Document No." := salesHeader."No.";
                    MarketerNOList[2].Percentage := 0.01;
                    MarketerNOList[2].Insert();
                    // abdelwahab
                    MarketerNOList[3].Init();
                    MarketerNOList[3]."No." := 'RV10079';
                    vendNameFind.Reset();
                    vendNameFind.SetRange("No.", MarketerNOList[3]."No.");
                    if vendNameFind.FindFirst() then MarketerNOList[3].Name := vendNameFind.Name;
                    MarketerNOList[3]."Document No." := salesHeader."No.";
                    MarketerNOList[3].Percentage := 0.005;
                    MarketerNOList[3].Insert();
                    // External Marketer Found
                    MarketerNOList[4].Init();
                    MarketerNOList[4]."No." := vend2."No.";
                    MarketerNOList[4].Name := vend2.Name;
                    MarketerNOList[4]."Document No." := salesHeader."No.";
                    MarketerNOList[4].Percentage := 0.25;
                    MarketerNOList[4].Insert();
                end;



            else
                receiptAtt := receiptAtt;

        end;



        /// 
        /// 
        /*
        TextLine := marketer;
        counter := STRLEN(DELCHR(TextLine, '=', DELCHR(TextLine, '=', ',')));
        for I := 1 to counter do begin
            MarketerNOs[I] := SelectStr(I, TextLine);
            MarketerNOList[I].Init();
            MarketerNOList[I]."No." := SelectStr(I, TextLine);

            vend.SetRange("No.", MarketerNOList[I]."No.");
            vend.SetRange("No.", MarketerNOList[I]."No.");
            if vend.FindFirst() then MarketerNOList[I].Name := vend.Name;
            MarketerNOList[I]."Document No." := salesHeader."No.";
            MarketerNOList[I].Insert();
        end;
*/
        exit(salesHeader.SystemId);
    end;

    local procedure CreateDefaultDimensionsForCustomer(CustomerNo: Code[20])
    var
        DefaultDim: Record "Default Dimension";
    // If you need to validate the Dimension Code or Dimension Value Code
    // you can also record lookup in "Dimension Value" etc. 
    begin
        // === 1) BUS-UNIT / REAL-ESTATE ===
        // Upsert logic (check if it exists, otherwise insert)
        if DefaultDim.Get(Database::Customer, CustomerNo, 'BUS-UNIT') then begin
            DefaultDim.Validate("Dimension Value Code", 'REAL-ESTATE');
            DefaultDim.Modify();
        end else begin
            DefaultDim.Init();
            DefaultDim."Table ID" := Database::Customer;  // Link to Customer
            DefaultDim."No." := CustomerNo;
            DefaultDim."Dimension Code" := 'BUS-UNIT';
            DefaultDim.Validate("Dimension Value Code", 'REAL-ESTATE');
            DefaultDim.Insert();
        end;

        // === 2) PROJECTS ===
        if DefaultDim.Get(Database::Customer, CustomerNo, 'PROJECTS') then begin
            DefaultDim.Modify();
        end else begin
            DefaultDim.Init();
            DefaultDim."Table ID" := Database::Customer;  // Link to Customer
            DefaultDim."No." := CustomerNo;
            DefaultDim."Dimension Code" := 'PROJECTS';
            DefaultDim.Insert();
        end;
    end;

    procedure sendQuotation2Cust(orederNo: Text; sellToCustNo: Text)
    var
        salesHesder: Record "Sales Header";
        cust: Record Customer;
        SI_HttpClient: HttpClient;
        SI_HttpHeaders: HttpHeaders;
        SI_Content: HttpContent;
        SI_HttpRequestMessage: HttpRequestMessage;
        SI_HttpResponseMessage: HttpResponseMessage;

        SI_AccessToken: Text;
        SI_ResponseBody: Text;


        SI_jsonbjet: JsonObject;
        SI_jsonbjettext: text;

        res: text;
        resjson: JsonObject;
        value: JsonToken;
        valueText: text;
    begin


        SI_AccessToken := getToken();

        // Set Authorization header
        SI_HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + SI_AccessToken);

        SI_jsonbjet.Add('reportNO', 50106);
        SI_jsonbjet.Add('parameters', '<?xml version="1.0" standalone="yes"?><ReportParameters name="PrintQuotationReport" id="50106"><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(1),Field3=1(' + orederNo + '))</DataItem><DataItem name="Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="Marketer">VERSION(1) SORTING(Field50001,Field50003)</DataItem></DataItems></ReportParameters>');



        SI_jsonbjet.WriteTo(SI_jsonbjettext);

        SI_Content.WriteFrom(SI_jsonbjettext);


        SI_Content.GetHeaders(SI_HttpHeaders);
        SI_HttpHeaders.Clear();
        SI_HttpHeaders.Add('Content-Type', 'application/json');
        SI_HttpRequestMessage.Content := SI_Content;
        SI_HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/PROD/ODataV4/MStest_RunReport?company=ALINMA%20FOR%20REAL%20ESTATE');
        SI_HttpRequestMessage.Method('POST');
        SI_HttpClient.Send(SI_HttpRequestMessage, SI_HttpResponseMessage);

        SI_HttpResponseMessage.Content.ReadAs(res);
        resjson.ReadFrom(res);
        resjson.Get('value', value);
        value.WriteTo(valueText);
        //  Message(valueText);
        valueText := valueText.Replace('=', '%3D');
        valueText := valueText.Replace('+', '%2B');
        valueText := valueText.Replace('/', '%2F');
        valueText := valueText.Replace('"', '');
        //Message(valueText);
        cust.SetRange("No.", sellToCustNo);
        if cust.FindSet() then
            SendDocumentToWhatsApp(valueText, cust."Phone No.", orederNo);
    end;

    local procedure SendDocumentToWhatsApp(reportB64: Text; customerPhoneNo: Text; saleOrderNo: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        Base64Text: Text;
        Base64EncodedText: Text;
        ErrorMessage: Text;
        FileName: Text;
        InstanceID: Text;
        Token: Text;
        ToPhoneNumber: Text;
        FileData: InStream;
        FilePath: Text;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
        ResultCode: Integer;
        FileManagement: Codeunit "File Management";
        base64report: Text;
        caption: Text;

    begin
        // Set up variables
        InstanceID := 'instance95060';  // Your instance ID
        Token := 'y6d5yjg7fj3z7stt';       // Your token
        ToPhoneNumber := customerPhoneNo;// Recipient phone number
        FileName := 'Sales Quotation ' + saleOrderNo + '.pdf';
        caption := 'Dear Customer this is your quotation ';
        // Read the file and convert to Base64

        Base64EncodedText := reportB64;
        // Base64EncodedText := Base64EncodedText.Replace('=', '%3D');
        // Base64EncodedText := Base64EncodedText.Replace('+', '%2B');
        // Base64EncodedText := Base64EncodedText.Replace('/', '%2F');
        // Base64EncodedText := Base64EncodedText.Replace('"', '');
        // Prepare the request
        HttpContent.WriteFrom('token=' + Token + '&to=' + ToPhoneNumber + '&document=' + Base64EncodedText + '&filename=' + FileName + '&caption=' + caption);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Create the HTTP request
        HttpRequestMessage.SetRequestUri('https://api.ultramsg.com/' + InstanceID + '/messages/document');
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content := HttpContent;

        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            ResultCode := HttpResponseMessage.HttpStatusCode;
        end;
        //     if ResultCode = 200 then
        //         Message('Document sent successfully: %1', ResponseText)
        //     else
        //         Error('Failed to send document. Status Code: %1. Response: %2', ResultCode, ResponseText);
        // end else begin
        //     HttpResponseMessage.Content.ReadAs(ErrorMessage);
        //     Error('Request failed: %1', ErrorMessage);
        // end;
    end;

    local procedure getToken(): Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        IsSuccessful: Boolean;
        uri: Text;
        AccessToken: Text;
        responseText: Text;
        JSONManagement: Codeunit "JSON Management";
        lJsonObjectLine: JsonObject;
    begin

        uri := 'https://login.microsoftonline.com/9b540f11-2b5c-4c74-bb40-a4d22950e763/oauth2/v2.0/token';
        //RequestURI := 'https://httpcats.com/418.json';

        content.WriteFrom('grant_type=client_credentials&client_id=49867617-f917-4774-b0d1-c404c9fb8cc3&client_secret=i2u8Q~DM97icb0KMjDPXwDeUNigpst3NsloVlc5y&scope=https://api.businesscentral.dynamics.com/.default');

        // Replace the default content type header with a header associated with this request
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in 
        // the content associated with the request message
        request.Content := content;

        request.SetRequestUri(uri);
        request.Method := 'POST';

        IsSuccessful := client.Send(request, response);

        if not IsSuccessful then begin
            // handle the error
        end;

        if not response.IsSuccessStatusCode() then begin
            // handle the error
        end;

        // Read the response content as json.
        response.Content.ReadAs(responseText);
        ;
        // GetJsonToken(lJsonObjectHeader, 'type').AsValue().AsText();
        JSONManagement.InitializeObject(responseText);
        JSONManagement.GetArrayPropertyValueAsStringByName('access_token', AccessToken);
        exit(AccessToken);
    end;



}