query 50131 StockOnHandQuery
{
    QueryType = Normal;
    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            column(Item_No_; "Item No.")
            {

            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }



        }
    }
}