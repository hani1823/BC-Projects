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

        }
        field(146; "Bank Type"; Enum BankType)
        {

        }
        field(147; "Sale Source"; Enum SaleSourceEnum)
        {

        }
        field(149; "Conveyance Agent"; Enum ConveyanceAgentEnum)
        {

        }
        field(150; "Cheque Number"; Code[10])
        {

        }
        field(156; "Conveyance Date"; Date)
        {

        }
        field(157; "Conveyance Bank"; Enum BankType)
        {

        }
    }
}