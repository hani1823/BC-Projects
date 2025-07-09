table 50130 "Foodics Setup"
{
    Caption = 'Foodics Setup';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Base URL"; Text[150])
        {
            Caption = 'Base URL';
        }
        field(3; "API Token"; Text[1300])
        {
            Caption = 'API Token';
            ExtendedDatatype = Masked;
        }
        field(4; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'SETUP'; //سجل وحيد
    end;
}
