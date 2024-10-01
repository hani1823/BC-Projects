page 50133 "Land Page"
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
                field("Land Code"; Rec."Land Code")
                {
                    ApplicationArea = All;
                    Caption = 'Property Code';
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
                field("Price Per Meter"; Rec."Total price per meter")
                {
                    ApplicationArea = All;
                }
                field("Type of Land"; Rec."Type of Land")
                {
                    ApplicationArea = All;
                    Caption = 'Type of Property';
                }
                field("Using of Land"; Rec."Using of Land")
                {
                    ApplicationArea = All;
                    Caption = 'Using of Property';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(IsOwnedByQuaedAlinma; Rec.IsOwnedByQuaedAlinma)
                {
                    ApplicationArea = All;
                }
                field("Plan Name"; Rec."Plan Name")
                {
                    ApplicationArea = all;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}