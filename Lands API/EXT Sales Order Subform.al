pageextension 50266 "SalesOrderSubformExt" extends "Sales Order Subform"
{
    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    trigger OnAfterGetRecord()
    begin
        // Update the Unit Price only if it differs from Total Commission Without VAT
        if (ShowFields) then begin
            if Rec."Unit Price" <> Rec."Total Commission Without VAT" then begin
                Rec.Validate("Unit Price", Rec."Total Commission Without VAT");
                Rec.Modify(true);
            end;
        end;
    end;

    var
        ShowFields: Boolean;

}