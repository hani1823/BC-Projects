report 50103 "CarReport"
{
    UsageCategory = ReportsAndAnalysis;
    AdditionalSearchTerms = 'Cars, Report';
    ApplicationArea = All;
    Caption = 'Car Reports';
    RDLCLayout = 'Layouts/CarList.rdl';

    dataset
    {
        dataitem(Car; Car)
        {
            //RequestFilterFields = companyName, date, name;
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
            column(Car_Title; Car_Title)
            {

            }
        }
    }

    requestpage
    {
        AboutTitle = 'Here is the AboutTiltle';
        AboutText = 'Here is the AboutText';
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
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
        Car_Title: Label 'Cars Report';
}