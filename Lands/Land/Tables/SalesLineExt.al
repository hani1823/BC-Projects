tableextension 50133 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(24; "Price Per Meter"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Total Net Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Total Commission With VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Total Commission Without VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Total Retax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Total Inclusive Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}