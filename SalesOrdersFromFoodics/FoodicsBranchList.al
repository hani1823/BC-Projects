page 50113 "Foodics Branches"
{
    PageType = ListPart;
    SourceTable = "Foodics Branch";
    Caption = 'Foodics Branches';
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name) { ApplicationArea = All; }
                field("Branch Id"; Rec."Branch Id") { ApplicationArea = All; }
                field("Journal Batch Name"; Rec."Journal Batch Name") { ApplicationArea = All; }
                field("Journal Template Name"; Rec."Journal Template Name") { ApplicationArea = All; }
                field("Sales G/L Account"; Rec."Sales G/L Account") { ApplicationArea = All; }
            }
        }
    }

}
