page 50135 OwnerNameLookup
{
    PageType = List;
    SourceTable = TempTable2;
    ApplicationArea = All;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                }
                field("Plan Name"; Rec."Plan Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        qr: Query OwnerQuery;
    begin
        qr.SetRange(qr.Plan_Name, PlanName);
        if qr.Open() then begin
            while qr.Read() do begin
                rec.Init();
                Rec."Plan Name" := qr.Plan_Name;
                Rec."Owner Name" := qr.Owner_Name;
                rec.Insert();
            end;
            qr.Close();
        end;
    end;


    var
        PlanName: Text[100];

    procedure SetPlanName(Name: Text[100])
    begin
        PlanName := Name;
    end;
}
