table 50109 TempTable2
{
    DataClassification = CustomerContent;
    TableType = Temporary;
    fields
    {

        field(2; "Owner Name"; Code[60])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(test; "Owner Name")
        {
            Clustered = true;
        }
    }


}