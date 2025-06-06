tableextension 50135 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50141; "Owner Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50143; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50144; "Plan Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50145; "Payment Method"; Enum PaymentMethod)
        {
            Caption = 'Type of Sale';
            DataClassification = ToBeClassified;
        }
        field(50146; "Bank Type"; Enum BankType)
        {
            DataClassification = ToBeClassified;
        }
        field(50147; "Sale Source"; Enum SaleSourceEnum)
        {
            DataClassification = ToBeClassified;
        }
        field(50149; "Conveyance Agent"; Enum ConveyanceAgentEnum)
        {
            DataClassification = ToBeClassified;
        }
        field(50158; "SREM No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50159; "RETax No."; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(50150; "Cheque Number"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50156; "Conveyance Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50157; "Conveyance Bank"; Enum BankType)
        {
            DataClassification = ToBeClassified;
        }
        field(50160; "With Commission?"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;
        }
    }
}