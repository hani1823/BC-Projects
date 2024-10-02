table 50114 Contributors
{
    DataClassification = ToBeClassified;
    fields
    {
        field(50001; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Contributor Name"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; Percentage; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 10;
            AutoFormatExpression = '<precision, 2:4><standard format,0>%';
        }
    }

    keys
    {
        key(Key1; "Plan Name", "Contributor Name")
        {
            Clustered = true;
        }
    }
}