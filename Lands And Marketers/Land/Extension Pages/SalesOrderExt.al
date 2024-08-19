pageextension 50135 "Sales Order Ext1" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Plan Name"; Rec."Plan Name")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                ShowMandatory = true;
                Editable = Rec."Sell-to Customer Name" <> '';

                //run the NameLookup page and show the list and set the values of Plan Name and Plan Code
                trigger OnLookup(var Text: Text): Boolean
                begin
                    DimPlanRec.Reset();
                    if Page.RunModal(Page::"Plan Name Lookup", DimPlanRec) = Action::LookupOK then begin
                        Rec."Plan Name" := DimPlanRec.Name;
                        Rec."Plan Code" := DimPlanRec.Code;
                        CurrPage.Update(true);
                    end;
                end;

                /*validation of the Plan Name field if the field is empty or not, if not empty then if the entered value is the same
                value as exist in the Dimension Value or not, if not an error message appear*/
                trigger OnValidate()
                begin
                    if Rec."Plan Name" <> '' then begin
                        DimPlanRec.Reset();
                        DimPlanRec.SetRange(Name, Rec."Plan Name");
                        if not DimPlanRec.FindFirst() then begin
                            Rec."Plan Name" := '';
                            Rec."Plan Code" := '';
                            Error('The entered Plan Name is not valid. Please select a valid Plan Name from the lookup page.');
                        end
                        else begin
                            Rec."Plan Code" := DimPlanRec.Code;
                        end;
                    end;
                end;
            }
            field("Owner Name"; Rec."Owner Name")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                ShowMandatory = true;
                Editable = Rec."Plan Name" <> '';

                //run the OwnerNameLookup page and show the list and set the values of Owner Name
                trigger OnLookup(var Text: Text): Boolean
                var
                    OwnerQueryRec: Record TempTableForOwnerQuery;
                    OwnerNameLookup: Page "Owner Name Lookup";
                begin
                    OwnerQueryRec.Reset();
                    OwnerQueryRec.SetRange("Plan Name", Rec."Plan Name");

                    OwnerNameLookup.SetTableView(OwnerQueryRec);
                    OwnerNameLookup.LookupMode(true);
                    OwnerNameLookup.SetPlanName(Rec."Plan Name");

                    if OwnerNameLookup.RunModal() = ACTION::LookupOK then begin
                        OwnerNameLookup.GetRecord(OwnerQueryRec);
                        Rec."Owner Name" := OwnerQueryRec."Owner Name";
                        CurrPage.Update(true);
                    end;

                end;

                /*validation of the Owner Name field if the field is empty or not, if not empty then if the entered value is the same
                value as exist in the Land table or not, if not an error message appear*/
                trigger OnValidate()
                var
                    LandRec: Record Land;
                begin
                    if Rec."Owner Name" <> '' then begin
                        LandRec.Reset();
                        LandRec.SetRange("Plan Name", Rec."Plan Name");
                        LandRec.SetRange("Owner Name", Rec."Owner Name");
                        if not LandRec.FindFirst() then begin
                            Rec."Owner Name" := '';
                            Error('The entered Owner Name is not valid for the selected Plan Name. Please select a valid Owner Name from the lookup page.');
                        end;
                    end;
                end;
            }
        }
        //This line used to make the part of SalesLines unenabled until these three conditions be true
        modify(SalesLines)
        {
            Enabled = (NOT ShowFields) OR ((Rec."Plan Name" <> '') AND (Rec."Owner Name" <> ''));
        }
    }

    actions
    {
        addafter("&Print")
        {
            action("Sales Order")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::SalesOrderReport, true, false, SalesHeader);
                end;
            }
        }
        addbefore("Sales Order")
        {
            action("Print Quotation")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::PrintQuotationReport, true, false, SalesHeader);
                end;
            }
        }
        /*addafter("Create Purchase Document")
        {
            action("Make Order")
            {
                ApplicationArea = All;
                Image = MakeOrder;
                trigger OnAction()
                var
                    SalesLineRec: Record "Sales Line";
                    SO_Lines_ToBe_inserted: Record "Sales Line";
                    SI_Lines_ToBe_inserted: Record "Sales Line";
                begin
                    if Rec.
                end;
            }*/
    }


    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    var
        ShowFields: Boolean;
        DimPlanRec: Record "Dimension Value";

}