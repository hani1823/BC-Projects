reportextension 50102 PurchaseReceiptReport extends "Purchase - Receipt"
{
    dataset
    {
        add("Purch. Rcpt. Header")
        {
            column(Order_No; "Order No.")
            {

            }
            column(Shortcut_Dimension_Name; "Shortcut Dimension Name")
            {

            }
        }
        modify("Purch. Rcpt. Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                DimensionValue: Record "Dimension Value";
                DimSetEntry: Record "Dimension Set Entry";
            begin
                if CompanyName = 'ALINMA FOR CONSTRUCTION' then begin
                    DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
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
        }
    }
    var
        "Shortcut Dimension Name": Text[50];
}