pageextension 50018 "EXT Blanket Purchase Orders " extends "Blanket Purchase Orders"
{

    Caption = 'Purchase Requests';



    /*
        actions
        {
            addafter("O&rder")
            {
                action(NewAdd)
                {
                    Caption = 'Add';
                    Image = Add;
                    trigger OnAction()
                    begin
                        Message('Hello');
                    end;
                }
            }
        }
    */

    trigger OnOpenPage()
    begin
        //makeordeer := false;
        rec.Hidden := false;
        SetTableView(rec);
    end;
}