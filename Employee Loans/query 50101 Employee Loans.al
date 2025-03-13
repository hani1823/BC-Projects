query 51101 "Employee Loans"
{
    QueryType = Normal;

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            DataItemTableFilter = "G/L Account No." = filter(= 11050002);
            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { }

            column(G_L_Account_No_; "G/L Account No.")
            {
                ColumnFilter = G_L_Account_No_ = filter(= 11050002);

            }
            column(G_L_Account_Name; "G/L Account Name") { }
            column(Amount; Amount)
            {
                Method = sum;
            }

        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}