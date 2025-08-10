pageextension 50120 "Foodics GenJnl Ext" extends "General Journal"
{
    layout
    {
        modify("Total Emission CH4") { Visible = false; }
        modify("Total Emission CO2") { Visible = false; }
        modify("Total Emission N2O") { Visible = false; }
        modify("Sust. Account No.") { Visible = false; }
    }
    actions
    {
        addafter(SaveAsStandardJournal)
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
            action(ImportFoodicsConsumptions)
            {
                Caption = 'Import Foodics Consumptions';
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
                        Mgr.ImportConsumptionForDate(SelDate);
                        Message('Foodics Consumptions for %1 have been imported.', Format(SelDate));
                    end;
                end;
            }
            action(ImportFoodicsTransferReceiving)
            {
                Caption = 'Import Foodics Transfer Receiving';
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
                        Mgr.ImportTransferReceivingForDate(SelDate);
                        Message('Foodics Transfer Receiving for %1 have been imported.', Format(SelDate));
                    end;
                end;
            }
            action(ImportFoodicsTransferSending)
            {
                Caption = 'Import Foodics Transfer Sending';
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
                        Mgr.ImportTransferSendingForDate(SelDate);
                        Message('Foodics Transfer Sending for %1 have been imported.', Format(SelDate));
                    end;
                end;
            }
            action(ImportFoodicsQuantityAdjustment)
            {
                Caption = 'Import Foodics Quantity Adjustment';
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
                        Mgr.ImportQuantityAdjustmentForDate(SelDate);
                        Message('Foodics Quantity Adjustment for %1 have been imported.', Format(SelDate));
                    end;
                end;
            }
            action(ImportFoodicsReturnfromOrder)
            {
                Caption = 'Import Foodics Return from Order';
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
                        Mgr.ImportReturnfromOrderForDate(SelDate);
                        Message('Foodics Return from Order for %1 have been imported.', Format(SelDate));
                    end;
                end;
            }
            action(ImportFoodicsInventoryCounts)
            {
                Caption = 'Import Foodics Inventory Counts';
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
                        Mgr.ImportInventoryCountsForDate(SelDate);
                        Message('Foodics Inventory Counts for %1 have been imported.', Format(SelDate));
                    end;
                end;
            }
            action(ImportFoodicsCostAdjustments)
            {
                Caption = 'Import Foodics Cost Adjustments';
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
                        Mgr.ImportCostAdjustmentsForDate(SelDate);
                        Message('Foodics Cost Adjustments for %1 have been imported.', Format(SelDate));
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
