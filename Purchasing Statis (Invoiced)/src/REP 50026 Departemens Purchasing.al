report 50050 "Purchasing Statistics Inv"
{
    ExcelLayout = 'src/PurchasingStatisInvoiced.xlsx';
    Caption = 'Purchasing Statistics (Invoiced)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    PreviewMode = PrintLayout;
    DataAccessIntent = ReadOnly;

    dataset
    {



        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            RequestFilterFields = "Posting Date";
            DataItemTableView = WHERE("Type" = FILTER(Item));
            column(Invoiced_No_Line; "Document No.") { }
            column(VendName; VendName) { }
            column(Order_No_Line; "Order No.") { }
            column(Gen__Prod__Posting_Group; "Gen. Prod. Posting Group") { }
            column(Item_Category_Code; "Item Category Code") { }
            column(Line_No_; "Line No.") { }
            column(Location_Code; "Location Code") { }
            column(No_; "No.") { }
            column(Description; "Description") { }
            column(Quantity; Quantity) { }
            column(Quantity_Received; "Quantity") { }

            column(LineAmount; "Direct Unit Cost" * Quantity) { }
            column(Direct_Unit_Cost; "Direct Unit Cost") { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Posting_Date; "Posting Date") { }
            column(Month; Month) { }
            column("BusinessUnit"; "Shortcut Dimension 1 Code") { }
            column("Hotels"; "Shortcut Dimension 2 Code") { }
            column("Hotel_Name"; Dimensions_set[3]) { }
            column(Departement; Dimensions_set[1])
            {
            }
            column(Employee; Dimensions_set[2]) { }
            trigger OnAfterGetRecord()
            var
                dim_entry: Record "Dimension Set Entry";
                dim_entry_2: Record "Dimension Set Entry";

                dim_value: Record "Dimension Value";
                dim_value_2: Record "Dimension Value";
                dim_value_3: Record "Dimension Value";

                purInvHead: Record "Purch. Inv. Header";
                vendor: Record Vendor;
            begin


                purInvHead.SetRange("No.", "Document No.");
                if purInvHead.FindSet() then begin
                    vendor.SetRange("No.", purInvHead."Buy-from Vendor No.");
                    if vendor.FindSet() then VendName := vendor.Name;
                end;
                /// ***********Departement **********\\\\\
                dim_entry.SetRange("Dimension Set ID", "Dimension Set ID");
                dim_entry.SetRange("Dimension Code", 'DEP.');
                if dim_entry.FindSet() then begin
                    dim_value.SetRange("Dimension Code", 'DEP.');
                    dim_value.SetRange(Code, dim_entry."Dimension Value Code");
                    if dim_value.FindSet() then begin
                        Dimensions_set[1] := dim_value.Name;
                    end else
                        Dimensions_set[1] := 'Departement Name Not Found';
                end else
                    Dimensions_set[1] := '   -    ';


                /// ***********Depatement **********\\\\\
                dim_entry_2.SetRange("Dimension Set ID", "Dimension Set ID");
                dim_entry_2.SetRange("Dimension Code", 'EMPLOYEE');
                // dim_entry.SetFilter("Dimension Set ID", PurchLines);
                if dim_entry_2.FindSet() then begin
                    dim_value_2.SetRange("Dimension Code", 'EMPLOYEE');
                    dim_value_2.SetRange(Code, dim_entry_2."Dimension Value Code");
                    if dim_value_2.FindSet() then begin
                        Dimensions_set[2] := dim_value_2.Name;
                    end else
                        Dimensions_set[2] := 'EMPLOYEE Not Found';
                end else
                    Dimensions_set[2] := '   -    ';

                /// ***********Hotels **********\\\\\
                dim_value_3.SetRange("Dimension Code", 'HOTELS');
                dim_value_3.SetRange(Code, "Shortcut Dimension 2 Code");
                if dim_value_3.FindSet() then begin
                    Dimensions_set[3] := dim_value_3.Name;
                end else
                    Dimensions_set[3] := ' Hotel Name Not Found ';
                //************ Month **************
                Month := FORMAT("Posting Date", 0, '<Month Text>');

            end;
        }

    }


    var
        Dimensions_set: array[3] of text[50];
        VendName: Text[150];
        Amount: Decimal;
        Month: Text;


}