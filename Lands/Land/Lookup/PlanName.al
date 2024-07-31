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

    // Set the filters of the "Plan Name" Lookup
    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
        Rec.SetRange("Dimension Code", 'PROJECTS');

        //The mean of 'CP*' is to make the filter just show the records which Code value is start with CP and the remain is not matter.
        Rec.SetFilter(Code, 'CP*');
    end;
}