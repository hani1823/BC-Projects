reportextension 50133 "Edited Detail Trial Balance" extends "Detail Trial Balance"
{
    dataset
    {
        add("G/L Entry")
        {
            column(Document_Type; "Document Type") { }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(Entry_No_; "Entry No.") { }
            column(Source_Type; "Source Type") { }
            column("القطاع"; "Global Dimension 1 Code") { }
            column("المشروعات"; "Global Dimension 2 Code") { }
            column("Employee"; "Shortcut Dimension 3 Code") { }
            column("الإدارات"; "Shortcut Dimension 4 Code") { }
            column(User_ID; "User ID") { }
            column(GLRegisterNo; GLRegNoVar) { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(G_L_Account_Name; "G/L Account Name") { }
        }
        modify("G/L Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                GLRegister: Record "G/L Register";
            begin
                GLRegNoVar := 0; // Reset each iteration

                // Filter the G/L Register so that "From Entry No." <= the G/L Entry's Entry No.
                // and "To Entry No." >= the G/L Entry's Entry No.
                // 1) set a filter so that "From Entry No." is up to your G/L Entry.No
                GLRegister.SetFilter("From Entry No.", '..%1', "G/L Entry"."Entry No.");
                // 2) set a filter so that "To Entry No." is from your G/L Entry.No up to the max
                GLRegister.SetFilter("To Entry No.", '%1..', "G/L Entry"."Entry No.");

                // If there's a G/L Register that covers that Entry No., retrieve it
                if GLRegister.FindFirst() then
                    GLRegNoVar := GLRegister."No.";
            end;
        }
    }

    var
        GLRegNoVar: Integer;
}