codeunit 50158 "Force Update All DimSet"
{
    //Caption = 'Force Update Dimension Set';
    // We need permission to Modify Table 480
    Permissions =
        tabledata "Dimension Set Entry" = rimd,
        tabledata "Dimension Value" = rimd;

    procedure UpdateAllEmployeeDimensions(OldEmployeeCode: Code[20]; NewEmployeeCode: Code[20])
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        NewValueID: Integer;
        UpdateCount: Integer;
    begin
        // 1) Validate that the new dimension value exists for "EMPLOYEE"
        if not DimValue.Get('EMPLOYEE', NewEmployeeCode) then
            Error('Dimension Value %1 does not exist for the EMPLOYEE dimension.', NewEmployeeCode);

        // We'll store the correct "Id" field for the new employee dimension value
        NewValueID := 301;

        // 2) Find all "Dimension Set Entry" records where:
        //    - Dimension Code = 'EMPLOYEE'
        //    - Dimension Value Code = OldEmployeeCode
        DimSetEntry.Reset();
        DimSetEntry.SetRange("Dimension Code", 'EMPLOYEE');
        DimSetEntry.SetRange("Dimension Value Code", OldEmployeeCode);

        if DimSetEntry.FindSet() then begin
            repeat
                // 3) Update each matching record
                // First, use Validate() to trigger standard dimension validations
                DimSetEntry.Validate("Dimension Value Code", NewEmployeeCode);

                // Then fix the "Dimension Value ID" to the new ID
                DimSetEntry."Dimension Value ID" := NewValueID;
                DimSetEntry.Modify();

                UpdateCount += 1;
            until DimSetEntry.Next() = 0;

            // Show a message summarizing how many records were changed
            Message(
              '%1 records were updated. EMPLOYEE dimension changed from "%2" to "%3".',
              UpdateCount, OldEmployeeCode, NewEmployeeCode);
        end else
            // If no records found, show error or info
            Message('No records found for EMPLOYEE dimension code = %1. Nothing changed.', OldEmployeeCode);
    end;
}