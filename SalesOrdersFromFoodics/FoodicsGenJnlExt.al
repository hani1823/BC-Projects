pageextension 50120 "Foodics GenJnl Ext" extends "General Journal"
{
    actions
    {
        addafter(SaveAsStandardJournal)               // يضع الزر في مجموعة "Process"
        {
            action(ImportFoodicsOrders)
            {
                Caption = 'Import Foodics Sales';
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
                        Mgr.ImportOrdersForDate(SelDate);
                        Message('Foodics sales for %1 have been imported.', Format(SelDate));
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
