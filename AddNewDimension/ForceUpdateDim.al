codeunit 50159 "Force Update DimSet"
{
    //Caption = 'Force Update Dimension Set';
    // We need permission to Modify Table 480
    Permissions =
        tabledata "Dimension Set Entry" = rimd,
        tabledata "Dimension Value" = rimd;

    procedure UpdateEmployeeDimension(DimSetID: Integer; OldEmployeeCode: Code[20]; NewEmployeeCode: Code[20])
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
    begin
        // 1) Validate that the new dimension value exists for "EMPLOYEE"
        if not DimValue.Get('EMPLOYEE', NewEmployeeCode) then
            Error('Dimension Value %1 does not exist for the EMPLOYEE dimension.', NewEmployeeCode);

        // 2) Find the existing line in Table 480
        DimSetEntry.Reset();
        DimSetEntry.SetRange("Dimension Set ID", DimSetID);
        DimSetEntry.SetRange("Dimension Code", 'EMPLOYEE');
        DimSetEntry.SetRange("Dimension Value Code", OldEmployeeCode);

        if DimSetEntry.FindFirst() then begin
            // 3) Update the dimension line
            DimSetEntry.Validate("Dimension Value Code", NewEmployeeCode);
            DimSetEntry."Dimension Value ID" := 305; // must match the "Id" of the new dimension value
            DimSetEntry.Modify();

            Message(
              'Dimension Set ID %1 updated: EMPLOYEE changed from %2 to %3.',
              DimSetID, OldEmployeeCode, NewEmployeeCode);
        end else
            Error(
              'Could not find a Dimension Set Entry for ID = %1 with EMPLOYEE = %2.',
              DimSetID, OldEmployeeCode);
    end;
}