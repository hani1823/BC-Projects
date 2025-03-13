report 51102 "Employee Loans"
{
    ExcelLayout = 'Employee Loans.xlsx';
    Caption = 'Employee Loans';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    PreviewMode = PrintLayout;
    DataAccessIntent = ReadOnly;

    dataset
    {

        dataitem(Integer; Integer)
        {
            column(Account_NO; G_L_Account_No_) { }
            column(Account_Name; G_L_Account_Name) { }
            column(Employee_Code; Shortcut_Dimension_3_Code) { }
            column(Employee_Name; EmpoyeeName) { }
            column(Amount; Amount) { }
            trigger OnPreDataItem()
            begin
                LoanQuery.Open();
            end;

            trigger OnAfterGetRecord()
            var
                DimeValue: Record "Dimension Value";
            begin

                if LoanQuery.Read() then begin

                    DimeValue.SetRange("Dimension Code", 'EMPLOYEE');
                    DimeValue.SetRange(code, LoanQuery.Shortcut_Dimension_3_Code);
                    if DimeValue.FindSet() then EmpoyeeName := DimeValue.Name;

                    G_L_Account_No_ := LoanQuery.G_L_Account_No_;
                    G_L_Account_Name := LoanQuery.G_L_Account_Name;
                    Shortcut_Dimension_3_Code := LoanQuery.Shortcut_Dimension_3_Code;
                    Amount := LoanQuery.Amount;

                end else begin
                    LoanQuery.Close();
                    CurrReport.Break();
                end;

            end;
        }

    }


    var


        LoanQuery: Query "Employee Loans";
        LoanQuery2: Query "Employee Loans";
        EmpoyeeName: Text[100];
        G_L_Account_No_: code[20];
        G_L_Account_Name: Text;
        Shortcut_Dimension_3_Code: Text;
        Amount: Decimal;


}