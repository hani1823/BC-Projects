query 50065 "Batch List in SR"
{
    Caption = 'Batch List in PR';
    QueryType = Normal;

    elements
    {
        dataitem(Sales_Line; "Sales Line")
        {
            column(Journal_Batch_Name; "Journal Batch Name")
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