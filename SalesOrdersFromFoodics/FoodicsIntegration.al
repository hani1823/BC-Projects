codeunit 50131 "Foodics Integration Mgr"
{
    SingleInstance = true;

    procedure ImportOrdersForDate(BusinessDate: Date)
    var
        Setup: Record "Foodics Setup";
        Branch: Record "Foodics Branch";
    begin
        if not Setup.Get('SETUP') then
            Error('Foodics Setup record not found.');

        if not Branch.FindSet() then
            Error('No Foodics branches defined.');

        repeat
            ImportBranch(Setup, Branch, BusinessDate);
        until Branch.Next() = 0;
    end;

    //==============================================================
    local procedure ImportBranch(
    Setup: Record "Foodics Setup";
    Branch: Record "Foodics Branch";
    BusinessDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;

        RespTxt: Text;
        RootObj: JsonObject;
        DataTok: JsonToken;
        LinksTok: JsonToken;
        Arr: JsonArray;
        ElTok: JsonToken;
        ValTok: JsonToken;
        JVal: JsonValue;
        NextTok: JsonToken;

        Total: Decimal;
        NextUrl: Text;
        PriceDec: Decimal;
        PriceTxt: Text;
        NextTxt: Text;
        Y, M, D : Integer;
        MTxt, DTxt, DateTxt : Text[10];

        GL: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        Y := DATE2DMY(BusinessDate, 3);
        M := DATE2DMY(BusinessDate, 2);
        D := DATE2DMY(BusinessDate, 1);

        if M < 10 then
            MTxt := '0' + Format(M)
        else
            MTxt := Format(M);

        if D < 10 then
            DTxt := '0' + Format(D)
        else
            DTxt := Format(D);

        DateTxt := Format(Y) + '-' + MTxt + '-' + DTxt;
        NextUrl := StrSubstNo('%1/orders?filter[branch_id]=%2&filter[business_date]=%3',
                              Setup."Base URL", Branch."Branch Id", DateTxt);
        repeat

            Clear(Request);
            Request.Method := 'GET';
            Request.SetRequestUri(NextUrl);

            Request.GetHeaders(Headers);
            Headers.Add('Authorization', StrSubstNo('Bearer %1', Setup."API Token"));
            Headers.Add('Accept', 'application/json');

            if not Client.Send(Request, Response) then
                Error('Unable to contact Foodics. HTTP status: %1', Response.HttpStatusCode);

            if not Response.IsSuccessStatusCode() then
                Error('Foodics returned %1', Response.HttpStatusCode);

            Response.Content.ReadAs(RespTxt);     //Text
            RootObj.ReadFrom(RespTxt);            //Parse

            //--- data[]
            if RootObj.Get('data', DataTok) then begin
                Arr := DataTok.AsArray();
                foreach ElTok in Arr do begin
                    if ElTok.AsObject().Get('total_price', ValTok) and ValTok.IsValue() then begin
                        JVal := ValTok.AsValue();
                        PriceTxt := JVal.AsText();
                        if Evaluate(PriceDec, PriceTxt) then
                            Total += PriceDec;
                    end;
                end;
            end;

            //--- pagination (links.next)
            NextUrl := '';
            if RootObj.Get('links', LinksTok) then
                if LinksTok.AsObject().Get('next', NextTok) and NextTok.IsValue() then begin
                    JVal := NextTok.AsValue();
                    if not JVal.IsNull() then begin
                        NextTxt := JVal.AsText();
                        if NextTxt <> '' then
                            NextUrl := NextTxt;
                    end;
                end;
        until NextUrl = '';



        if Total = 0 then
            exit;

        GL.Reset();
        GL.SetRange("Journal Template Name", Branch."Journal Template Name");
        GL.SetRange("Journal Batch Name", Branch."Journal Batch Name");
        if GL.FindLast() then
            LineNo := GL."Line No." + 10000
        else
            LineNo := 10000;

        GL.Init();
        GL."Journal Template Name" := Branch."Journal Template Name";
        GL."Journal Batch Name" := Branch."Journal Batch Name";
        GL."Line No." := LineNo;
        GL."Posting Date" := BusinessDate;
        GL."Document Date" := BusinessDate;
        GL.Description := StrSubstNo('Foodics Sales for %1 %2', Branch.Name, DateTxt);
        GL."Account Type" := GL."Account Type"::"G/L Account";
        GL."Account No." := Branch."Sales G/L Account";
        GL.Amount := Total;
        GL.Insert(true);
    end;

}
