query 70032 "APIV1 - ParentID"
{
    QueryType = API;
    APIPublisher = 'Alinma';
    APIGroup = 'RealestateApp';
    APIVersion = 'v1.0';
    Caption = 'Parent ID', Locked = true;
    EntityName = 'ParentID';
    EntitySetName = 'ParentID';

    elements
    {
        dataitem(Gen__Journal_Line; "Gen. Journal Line")
        {

            column(SystemId; SystemId)
            {
                Caption = 'SystemId', Locked = true;
            }
            column(Journal_Batch_Name; "Journal Batch Name")
            {
                Caption = 'SystemId', Locked = true;
                ColumnFilter = Journal_Batch_Name = Filter('ATTACHEMEN');
            }
            column(Incoming_Document_Entry_No_; "Incoming Document Entry No.")
            {
                Caption = 'SystemId', Locked = true;
                ColumnFilter = Incoming_Document_Entry_No_ = Filter('=0');
            }


        }
    }
}