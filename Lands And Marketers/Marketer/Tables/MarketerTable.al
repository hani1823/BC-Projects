table 50131 "Marketer"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Percentage; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 10;
            AutoFormatExpression = '<precision, 2:4><standard format,0>%';
        }
        field(5; Commission; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "No.", "Document No.")
        {
            Clustered = true;
        }
    }
}