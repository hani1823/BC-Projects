pageextension 50137 ChangeStatus extends "Blanket Sales Order"
{
    actions
    {
        addafter("Co&mments")
        {
            action(ChangeStatus)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    //if Rec."No." = 'HSR-00014' then begin
                    if Rec.Status = Rec.Status::"Pending Approval" then begin
                        Rec.Status := rec.Status::Released;
                        Rec.Modify();
                    end
                end;
                //end;
            }
        }
    }

    var
        myInt: Integer;
}