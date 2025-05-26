query 50037 "Vendor List in PR"
{
    Caption = 'Vendor List in PR';
    QueryType = Normal;

    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            column(Vendor_No_; "Vendor No.")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(IsCreated; IsCreated)
            {
            }
            column(Count)
            {
                Method = Count;
            }
        }
    }
}