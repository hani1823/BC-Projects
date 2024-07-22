page 50133 LandPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Land;

    layout
    {
        area(Content)
        {
            repeater("Land List")
            {
                field("Instrument number"; Rec."Instrument number")
                {
                    ApplicationArea = All;
                }
                field("Piece number"; Rec."Piece number")
                {
                    ApplicationArea = All;
                }
                field("Block number"; Rec."Block number")
                {
                    ApplicationArea = All;
                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = All;
                }
                field("Area"; Rec."Area")
                {
                    ApplicationArea = All;
                }
                field("Total price per meter"; Rec."Total price per meter")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

        }
    }
}