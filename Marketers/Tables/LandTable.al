table 50128 Land
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Instrument number"; BigInteger)
        {
            DataClassification = ToBeClassified;
            TableRelation = item;
        }
        field(2; "Piece number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Block number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Street"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Area"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Total price per meter"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Instrument number")
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