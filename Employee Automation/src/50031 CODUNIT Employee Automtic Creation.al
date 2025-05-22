codeunit 50031 "Employee Automatic Creation"
{
    trigger OnRun()
    var
        employee: Record Employee;
        dimensionValue: Record "Dimension Value";
        dimensionValueToInsert: Record "Dimension Value";
    begin
        /*if employee.FindSet() then begin
            repeat
            dimensionValue.Reset();
            dimensionValue.SetRange("Dimension Code", 'EMPLOYEE');
            dimensionValue.SetRange(Code, employee."No.");
            if dimensionValue.FindFirst() then begin

            end else begin
                dimensionValueToInsert.Init();
                dimensionValueToInsert.Code := employee."No.";
                dimensionValueToInsert.Validate(Name, employee.FullName());
                dimensionValueToInsert."Dimension Code" := 'EMPLOYEE';
                dimensionValueToInsert."Dimension Value Type" := dimensionValueToInsert."Dimension Value Type"::Standard;
                dimensionValueToInsert.Insert();
            end;
            until employee.Next() = 0;
            Commit();
        end;*/

        if Employee.FindSet() then
            repeat
                // Does a value for this employee already exist?
                if not dimensionValue.Get('EMPLOYEE', Employee."No.") then begin
                    dimensionValue.Init();
                    dimensionValue."Dimension Code" := 'EMPLOYEE';
                    dimensionValue.Code := Employee."No.";
                    dimensionValue.Validate(Name, Employee.FullName());
                    dimensionValue."Dimension Value Type" := dimensionValue."Dimension Value Type"::Standard;
                    dimensionValue.Insert(true);
                end;
            until Employee.Next() = 0;

        Commit();


    end;

}