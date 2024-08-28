tableextension 50133 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(24; "Price Per Meter"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Net Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Total Net Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Commission With VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Total Commission With VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Commission Without VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Total Commission Without VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Retax Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Total Retax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Total Vat of Commission"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Inclusive Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Total Inclusive Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "IsVerfied"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(47; Status; Enum LandStatus)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Land.Status where("Instrument number" = field("No.")));
        }

    }

}