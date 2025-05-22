pageextension 50137 CustomerpageEXT extends "Customer List"
{
    actions
    {
        addlast(reporting)
        {
            action("الفاتورة المجمعة")
            {
                ApplicationArea = all;
                Image = Report;
                trigger OnAction()
                var
                    ConsolidatedInvoiceREPORT: Report "Customer Invoice Report";
                begin
                    ConsolidatedInvoiceREPORT.Run();
                end;
            }
        }
    }
}