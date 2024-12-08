pageextension 50060 "EXT Blanket Sales Order" extends "Blanket Sales Order"
{
    Caption = 'Store Requisition';

    layout
    {
        modify("Sell-to Customer No.")
        {
            Visible = false;
        }
        modify("Sell-to Customer Name")
        {
            Visible = false;
        }
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        modify("Bill-to Contact No.")
        {
            Visible = false;
        }
        modify("Sell-to Contact No.")
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = false;
        }
        modify("External Document No.")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("sell-to Contact")
        {
            Visible = false;
        }
        modify("Sell-to")
        {
            Visible = false;
        }
        modify("Invoice Details")
        {
            Visible = false;
        }
        modify("Shipping and Billing")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Attached Documents")
        {
            Visible = false;
        }

        modify(Control13)
        {
            Visible = false;
        }



        modify(Control1902018507)
        {
            Visible = false;
        }
        modify(Control1900316107)
        {
            Visible = false;
        }
        modify(Control1906127307)
        {
            Visible = false;
        }
        modify(ApprovalFactBox)
        {
            Visible = false;
        }
        modify(Control1907012907)
        {
            Visible = false;
        }
        modify(WorkflowStatus)
        {
            Visible = false;
        }
        modify(Control1900383207)
        {
            Visible = false;
        }

        modify(Control1905767507)
        {
            Visible = false;
        }

        modify("Assigned User ID")
        {
            Editable = false;
        }


        addbefore("Order Date")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
                Caption = 'Description';
                Editable = hide;

            }
        }

    }

    actions
    {
        modify(SendApprovalRequest)
        {
            Enabled = (not OpenApprovalEntriesExist) and (CanRequestApprovalForFlow) and (Rec.Status <> Rec.Status::Released);
        }
        modify(CancelApprovalRequest)
        {
            Enabled = (CanCancelApprovalForRecord) or (CanCancelApprovalForFlow);
            trigger OnBeforeAction()
            var
                WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
            begin
                WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                Message('The approval request for the record has been canceled.');
            end;
        }
        addlast("F&unctions")
        {

            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Make Neg. Adjustm';

                trigger OnAction()
                var

                    ItemJrnLinesToBeInsert: Record "Item Journal Line";
                    SR_LineToBeInserted: Record "Sales Line";
                    MyQuery: Query "Batch List in SR";
                    itemSR: Record Item;
                    itemUOM: Record "Item Unit of Measure";
                begin

                    if Rec.Status = Rec.Status::Released then begin
                        MyQuery.SetFilter(MyQuery.Document_No_, rec."No.");
                        MyQuery.SetFilter(MyQuery.Journal_Batch_Name, '<>%1', '');
                        MyQuery.SetRange(MyQuery.IsCreated, false);
                        if MyQuery.Open() then begin
                            while MyQuery.Read() do begin
                                // Filter by Batch
                                SR_LineToBeInserted.SetRange("Document No.", Rec."No.");
                                SR_LineToBeInserted.SetRange("Document Type", Enum::"Sales Document Type"::"Blanket Order");
                                SR_LineToBeInserted.SetRange("Journal Batch Name", MyQuery.Journal_Batch_Name);
                                if SR_LineToBeInserted.FindSet() then begin
                                    repeat
                                        itemSR.SetRange("No.", SR_LineToBeInserted."No.");
                                        if itemSR.FindSet() then begin

                                            ItemJrnLinesToBeInsert.Init();

                                            ItemJrnLinesToBeInsert."Journal Template Name" := 'ITEM';
                                            ItemJrnLinesToBeInsert."Line No." := SR_LineToBeInserted."Line No." + 1;
                                            ItemJrnLinesToBeInsert."Item No." := SR_LineToBeInserted."No.";
                                            ItemJrnLinesToBeInsert."Posting Date" := Today();

                                            ItemJrnLinesToBeInsert."Entry Type" := Enum::"Item Ledger Entry Type"::"Negative Adjmt.";
                                            ItemJrnLinesToBeInsert.Description := itemSR.Description;
                                            ItemJrnLinesToBeInsert."Inventory Posting Group" := 'INVENTORY';
                                            ItemJrnLinesToBeInsert.Quantity := SR_LineToBeInserted.Quantity;
                                            ItemJrnLinesToBeInsert."Invoiced Qty. (Base)" := SR_LineToBeInserted.Quantity;
                                            ItemJrnLinesToBeInsert."Quantity (Base)" := SR_LineToBeInserted.Quantity;
                                            ItemJrnLinesToBeInsert."Source Code" := 'ITEMJNL';
                                            ItemJrnLinesToBeInsert."Journal Batch Name" := SR_LineToBeInserted."Journal Batch Name";
                                            ItemJrnLinesToBeInsert."Gen. Prod. Posting Group" := itemSR."Gen. Prod. Posting Group";
                                            ItemJrnLinesToBeInsert."Document Date" := Today();

                                            itemUOM.SetRange("Item No.", itemSR."No.");
                                            itemUOM.SetRange(code, SR_LineToBeInserted."Unit of Measure Code");
                                            if itemUOM.FindSet() then ItemJrnLinesToBeInsert."Qty. per Unit of Measure" := itemUOM."Qty. per Unit of Measure";

                                            ItemJrnLinesToBeInsert."Unit of Measure Code" := SR_LineToBeInserted."Unit of Measure Code";
                                            ItemJrnLinesToBeInsert."Location Code" := SR_LineToBeInserted."Location Code";
                                            ItemJrnLinesToBeInsert."Item Category Code" := itemSR."Item Category Code";
                                            ItemJrnLinesToBeInsert."Value Entry Type" := enum::"Cost Entry Type"::"Direct Cost";
                                            ItemJrnLinesToBeInsert.Type := enum::"Capacity Type Journal"::"Work Center";
                                            ItemJrnLinesToBeInsert."Dimension Set ID" := SR_LineToBeInserted."Dimension Set ID";
                                            ItemJrnLinesToBeInsert."Shortcut Dimension 1 Code" := SR_LineToBeInserted."Shortcut Dimension 1 Code";
                                            ItemJrnLinesToBeInsert."Shortcut Dimension 2 Code" := SR_LineToBeInserted."Shortcut Dimension 2 Code";

                                            ItemJrnLinesToBeInsert.RecalculateUnitAmount();

                                            ItemJrnLinesToBeInsert.Insert();
                                            SR_LineToBeInserted.IsCreated := true;
                                            SR_LineToBeInserted.Modify();
                                            //ItemJrnLinesToBeInsert.Quantity := ;

                                        end else
                                            Error('Item in SR Line Not Found');
                                        ;

                                    until SR_LineToBeInserted.Next() = 0;
                                end else
                                    Error('SR Line Not Found');
                                ;
                            end;
                        end;
                        Commit();
                    end;
                end;
            }
        }
    }


    trigger OnOpenPage()
    var
    begin
        CheckShowBackgrValidationNotification();
        hide := true;
        if (Rec.Status = rec.Status::"Pending Approval") OR (Rec.Status = rec.Status::Released) then begin
            hide := false;
        end;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId(), CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;


    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    local procedure CheckShowBackgrValidationNotification()
    var
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
    begin
        if DocumentErrorsMgt.CheckShowEnableBackgrValidationNotification() then
            SetControlAppearance();
    end;

    var
        //[InDataSet]
        hide: boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
}