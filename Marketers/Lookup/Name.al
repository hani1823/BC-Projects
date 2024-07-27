page 50128 NameLookup
{
    PageType = List;
    SourceTable = "Dimension Value";
    ApplicationArea = All;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        // Add actions here if needed
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
        Rec.SetRange("Dimension Code", 'PROJECTS');
        Rec.SetFilter(Code, 'CP*');
    end;
}
