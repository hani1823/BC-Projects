report 50125 OneFruitReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/OneFruitReport.rdl';
    dataset
    {
        dataitem(fruit; fruit)
        {
            column(ID; ID)
            {

            }
            column(Name; Name)
            {

            }
            column(Color; Color)
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Weight; Weight)
            {

            }
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(Check; Check)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        myInt: Integer;
        Check: Integer;
}