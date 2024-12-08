pageextension 50112 "GLEntryAttachmentAction" extends "General Ledger Entries"
{
    actions
    {
        addlast("F&unctions")
        {
            action("BringInvoiceAttachments")
            {
                Caption = 'Bring Attachments from Purchase Invoice';
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                var
                    DocAttachment: Record "Document Attachment";
                    GLEntry: Record "G/L Entry";
                    NewAttachment: Record "Document Attachment";
                    PurchInvHeader: Record "Posted Purchase Invoice";
                begin
                    // Validate that the current G/L Entry is selected
                    if Rec.IsEmpty then
                        Error('Please select a General Ledger Entry.');

                    // Fetch the related Posted Purchase Invoice using Document No.
                    PurchInvHeader.SetRange(, Rec."Document No.");
                    if not PurchInvHeader.FindFirst() then
                        Error('No related Posted Purchase Invoice found for Document No. %1.', Rec."Document No.");

                    // Fetch attachments from the Document Attachment table
                    DocAttachment.SetRange("No.", PurchInvHeader."No.");
                    if DocAttachment.FindSet() then begin
                        repeat
                            // Copy each attachment to the Document Attachment for G/L Entry
                            NewAttachment.Init();
                            NewAttachment."Table ID" := DATABASE::"G/L Entry";
                            NewAttachment."No." := Format(Rec."Entry No.");
                            NewAttachment."File Name" := DocAttachment."File Name";
                            NewAttachment."Blob Reference" := DocAttachment."Blob Reference";
                            NewAttachment."Document Type" := DocAttachment."Document Type";
                            NewAttachment."Description" := DocAttachment."Description";
                            NewAttachment.Insert();
                        until DocAttachment.Next() = 0;

                        Message('%1 attachment(s) have been linked to G/L Entry %2.', DocAttachment.Count(), Rec."Entry No.");
                    end else
                        Message('No attachments found for the related Posted Purchase Invoice.');
                end;
            }
        }
    }
}
