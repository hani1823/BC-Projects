pageextension 50121 "Foodics Purchase Invoice EXT" extends "Purchase Invoices"
{
    actions
    {
        addafter("P&osting")
        {
            action("ImportFoodicsPurchasing")
            {
                Caption = 'Import Foodics Purchasing';
                ApplicationArea = All;
                Image = Import;
                Visible = ShowFields;

                trigger OnAction()
                var
                    DateDlg: Page "Foodics Date Selection";
                    SelDate: Date;
                    Mgr: Codeunit "Foodics Integration Mgr";
                begin
                    // افتح نافذة اختيار التاريخ
                    DateDlg.InitDate(Today);
                    if DateDlg.RunModal() = ACTION::OK then begin
                        SelDate := DateDlg.GetDate();
                        Mgr.ImportPurchasingForDate(SelDate);
                        Message('Foodics Purchase Orders %1 have been imported.', Format(SelDate));
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'MOLTEN CHEESE.';
    end;

    var
        ShowFields: Boolean;
}