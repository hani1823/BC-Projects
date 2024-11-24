reportextension 50068 "EXT REP Store Requisition" extends "Blanket Sales Order"
{
    dataset
    {
        add("Sales Header")
        {
            column(Status; Status) { }
            column(Assigned_User_ID; Assigned_User_ID) { }
            column(Order_Date; "Order Date") { }

        }
        modify("Sales Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                users: Record User;
            begin
                users.SetRange("User Name", "Assigned User ID");

                if users.FindSet() then begin
                    Assigned_User_ID := users."Full Name";

                end;
            end;
        }

        add(RoundLoop)
        {
            column(HotelDim; DimValue[1]) { }
            column(EmployeeDim; DimValue[2]) { }
            column(DepartementDim; DimValue[3]) { }
            column(Unit_Cost; TempUnitCost) { }
            column(Amount; TempAmount) { }
        }

        modify(RoundLoop)
        {
            trigger OnAfterAfterGetRecord()
            var
                DimenValue: Record "Dimension Value";
                dim_entry: Record "Dimension Set Entry";
                SalesLine: Record "Sales Line";
            begin


                if CompanyName = 'ALINMA FOR HOTELING' then begin

                    //*** hotels***\\
                    dim_entry.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                    dim_entry.SetRange("Dimension Code", 'HOTELS');
                    if dim_entry.FindSet() then begin
                        DimenValue.SetRange("Dimension Code", 'HOTELS');
                        DimenValue.SetRange(Code, dim_entry."Dimension Value Code");
                        if DimenValue.FindSet() then DimValue[1] := DimenValue.Code;
                    end;
                end else
                    //*** Construction***\\
                    if CompanyName = 'ALINMA FOR CONSTRUCTION' then begin
                        dim_entry.Reset();
                        DimenValue.Reset();

                    end;
                ;

                //*** Employee***\\
                dim_entry.Reset();
                DimenValue.Reset();
                dim_entry.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                dim_entry.SetRange("Dimension Code", 'EMPLOYEE');
                if dim_entry.FindSet() then begin

                    DimenValue.SetRange("Dimension Code", 'EMPLOYEE');
                    DimenValue.SetRange(Code, dim_entry."Dimension Value Code");
                    if DimenValue.FindSet() then DimValue[2] := DimenValue.Name;
                end;


                //*** Departement***\\
                dim_entry.Reset();
                DimenValue.Reset();
                dim_entry.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                dim_entry.SetRange("Dimension Code", 'DEP.');
                if dim_entry.FindSet() then begin

                    DimenValue.SetRange("Dimension Code", 'DEP.');
                    DimenValue.SetRange(Code, dim_entry."Dimension Value Code");
                    if DimenValue.FindSet() then DimValue[3] := DimenValue.Name;
                end;


                TempUnitCost := 0; // Reset to default
                TempAmount := 0; // Reset to default

                if SalesLine.Get("Sales Line"."Document Type", "Sales Line"."Document No.", "Sales Line"."Line No.") then begin
                    TempUnitCost := SalesLine."Unit Cost"; // Fetch Unit Cost
                    TempAmount := SalesLine.Quantity * SalesLine."Unit Cost"; // Calculate Amount
                end;
            end;

        }

    }
    var

        Assigned_User_ID: Text[100];
        DimValue: array[4] of Text[100];
        TempUnitCost: Decimal;
        TempAmount: Decimal;
}
