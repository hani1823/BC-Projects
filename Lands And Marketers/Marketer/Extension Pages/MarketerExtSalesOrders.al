pageextension 50132 "Sales Order Extension" extends "Sales Order"
{
    layout
    {
        addafter(SalesLines)
        {

            part(MarketersPart; "Marketer Page")
            {
                ApplicationArea = all;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = FIELD("No.");
                Visible = ShowMarketersPart;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowMarketersPart := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage.MarketersPart.Page.SetSalesHeader(Rec);
        SetMarketerFilter();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetMarketerFilter();
    end;

    local procedure SetMarketerFilter()
    begin
        MarketerRec.FilterGroup(2);
        MarketerRec.SetRange("Document No.", Rec."No.");
        MarketerRec.FilterGroup(0);
        CurrPage.MarketersPart.Page.SetTableView(MarketerRec);
    end;

    var
        MarketerRec: Record Marketer;
        ShowMarketersPart: Boolean;
}