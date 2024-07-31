table 50109 TempTableForOwnerQuery
{
    DataClassification = CustomerContent;
    TableType = Temporary;
    fields
    {
        field(1; "Plan Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Owner Name"; Code[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(test; "Plan Name", "Owner Name")
        {
            Clustered = true;
        }
    }


}