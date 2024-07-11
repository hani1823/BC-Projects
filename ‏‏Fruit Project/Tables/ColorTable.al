table 50127 ColorTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Color; Text[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Color; Color)
        {
            Clustered = true;
        }
    }


    var
        myInt: Integer;
}
