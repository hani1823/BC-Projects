page 50131 "Marketer Page"
{
    Caption = 'Marketers';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = Marketer;

    layout
    {
        area(Content)
        {
            repeater("Marketers List")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    // This lines generate a lookup page of the Vendors list
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        VendorRec.SetRange("Gen. Bus. Posting Group", 'Agents');
                        if PAGE.RunModal(PAGE::"Vendor List", VendorRec) = ACTION::LookupOK then begin
                            Rec."No." := VendorRec."No.";
                            Rec.Name := VendorRec.Name;
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }



    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document No." := SalesRec."No.";

    end;

    procedure SetSalesHeader(SalesHeader: Record "Sales Header")
    begin
        SalesRec := SalesHeader;
    end;

    var
        VendorRec: Record Vendor;
        SalesRec: Record "Sales Header";


}