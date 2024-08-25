pageextension 50118 CustomerCardEXT extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("Customer ID"; Rec."Customer ID")
            {
                ApplicationArea = All;
                Visible = ShowFields;
            }
            field("Date of Birth"; Rec."Date of Birth")
            {
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