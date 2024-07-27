tableextension 50135 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(141; "Owner Name"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(142; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(143; "Plan Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;


}