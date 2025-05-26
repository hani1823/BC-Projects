tableextension 50038 "purch lines EXt" extends "Purchase Line"
{
    fields
    {
        field(50000; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }

        field(50001; "Vendor Name"; Text[150])
        {

            FieldClass = FlowField;
            //DataClassification = Normal;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }
        field(50002; IsCreated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }


}