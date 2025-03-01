pageextension 50557 "EXT Payment Journal" extends "Payment Journal"
{
    trigger OnOpenPage()

    var

    begin
        if CompanyName = 'ALINMA FOR CONSTRUCTION' then begin
            repeat
                rec.Validate("Account No.");
                rec.Validate("Bal. Account No.");
            until rec.Next() = 0;
        end;
    end;

    var
        myInt: Integer;
}