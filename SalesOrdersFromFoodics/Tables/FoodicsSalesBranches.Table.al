table 50111 "Foodics Branch"
{
    Caption = 'Foodics sales Branches';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Branch Id"; Text[100])
        {
            Caption = 'Branch Id';
            NotBlank = true;
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
        field(5; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('Branches'));
        }
        field(6; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEP.'));
        }
    }

    keys
    {
        key(PK; "Branch Id") { Clustered = true; }
    }
}
