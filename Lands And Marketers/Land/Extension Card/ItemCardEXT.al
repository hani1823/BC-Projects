pageextension 50115 ItemCardEXT extends "Item Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                Caption = 'Property Code';
                ApplicationArea = All;
                Visible = ShowFields;
                Editable = false;
                trigger OnValidate()
                var
                    LandRec: Record Land;
                begin
                    LandRec.SetRange("Instrument number", Rec."No.");
                    if LandRec.FindFirst() then begin
                        Rec."No. 2" := LandRec."Land Code";
                    end;
                end;
            }
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                LandRec: Record Land;
            begin
                LandRec.SetRange("Instrument number", Rec."No.");
                if LandRec.FindFirst() then begin
                    Rec."No. 2" := LandRec."Land Code";
                end;
            end;
        }
    }
    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    trigger OnAfterGetRecord()
    var
        LandRec: Record Land;
    begin
        LandRec.SetRange("Instrument number", Rec."No.");
        if LandRec.FindFirst() then begin
            Rec."No. 2" := LandRec."Land Code";
        end;
    end;

    var
        ShowFields: Boolean;
}