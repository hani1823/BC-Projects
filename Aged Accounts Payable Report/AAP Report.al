reportextension 50114 "Aged Accounts Payable" extends "Aged Accounts Payable"
{
    dataset
    {
        add(TempVendortLedgEntryLoop)
        {
            column(Description; TempVendorLedgEntry.Description) { }
            column("القطاع"; TempVendorLedgEntry."Global Dimension 1 Code") { }
            column("المشروعات"; TempVendorLedgEntry."Global Dimension 2 Code") { }
            column(Entry_No; TempVendorLedgEntry."Entry No.") { }
            column(User_ID; TempVendorLedgEntry."User ID") { }
            column(Order_No_; "Order No.") { }
        }
        modify(TempVendortLedgEntryLoop)
        {
            trigger OnAfterAfterGetRecord()
            var
                "Project LI": Record "Job Ledger Entry";
                "Posted PI": Record "Purch. Inv. Header";
            begin
                Clear("Order No.");

                "Posted PI".Reset();
                "Posted PI".SetRange("Vendor Ledger Entry No.", TempVendorLedgEntry."Entry No.");
                if "Posted PI".FindFirst() then begin
                    "Order No." := "Posted PI"."Order No.";
                end;
            end;
        }
    }
    var
        "Order No.": Code[20];
}