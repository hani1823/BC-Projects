query 50071 "Ezee Invoice by folio"
{
    Caption = 'Ezee Invoice by folio';
    QueryType = Normal;

    elements
    {
        dataitem(eZee_Revenue_Header; "eZee Revenue Header2")
        {
            column(Hotel_Code; "Hotel Code") { }
            column(Check_Out_Date; "Check Out Date") { }
            column(Folio_No_; "Folio No.")
            {
            }
            column(Bill_No____Invoice_No_; "Bill No. / Invoice No.")
            {
            }
            column(Total_Amount; "Total Amount")
            {
                Method = Sum;
            }

        }
    }
}