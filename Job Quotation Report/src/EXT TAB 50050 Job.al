tableextension 50050 "EXT job" extends Job
{
    fields
    {
        field(50000; Surface; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'المساحة';

        }
        field(50001; MeterPrice; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'ثمن المتر';

        }
        field(50002; TotalPrice; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'الثمن الإجمالي';

        }


    }
}