reportextension 50012 "GL Register Ext" extends "G/L Register"
{
    dataset
    {
        add("G/L Entry")
        {
            column(ExtDocNo; "External Document No.") { }
            column(dim4; "Shortcut Dimension 4 Code") { }
            column(dim2; "Global Dimension 2 Code") { }
        }
    }


}