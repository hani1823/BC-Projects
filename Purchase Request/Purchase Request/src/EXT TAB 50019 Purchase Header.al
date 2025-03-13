tableextension 50019 "Purch Header Ext" extends "Purchase Header"
{

    fields
    {
        field(50000; Hidden; Boolean)
        {
            Caption = 'Hidden';
            Editable = true;
        }

        field(50001; "Purchase Request No."; Code[20])
        {
            Caption = 'Purchase Request No.';
        }
        field(50002; Description; Text[200])
        {
            Caption = 'Description';
            Editable = true;

        }


    }


    /*
        procedure VendorName()
        var
            purchEnum: Enum "Purchase Document Type";
        begin
            if (Rec."Document Type" = purchEnum::"Blanket Order") then begin
                rec."Buy-from Vendor No." := 'HV100365';
                rec."Buy-from Vendor Name" := 'Purchase Request';
            end;


        end;

        trigger OnBeforeInsert();
        begin
            VendorName();
        end;

    */
}