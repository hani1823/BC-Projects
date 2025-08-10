page 50114 "Foodics Accounts"
{
    PageType = ListPart;
    SourceTable = "Foodics Accounts";
    Caption = 'Foodics Accounts';
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the account.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'The type of the account.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The number of the account.';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The code of the branch associated with this account.';
                }
            }
        }
    }
}