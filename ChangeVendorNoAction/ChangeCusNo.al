pageextension 50112 ChangeCustomerNoAction extends "Customer Card"
{
    actions
    {
        addafter("Sales Journal")
        {
            action("Correct No. Action")
            {
                ApplicationArea = All;
                Visible = true;
                trigger OnAction()
                var
                    ModifyNoCodeunit: Codeunit "Modify Cust No Codeunit";
                begin
                    ModifyNoCodeunit.CorrectNoAction(Rec."No.");
                end;
            }
        }
    }
}