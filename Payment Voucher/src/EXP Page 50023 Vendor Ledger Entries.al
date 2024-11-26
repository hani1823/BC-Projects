pageextension 50047 " EXT BankLedger Entries" extends "Bank Account Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Navigate")
        {
            action("Payment Voucher")
            {
                ApplicationArea = Suite;
                Caption = 'Payment Voucher';
                //Ellipsis = true;
                Image = "Attach";
                //ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    BankLedgEntries: Record "Bank Account Ledger Entry";
                    repo: Report "Payment Voucher Bank";
                begin
                    BankLedgEntries := Rec;
                    CurrPage.SetSelectionFilter(BankLedgEntries);
                    repo.SetTableView(BankLedgEntries);
                    repo.Run();

                end;

            }
        }
    }

    var
        myInt: Integer;
}