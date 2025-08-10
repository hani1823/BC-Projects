page 50115 "Foodics Purchase Branches"
{
    PageType = ListPart;
    SourceTable = "Foodics Purchase Branch";
    Caption = 'Foodics Purchase Branches';
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
                field("Branch Code"; Rec."Branch Code") { ApplicationArea = All; }
                field("Department Code"; Rec."Department Code") { ApplicationArea = All; }
            }
        }
    }

}
