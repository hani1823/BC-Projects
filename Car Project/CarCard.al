namespace ALProject.ALProject;

page 50102 "Car Card"
{
    ApplicationArea = All;
    Caption = 'Car Card';
    PageType = Card;
    SourceTable = Car;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                }
                field(name; Rec.name)
                {
                    ToolTip = 'Specifies the value of the name field.', Comment = '%';
                }
                field("date"; Rec."date")
                {
                    ToolTip = 'Specifies the value of the date field.', Comment = '%';
                }
                field(companyName; Rec.companyName)
                {
                    ToolTip = 'Specifies the value of the companyName field.', Comment = '%';
                }
                field(fuelType; Rec.fuelType)
                {
                    ToolTip = 'Specifies the value of the fuelType field.', Comment = '%';
                }
            }
        }
    }
}
