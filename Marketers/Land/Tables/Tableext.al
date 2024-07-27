tableextension 50133 Tableext extends "Sales Line"
{
    fields
    {
        field(70; "Price Per Meter"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Total Net Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Total Commission"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Total Retax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Total Inclusive Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}