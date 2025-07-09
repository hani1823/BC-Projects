table 50112 "Foodics Accounts"
{
    Caption = 'Foodics Accounts';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(3; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Account Type" = const("Allocation Account")) "Allocation Account"
            else
            if ("Account Type" = const(Employee)) Employee;
        }
        field(4; "Branch Name"; Text[100])
        {
            Caption = 'Branch Name (optional)';
            TableRelation = "Foodics Branch";
        }
    }

    keys
    {
        key(PK; "Account Name", "Branch Name")
        {
            Clustered = true;
        }
    }
}
