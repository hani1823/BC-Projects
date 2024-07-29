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
                Visible = ShowFields;
            }
            field("Total Retax"; Rec."Total Retax")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
            field("Total Commission"; Rec."Total Commission")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
            field("Total Inclusive Value"; Rec."Total Inclusive Value")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
        }
        addafter("Unit Price")
        {
            field("Price Per Meter"; Rec."Price Per Meter")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                trigger OnValidate()
                begin
                    CalculateTotalValues();
                end;
            }
        }

    }

    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateTotalValues();
    end;

    local procedure CalculateTotalValues()
    var
        saleslie: Record "Sales Line";
    begin
        TotalNetValue := 0;
        VatOfCommission := 0;
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
        VatOfCommission := Rec."Total Commission" * 0.15;
        Rec."Total Inclusive Value" := Rec."Total Net Value" + Rec."Total Retax" + Rec."Total Commission" + VatOfCommission;
        CurrPage.Update();
    end;

    var
        LandRec: Record Land;
        TotalNetValue: Decimal;
        VatOfCommission: Decimal;
        LandArea: Decimal;
        ShowFields: Boolean;
        SalesHeaderRec: Record "Sales Header";

}