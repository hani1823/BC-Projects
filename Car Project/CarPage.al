page 50101 "Car Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Car;
    CardPageId = "Car Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;

                }
                field(name; Rec.name)
                {
                    ApplicationArea = All;
                }
                field(date; Rec.date)
                {
                    ApplicationArea = All;
                }
                field(companyName; Rec.companyName)
                {
                    ApplicationArea = All;
                }
                field(fuelType; Rec.fuelType)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(PrintReport)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CarReport.Run();
                end;
            }
            action(OneRecordPrint)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(car);
                    OneRecordPrint.SetTableView(car);
                    OneRecordPrint.Run();
                end;
            }
        }
    }


    var
        myInt: Integer;
        CarReport: Report CarReport;
        OneRecordPrint: Report OneRecordReport;
        car: Record Car;
}