pageextension 50135 "Sales Order Ext2" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Owner Name"; LandRec."Owner Name")
            {
                ApplicationArea = all;
            }
            field("Name of Plan"; LandRec."Name of Plan")
            {
                ApplicationArea = all;
            }

        }
    }


    actions
    {

    }

    var
        LandRec: Record Land;
}