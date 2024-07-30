tableextension 50135 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(141; "Owner Name"; Code[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate() begin
                
            end;
        }
        field(143; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(144; "Plan Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
}