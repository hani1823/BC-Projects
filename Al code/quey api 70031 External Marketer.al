query 70031 "APIV1 - External Marketer"
{
    QueryType = API;
    APIPublisher = 'Alinma';
    APIGroup = 'RealestateApp';
    APIVersion = 'v1.0';
    Caption = 'External Marketer', Locked = true;
    EntityName = 'External_Marketer';
    EntitySetName = 'External_Marketer';

    elements
    {
        dataitem(Vendor; Vendor)
        {

            column(Name; Name)
            {
                Caption = 'Name', Locked = true;
            }

            column(Phone_No_; "Phone No.")
            {
                Caption = 'Phone No.', Locked = true;
            }

            column(E_Mail; "E-Mail")
            {
                Caption = 'E-Mail', Locked = true;
            }

            column(IBAN; "Our Account No.")
            {
                Caption = 'IBAN', Locked = true;
            }
            filter(Gen__Bus__Posting_Group; "Gen. Bus. Posting Group")
            {
                Caption = 'Gen. Bus. Posting Group', Locked = true;
                ColumnFilter = Gen__Bus__Posting_Group = Filter('Domestic');
            }

        }
    }
}