pageextension 50134 SalesSubExt extends "Sales Order Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                LandPage: Page "Land Page";
                LandRec: Record Land;
            begin
                if Page.RunModal(Page::"Land Page", LandRec) = Action::LookupOK then begin
                    Rec."No." := Format(LandRec."Instrument number");
                    Text := Rec."No.";
                    exit(true);
                end;
                exit(false);
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}