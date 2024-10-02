table 50110 Owners
{
    DataClassification = ToBeClassified;
    fields
    {
        field(50001; "ID Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Name; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; Nationality; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; Email; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Mobile No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50006; Address; Code[150])
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