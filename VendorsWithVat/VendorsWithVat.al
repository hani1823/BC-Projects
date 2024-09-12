pageextension 50107 "Vendors With Vat No" extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Financial Management")
        {
            action("Vendors With Vat No.")
            {
                ApplicationArea = All;
                Image = Excel;
                Visible = ShowFields;
                trigger OnAction()
                begin
                    "Vendors With Vat No".Run();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'MOLTEN CHEESE.';
    end;

    var
        "Vendors With Vat No": Report "Vendors With Vat No";
        ShowFields: Boolean;

}