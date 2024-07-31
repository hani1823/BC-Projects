query 50130 ItemAvailabilityQuery
{
    QueryType = Normal;
    OrderBy = descending(Item_No_);

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {

            column(Quantity; Quantity)
            {
                Method = Sum;
            }

            column(Item_No_; "Item No.")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(Cost_Amount_Actual; "Cost Amount (Actual)")
            {
                Method = Sum;
            }
            filter(Posting_Date; "Posting Date")
            {

            }


        }
    }
}