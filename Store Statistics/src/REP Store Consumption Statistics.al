report 50027 "Store Consumption Statistics"
{
    ExcelLayout = 'src/Store Consumption Statistics.xlsx';
    Caption = 'Store Consumption Statistics';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    PreviewMode = PrintLayout;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            RequestFilterFields = "Posting Date";
            DataItemTableView = WHERE("Item Ledger Entry Type" = FILTER('Negative Adjmt.'), "Source Code" = FILTER('ITEMJNL'));
            column(Posting_Date; "Posting Date") { }
            column(Month; Month) { }
            column(year; yearVar) { }
            column(Source_Code; "Source Code") { }
            column(Document_No_; "Document No.")
            {
            }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(ItemLedgerEntryType; "Item Ledger Entry Type") { }
            column(Entry_No_; "Entry No.") { }

            column(Item_No; "Item No.") { }
            column(Item_Name; Names[4]) { }
            column(Valued_Quantity; -"Valued Quantity") { }
            column(Cost_Posted_to_GL; -"Cost Posted to G/L") { }

            column(Location_Code; "Location Code") { }
            column(Item_Category_Code; Fin_Infos[1])
            {
            }
            column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group")
            {
            }
            column(Inventory_Posting_Group; Fin_Infos[3])
            {
            }

            column(Business_Unit; "Global Dimension 1 Code") { }
            column(Hotel; "Global Dimension 2 Code") { }
            column(Hotel_Name; Names[3]) { }
            column(Employee; "Shortcut Dimension 3 Code") { }
            column(Employee_Name; Names[1]) { }
            column(Departement; "Shortcut Dimension 4 Code") { }
            column(Departement_Name; Names[2]) { }


            trigger OnAfterGetRecord()
            var
                dim_value: Record "Dimension Value";
                dim_value_2: Record "Dimension Value";
                dim_value_3: Record "Dimension Value";
                item_Name: Record Item;
            begin

                //************ Departement ***********
                dim_value.SetRange("Dimension Code", 'DEP.');
                dim_value.SetRange(Code, "Shortcut Dimension 4 Code");
                if dim_value.FindSet() then begin
                    Names[2] := dim_value.Name;
                end else
                    Names[2] := 'Departement Name Not Found';


                //************ Employee ***********
                dim_value_2.SetRange("Dimension Code", 'EMPLOYEE');
                dim_value_2.SetRange(Code, "Shortcut Dimension 3 Code");
                if dim_value_2.FindSet() then begin
                    Names[1] := dim_value_2.Name;
                end else
                    Names[1] := 'EMPLOYEE Name Not Found';

                //************ Item ***********
                item_Name.SetRange("No.", "Item No.");
                if item_Name.FindSet() then begin
                    Names[4] := item_Name.Description;
                    Fin_Infos[1] := item_Name."Item Category Code";
                    Fin_Infos[2] := item_Name."Gen. Prod. Posting Group";
                    Fin_Infos[3] := item_Name."Inventory Posting Group";
                end
                else begin
                    Fin_Infos[1] := 'Not Found';
                    Fin_Infos[2] := 'Not Found';
                    Fin_Infos[3] := 'Not Found';
                    Names[4] := 'Item Name Not Found';
                end;
                //************ Hotel ***********
                dim_value_3.SetRange("Dimension Code", 'HOTELS');
                dim_value_3.SetRange(Code, "Global Dimension 2 Code");
                if dim_value_3.FindSet() then begin
                    Names[3] := dim_value_3.Name;
                end
                else
                    Names[3] := 'Hotel Name Not Found';
                //************ Month **************
                Month := FORMAT("Posting Date", 0, '<Month Text>');
                //************ year **************
                yearVar := Date2DMY("Posting Date", 3);
            end;
        }

    }



    var
        Names: array[4] of Text[150];
        Fin_Infos: array[3] of Text[150];
        Month: Text;
        yearVar: Integer;
}