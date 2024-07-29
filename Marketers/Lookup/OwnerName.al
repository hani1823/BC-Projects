page 50135 OwnerNameLookup
{
    PageType = List;
    SourceTable = TempTable2;
    ApplicationArea = All;
    //Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    trigger OnOpenPage()
    var
        qr: Query OwnerQuery;

    begin

        //TempTable.DeleteAll();
        if qr.Open() then begin
            while qr.Read() do begin
                rec.Init();

                rec."Owner Name" := qr.Owner_Name;
                rec.Insert();
            end;
            qr.Close();
        end;

        // CurrPage.SetSelectionFilter(TempTable);
    end;
    /*trigger OnOpenPage()
    var
        qr: Query OwnerQuery;
        salesRec: Record "Sales Header";
    begin
        if qr.Open() then begin
            Rec.SetRange(Rec."Plan Name", qr.Plan_Name);
            while qr.Read() do begin
                Rec.Init();
                Rec."Plan Name" := qr.Plan_Name;
                Rec."Owner Name" := qr.Owner_Name;
                Rec.Insert();
            end;
            qr.Close();
        end;*/
    /* qr.SetRange(qr.Plan_Name, SalesRec."Plan Name");
     qr.Open();
     while qr.Read() do begin
         rec."Owner Name" := qr.Owner_Name;
         rec."Plan Name" := qr.Plan_Name;
         rec.Insert();
     end;
     qr.Close();
     CurrPage.SetTableView(Rec);

end;*/

}
