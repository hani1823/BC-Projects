pageextension 50149 ExpiryDateItemPage extends "Item Card"
{
    layout
    {
        addafter(Type)
        {
            field("Has an Expiry Date?"; Rec."Has an Expiry Date?")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                ShowMandatory = true;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR HOTELING';
    end;

    var
        ShowFields: Boolean;
}