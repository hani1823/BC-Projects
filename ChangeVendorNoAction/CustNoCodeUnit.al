codeunit 50132 "Modify Cust No Codeunit"
{
    Permissions = tabledata Customer = RIMD;

    procedure CorrectNoAction(No: Code[20])
    var
        CustomerRec: Record Customer;
    begin
        CustomerRec.SetRange("No.", No);
        if CustomerRec.FindFirst() then begin
            if CustomerRec."No." = 'MC-100002' then begin
                CustomerRec.Rename('HC101071');
                //VendorRec.Modify();
                Message('No. updated successfully.');
            end else
                Message('No. did not match the expected value.');
        end else
            Error('Sales Invoice not found.');
    end;
}