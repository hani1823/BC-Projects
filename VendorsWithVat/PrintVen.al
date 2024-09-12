report 50111 "Vendors With Vat No"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = PrintVendorsWithVat;
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {

            }
        }
    }
    rendering
    {
        layout(PrintVendorsWithVat)
        {
            Type = Excel;
            LayoutFile = 'Layouts/VendorsWithVat.xlsx';
        }
    }
}