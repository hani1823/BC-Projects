table 50111 "Foodics Branch"
{
    Caption = 'Foodics Branch';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Branch Id"; Text[100])
        {
            Caption = 'Branch Id';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(4; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }

        field(5; "Sales G/L Account"; Code[20])
        {
            Caption = 'Sales G/L Account';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(PK; "Branch Id") { Clustered = true; }
    }
}
