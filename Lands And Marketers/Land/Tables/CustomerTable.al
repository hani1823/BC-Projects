tableextension 50118 CustomerTableEXT extends "Customer"
{
    fields
    {
        field(13; "Customer ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
}