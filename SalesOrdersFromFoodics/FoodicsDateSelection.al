page 50121 "Foodics Date Selection"
{
    PageType = StandardDialog;
    Caption = 'Select Business Date';

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field(BusinessDate; BusinessDate)
                {
                    Caption = 'Business Date';
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        BusinessDate: Date;
        Branch: Text[100];

    procedure InitDate(DefaultDate: Date)
    begin
        BusinessDate := DefaultDate;
    end;

    procedure GetDate(): Date
    begin
        exit(BusinessDate);
    end;
}