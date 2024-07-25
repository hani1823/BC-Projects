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
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
                field(percentage; Rec.percentage)
                {
                    ApplicationArea = all;

                    //Check section for the sum of all percentage to be between 0 and 1 
                    trigger OnValidate()
                    var
                        TotalPercentage: Decimal;
                    begin
                        MarketerRec.SetRange("Document No.", Rec."Document No.");
                        if MarketerRec.FindSet() then begin
                            repeat
                                if MarketerRec."No." <> Rec."No." then
                                    TotalPercentage += MarketerRec.percentage;
                            until MarketerRec.Next() = 0;
                        end;
                        TotalPercentage += Rec.percentage;

                        if TotalPercentage > 1 then
                            Error('The sum of all records percentage must be 1 or less. Your current sum = %1', TotalPercentage);

                        if TotalPercentage < 0 then
                            Error('The sum of all records percentage must be 0 or more. Your current sum = %1', TotalPercentage);

                    end;
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
        MarketerRec: Record Marketer;



}