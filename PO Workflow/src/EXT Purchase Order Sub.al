pageextension 50145 "EXT Purhcase Order Sub" extends "Purchase Order Subform"
{
    layout
    {
        modify("Unit of Measure Code")
        {
            Editable = false;
        }
        //modify("Gen. Bus. Posting Group"){ Editable = false; }
        modify("Gen. Prod. Posting Group")
        {
            Editable = false;
        }
    }
}