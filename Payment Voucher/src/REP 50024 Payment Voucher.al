report 50049 "Payment Voucher Bank"
{
    DefaultRenderingLayout = PVQuaed;
    Caption = 'Payment Voucher';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Entry No.";

            column(Description; Description) { }
            column(amount; Amount) { }
            column(PostingDate; "Posting Date") { }
            column(Ext_Doc_No; "External Document No.") { }
            column(entryNo; "Entry No.") { }
            column(DocNo; "Document No.") { }
            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { }
            column(Employee; Employee) { }
            column(Assigned_User_ID; Assigned_User_ID) { }
            column(Bank_Account_No_; "Bank Account No.") { }
            column(Bank_Name; Bank_Name) { }

            trigger OnAfterGetRecord()
            var
                dimValue: Record "Dimension Value";
                users: Record User;
                BankAccount: Record "Bank Account";
            begin
                dimValue.SetRange("Dimension Code", 'EMPLOYEE');
                dimValue.SetRange(Code, "Shortcut Dimension 3 Code");
                if dimValue.FindSet() then begin
                    Employee := dimValue.Name;
                end;

                users.SetRange("User Name", UserId);
                if users.FindSet() then begin
                    Assigned_User_ID := users."Full Name";
                end;

                BankAccount.SetRange("No.", "Bank Account No.");
                if BankAccount.FindSet() then begin
                    Bank_Name := BankAccount.Name;
                end;
            end;
        }
    }

    rendering
    {
        layout(PVQuaed)
        {
            Type = RDLC;
            LayoutFile = 'src/PVQuaed.rdl';
            Caption = 'ALINMA FOR CONSTRUCTION Layout';
        }
        layout(RVArtalِAlamy)
        {
            Type = RDLC;
            LayoutFile = 'src/PVArtalAlamy.rdl';
            Caption = 'Artal Al-Alamy Hotel Layout';
        }
        layout(PVArtalِTaibah)
        {
            Type = RDLC;
            LayoutFile = 'src/PVArtalTaibah.rdl';
            Caption = 'Artal Taibah Hotel Layout';
        }
        layout(PVRedPalm)
        {
            Type = RDLC;
            LayoutFile = 'src/PVRedPalm.rdl';
            Caption = 'ALINMA FOR REAL ESTATE Layout';
        }
        layout(PVLaundry)
        {
            Type = RDLC;
            LayoutFile = 'src/PVLaundry.rdl';
            Caption = 'Artal Arabia For Laundary Layout';
        }
        layout(PVMasharif)
        {
            Type = RDLC;
            LayoutFile = 'src/PVMasharif.rdl';
            Caption = 'Masharif Taibah Layout';
        }
    }

    var
        Employee: Text;
        Assigned_User_ID: Text[100];
        Bank_Name: Text[100];
}