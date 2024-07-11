page 50121 FruitPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = fruit;
    CardPageId = FruitCard;

    layout
    {
        area(Content)
        {
            repeater(GeneralList)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
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
                var
                    FruitReport: Report "FruitReport";
                begin
                    FruitReport.Run();
                end;
            }
            action(PrintOneRecord)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    fr: Record fruit;
                    OneRecord: Report "OneFruitReport";
                begin
                    CurrPage.SetSelectionFilter(fr);
                    OneRecord.SetTableView(fr);
                    OneRecord.Run();
                end;
            }
        }
    }


}