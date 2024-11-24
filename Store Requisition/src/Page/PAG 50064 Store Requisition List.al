page 50064 "Store Requisition List"
{
    ApplicationArea = All;
    Caption = 'Store Requisition List';
    CardPageID = "Blanket Sales Order";
    //DataCaptionFields = "sell-to cutomer No.";
    Editable = false;
    PageType = List;
    QueryCategory = 'Blanket Sales Orders';
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = CONST("Blanket Order"), Hidden = const(false));
    UsageCategory = Administration;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }

                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Visible = true;

                }




                field("order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }

                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                    StyleExpr = StatusStyleTxt;
                }
            }
        }
    }

    actions
    {

        area(Processing)
        {

            action(NewSR)
            {
                ApplicationArea = ALL;
                Caption = 'New Store Requisition';

                Image = Add;
                trigger OnAction()
                var
                    StoreRequisitin: Page "Blanket Sales Order";
                    SaleHeader: Record "Sales Header";
                begin

                    SaleHeader.SetRange(hidden, true);
                    if SaleHeader.FindFirst() then begin
                        SaleHeader.Modify(true);
                        SaleHeader.Hidden := false;
                        SaleHeader."Assigned User ID" := UserId;
                        SaleHeader."Posting Description" := '';
                        SaleHeader."Order Date" := Today;
                        SaleHeader.Modify();

                        StoreRequisitin.SetRecord(SaleHeader);
                        StoreRequisitin.Run();
                    end else
                        Message('Error');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        Rec.SetRange("Assigned User ID", USERID);
        SetTableView(Rec);

    end;

    trigger OnAfterGetRecord()
    begin

        StatusStyleTxt := Rec.GetStatusStyleText();

    end;

    var

        [InDataSet]
        StatusStyleTxt: Text;


}