query 50070 "Ezee Invoice by folio Lines"
{
    Caption = 'Ezee Invoice by folio Lines';
    QueryType = Normal;

    elements
    {
        dataitem(eZee_Revenue_Line; "eZee Revenue Line2")
        {
            column(Hotel_Code; "Hotel Code") { }

            column(Folio_No_; "Folio No.")
            {
            }
            column(Charge_Name; "Charge Name")
            {
            }
            column(Amount; Amount)
            {
                Method = Sum;
            }

        }
    }
}