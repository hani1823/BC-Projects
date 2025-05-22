pageextension 50138 ExtPaymentJournal extends "Payment Journal"
{
    layout
    {
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