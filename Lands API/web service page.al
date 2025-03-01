page 50144 "Get Report Parms"
{
    Caption = 'Get Report Parms';
    ApplicationArea = all;
    PageType = Card;
    layout
    {
        area(Content)
        {
            field(ReportNo; ReportNo)
            {
                Caption = 'Report';
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    message(Report.RunRequestPage(ReportNo));
                end;
            }
        }
    }
    var
        ReportNo: Integer;
}