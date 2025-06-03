report 50126 "Customer Invoice Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    Caption = 'Consolidated Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = 'ConsolidatedInvoice.rdl';

    //──────────────────── REQUEST PAGE ────────────────────
    dataset
    {
        // نطبع من الجدول المؤقّت مباشرة
        dataitem(Summary; "Tmp Item Summary")
        {
            DataItemTableView = sorting("Item No.");
            UseTemporary = true;
            column(CustomerFilter; CustomerFilter) { }
            column(Customer_Name; "Customer Name") { }
            column(Customer_VAT; "Customer VAT") { }
            column(FromDate; FromDate) { }
            column(ToDate; ToDate) { }
            column(CompanyName; CompanyName) { }
            column(CompanyCity; CompanyCity) { }
            column(CompanyAddr; CompanyAddr) { }
            column(CompanyVat; CompanyVat) { }
            column(Tafqueet; Tafqueet[2]) { }
            column(ItemNo; "Item No.") { }
            column(Description; Description) { }
            column(UnitPrice; "Unit Price") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(QuantitySum; QuantityAgg) { }
            column(LineExclVat; LineAmtExclVAT) { }
            column(LineInclVat; LineAmtInclVAT) { }

            // المجاميع العامة (تُظهرها في ذيل التقرير فقط)
            column(GrandExclVat; TotalExclVAT) { }
            column(GrandVatAmount; TotalVatAmount) { }
            column(GrandInclVat; TotalInclVAT) { }
            trigger OnAfterGetRecord()
            var
                PayTerm: Record "Payment Terms";
                Invoicetotal: Decimal;
            begin
                //// Tafquit
                /// 
                /// 
                AmountToWords.InitTextVariable;

                AmountToWords.FormatNoText(Tafqueet, TotalInclVAT, 'SAR');
                Tafqueet[2] := Tafquit.Tafqueet(TotalInclVAT);
                /// Tafquit
            end;
        }
    }

    //─────────────────── REQUEST PAGE ────────────────────
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(CustomerFilterFld; CustomerFilter)
                    {
                        Caption = 'Customer No.';
                        ApplicationArea = All;
                        TableRelation = Customer;
                    }
                    field(FromDateFld; FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;
                    }
                    field(ToDateFld; ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }


    trigger OnPreReport()
    var
        SalesInvLine: Record "Sales Invoice Line";
        CustomerLedEnt: Record "Cust. Ledger Entry";
        companyRec: Record "Company Information";
        CustomerRec: Record Customer;
        KeyTxt: Text[250];
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        Qty: Decimal;
        SalesAmt: Decimal;
        UnitPriceDec: Decimal;
        VATRate: Decimal;
        Item: Record Item;
    begin
        VATRate := 0.15;
        if CustomerFilter <> '' then begin
            CustomerRec.Get(CustomerFilter);
            "Customer Name" := CustomerRec.Name;
            "Customer VAT" := CustomerRec."VAT Registration No.";
            if CustomerRec."Outside Scope Of Tax HAC" then
                VATRate := 0
            else
                VATRate := 0.15;
        end;

        if (FromDate > ToDate) and (ToDate <> 0D) then
            Error('From-Date must be earlier than To-Date.');

        TmpSummary.DeleteAll();
        Summary.DeleteAll();
        TotalExclVAT := 0;
        TotalInclVAT := 0;
        TotalVatAmount := 0;

        // إعداد فلاتر Value Entry
        ValueEntry.Reset();
        ValueEntry.SetRange("Source Type", ValueEntry."Source Type"::Customer);
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetRange("Expected Cost", false);
        ValueEntry.SetRange(Adjustment, false);
        if CustomerFilter <> '' then
            ValueEntry.SetRange("Source No.", CustomerFilter);
        if (FromDate <> 0D) or (ToDate <> 0D) then
            ValueEntry.SetRange("Posting Date", FromDate, ToDate);

        if ValueEntry.FindSet() then
            repeat
                ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
                // تحويل السالب إلى موجب
                Qty := -ValueEntry."Invoiced Quantity";
                if Qty <> 0 then begin
                    SalesAmt := ValueEntry."Sales Amount (Actual)";
                    Clear(Item);
                    if Item.Get(ValueEntry."Item No.") then;
                    //UnitPriceDec := Round(SalesAmt / Qty, 0.01);
                    //KeyTxt := StrSubstNo('%1|%2', ValueEntry."Item No.", Format(UnitPriceDec));
                    KeyTxt := StrSubstNo(ValueEntry."Item No.");
                    if not TmpSummary.Get(KeyTxt) then begin
                        TmpSummary.Init();
                        TmpSummary."Key" := KeyTxt;
                        TmpSummary."Item No." := ValueEntry."Item No.";
                        TmpSummary.Description := Item.Description;
                        //TmpSummary."Unit Price" := UnitPriceDec;
                        TmpSummary."Unit of Measure Code" := Item."Base Unit of Measure";
                        TmpSummary.QuantityAgg := Qty;
                        TmpSummary.LineAmtExclVAT := SalesAmt;
                        TmpSummary.LineAmtInclVAT := SalesAmt * (1 + VATRate);
                        TmpSummary.Insert();
                    end else begin
                        TmpSummary.QuantityAgg += Qty;
                        TmpSummary.LineAmtExclVAT += SalesAmt;
                        TmpSummary.LineAmtInclVAT += SalesAmt * (1 + VATRate);
                        TmpSummary.Modify();
                    end;
                    TotalExclVAT += SalesAmt;
                end;
            until ValueEntry.Next() = 0;

        TotalVatAmount := Round(TotalExclVAT * VATRate, 0.01);
        TotalInclVAT := TotalExclVAT + TotalVatAmount;

        if TmpSummary.FindSet() then
            repeat
                Summary := TmpSummary;
                Summary.Insert();
            until TmpSummary.Next() = 0;

        if companyRec.FindFirst() then begin
            CompanyName := companyRec.Name;
            CompanyCity := companyRec.City;
            CompanyAddr := companyRec.Address;
            CompanyVat := companyRec."VAT Registration No.";
        end;


        /*//-- فحص التاريخ
        if (FromDate > ToDate) and (ToDate <> 0D) then
            Error('From-Date must be earlier than To-Date.');

        //-- فلاتر سطور الفواتير
        SalesInvLine.Reset();

        if CustomerFilter <> '' then
            SalesInvLine.SetRange("Sell-to Customer No.", CustomerFilter);
            CustomerLedEnt.SetRange("Customer No.",CustomerFilter);
        if (FromDate <> 0D) or (ToDate <> 0D) then
            SalesInvLine.SetRange("Posting Date", FromDate, ToDate);
            CustomerLedEnt.SetRange("Posting Date", FromDate, ToDate);

        //-- جهّز جداولنا المؤقّتة
        TmpSummary.DeleteAll();
        Summary.DeleteAll();       // <-- يمسح أى بيانات قديمة

        //-- ابْنِ الملخّص فى TmpSummary
        if SalesInvLine.FindSet() then
            repeat
                KeyTxt := StrSubstNo('%1|%2', SalesInvLine."No.", SalesInvLine."Unit Price");

                if not TmpSummary.Get(KeyTxt) then begin
                    TmpSummary.Init();
                    TmpSummary."Key" := KeyTxt;
                    TmpSummary."Item No." := SalesInvLine."No.";
                    TmpSummary.Description := SalesInvLine.Description;
                    TmpSummary."Unit Price" := SalesInvLine."Unit Price";
                    TmpSummary."Unit of Measure Code" := SalesInvLine."Unit of Measure Code";
                    TmpSummary.QuantityAgg := SalesInvLine.Quantity;
                    TmpSummary.LineAmtExclVAT := SalesInvLine.Amount;
                    TmpSummary.LineAmtInclVAT := SalesInvLine."Amount Including VAT";
                    TmpSummary.Insert();
                end else begin
                    TmpSummary.QuantityAgg += SalesInvLine.Quantity;
                    TmpSummary.LineAmtExclVAT += SalesInvLine.Amount;
                    TmpSummary.LineAmtInclVAT += SalesInvLine."Amount Including VAT";
                    TmpSummary.Modify();
                end;

                TotalExclVAT += SalesInvLine.Amount;
                TotalInclVAT += SalesInvLine."Amount Including VAT";
                TotalVatAmount += SalesInvLine."Amount Including VAT" - SalesInvLine.Amount;
            until SalesInvLine.Next() = 0;

        //-- انسخ الصفوف إلى الـ DataItem Summary نفسه
        if TmpSummary.FindSet() then
            repeat
                Summary := TmpSummary;     // ينسخ كل الحقول مرة واحدة
                Summary.Insert();
            until TmpSummary.Next() = 0;

        if companyRec.FindSet() then begin
            CompanyName := companyRec.Name;
            CompanyCity := companyRec.City;
            CompanyAddr := companyRec.Address;
            CompanyVat := companyRec."VAT Registration No.";
        end;

        CustomerRec.SetRange(CustomerRec."No.", CustomerFilter);
        if CustomerRec.FindSet() then begin
            "Customer Name" := CustomerRec.Name;
            "Customer VAT" := CustomerRec."VAT Registration No.";
        end;*/
    end;
    //──────────────────── VARIABLES ────────────────────
    var
        CustomerFilter: Code[20];
        "Customer Name": Text[100];
        "Customer VAT": Text[20];
        FromDate: Date;
        ToDate: Date;

        TmpSummary: record "Tmp Item Summary" temporary;
        TotalExclVAT: Decimal;
        TotalInclVAT: Decimal;
        TotalVatAmount: Decimal;

        CompanyName: Text[100];
        CompanyCity: Text[30];
        CompanyAddr: Text[100];
        CompanyVat: Text[20];
        Tafqueet: array[2] of Text;
        Tafquit: Codeunit tafqueet2;
        AmountToWords: Report 1401;

}