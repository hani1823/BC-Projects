page 50034 "Purchase Request List"
{
    ApplicationArea = All;
    Caption = 'Purchase Request List';
    CardPageID = "Blanket Purchase Order";
    DataCaptionFields = "Buy-from Vendor No.";
    Editable = false;
    PageType = List;
    QueryCategory = 'Blanket Purchase Orders';
    SourceTable = "Purchase Header";
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
                /*
                                field(Description; Rec."Pay-to Address")
                                {
                                    Caption = 'Description';
                                    ApplicationArea = Suite;
                                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                                }
                */


                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
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
                /*  field("Location Code"; Rec."Location Code")
                  {
                      ApplicationArea = Location;
                      ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                  }
  */
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

        area(Reporting)
        {

            action(NewPR)
            {
                ApplicationArea = ALL;
                Caption = 'New Purchase Request';

                Image = Add;
                trigger OnAction()
                var
                    PurchaseRequest: Page "Blanket Purchase Order";
                    purchaseHeader: Record "Purchase Header";
                begin

                    purchaseHeader.SetRange(hidden, true);
                    if purchaseHeader.FindFirst() then begin
                        purchaseHeader.Modify(true);
                        purchaseHeader.Hidden := false;
                        purchaseHeader."Assigned User ID" := UserId;
                        purchaseHeader."Order Date" := Today;
                        purchaseHeader.Modify();

                        PurchaseRequest.SetRecord(purchaseHeader);
                        PurchaseRequest.Run();
                    end else
                        Message('Error');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Rec.SetRange("Assigned User ID", USERID);
        Rec.SetRange("Assigned User ID", USERID);
        //  SetRecord();
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