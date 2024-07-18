page 50131 "Marketer Page"
{
    Caption = 'Marketers';
    PageType = Listpart;
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
                    ApplicationArea = all;
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
    var
        VendorRec: Record Vendor;
}