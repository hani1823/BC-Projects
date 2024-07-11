report 50124 FruitReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/FruitReport.rdl';

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
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Report)
                {
                    field(Check; Check)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

    }


    var
        myInt: Integer;
        Check: Boolean;
}