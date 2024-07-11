table 50120 Fruit
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Quantity; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if (Quantity < 0) then
                    Error('The quantity must be 0 or more.');
            end;
        }
        field(4; Color; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = ColorTable.Color;

            trigger OnLookup()
            var
                ColorRec: Record ColorTable;
                ColorPage: Page ColorLookup;
            begin
                if Page.RunModal(Page::ColorLookup, ColorRec) = Action::LookupOK then begin
                    Rec.Color := ColorRec.Color;
                end;
            end;
        }
        field(5; Weight; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(ID; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;


}
