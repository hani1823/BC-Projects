table 50110 Owners
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "ID Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Nationality; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Email; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Mobile No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(6; Address; Code[150])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }
}