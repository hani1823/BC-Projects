codeunit 50031 "Employee Automatic Creation"
{
    trigger OnRun()
    var
        employee: Record Employee;
        dimensionValue: Record "Dimension Value";
        dimensionValueToInsert: Record "Dimension Value";
    begin
        if employee.FindSet() then begin
            repeat
                dimensionValue.SetRange("Dimension Code", 'EMPLOYEE');
                dimensionValue.SetRange(Code, employee."No.");
                if dimensionValue.FindSet() then begin

                end else begin

                    dimensionValueToInsert.Code := employee."No.";
                    dimensionValueToInsert.Name := employee.FullName();
                    dimensionValueToInsert."Dimension Code" := 'EMPLOYEE';
                    dimensionValueToInsert."Dimension Value Type" := dimensionValueToInsert."Dimension Value Type"::Standard;
                    dimensionValueToInsert.Insert();
                end;
                Commit();
            until employee.Next() = 0

        end;
    end;

}