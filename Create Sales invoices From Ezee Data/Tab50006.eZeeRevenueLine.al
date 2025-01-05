table 50071 "eZee Revenue Line2"
{
    Caption = 'eZee Revenue Line';
    DataClassification = CustomerContent;
    LookupPageId = "eZee Revenue Lines";
    DrillDownPageId = "eZee Revenue Lines";

    fields
    {
        field(4; "Hotel Code"; Code[50])
        {
            Caption = 'Hotel Code';
            DataClassification = CustomerContent;
        }
        field(5; "Header Unique Id"; Text[100])
        {
            Caption = 'Header Unique Id';
            DataClassification = CustomerContent;
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; "Rental Id"; Text[20])
        {
            Caption = 'Rental Id';
            DataClassification = CustomerContent;
        }
        field(20; "Rental Date"; Date)
        {
            Caption = 'Rental Date';
            DataClassification = CustomerContent;
        }
        field(30; "Reference Id"; Text[20])
        {
            Caption = 'Reference Id';
            DataClassification = CustomerContent;
        }
        field(40; "Reference Name"; Text[150])
        {
            Caption = 'Reference Name';
            DataClassification = CustomerContent;
        }
        field(50; "Single Ledger Ref. Id"; Text[20])
        {
            Caption = 'Single Ledger Ref. Id';
            DataClassification = CustomerContent;
        }
        field(60; "Single Ledger Ref. Value"; Text[100])
        {
            Caption = 'Single Ledger Ref. Value';
            DataClassification = CustomerContent;
        }
        field(70; "Room Name Ref. Id"; Text[20])
        {
            Caption = 'Room Name Ref. Id';
            DataClassification = CustomerContent;
        }
        field(80; "Room Name Ref. Value"; Text[100])
        {
            Caption = 'Room Name Ref. Value';
            DataClassification = CustomerContent;
        }
        field(90; "Room Type Ref. Id"; Text[20])
        {
            Caption = 'Room Type Ref. Id';
            DataClassification = CustomerContent;
        }
        field(100; "Room Type Ref. Value"; Text[100])
        {
            Caption = 'Room Type Ref. Value';
            DataClassification = CustomerContent;
        }
        field(110; "Rate Type Ref. Id"; Text[20])
        {
            Caption = 'Rate Type Ref. Id';
            DataClassification = CustomerContent;
        }
        field(120; "Rate Type Ref. Value"; Text[100])
        {
            Caption = 'Rate Type Ref. Value';
            DataClassification = CustomerContent;
        }
        field(130; "Room Charge Ref. Id"; Text[20])
        {
            Caption = 'Room Charge Ref. Id';
            DataClassification = CustomerContent;
        }
        field(140; "Room Charge Ref. Value"; Text[100])
        {
            Caption = 'Room Charge Ref. Value';
            DataClassification = CustomerContent;
        }
        field(150; "Slab Tax Ref. Id"; Text[20])
        {
            Caption = 'Slab Tax Ref. Id';
            DataClassification = CustomerContent;
        }
        field(160; "Slab Tax Ref. Value"; Text[100])
        {
            Caption = 'Slab Tax Ref. Value';
            DataClassification = CustomerContent;
        }
        field(170; "Source Ref. Id"; Text[20])
        {
            Caption = 'Source Ref. Id';
            DataClassification = CustomerContent;
        }
        field(180; "Source Ref. Value"; Text[100])
        {
            Caption = 'Source Ref. Value';
            DataClassification = CustomerContent;
        }
        field(190; "Market Code Ref. Id"; Text[20])
        {
            Caption = 'Market Code Ref. Id';
            DataClassification = CustomerContent;
        }
        field(200; "Market Code Ref. Value"; Text[100])
        {
            Caption = 'Market Code Ref. Value';
            DataClassification = CustomerContent;
        }
        field(210; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(220; "Tax Per"; Decimal)
        {
            Caption = 'Tax Per';
            DataClassification = CustomerContent;
        }
        field(230; "Slab Tax Id"; Text[100])
        {
            Caption = 'Slab Tax Id';
            DataClassification = CustomerContent;
        }
        field(240; "Slab Tax Name"; Text[150])
        {
            Caption = 'Slab Tax Name';
            DataClassification = CustomerContent;
        }
        field(250; "Slab Range"; Text[150])
        {
            Caption = 'Slab Range';
            DataClassification = CustomerContent;
        }
        field(260; "Charge Name"; Text[250])
        {
            Caption = 'Charge Name';
            DataClassification = CustomerContent;
        }
        field(270; "Master Unique Id"; Text[20])
        {
            Caption = 'Master Unique Id';
            DataClassification = CustomerContent;
        }
        field(280; "Parent Master Unique Id"; Text[20])
        {
            Caption = 'Parent Master Unique Id';
            DataClassification = CustomerContent;
        }
        field(290; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(300; "Tax Type"; Text[100])
        {
            Caption = 'Tax Type';
            DataClassification = CustomerContent;
        }
        field(310; "POS Data"; Text[250])
        {
            Caption = 'POS Data';
            DataClassification = CustomerContent;
        }
        field(320; "POS Tax Name"; Text[150])
        {
            Caption = 'POS Tax Name';
            DataClassification = CustomerContent;
        }
        field(321; "POS Tax Percentage"; Text[10])
        {
            Caption = 'POS Tax Percentage';
            DataClassification = CustomerContent;
        }
        field(400; "Header Record Date"; Date)
        {
            Caption = 'Header Record Date';
            DataClassification = CustomerContent;
        }
        field(410; "Header Check In Date"; Date)
        {
            Caption = 'Header Check In Date';
            DataClassification = CustomerContent;
        }
        field(420; "Header Check Out Date"; Date)
        {
            Caption = 'Header Check Out Date';
            DataClassification = CustomerContent;
        }
        field(430; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            DataClassification = CustomerContent;
        }
        field(440; "Folio No."; Text[100])
        {
            Caption = 'Folio No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Hotel Code", "Header Unique Id", "Line No.")
        {
            Clustered = true;
        }
        key(myKey1; "Header Unique Id", "Sales Invoice No.")
        {
        }
        key(myKey3; "Rental Date")
        {
        }
        key(myKey4; "Sales Invoice No.", "Rental Date")
        {
        }
    }

    trigger OnModify()
    begin
        eZeeRevenueHeader.Get("Hotel Code", "Header Unique Id");
        if eZeeRevenueHeader."Sales Invoice No." = '' then begin
            eZeeRevenueHeader."Sales Invoice No." := "Sales Invoice No.";
            eZeeRevenueHeader.Modify();
        end;
    end;

    var
        eZeeRevenueHeader: Record "eZee Revenue Header";
}
