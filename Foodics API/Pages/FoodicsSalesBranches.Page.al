page 50113 "Foodics Sales Branches"
{
    PageType = ListPart;
    SourceTable = "Foodics Branch";
    Caption = 'Foodics Sales Branches';
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name) { ApplicationArea = All; }
                field("Branch Id"; Rec."Branch Id") { ApplicationArea = All; }
                field("Journal Template Name"; Rec."Journal Template Name") { ApplicationArea = All; }
                field("Journal Batch Name"; Rec."Journal Batch Name") { ApplicationArea = All; }
                field("Branch Code"; Rec."Branch Code") { ApplicationArea = All; }
                field("Department Code"; Rec."Department Code") { ApplicationArea = All; }
            }
        }
    }

}
