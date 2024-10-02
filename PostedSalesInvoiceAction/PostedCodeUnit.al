codeunit 50129 "Modify VAT Codeunit"
{
    Permissions = tabledata "Sales Invoice Header" = RIMD;

    procedure CorrectVATNo(SalesInvoiceNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.SetRange("No.", SalesInvoiceNo);
        if SalesInvoiceHeader.FindFirst() then begin
            if SalesInvoiceHeader."VAT Registration No." = '300704677300003' then begin
                SalesInvoiceHeader."VAT Registration No." := '310268318900003';
                SalesInvoiceHeader.Modify();
                Message('VAT Registration No. updated successfully.');
            end else
                Message('VAT Registration No. did not match the expected value.');
        end else
            Error('Sales Invoice not found.');
    end;
}