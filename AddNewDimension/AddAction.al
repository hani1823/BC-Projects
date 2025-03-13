pageextension 50157 "Vendor Card Ext" extends "Vendor Card"
{
    actions
    {
        addlast(Processing) // or addlast(Home), whichever group you prefer
        {
            action("CreateManualDimensionSet")
            {
                Caption = 'Create Dimension Set';
                ApplicationArea = All;

                trigger OnAction()
                var
                    DimHelper: Codeunit "Insert Dimensions Manual";
                    NewDimSetID: Integer;
                begin
                    // Call your procedure to create the Dimension Set
                    NewDimSetID := DimHelper.CreateNewDimensionSetManually();

                    // Show a message with the result
                    Message('New Dimension Set ID: %1 created.', NewDimSetID);
                end;
            }
            action("ForceEmployeeUpdate")
            {
                Caption = 'Force Employee Dim to 28270';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ForceDimSet: Codeunit "Force Update DimSet";
                begin
                    // Hard-coded example: We want to change
                    // DimSetID=2158, OldEmp=28263, NewEmp=28270
                    ForceDimSet.UpdateEmployeeDimension(2158, '28263', '28270');
                end;
            }
            action("ForceAllEmployeeUpdate28253")
            {
                Caption = 'Force All Employee Dim from 28253 to 28270';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ForceDimSet: Codeunit "Force Update All DimSet";
                begin
                    // Hard-coded example: We want to change
                    // OldEmp=28263, NewEmp=28270
                    ForceDimSet.UpdateAllEmployeeDimensions('28253', '28240');
                end;
            }
            /*action("ForceAllEmployeeUpdate28263")
            {
                Caption = 'Force All Employee Dim from 28263 to 28270';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ForceDimSet: Codeunit "Force Update All DimSet";
                begin
                    // Hard-coded example: We want to change
                    // OldEmp=28263, NewEmp=28270
                    ForceDimSet.UpdateAllEmployeeDimensions('28263', '28270');
                end;
            }
            action("ForceAllEmployeeUpdate28273")
            {
                Caption = 'Force All Employee Dim from 28273 to 28270';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ForceDimSet: Codeunit "Force Update All DimSet";
                begin
                    // Hard-coded example: We want to change
                    // OldEmp=28263, NewEmp=28270
                    ForceDimSet.UpdateAllEmployeeDimensions('28273', '28270');
                end;
            }
            action("ForceAllEmployeeUpdate28274")
            {
                Caption = 'Force All Employee Dim from 28274 to 28270';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ForceDimSet: Codeunit "Force Update All DimSet";
                begin
                    // Hard-coded example: We want to change
                    // OldEmp=28263, NewEmp=28270
                    ForceDimSet.UpdateAllEmployeeDimensions('28274', '28270');
                end;
            }
            action("ForceAllEmployeeUpdate28275")
            {
                Caption = 'Force All Employee Dim from 28275 to 28270';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ForceDimSet: Codeunit "Force Update All DimSet";
                begin
                    // Hard-coded example: We want to change
                    // OldEmp=28263, NewEmp=28270
                    ForceDimSet.UpdateAllEmployeeDimensions('28275', '28270');
                end;
            }*/
        }
    }
}