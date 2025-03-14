query 70028 "APIV1 - lands"
{
    QueryType = API;
    APIPublisher = 'Alinma';
    APIGroup = 'RealestateApp';
    APIVersion = 'v1.0';
    Caption = 'lands', Locked = true;
    EntityName = 'lands';
    EntitySetName = 'lands';

    elements
    {
        dataitem(land; Land)
        {
            column(Instrument_number; "Instrument number")
            {
                Caption = 'Instrument number', Locked = true;
            }
            column("Area"; "Area")
            {
                Caption = 'Area', Locked = true;
            }
            column(Block_number; "Block number")
            {
                Caption = 'Block number', Locked = true;
            }
            column(Piece_number; "Piece number")
            {
                Caption = 'Piece number', Locked = true;
            }
            column(Type_of_Land; "Type of Land")
            {
                Caption = 'Type of Land', Locked = true;
            }
            column(Using_of_Land; "Using of Land")
            {
                Caption = 'Using of Land', Locked = true;
            }
            column(Plan_Name; "Plan Name")
            {
                Caption = 'Plan Name', Locked = true;
            }
            column(Owner_Name; "Owner Name")
            {
                Caption = 'Owner Name', Locked = true;
            }
            column(Status; Status)
            {
                Caption = 'Status', Locked = true;
            }
            column(Total_price_per_meter; "Total price per meter")
            {
                Caption = 'Total price per meter', Locked = true;
            }
            column(Street; Street)
            {
                Caption = 'Street', Locked = true;
            }
        }
    }
}