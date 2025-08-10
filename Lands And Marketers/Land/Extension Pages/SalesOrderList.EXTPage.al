pageextension 50144 "Sales Order List EXT" extends "Sales Order List"
{
    layout
    {
        addbefore("Assigned User ID")
        {
            field("Property Code"; Rec."Property Code")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
        }
    }
    trigger OnOpenPage()
    var
        LandRec: Record Land;
        salesLine: Record "Sales Line";
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';

    end;

    trigger OnAfterGetRecord()
    var
        LandRec: Record Land;
        salesLine: Record "Sales Line";
    begin
        if ShowFields then begin
            salesLine.SetRange("Document No.", Rec."No.");
            if salesLine.FindSet() then begin
                LandRec.SetRange("Instrument number", salesLine."No.");
                if LandRec.FindFirst() then
                    Rec."Property Code" := LandRec."Land Code";
            end;
        end;
    end;

    var
        ShowFields: Boolean;
}