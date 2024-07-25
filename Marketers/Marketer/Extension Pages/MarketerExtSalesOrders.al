pageextension 50132 "Sales Order Extension" extends "Sales Order"
{
    layout
    {
        addafter(SalesLines)
        {
            part(MarketersPart; "Marketer Page")
            {
                ApplicationArea = all;
                UpdatePropagation = SubPart;
                Visible = true;
            }
        }
    }

    /*trigger OnOpenPage()
    var
        CompanySetup: Record "Company Setup";
    begin
        PopulateCompanySetup();
        ShowMarketersPart := false;
        if CompanySetup."Company Name" = COMPANYNAME then begin
            ShowMarketersPart := CompanySetup.Visibility;
        end;
    end;*/

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

    /*procedure PopulateCompanySetup()
    var
        CompanySetup: Record "Company Setup";
    begin
        if not CompanySetup.Get('ALINMA FOR REAL ESTATE') then begin
            CompanySetup.Init();
            CompanySetup."Company Name" := 'ALINMA FOR REAL ESTATE';
            CompanySetup.Visibility := true;
            CompanySetup.Insert();
        end;
    end;*/

    var
        MarketerRec: Record Marketer;
        ShowMarketersPart: Boolean;
}