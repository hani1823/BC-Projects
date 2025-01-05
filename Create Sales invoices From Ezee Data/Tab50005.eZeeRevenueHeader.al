table 50070 "eZee Revenue Header2"
{
    Caption = 'eZee Revenue Header';
    DataClassification = CustomerContent;

    fields
    {
        field(4; "Hotel Code"; Code[50])
        {
            Caption = 'Hotel Code';
            DataClassification = CustomerContent;
        }
        field(10; "Record Unique Id"; Text[150])
        {
            Caption = 'Record Unique Id';
            DataClassification = CustomerContent;
        }
        field(20; "Record Date"; Date)
        {
            Caption = 'Record Date';
            DataClassification = CustomerContent;
        }
        field(30; "Check In Date"; Date)
        {
            Caption = 'Check In Date';
            DataClassification = CustomerContent;
        }
        field(40; "Check Out Date"; Date)
        {
            Caption = 'Check Out Date';
            DataClassification = CustomerContent;
        }
        field(50; "Reservasion No."; Text[100])
        {
            Caption = 'Reservasion No.';
            DataClassification = CustomerContent;
        }
        field(60; "Folio No."; Text[100])
        {
            Caption = 'Folio No.';
            DataClassification = CustomerContent;
        }
        field(70; "Guest Name"; Text[250])
        {
            Caption = 'Guest Name';
            DataClassification = CustomerContent;
        }
        field(80; "Reference 6"; Text[250])
        {
            Caption = 'Reference 6';
            DataClassification = CustomerContent;
        }
        field(90; Source; Text[100])
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(100; "Bill No. / Invoice No."; Text[100])
        {
            Caption = 'Bill No. / Invoice No.';
            DataClassification = CustomerContent;
        }
        field(110; "Bill To"; Text[250])
        {
            Caption = 'Bill To';
            DataClassification = CustomerContent;
        }
        field(120; "Voucher No."; Text[100])
        {
            Caption = 'Voucher No.';
            DataClassification = CustomerContent;
        }
        field(130; "Reference 11"; Text[250])
        {
            Caption = 'Reference 11';
            DataClassification = CustomerContent;
        }
        field(140; "Reference 12"; Text[250])
        {
            Caption = 'Reference 12';
            DataClassification = CustomerContent;
        }
        field(150; "Room No."; Text[20])
        {
            Caption = 'Room No.';
            DataClassification = CustomerContent;
        }
        field(160; "Room Type"; Text[100])
        {
            Caption = 'Room Type';
            DataClassification = CustomerContent;
        }
        field(170; "Rate Type"; Text[100])
        {
            Caption = 'Rate Type';
            DataClassification = CustomerContent;
        }
        field(180; "Market Code"; Text[100])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
        }
        field(190; "Identity Type"; Text[100])
        {
            Caption = 'Identity Type';
            DataClassification = CustomerContent;
        }
        field(195; "Identity No."; Text[100])
        {
            Caption = 'Identity No.';
            DataClassification = CustomerContent;
        }
        field(200; "Email of Billing Contact"; Text[150])
        {
            Caption = 'Email of Billing Contact';
            DataClassification = CustomerContent;
        }
        field(210; "Address of Billing Contact"; Text[250])
        {
            Caption = 'Address of Billing Contact';
            DataClassification = CustomerContent;
        }
        field(220; "Telephone of Billing Contact"; Text[100])
        {
            Caption = 'Telephone of Billing Contact';
            DataClassification = CustomerContent;
        }
        field(330; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            DataClassification = CustomerContent;
        }
        field(340; "Flat Discount"; Decimal)
        {
            Caption = 'Flat Discount';
            DataClassification = CustomerContent;
        }
        field(350; "Adjustment Amount"; Decimal)
        {
            Caption = 'Adjustment Amount';
            DataClassification = CustomerContent;
        }
        field(360; "Add Less Amount"; Decimal)
        {
            Caption = 'Add Less Amount';
            DataClassification = CustomerContent;
        }
        field(370; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
        field(380; "Amount Paid"; Decimal)
        {
            Caption = 'Amount Paid';
            DataClassification = CustomerContent;
        }
        field(390; Balance; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(400; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Hotel Code", "Record Unique Id")
        {
            Clustered = true;
        }
        key(myKey1; "Sales Invoice No.")
        {
        }
    }

    trigger OnDelete()
    begin
        eZeeRevenueLine.Reset();
        eZeeRevenueLine.SetRange("Header Unique Id", "Record Unique Id");
        eZeeRevenueLine.DeleteAll();
    end;

    var
        eZeeRevenueLine: Record "eZee Revenue Line";
}