pageextension 50102 "Posted Purchase Receipt EXT" extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension Name"; "Shortcut Dimension Name")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        DimensionValue: Record "Dimension Value";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        if CompanyName = 'ALINMA FOR CONSTRUCTION' then begin
            DimSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
            DimSetEntry.SetRange("Dimension Code", 'PROJECTS');
            if DimSetEntry.FindFirst() then begin
                DimensionValue.SetRange("Dimension Code", 'PROJECTS');
                DimensionValue.SetRange(Code, DimSetEntry."Dimension Value Code");
                if DimensionValue.FindFirst() then begin
                    "Shortcut Dimension Name" := DimensionValue.Name;
                end;
            end;
        end;
    end;

    var
        "Shortcut Dimension Name": Text[50];
}
