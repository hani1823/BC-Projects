report 50104 OneRecordReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/OneRecordReport.rdl';

    dataset
    {
        dataitem(Car; Car)
        {
            column(ID; ID)
            {
                IncludeCaption = true;
            }
            column(name; name)
            {
                IncludeCaption = true;
            }
            column(companyName; companyName)
            {
                IncludeCaption = true;
            }
            column(date; date)
            {
                IncludeCaption = true;
            }
            column(fuelType; fuelType)
            {
                IncludeCaption = true;
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
                group(GroupName)
                {

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
}