pageextension 50014 "EXT Business Manager RC" extends "Business Manager Role Center"
{


    actions
    {



        addafter("Purchase Quote")
        {
            action("PurchaseRequest")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Requests';
                RunObject = page "Blanket Purchase Orders";
            }

        }
    }


}

pageextension 50017 "EXT urchasing Manager RC" extends "Purchasing Manager Role Center"
{


    actions
    {

        addafter("Orders")
        {
            action("PurchaseRequest")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Requests';
                RunObject = page "Blanket Purchase Orders";
            }

        }
    }


}