pageextension 50111 ChangeVendorNoAction extends "Vendor Card"
{
    actions
    {
        addafter(PayVendor)
        {
            action("Correct No. Action")
            {
                ApplicationArea = All;
                Visible = true;
                trigger OnAction()
                var
                    ModifyNoCodeunit: Codeunit "Modify No Codeunit";
                begin
                    ModifyNoCodeunit.CorrectNoAction(Rec."No.");
                end;
            }
        }
    }
}