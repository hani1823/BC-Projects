pageextension 50051 "EXT Job Card" extends "Job Card"
{
    layout
    {
        addlast(General)
        {
            field(Surface; Rec.Surface)
            {
                ApplicationArea = all;
                Visible = true;

                trigger OnValidate()
                begin
                    Rec.TotalPrice := Rec.MeterPrice * Rec.Surface;

                end;

            }
            field(MeterPrice; Rec.MeterPrice)
            {
                ApplicationArea = all;
                Visible = true;
                trigger OnValidate()
                begin
                    Rec.TotalPrice := Rec.MeterPrice * Rec.Surface;

                end;

            }

            field(TotalPrice; Rec.TotalPrice)
            {
                ApplicationArea = all;

                Visible = true;
                Editable = false;


            }
        }

    }





}