codeunit 50035 "PR Creation"
{
    trigger OnRun()
    begin
        cpt := 0;
        count := 0;
        PurchaseHeaderCount.SetRange(Hidden, true);
        if PurchaseHeaderCount.FindSet() then
            repeat
                count := count + 1;
            until PurchaseHeaderCount.Next() = 0;

        if count < 30 then begin
            left := 30 - count;

            for cpt := 1 to left do begin
                PurchaseHeader[cpt].Init();
                PurchaseHeader[cpt]."Document Type" := Enum::"Purchase Document Type"::"Blanket Order";
                PurchaseHeader[cpt]."Pay-to Vendor No." := 'HV100428';
                PurchaseHeader[cpt]."Buy-from Vendor No." := 'HV100428';
                PurchaseHeader[cpt]."Pay-to Name" := 'Purchase Request';
                PurchaseHeader[cpt]."Buy-from Vendor Name" := 'Purchase Request';
                PurchaseHeader[cpt]."Vendor Posting Group" := 'DOMESTIC';
                PurchaseHeader[cpt]."VAT Bus. Posting Group" := 'DOMESTIC';
                PurchaseHeader[cpt].Hidden := true;
                PurchaseHeader[cpt].InitInsert();
                PurchaseHeader[cpt].Insert();
                // PurchaseHeader.InitInsert();
            end;
        end;
        Commit();

    end;

    var
        PurchaseHeader: array[30] of Record "Purchase Header";
        PurchaseHeaderCount: Record "Purchase Header";
        cpt: Integer;
        count: Integer;
        left: Integer;

}