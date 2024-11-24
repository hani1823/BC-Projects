tableextension 50063 "EXT Sales Header" extends "Sales Header"
{
    fields
    {
        field(50000; Hidden; Boolean)
        {
            Caption = 'Hidden';
            Editable = true;
        }

    }


}