tableextension 50013 "GeneralJournalLineExt" extends "Gen. Journal Line"
{
    fields
    {
        field(51000; AmountInWords; Text[255])
        {
            DataClassification = ToBeClassified;
            Caption = 'تفنيط';
        }
        field(51001; Recipient; Text[255])
        {
            DataClassification = ToBeClassified;
            Caption = 'المرسل اليه';
        }
    }


}