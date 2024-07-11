pageextension 50106 ItemAvailabilityPage extends "Item List"
{
    layout
    {
        // Add changes to page layout here
    }
    actions
    {
        addfirst(Reporting)
        {
            action("Stock On Hand")
            {
                ApplicationArea = All;
                Image = Excel;
                trigger OnAction()
                begin
                    ItemAvailability.Run();

                end;
            }
        }
    }

    var
        ItemAvailability: Report ItemAvailabilityReport;
}