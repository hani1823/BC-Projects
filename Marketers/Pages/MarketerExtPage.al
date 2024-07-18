pageextension 50130 "Sales Invoice Extension" extends "Sales Invoice"
{
    layout
    {
        addafter(SalesLines)
        {

            part(MarketersPart; "Marketer Page")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }


    var
        myInt: Integer;
}