table 50128 Land
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; type; Enum LandType)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Land Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Land Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

}