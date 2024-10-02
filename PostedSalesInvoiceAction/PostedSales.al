pageextension 50119 "Posted Sales Invoice EXT" extends "Posted Sales Invoice"
{
    actions
    {
        addlast(Correct)
        {
            action("Correct VAT No.")
            {
                ApplicationArea = All;
                Visible = true;
                trigger OnAction()
                var
                    ModifyVATCodeunit: Codeunit "Modify VAT Codeunit";
                begin
                    ModifyVATCodeunit.CorrectVATNo(Rec."No.");
                end;
            }
        }
    }


}