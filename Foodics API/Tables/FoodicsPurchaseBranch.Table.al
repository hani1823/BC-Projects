table 50113 "Foodics Purchase Branch"
{
    Caption = 'Foodics Purchase Branch';
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
        field(3; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('Branches'));
        }
        field(4; "Department Code"; Code[20])
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
