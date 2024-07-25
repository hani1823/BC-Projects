pageextension 50130 "Sales Invoice Extension" extends "Sales Invoice"
{

    layout
    {
        addafter(SalesLines)
        {
            part(MarketersPart; "Marketer Page")
            {
                ApplicationArea = All;
                UpdatePropagation = SubPart;
            }
        }
    }

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
}
