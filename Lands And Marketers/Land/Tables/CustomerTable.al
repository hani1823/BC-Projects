tableextension 50118 CustomerTableEXT extends "Customer"
{
    fields
    {
        field(50013; "Customer ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
}