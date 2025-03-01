query 70030 "APIV1 - Customer"
{
    QueryType = API;
    APIPublisher = 'Alinma';
    APIGroup = 'RealestateApp';
    APIVersion = 'v1.0';
    Caption = 'Customers', Locked = true;
    EntityName = 'Customers';
    EntitySetName = 'Customers';

    elements
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.")
            {
                Caption = 'No.', Locked = true;
            }

            column(Name; Name)
            {
                Caption = 'Name', Locked = true;
            }

            column(Phone_No_; "Phone No.")
            {
                Caption = 'Phone No.', Locked = true;
            }
            column(Customer_ID; "Customer ID")
            {
                Caption = 'Customer ID', Locked = true;
            }

            column(Date_of_Birth; "Date of Birth")
            {
                Caption = 'Date of Birth', Locked = true;
            }

            column(E_Mail; "E-Mail")
            {
                Caption = 'E-Mail', Locked = true;
            }

            /*
                        filter(Gen__Bus__Posting_Group; "Gen. Bus. Posting Group")
                        {
                            Caption = 'Gen. Bus. Posting Group', Locked = true;
                            ColumnFilter = Gen__Bus__Posting_Group = Filter('AGENTS');
                        }
            */

        }
    }
}