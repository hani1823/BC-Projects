reportextension 50010 CheckExt extends Check
{

    dataset
    {
        // Add changes to dataitems and columns here
        add(GenJnlLine)
        {
            column(Comment; Comment) { }
            column(MessagetoRecipient; "Message to Recipient") { }
            column(AmountInWords; AmountInWords) { }
            column(Recipient; Recipient) { }
        }
    }


}

