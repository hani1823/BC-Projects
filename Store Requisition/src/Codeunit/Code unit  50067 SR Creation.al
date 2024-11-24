codeunit 50067 "SR Creation"
{
    trigger OnRun()
    begin
        cpt := 0;
        count := 0;
        SalesHeaderCount.SetRange(Hidden, true);
        SalesHeaderCount.SetRange("Document Type", Enum::"sales Document Type"::"Blanket Order");
        if SalesHeaderCount.FindSet() then
            repeat
                count := count + 1;
            until SalesHeaderCount.Next() = 0;

        if count < 30 then begin
            left := 30 - count;

            for cpt := 1 to left do begin
                SalesHeader[cpt].Init();

                SalesHeader[cpt]."Document Type" := Enum::"sales Document Type"::"Blanket Order";


                SalesHeader[cpt]."Sell-to Customer No." := 'HC101071 ';
                SalesHeader[cpt]."bill-to Customer No." := 'HC101071 ';
                SalesHeader[cpt]."sell-to Customer Name" := 'Store Requisition';
                SalesHeader[cpt]."Bill-to Name" := 'Store Requisition';
                SalesHeader[cpt]."Customer Posting Group" := 'GUST';
                SalesHeader[cpt]."VAT Bus. Posting Group" := 'DOMESTIC';


                SalesHeader[cpt].Hidden := true;
                SalesHeader[cpt].InitInsert();
                SalesHeader[cpt].Insert();
                // PurchaseHeader.InitInsert();
            end;
        end;
        Commit();

    end;

    var
        SalesHeader: array[30] of Record "Sales Header";
        SalesHeaderCount: Record "Sales Header";
        cpt: Integer;
        count: Integer;
        left: Integer;

}