tableextension 50064 "EXT Sales Line" extends "Sales Line"
{
    fields
    {
        field(50000; IsCreated; Boolean)
        {
            Caption = 'Hidden';
            Editable = true;

        }

        field(50001; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name;
            Editable = true;
        }

    }
    var

}