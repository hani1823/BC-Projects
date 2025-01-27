reportextension 50115 "Aged Accounts Receivable EXT" extends "Aged Accounts Receivable"
{
    dataset
    {
        add(Customer)
        {
            column(Customer_Posting_Group; "Customer Posting Group") { }
            column(TotalPostGroup_Customer; Text01 + Format(' ') + "Customer Posting Group") { }
            column(CustFieldCaptPostingGroup; StrSubstNo(Text02, FieldCaption("Customer Posting Group"))) { }
        }
        modify(Customer)
        {
            RequestFilterFields = "Customer Posting Group";
        }
    }
    var
        Text01: Label 'Total for';
        Text02: Label 'Group Totals: %1';
}