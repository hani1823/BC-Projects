reportextension 50111 "Vendor Detail Balance EXT" extends "Vendor - Detail Trial Balance"
{
    dataset
    {
        modify(Vendor)
        {
            RequestFilterFields = "Global Dimension 2 Code", "Global Dimension 2 Filter";
        }
    }
}