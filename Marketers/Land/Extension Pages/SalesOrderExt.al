pageextension 50135 "Sales Order Ext2" extends "Sales Order"
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

                trigger OnValidate()
                begin
                    if Rec."Plan Name" <> '' then begin
                        DimRec.Reset();
                        DimRec.SetRange(Name, Rec."Plan Name");
                        if not DimRec.FindFirst() then begin
                            Rec."Plan Name" := '';
                            Rec."Plan Code" := '';
                            Error('The entered Plan Name is not valid. Please select a valid Plan Name from the lookup page.');
                        end
                        else begin
                            Rec."Plan Code" := DimRec.Code;
                        end;
                    end;
                end;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    DimRec.Reset();
                    Rec.SetRange("No.", Rec."No.");
                    if Page.RunModal(Page::NameLookup, DimRec) = Action::LookupOK then begin
                        Rec."Plan Name" := DimRec.Name;
                        Rec."Plan Code" := DimRec.Code;
                        CurrPage.Update(true);
                    end;
                end;
            }
            field("Owner Name"; Rec."Owner Name")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                Editable = Rec."Plan Name" <> '';

            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;



    var
        ShowFields: Boolean;
        DimRec: Record "Dimension Value";



}