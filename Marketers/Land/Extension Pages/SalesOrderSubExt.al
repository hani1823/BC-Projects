pageextension 50136 SalesOrderSubExt extends "Sales Order Subform"
{
    layout
    {
        addafter("Total Amount Incl. VAT")
        {
            field("Total Net Value"; Rec."Total Net Value")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Total Retax"; Rec."Total Retax")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Total Commission"; Rec."Total Commission")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Total Inclusive Value"; Rec."Total Inclusive Value")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Unit Price")
        {
            field("Price Per Meter"; Rec."Price Per Meter")
            {
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    CalculateTotalNetValue();
                end;
            }
        }

    }

    var
        LandRec: Record Land;
        TotalNetValue: Decimal;
        Vat: Decimal;
        WholeTotal: Decimal;
        LandArea: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalculateTotalNetValue();
    end;

    local procedure CalculateTotalNetValue()
    var
        saleslie: Record "Sales Line";
    begin
        TotalNetValue := 0;
        Vat := 0;
        WholeTotal := 0;
        LandArea := 0;
        saleslie.SetRange("Document No.", rec."Document No.");
        if saleslie.FindSet() then begin
            repeat
                LandRec.SetRange("Instrument number", saleslie."No.");
                if LandRec.FindSet() then
                    TotalNetValue += LandRec."Area" * saleslie."Price Per Meter";
                LandArea += LandRec."Area";
            until saleslie.Next() = 0;
        end;
        Rec."Total Net Value" := TotalNetValue;
        Rec."Total Retax" := Rec."Total Net Value" * 0.05;
        Rec."Total Commission" := Rec."Total Net Value" * 0.025;
        Vat := Rec."Total Commission" * 0.15;
        Rec."Total Inclusive Value" := Rec."Total Net Value" + Rec."Total Retax" + Rec."Total Commission" + Vat;
    end;


}