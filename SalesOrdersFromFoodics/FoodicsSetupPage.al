page 50112 "Foodics Setup"
{
    PageType = Card;
    SourceTable = "Foodics Setup";
    Caption = 'Foodics Setup';
    Editable = true;

    layout
    {
        area(Content)
        {

            group(General)
            {

                field("Base URL"; Rec."Base URL") { ApplicationArea = All; }
                field("API Token"; Rec."API Token") { ApplicationArea = All; }
                field("Journal Template Name"; Rec."Journal Template Name") { ApplicationArea = All; }
            }

            part(Branches; "Foodics Branches")
            {
                ApplicationArea = All;
                SubPageLink = "Journal Template Name" = field("Journal Template Name");
                UpdatePropagation = Both;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then begin
            Rec.Init();
            Rec."Primary Key" := 'SETUP';
            Rec.Insert();
            CurrPage.Update(false);
        end;
    end;


}
