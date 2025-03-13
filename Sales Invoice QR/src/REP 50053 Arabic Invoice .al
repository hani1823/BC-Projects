report 50053 "Arabic - Invoice"
{
    RDLCLayout = './src/ArabicInvoice.rdl';
    // WordLayout = './StandardSalesInvoice.docx';
    Caption = 'Arabic - Invoice';
    DefaultLayout = RDLC;
    EnableHyperlinks = true;
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;

    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Order_Date; "Order Date") { }
            column(Currency_Code; "Currency Code") { }
            column(Your_Reference; "Your Reference") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(PaymenTerms; PaymenTerms) { }
            column(QrCode; QrCode) { }
            column(Tafqueet; Tafqueet[2]) { }
            column(TafqueetENG; Tafqueet[1]) { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Customer_No; "Sell-to Customer No.") { }
            column(Sell_to_County; "Sell-to County") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Sell_to_City; "Sell-to City") { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }

            column(TotalBeforeVat; TotalBeforeVat) { }
            column(TotalDiscount; TotalDiscount) { }
            column(TotalTaxableAmountBeforeVat; TotalTaxableAmountBeforeVat) { }
            column(TotalVatAmount; TotalVatAmount) { }
            column(TotalAmountAfterVat; TotalAmountAfterVat) { }


            column(CompanyName; companyInfo[1]) { }
            column(CompanyVat; companyInfo[2]) { }
            column(CompanyCountry; companyInfo[3]) { }
            column(CompanyPhone; companyInfo[4]) { }
            column(CompanyCity; companyInfo[5]) { }
            column(CompanyPostalCode; companyInfo[6]) { }
            column(CompanyAddr; companyInfo[7]) { }
            column(CustVat; customer[5]) { }



            dataitem(Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = Header;
                // DataItemTableView = SORTING("Document No.", "Line No.");
                column(LineNo_Line; "Line No.")
                {
                }
                column(Item_No_; "No.") { }
                column(Description; Description) { }
                column(Unit_Price; "Unit Price") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(VAT__; "VAT %") { }
                column(Amount; Amount) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }


            }



            trigger OnAfterGetRecord()
            var
                cust: Record Customer;
                company: Record "Company Information";

                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                BarcodeString: Text;

                SellerName: Text;
                varRegNum: Text;
                dateDoc: Date;
                vatAmount: Decimal;
                Invoicetotal: Decimal;

                SalesInvoiceHeader: Record "Sales Invoice Header";
                PayTerm: Record "Payment Terms";


            begin

                cust.SetRange("No.", "Sell-to Customer No.");
                if cust.FindSet() then customer[5] := cust."VAT Registration No.";

                //GenerateQRCode();
                ///////////////*********************////////////////////////
                /// 
                /// 

                if company.get() then begin
                    varRegNum := company."VAT Registration No.";
                    SellerName := company.Name;
                    companyInfo[1] := company.Name;
                    companyInfo[2] := company."VAT Registration No.";
                    companyInfo[3] := company.County;
                    companyInfo[4] := company."Phone No.";
                    companyInfo[5] := company.City;
                    companyInfo[6] := company."Post Code";
                    companyInfo[7] := company.Address;

                end;

                dateDoc := "Document Date";
                Invoicetotal := "Amount Including VAT";
                if SalesInvoiceHeader.Get("No.") then begin
                    SalesInvoiceHeader.CalcFields(Amount, "Amount Including VAT", "Invoice Discount Amount");
                    VATAmount := SalesInvoiceHeader."Amount Including VAT" - SalesInvoiceHeader.Amount;
                    Invoicetotal := SalesInvoiceHeader."Amount Including VAT";
                end;

                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";

                BarcodeString := '01' + Base64Convert.Int2Hex(StrLen(SellerName)) + Base64Convert.ConvertBase16(SellerName) +
                                         '02' + Base64Convert.Int2Hex(StrLen(varRegNum)) + Base64Convert.ConvertBase16(varRegNum) +
                                         '03' + Base64Convert.Int2Hex(StrLen(Format("Document Date"))) + Base64Convert.ConvertBase16(Format("Document Date")) +
                                         '04' + Base64Convert.Int2Hex(StrLen(Format(Invoicetotal))) + Base64Convert.ConvertBase16(Format(Invoicetotal)) +
                                         '05' + Base64Convert.Int2Hex(StrLen(Format(VATAmount))) + Base64Convert.ConvertBase16(Format(VATAmount));


                BarcodeString := Base64Convert.ConvertBase16StringToBinaryValue(BarcodeString);
                BarcodeString := Base64Convert.ConvertBinaryValueToBase64String2(BarcodeString);

                QrCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);

                /// 
                ///////////////*********************////////////////////////

                //// Tafquit
                /// 


                /// 
                AmountToWords.InitTextVariable;

                AmountToWords.FormatNoText(Tafqueet, Invoicetotal, 'SAR');
                Tafqueet[2] := Tafquit.Tafqueet(Invoicetotal);
                /// Tafquit



                /// payment terms
                PayTerm.SetRange(Code, "Payment Terms Code");
                if PayTerm.FindSet() then begin
                    PaymenTerms := PayTerm.Description;
                end;

                /// Totals
                TotalAmountAfterVat := Invoicetotal;
                TotalVatAmount := VATAmount;
                TotalDiscount := "Invoice Discount Amount";
                TotalTaxableAmountBeforeVat := TotalAmountAfterVat - VATAmount;
                TotalBeforeVat := TotalAmountAfterVat - VATAmount - TotalDiscount;




            end;
        }


    }






    var
        customer: array[5] of Text[100];
        Company: Record "Company Information";
        QrCode: Text;
        PaymenTerms: Text;
        Tafqueet: array[2] of Text;

        Base64Convert: Codeunit Base64ConvertTwo;
        Tafquit: Codeunit Tafqueet2;
        AmountToWords: Report 1401;
        companyInfo: array[7] of Text[100];

        TotalBeforeVat: Decimal;
        TotalDiscount: Decimal;
        TotalTaxableAmountBeforeVat: Decimal;
        TotalVatAmount: Decimal;
        TotalAmountAfterVat: Decimal;

}