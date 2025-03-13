pageextension 50052 "EXT Purchase Order" extends "Purchase Order"
{

    trigger OnClosePage()
    var
        User_Setup: Record "User Setup";
        PO: Record "Purchase Header";
        PO_2: Record "Purchase Header";
        PO_Invoiced: Record "Purch. Inv. Header";
        LastDate: Date;
        FirstDate: Date;
        PO_Total: Decimal;
        PO_INV_Total: Decimal;
        TotalPurchaseLine: Record "Purchase Line";
        TotalInvoicedPurchaseLine: Record "Purch. Inv. Line";
        DocumentTotals: Codeunit "Document Totals";
        approvalEntry: Record "Approval Entry";
        Totals: array[5] of Decimal;
    begin

        PO_Total := 0;
        PO_INV_Total := 0;
        LastDate := CALCDATE('CM', Today);
        FirstDate := CALCDATE('-CM', Today);

        if CompanyName = 'ALINMA FOR HOTELING' then begin

            User_Setup.SetRange("User ID", 'AABDELGHANY');
            if User_Setup.FindSet() then begin
                ////************** PO Released **************\\\\\\\\
                PO.SetRange("Document Type", Enum::"Purchase Document Type"::Order);
                PO.SetFilter(Status, '%1|%2', Enum::"Purchase Document Status"::Released, Enum::"Purchase Document Status"::"Pending Approval");
                PO.SetFilter("Posting Date", '%1..%2', FirstDate, LastDate);
                PO.SetFilter("Payment Method Code", '3300');
                PO.SetFilter("Amount Including VAT", '<1001');
                if PO.FindSet() then
                    repeat
                        TotalPurchaseLine.SetRange("Document Type", Enum::"Purchase Document Type"::Order);
                        TotalPurchaseLine.SetRange("Document No.", po."No.");
                        TotalPurchaseLine.CalcSums("Amount Including VAT");
                        PO_Total := PO_Total + TotalPurchaseLine."Amount Including VAT";
                        TotalPurchaseLine.Reset();
                    until PO.Next() = 0;


                ////************** PO Invoiced **************\\\\\\\\  
                PO_Invoiced.SetFilter("Posting Date", '%1..%2', FirstDate, LastDate);
                PO_Invoiced.SetFilter("Order No.", 'HPO*');
                // PO_Invoiced.SetRange(Cancelled, false);
                PO_Invoiced.SetFilter("Amount Including VAT", '<1001');
                PO_Invoiced.SetFilter("Payment Method Code", '3300');
                if PO_Invoiced.FindSet() then
                    repeat
                        TotalInvoicedPurchaseLine.SetRange("Document No.", PO_Invoiced."No.");
                        TotalInvoicedPurchaseLine.CalcSums("Amount Including VAT");
                        PO_INV_Total := PO_INV_Total + TotalInvoicedPurchaseLine."Amount Including VAT";
                        TotalInvoicedPurchaseLine.Reset();
                    until PO_Invoiced.Next() = 0;
                if (PO_Total + PO_INV_Total) > 10000 then begin
                    User_Setup."Purchase Amount Approval Limit" := 0;
                    User_Setup.Modify;
                end;
            end;
        end;
    end;
}