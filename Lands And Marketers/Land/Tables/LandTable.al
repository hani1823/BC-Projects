table 50128 Land
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Instrument number"; code[20])
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
        field(7; "Type of Land"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Using of Land"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Owner Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Status; Enum LandStatus)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "IsOwnedByQuaedAlinma"; Boolean)
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
}