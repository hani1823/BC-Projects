pageextension 50033 "EXT Blanket PO Subform" extends "Blanket Purchase Order Subform"
{
    layout
    {
        modify(Control37)
        {
            Visible = false;
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = Suite;
                Visible = true;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = Suite;
                Visible = true;
            }
            field(IsCreated; Rec.IsCreated)
            {
                ApplicationArea = Suite;
                Visible = true;
            }
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Suite;
                Visible = true;
            }
            field("Job Planning Line No."; Rec."Job Planning Line No.")
            {
                ApplicationArea = Suite;
                Visible = true;
            }
            field("Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = Suite;
                Visible = true;
            }
        }
    }

    actions
    {


    }


}