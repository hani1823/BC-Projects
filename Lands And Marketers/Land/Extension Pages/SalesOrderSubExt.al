pageextension 50136 SalesOrderSubExt extends "Sales Order Subform"
{
    layout
    {
        // these lines of modify change the page opened in the Lookup of No. of the Lines in Sales Order Subform page
        Modify("No.")
        {
            Visible = ShowFields;
            ShowMandatory = true;
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
            field("Net Value"; Rec."Net Value")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Total Net Value"; Rec."Total Net Value")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
            field("Retax Value"; Rec."Retax Value")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Total Retax"; Rec."Total Retax")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = ShowFields;
            }
            field("Commission With VAT"; Rec."Commission With VAT")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Total Commission With VAT"; Rec."Total Commission With VAT")
            {
                ApplicationArea = all;
                Caption = 'Total Commission';
                Editable = false;
                Visible = ShowFields;
            }
            field("Commission Without VAT"; Rec."Commission Without VAT")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Total Commission Without VAT"; Rec."Total Commission Without VAT")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Total Vat of Commission"; Rec."Total Vat of Commission")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Inclusive Value"; Rec."Inclusive Value")
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
                ShowMandatory = true;
                trigger OnValidate()
                begin
                    CalculateValues();
                    CalculateTotalValues();
                    UpdateMarketerTable();
                    CurrPage.Update();
                end;
            }
        }
        addafter("Line Amount")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Visible = ShowFields;
            }
        }
        addafter("No.")
        {
            field("Land Code"; "Land Code")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowFields;
                Caption = 'Property Code';
            }
        }
        modify("Location Code")
        {
            Visible = (NOT ShowFields);
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = (NOT ShowFields);
        }
        modify("Reserved Quantity")
        {
            Visible = (NOT ShowFields);
        }
        modify("Line Discount %")
        {
            Visible = (NOT ShowFields);
        }
        modify("Line Amount")
        {
            Visible = (NOT ShowFields);
        }
        modify("Quantity Shipped")
        {
            Visible = (NOT ShowFields);
        }
        modify("Quantity Invoiced")
        {
            Visible = (NOT ShowFields);
        }
        modify("Qty. to Assign")
        {
            Visible = (NOT ShowFields);
        }
        modify("Item Charge Qty. to Handle")
        {
            Visible = (NOT ShowFields);
        }
        modify("Qty. Assigned")
        {
            Visible = (NOT ShowFields);
        }
        modify("Planned Delivery Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("Planned Shipment Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("Shipment Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("Applicable For Serv. Decl.")
        {
            Visible = (NOT ShowFields);
        }
        modify(Control45)
        {
            Visible = (NOT ShowFields);
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = (NOT ShowFields);
        }
        modify("Total Amount Incl. VAT")
        {
            Visible = (NOT ShowFields);
        }
        modify("Total VAT Amount")
        {
            Visible = (NOT ShowFields);
        }
    }

    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    trigger OnAfterGetRecord()
    var
        LandRec: Record Land;
    begin
        LandRec.SetRange("Instrument number", Rec."No.");
        if LandRec.FindFirst() then begin
            "Land Code" := LandRec."Land Code";
        end;
        CalculateValues();
        CalculateTotalValues();
        UpdateMarketerTable();
    end;

    local procedure UpdateMarketerTable()
    var
        MarketerRec: Record Marketer;
        TotalCommissionWithoutVAT: Decimal;
    begin
        MarketerRec.SetRange("Document No.", Rec."Document No.");
        if MarketerRec.FindSet() then begin
            repeat
                // Calculate the commission based on the updated values
                MarketerRec.Commission := Rec."Total Commission Without VAT" * MarketerRec.percentage;
                MarketerRec.Modify();
            until MarketerRec.Next() = 0;
        end;
    end;

    local procedure CalculateValues()
    var
        salesline: Record "Sales Line";
        LandRec: Record Land;
        VatOfCommission: Decimal;
    begin
        salesline.SetRange("Document No.", Rec."Document No.");
        salesline.SetRange("No.", Rec."No.");
        if salesline.Findset() then begin

            VatOfCommission := 0;

            LandRec.SetRange("Instrument number", Rec."No.");
            if LandRec.FindFirst() then begin
                Rec."Net Value" := LandRec."Area" * salesline."Price Per Meter";
                Rec."Retax Value" := Rec."Net Value" * 0.05;
                Rec."Commission Without VAT" := Rec."Net Value" * 0.025;
                VatOfCommission := Rec."Commission Without VAT" * 0.15;
                Rec."Commission With VAT" := Rec."Commission Without VAT" + VatOfCommission;
                Rec."Inclusive Value" := Rec."Net Value" + Rec."Retax Value" + Rec."Commission With VAT";
                Rec.Modify();
            end;
        end;
    end;

    //This method to calculate the totals
    local procedure CalculateTotalValues()
    var
        saleslie: Record "Sales Line";
        LandRec: Record Land;
        TotalNetValue: Decimal;
        LandArea: Decimal;
    begin
        TotalNetValue := 0;
        LandArea := 0;
        saleslie.SetRange("Document No.", Rec."Document No.");
        if saleslie.FindSet() then begin
            repeat
                LandRec.SetRange("Instrument number", saleslie."No.");
                if LandRec.FindSet() then begin
                    TotalNetValue += LandRec."Area" * saleslie."Price Per Meter";
                end;
                LandArea += LandRec."Area";
            until saleslie.Next() = 0;
        end;
        Rec."Total Net Value" := TotalNetValue;
        Rec."Total Retax" := Rec."Total Net Value" * 0.05;
        Rec."Total Commission Without VAT" := Rec."Total Net Value" * 0.025;
        Rec."Total Vat of Commission" := Rec."Total Commission Without VAT" * 0.15;
        Rec."Total Commission With VAT" := Rec."Total Commission Without VAT" + Rec."Total Vat of Commission";
        Rec."Total Inclusive Value" := Rec."Total Net Value" + Rec."Total Retax" + Rec."Total Commission With VAT";
        Rec.Modify();
    end;

    var
        ShowFields: Boolean;
        "Land Code": Code[20];

}