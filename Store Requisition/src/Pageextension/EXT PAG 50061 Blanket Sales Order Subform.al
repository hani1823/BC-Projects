pageextension 50061 "EXT Blkt Sales Order Subform" extends "Blanket Sales Order Subform"
{
    layout
    {
        modify(Control53)
        { Visible = false; }
        // modify("Location Code") { Visible = false; }
        modify("Unit Price") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Line Amount") { Visible = false; }
        modify("Qty. to Ship") { Visible = false; }
        modify("Quantity Shipped") { Visible = false; }
        modify("Quantity Invoiced") { Visible = false; }
        modify("Shipment Date") { Visible = false; }
        modify("Service Commitments") { Visible = false; }
        modify("Location Code")
        {
            trigger OnBeforeValidate()
            var
                IteLed: Record "Item Ledger Entry";
            begin
                if rec."Location Code" = '' then begin
                    Error('Please enter location code');
                end else begin
                    IteLed.SetRange("Location Code", Rec."Location Code");
                    IteLed.SetRange("Item No.", Rec."No.");
                    IteLed.CalcSums(Quantity);
                    if Rec.Quantity > IteLed.Quantity then Error('Quantity not available in Store');
                end;


            end;
        }
        modify(Quantity)
        {

            trigger OnBeforeValidate()
            var
                TempItemJournalLine: Record "Item Journal Line" temporary;
                IteLed: Record "Item Ledger Entry";
            begin
                IteLed.SetRange("Location Code", Rec."Location Code");
                IteLed.SetRange("Item No.", Rec."No.");
                IteLed.CalcSums(Quantity);

                if Rec.Quantity > IteLed.Quantity then Error('Quantity not available in Store');
            end;

            trigger OnLookup(var Text: Text): Boolean
            var
                ItemRec: Record Item;
                loc: Record Location;
                AdjustInventory: Page "Adjust Inventory";
            begin
                //ItemRec.Reset();
                //loc.Reset();
                //ItemRec.SetRange("No.", rec."No.");
                AdjustInventory.SetItem(Rec."No.");
                AdjustInventory.Editable(false);
                AdjustInventory.Caption('Item availability');
                AdjustInventory.RunModal();
                // Page.RunModal(Page::"Adjust Inventory", loc);

            end;

            trigger OnAfterValidate()
            begin
                CalculateAmount();
            end;
        }
        addafter(Description)
        {
            field(IsCreated; Rec.IsCreated)
            {
                ApplicationArea = all;
                Caption = 'Is Created';
            }
            field("Journal Batch Name"; Rec."Journal Batch Name")
            {
                ApplicationArea = all;
                Caption = 'Journal Batch Name';
            }
        }
        addafter(Quantity)
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = all;
                ToolTip = 'Total Amount for the quantity multiplied by the unit cost';
                Visible = true;
            }
        }

    }
    actions
    {

        modify("&Line") { Visible = false; }
        //modify("Get &Price") { Visible = false; }
        //modify("Get Li&ne Discount") { Visible = false; }
        modify("GetPrice") { Visible = false; }
        modify("GetLineDiscount") { Visible = false; }
        modify("E&xplode BOM") { Visible = false; }
        modify("Insert &Ext. Texts") { Visible = false; }
        modify("Select Nonstoc&k Items") { Visible = false; }


    }
    trigger OnAfterGetRecord()
    begin
        CalculateAmount();
    end;

    local procedure CalculateAmount()
    begin
        Rec.Amount := Rec."Unit Cost" * Rec.Quantity;
        Rec.Modify(true);
    end;
}