pageextension 50141 ExtGeneralJournal extends "General Journal"
{
    layout
    {
        modify("Total Emission CH4")
        {
            Visible = false;
        }
        modify("Total Emission N2O")
        {
            Visible = false;
        }
        modify("Total Emission CO2")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            ShowMandatory = IsAlinma;
        }
        modify(ShortcutDimCode4)
        {
            ShowMandatory = IsAlinma;
        }
    }

    trigger OnOpenPage()
    begin
        IsAlinma := Database.CompanyName() = 'ALINMA FOR HOTELING';
    end;

    var
        IsAlinma: Boolean;
}