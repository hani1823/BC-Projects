table 50128 Land
{
    DataClassification = ToBeClassified;
    fields
    {
        field(50001; "Instrument number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Land Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Piece number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Block number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Street"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Area"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Total price per meter"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Type of Land"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Using of Land"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Owner Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; Status; Enum LandStatus)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "IsOwnedByQuaedAlinma"; Boolean)
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