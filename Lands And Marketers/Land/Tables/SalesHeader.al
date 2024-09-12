tableextension 50135 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(141; "Owner Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(143; "Plan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(144; "Plan Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(145; "Payment Method"; Enum PaymentMethod)
        {
            Caption = 'Type of Sale';
            DataClassification = ToBeClassified;
        }
        field(146; "Bank Type"; Enum BankType)
        {
            DataClassification = ToBeClassified;
        }
        field(147; "Sale Source"; Enum SaleSourceEnum)
        {
            DataClassification = ToBeClassified;
        }
        field(149; "Conveyance Agent"; Enum ConveyanceAgentEnum)
        {
            DataClassification = ToBeClassified;
        }
        field(150; "Cheque Number"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(156; "Conveyance Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(157; "Conveyance Bank"; Enum BankType)
        {
            DataClassification = ToBeClassified;
        }
    }
}