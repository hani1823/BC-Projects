pageextension 50136 SalesOrderSubExt extends "Sales Order Subform"
{
    layout
    {
        // these lines of modify change the page opened in the Lookup of No. of the Lines in Sales Order Subform page
        Modify("No.")
        {
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

        //Here to add after the field "Total Amount Incl. VAT" these down defined fields 
        addafter("Total Amount Incl. VAT")
        {
            field("Total Net Value"; Rec."Total Net Value")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
            field("Total Retax"; Rec."Total Retax")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
            field("Total Commission With VAT"; Rec."Total Commission With VAT")
            {
                ApplicationArea = all;
                Caption = 'Total Commission';
                Editable = false;
                Visible = ShowFields;
            }
            field("Total Commission Without VAT"; Rec."Total Commission Without VAT")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Total Inclusive Value"; Rec."Total Inclusive Value")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
        }

        //Here to add after the field "Unit Price" these down defined fields 
        addafter("Unit Price")
        {
            field("Price Per Meter"; Rec."Price Per Meter")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                trigger OnValidate()
                begin
                    CalculateTotalValues();
                    CurrPage.Update();
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateTotalValues();
    end;

    //This method to calculate the totals
    local procedure CalculateTotalValues()
    var
        saleslie: Record "Sales Line";
    begin
        TotalNetValue := 0;
        VatOfCommission := 0;
        LandArea := 0;
        saleslie.SetRange("Document No.", Rec."Document No.");
        if saleslie.FindSet() then begin
            repeat
                LandRec.SetRange("Instrument number", saleslie."No.");
                if LandRec.FindSet() then
                    TotalNetValue += LandRec."Area" * saleslie."Price Per Meter";
                LandArea += LandRec."Area";
            until saleslie.Next() = 0;
        end;
        Rec."Total Net Value" := TotalNetValue;
        Rec."Total Retax" := Rec."Total Net Value" * 0.05;
        Rec."Total Commission Without VAT" := Rec."Total Net Value" * 0.025;
        VatOfCommission := Rec."Total Commission Without VAT" * 0.15;
        Rec."Total Commission With VAT" := Rec."Total Commission Without VAT" + VatOfCommission;
        Rec."Total Inclusive Value" := Rec."Total Net Value" + Rec."Total Retax" + Rec."Total Commission With VAT";
        Rec.Modify();
    end;

    var
        LandRec: Record Land;
        TotalNetValue: Decimal;
        VatOfCommission: Decimal;
        LandArea: Decimal;
        ShowFields: Boolean;

}