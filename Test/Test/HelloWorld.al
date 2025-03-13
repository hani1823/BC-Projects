page 51000 Test
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Correct G/L entry';
    Permissions = tabledata "LSC Statement" = RIMD;

    //SourceTable = TableName;

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                var

                    stateTab: Record "LSC Statement";
                    filterdate: date;

                begin
                    filterdate := 20240416D;
                    stateTab.SetRange("Posting Date", filterdate);
                    if stateTab.FindSet() then begin
                        repeat
                            Message('%1 --*******', stateTab."No.");
                        until stateTab.Next() = 0;

                        stateTab.Delete();
                        Commit();
                    end;



                end;
            }
        }
    }

    var
        myInt: Integer;
        codi: Codeunit "Cryptography Management";
}