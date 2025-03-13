pageextension 50200 MyExtension extends "Purchase Order Subform"
{


    actions
    {
        addlast("O&rder")
        {

            action(test)
            {
                Caption = 'Budget Type Line';
                ApplicationArea = all;

                trigger OnAction()
                var
                    PL: Record "Purchase Line";
                begin

                    CurrPage.SetSelectionFilter(PL);

                    if PL.FindSet() then begin
                        PL.Modifyall("Job Line Type", Enum::"Job Line Type"::Budget);
                    end;
                end;

            }
        }
    }

    var
        myInt: Integer;
}