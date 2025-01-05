codeunit 50157 "Insert Dimensions Manual"
{
    Permissions =
        tabledata "Dimension Set Entry" = rimd,
        tabledata "Dimension Value" = rimd;
    procedure CreateNewDimensionSetManually(): Integer
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        NextDimSetID: Integer;
    begin
        // 1) Determine a fresh "Dimension Set ID" to use.
        //    We'll just find the highest existing ID and add 1.
        DimSetEntry.Reset();
        // Filter out 0 because sometimes BC uses 0 as a "no dimension" placeholder.
        DimSetEntry.SetFilter("Dimension Set ID", '<>0');
        if DimSetEntry.FindLast() then
            NextDimSetID := DimSetEntry."Dimension Set ID" + 1
        else
            NextDimSetID := 1;

        // ---------------------------------------------------------
        // For each dimension line, you must:
        //  - Look up the Dimension Value's "Id" field in Table 349
        //  - Insert the new line in Table 480 with the same "Dimension Set ID"
        // ---------------------------------------------------------

        // (A) BUS-UNIT = HOTELS
        if DimValue.Get('BUS-UNIT', 'HOTELS') then begin
            DimSetEntry.Init();
            DimSetEntry."Dimension Set ID" := NextDimSetID;
            DimSetEntry."Dimension Code" := DimValue."Dimension Code";
            DimSetEntry."Dimension Value Code" := DimValue.Code;
            DimSetEntry."Dimension Value ID" := 1;
            DimSetEntry."Global Dimension No." := 0;
            DimSetEntry.Insert();
        end;

        // (B) DEP. = 117
        if DimValue.Get('DEP.', '117') then begin
            DimSetEntry.Init();
            DimSetEntry."Dimension Set ID" := NextDimSetID;
            DimSetEntry."Dimension Code" := DimValue."Dimension Code";
            DimSetEntry."Dimension Value Code" := DimValue.Code;
            DimSetEntry."Dimension Value ID" := 246;
            // Example: Shortcut Dimension No. = 4 if dimension 4, else 0 if not one of the first 2-3 shortcuts
            DimSetEntry."Global Dimension No." := 4;
            DimSetEntry.Insert();
        end;

        // (C) EMPLOYEE = 28270
        if DimValue.Get('EMPLOYEE', '28270') then begin
            DimSetEntry.Init();
            DimSetEntry."Dimension Set ID" := NextDimSetID;
            DimSetEntry."Dimension Code" := DimValue."Dimension Code";
            DimSetEntry."Dimension Value Code" := DimValue.Code;
            DimSetEntry."Dimension Value ID" := 305;
            DimSetEntry."Global Dimension No." := 3;
            DimSetEntry.Insert();
        end;

        // (D) HOTELS = 25364
        if DimValue.Get('HOTELS', '25364') then begin
            DimSetEntry.Init();
            DimSetEntry."Dimension Set ID" := NextDimSetID;
            DimSetEntry."Dimension Code" := DimValue."Dimension Code";
            DimSetEntry."Dimension Value Code" := DimValue.Code;
            DimSetEntry."Dimension Value ID" := 13;
            DimSetEntry."Global Dimension No." := 0;
            DimSetEntry.Insert();
        end;

        Message('New Dimension Set ID %1 created with 4 lines in Table 480.', NextDimSetID);

        exit(NextDimSetID);
    end;
}