pageextension 50113 "GLEntryAttachmentFactBox" extends "General Ledger Entries"
{
    layout
    {
        addafter(Attachments)
        {
            systempart(Attachments); // System FactBox to show Document Attachments
        }
    }
}