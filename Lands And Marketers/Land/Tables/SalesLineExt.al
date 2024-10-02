tableextension 50133 SalesLinesExt extends "Sales Line"
{
    fields
    {
        field(50024; "Price Per Meter"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Net Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Total Net Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Commission With VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Total Commission With VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Commission Without VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Total Commission Without VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Retax Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "Total Retax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Total Vat of Commission"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Inclusive Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Total Inclusive Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50047; Status; Enum LandStatus)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Land.Status where("Instrument number" = field("No.")));
        }

    }

}