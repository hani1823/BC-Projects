table 50133 "Company Setup"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Company Name"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Visibility"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Company Name")
        {
            Clustered = true;
        }
    }

}
