query 70029 "APIV1 - Marketers"
{
    QueryType = API;
    APIPublisher = 'Alinma';
    APIGroup = 'RealestateApp';
    APIVersion = 'v1.0';
    Caption = 'Marketers', Locked = true;
    EntityName = 'Marketers';
    EntitySetName = 'Marketers';

    elements
    {
        dataitem(Vendor; Vendor)
        {

            column(No_; "No.")
            {
                Caption = 'Marketer NO', Locked = true;
            }
            column(Name; Name)
            {
                Caption = 'Name', Locked = true;
            }

            filter(Gen__Bus__Posting_Group; "Gen. Bus. Posting Group")
            {
                Caption = 'Gen. Bus. Posting Group', Locked = true;
                ColumnFilter = Gen__Bus__Posting_Group = Filter('AGENTS');
            }

        }
    }
}