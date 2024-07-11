table 50101 Car
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(2; name; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(3; date; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(4; companyName; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(5; fuelType; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ID)
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

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}