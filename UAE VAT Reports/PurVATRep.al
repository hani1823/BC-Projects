report 50159 "LSC Purchase VAT Register"
{
    ApplicationArea = Basic, Suite;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/UAE.PurchaseVATRegister.rdl';
    Caption = 'Purchase VAT Register (UAE) NEW';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(VATEntry; "VAT Entry")
        {
            DataItemTableView = SORTING("Document No.", "Posting Date")
                                WHERE(Type = FILTER(Purchase));
            RequestFilterFields = Type, "Posting Date";
            column(CompName; CompInfo.Name)
            {
            }
            column(UserID; USERID)
            {
            }
            column(ReportDate; FORMAT(WORKDATE, 0, 4))
            {
            }
            column(ReportFilters; GETFILTERS)
            {
            }
            column(SrNo; SrNo)
            {
            }
            column(TAXGroupCode; VATGroupCode)
            {
            }
            /*column(Dimension; STRSUBSTNO('%1 - %2', "LSC VAT Dimension Code", DimName))
            {
            }*/
            column(DocumentNo; "Document No.")
            {
            }
            column(ExternalDocNo; "External Document No.")
            {
            }
            /*column(Narration; "LSC Narration")
            {
            }*/
            column(PostingDate; FORMAT("Posting Date"))
            {
            }
            column(SourceName; SourceName)
            {
            }
            column(SourceTRNNo; SourceTRNNo)
            {
            }
            column(TaxableAmount; Base)
            {
            }
            column(TAXPct; TAXPct)
            {
            }
            column(TaxAmount; Amount)
            {
            }
            column(DocumentAmount; Base + Amount)
            {
            }

            trigger OnAfterGetRecord()
            var
                dVATPostingSetup: Record "VAT Posting Setup";
                dCustomer: Record Customer;
                dVendor: Record Vendor;
                dDimValue: Record "Dimension Value";
            begin
                /*
                IF "VAT Calculation Type" IN ["VAT Calculation Type"::"Sales Tax","VAT Calculation Type"::"Reverse Charge VAT"] THEN
                  CurrReport.SKIP;
                */

                CLEAR(VATGroupCode);
                CLEAR(TAXPct);
                dVATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                //VATGroupCode := dVATPostingSetup."LSC VAT Group Code";
                TAXPct := dVATPostingSetup."VAT %";

                SrNo += 1;

                CLEAR(SourceName);
                CLEAR(SourceTRNNo);
                IF "Bill-to/Pay-to No." <> '' THEN BEGIN
                    IF dCustomer.GET("Bill-to/Pay-to No.") THEN BEGIN
                        SourceName := dCustomer.Name;
                        SourceTRNNo := dCustomer."VAT Registration No.";
                    END ELSE
                        IF dVendor.GET("Bill-to/Pay-to No.") THEN BEGIN
                            SourceName := dVendor.Name;
                            SourceTRNNo := dVendor."VAT Registration No.";
                        END;
                END;

                /*CLEAR(DimName);
                IF dDimValue.GET(DimCode, "LSC VAT Dimension Code") THEN
                    DimName := dDimValue.Name;*/
            end;

            /*trigger OnPreDataItem()
            var
                dDimension: Record Dimension;
            begin
                CLEAR(SrNo);
                CompInfo.GET;
                dDimension.RESET;
                dDimension.SETRANGE("LSC VAT Dimension", TRUE);
                IF dDimension.FINDFIRST THEN
                    DimCode := dDimension.Code;
            end;*/
        }
    }

    requestpage
    {

        layout
        {
        }
    }

    labels
    {
    }

    var
        CompInfo: Record "Company Information";
        ReportType: Option "Without Reverse Charge","With Reverse Charge";
        SrNo: Integer;
        SourceName: Text;
        SourceTRNNo: Text[20];
        TAXPct: Decimal;
        VATGroupCode: Code[10];
        DimCode: Code[20];
        DimName: Text;
}

