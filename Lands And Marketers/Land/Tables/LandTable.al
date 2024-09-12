table 50128 Land
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Instrument number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Land Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Piece number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Block number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Street"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Area"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Total price per meter"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Type of Land"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Using of Land"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Owner Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Enum LandStatus)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "IsOwnedByQuaedAlinma"; Boolean)
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