report 50021 "Receipt Voucher"
{
    Caption = 'Receipt Voucher Customer';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = RVQuaed;
    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Entry No.";
            column(Customer_No; "Customer No.") { }
            column(Customer_Name; "Customer Name") { }
            column(Description; Description) { }
            column(amount; Amount) { }
            column(PostingDate; "Posting Date") { }
            column(Ext_Doc_No; "External Document No.") { }
            column(entryNo; "Entry No.") { }
            column(DocNo; "Document No.") { }
            column(payMethCod; "Payment Method Code") { }
        }
    }
    rendering
    {
        layout(RVQuaed)
        {
            Type = RDLC;
            LayoutFile = 'src/RVQuaed.rdl';
            Caption = 'ALINMA FOR CONSTRUCTION Layout';
        }
        layout(RVArtalِAlamy)
        {
            Type = RDLC;
            LayoutFile = 'src/RVArtalAlamy.rdl';
            Caption = 'Artal Al-Alamy Hotel Layout';
        }
        layout(RVArtalِTaibah)
        {
            Type = RDLC;
            LayoutFile = 'src/RVArtalTaibah.rdl';
            Caption = 'Artal Taibah Hotel Layout';
        }
        layout(RVRedPalm)
        {
            Type = RDLC;
            LayoutFile = 'src/RVRedPalm.rdl';
            Caption = 'ALINMA FOR REAL ESTATE Layout';
        }
        layout(RVLaundry)
        {
            Type = RDLC;
            LayoutFile = 'src/RVLaundry.rdl';
            Caption = 'Artal Arabia For Laundary Layout';
        }
        layout(RVMasharif)
        {
            Type = RDLC;
            LayoutFile = 'src/RVMasharif.rdl';
            Caption = 'Masharif Taibah Layout';
        }
    }
    trigger OnPreReport()
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        case CompanyInfo.Name of
            'ALINMA FOR CONSTRUCTION':
                DefaultRenderingLayout := 'RVQuaed';
            'ALINMA FOR HOTELING':
                DefaultRenderingLayout := 'RVArtalTaibah';
            'ALINMA FOR REAL ESTATE':
                DefaultRenderingLayout := 'RVRedPalm';
            'Artal Arabia For Laundary':
                DefaultRenderingLayout := 'RVLaundry';
            'Wafer Co.':
                DefaultRenderingLayout := 'RVMasharif';
            else
                DefaultRenderingLayout := 'RVQuaed'; // Default layout
        end;
    end;

    var
        DefaultRenderingLayout: Text;
}