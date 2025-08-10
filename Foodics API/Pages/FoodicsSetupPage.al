page 50112 "Foodics Setup"
{
    PageType = Card;
    SourceTable = "Foodics Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Foodics Setup';

    Editable = true;

    layout
    {
        area(Content)
        {

            group(General)
            {

                field("Base URL"; Rec."Base URL") { ApplicationArea = All; }
                field("API Token"; Rec."API Token")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if UserSecurityId() <> '601fa94b-d9da-43c6-8e38-520498eba153' then begin
                            Editable := false;
                        end;
                    end;
                }
                field("Journal Template Name"; Rec."Journal Template Name") { ApplicationArea = All; }
            }

            part(Accounts; "Foodics Accounts")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            part(Branches; "Foodics Sales Branches")
            {
                ApplicationArea = All;
                SubPageLink = "Journal Template Name" = field("Journal Template Name");
                UpdatePropagation = Both;
            }
            part(PurchaseBranches; "Foodics Purchase Branches")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            part(ConsumptionBranches; "Foodics Consumption Branches")
            {
                ApplicationArea = All;
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
