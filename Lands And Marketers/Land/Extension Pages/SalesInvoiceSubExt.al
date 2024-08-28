pageextension 50137 SalesInvoiceSubExt extends "Sales Invoice Subform"
{

    layout
    {
        Modify("No.")
        {
            Visible = ShowFields;
            trigger OnLookup(var Text: Text): Boolean
            var
                LandRec: Record Land;
                SalesHeader: Record "Sales Header";
                LandPage: Page "Land Page";
            begin
                /*retrieve the record from the "Sales Header" table that matches the given "Document Type" and "Document No." 
                from the current record (Rec).*/
                SalesHeader.Get(Rec."Document Type", Rec."Document No.");

                //Set the ranges to be the same as selected "Plan Name" and "Owner Name" in the Sales Header table
                LandRec.SetRange("Plan Name", SalesHeader."Plan Name");
                LandRec.SetRange("Owner Name", SalesHeader."Owner Name");

                //View the LandRec that filtered above in the LandPage, then make the lookupmode true.
                LandPage.SetTableView(LandRec);
                LandPage.LookupMode(true);

                //Run lookup page, and get the records of Land in Land page
                if LandPage.RunModal() = Action::LookupOK then begin
                    LandPage.GetRecord(LandRec);
                    Rec.Validate("No.", LandRec."Instrument number");
                    Text := Rec."No.";
                    exit(true);
                end;
                exit(false);
            end;
        }
        addafter("Unit Price")
        {
            field("Price Per Meter"; Rec."Price Per Meter")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
        }
        addafter("Line Amount")
        {
            /*field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Visible = ShowFields;
            }*/
            field(IsVerfied; Rec.IsVerfied)
            {
                ApplicationArea = All;
                Visible = ShowFields;
            }
        }
        modify("Unit Price")
        {
            Visible = ShowFields;
        }
    }
    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    var
        ShowFields: Boolean;
}