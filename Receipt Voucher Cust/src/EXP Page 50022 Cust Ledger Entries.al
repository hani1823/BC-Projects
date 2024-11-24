pageextension 50022 " EXT Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("IncomingDocument")
        {
            action("Cust Voucher Reciept")
            {
                ApplicationArea = Suite;
                Caption = 'Customer Receipt Voucher';
                //Ellipsis = true;
                Image = "Attach";
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    CustLedgEntries: Record "Cust. Ledger Entry";
                    repo: Report "Receipt Voucher";
                begin
                    CustLedgEntries := Rec;
                    CurrPage.SetSelectionFilter(CustLedgEntries);
                    //repo.SetTableView(CustLedgEntries);
                    //repo.Run();
                    REPORT.Run(REPORT::"Receipt Voucher", true, false, CustLedgEntries);


                end;

            }
        }
    }

    var
        myInt: Integer;
}