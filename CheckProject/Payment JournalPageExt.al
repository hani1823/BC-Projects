pageextension 50012 "Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addlast(Control1)
        {
            field(AmountInWords; Rec.AmountInWords)
            {
                ApplicationArea = all;
                Visible = true;

            }
            field(Recipient; Rec.Recipient)
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
    }


}