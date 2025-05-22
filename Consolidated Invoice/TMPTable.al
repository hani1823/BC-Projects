table 50100 "Tmp Item Summary"
{
    TableType = Temporary;
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Key"; Code[250]) { }
        field(2; "Item No."; Code[20]) { }
        field(3; Description; Text[100]) { }
        field(4; "Unit Price"; Decimal) { }
        field(5; "Unit of Measure Code"; Text[50]) { }
        field(6; QuantityAgg; Decimal) { }
        field(7; LineAmtExclVAT; Decimal) { }
        field(8; LineAmtInclVAT; Decimal) { }
    }

    keys
    {
        key(PK; "Key") { Clustered = true; }
        key(ItemNo; "Item No.") { }
    }
}
