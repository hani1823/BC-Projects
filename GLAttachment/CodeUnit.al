codeunit 50113 "Attachment Transfer Handler"
{
Subtype = EventSubscriber;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseInvoice', true, true)]
    local procedure OnAfterPostPurchaseInvoice(PurchHeader: Record "Purchase Header"; var GenJnlLine: Record "Gen. Journal Line")
    var
        DocAttachment: Record "Document Attachment";
        NewAttachment: Record "Document Attachment";
        GLEntry: Record "G/L Entry";
    begin
        // Fetch G/L Entries related to the posted Purchase Invoice
        GLEntry.SetRange("Document No.", PurchHeader."No.");
        if GLEntry.FindSet() then begin
            // Loop through G/L Entries
            repeat
                // Fetch attachments from the Document Attachment table
                DocAttachment.SetRange("No.", PurchHeader."No.");
                if DocAttachment.FindSet() then begin
                    // Transfer each attachment to the G/L Entry
                    repeat
                        NewAttachment.Init();
                        NewAttachment."Table ID" := DATABASE::"G/L Entry";
                        NewAttachment."No." := Format(GLEntry."Entry No.");
                        NewAttachment."File Name" := DocAttachment."File Name";
                        NewAttachment."Document Type" := DocAttachment."Document Type";
                        NewAttachment."Blob Reference" := DocAttachment."Blob Reference"; // Copy the actual file
                        NewAttachment."Description" := DocAttachment."Description";
                        NewAttachment.Insert();
                    until DocAttachment.Next() = 0;
                end;
            until GLEntry.Next() = 0;
        end;
    end;
}
