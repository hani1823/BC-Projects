pageextension 50129 ItemPageEXT extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                Caption = 'Land Code';
                ApplicationArea = All;
                Visible = ShowFields;
            }
        }
    }
    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    var
        ShowFields: Boolean;

}