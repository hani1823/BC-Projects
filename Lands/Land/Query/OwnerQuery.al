query 50132 OwnerQuery
{
    QueryType = Normal;

    elements
    {
        dataitem(Land; Land)
        {
            column(Plan_Name; "Plan Name")
            {

            }
            column(Owner_Name; "Owner Name")
            {

            }
            column("Area"; "Area")
            {
                Method = Sum;
            }
        }
    }
}