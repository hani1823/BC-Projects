page 50025 "Purchase Request Lines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purchase Line";



    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;

                }


            }
        }
    }


}