page 50128 ColorLookup
{
    PageType = List;
    SourceTable = ColorTable;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Add actions here if needed
    }
}
