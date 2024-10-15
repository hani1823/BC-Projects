codeunit 50131 "Modify No Codeunit"
{
    Permissions = tabledata Vendor = RIMD;

    procedure CorrectNoAction(No: Code[20])
    var
        VendorRec: Record Vendor;
    begin
        VendorRec.SetRange("No.", No);
        if VendorRec.FindFirst() then begin
            if VendorRec."No." = 'MV-100008' then begin
                VendorRec.Rename('HV100428');
                //VendorRec.Modify();
                Message('No. updated successfully.');
            end else
                Message('No. did not match the expected value.');
        end else
            Error('Sales Invoice not found.');
    end;
}