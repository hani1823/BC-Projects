pageextension 50135 "Sales Order Ext1" extends "Sales Order"
{
    layout
    {
        /*modify(SalesLines)
        {
            Editable = Rec."Plan Name" <> '';
        }*/
        addafter(Status)
        {
            field("Plan Name"; Rec."Plan Name")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                ShowMandatory = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    DimPlanRec.Reset();
                    if Page.RunModal(Page::NameLookup, DimPlanRec) = Action::LookupOK then begin
                        Rec."Plan Name" := DimPlanRec.Name;
                        Rec."Plan Code" := DimPlanRec.Code;
                        CurrPage.Update(true);
                    end;
                end;

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

                trigger OnDrillDown()
                var
                    OwnerQueryRec: Record TempTable2;
                    OwnerNameLookup: Page OwnerNameLookup;
                    SalesLinePage: Page "Sales Order Subform";
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
    }

    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    var
        ShowFields: Boolean;
        DimPlanRec: Record "Dimension Value";
}