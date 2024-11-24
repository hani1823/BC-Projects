
page 81000 Test
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'create lines';

    Permissions = tabledata "Gen. Journal Line" = RMID;



    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                Caption = 'Get ';
                trigger OnAction()
                var
                    HttpClient: HttpClient;
                    HttpResponseMessage: HttpResponseMessage;
                    AccessToken: Text;
                    ResponseBody: Text;
                    cccccc: Char;
                    comp: Text;
                    compGuid: Guid;
                    iye: Record Item;

                begin
                    iye.SetRange("No.", '1001');
                    if iye.FindSet() then comp := iye.Description;
                    // Obtain access token
                    AccessToken := getToken();

                    // Set Authorization header
                    HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
                    compGuid := CompanyProperty.ID();

                    // Send GET request to protected API
                    // if HttpClient.Get('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/Sandbox-03/ODataV4/Companies(E5554158-808F-ED11-9989-6045BD694026)/Chart_of_Accounts', HttpResponseMessage) then begin
                    if HttpClient.Get('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/Sandbox-03/ODataV4/' + comp, HttpResponseMessage) then begin
                        // Read response body
                        HttpResponseMessage.Content.ReadAs(ResponseBody);

                        // Return or process the protected data
                        Message(ResponseBody);
                    end;



                end;
            }
            action(POST)
            {
                Caption = 'Post';

                trigger OnAction()
                var
                    HttpClient: HttpClient;
                    HttpResponseMessage: HttpResponseMessage;
                    HttpRequestMessage: HttpRequestMessage;
                    ContentHeaders: HttpHeaders;
                    Content: HttpContent;
                    AccessToken: Text;
                    ResponseBody: Text;

                    comp: Text;
                    compGuid: Guid;
                    iye: Record Item;

                    jsonbjet: JsonObject;
                    jsonbjettext: text;
                begin
                    //Content.GetHeaders(ContentHeaders);
                    HttpRequestMessage.GetHeaders(ContentHeaders);
                    if ContentHeaders.Contains('Content-Type') then ContentHeaders.Remove('Content-Type');
                    ContentHeaders.Add('Content-Type', 'application/json');

                    if ContentHeaders.Contains('Content-Encoding') then ContentHeaders.Remove('Content-Encoding');
                    ContentHeaders.Add('Content-Encoding', 'UTF8');
                    iye.SetRange("No.", '1001');
                    if iye.FindSet() then comp := iye.Description;
                    // Obtain access token
                    AccessToken := getToken();

                    // Set Authorization header
                    HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

                    jsonbjet.Add('planName', 'test');
                    jsonbjet.Add('saleType', '');
                    jsonbjet.Add('saleSource', '');
                    jsonbjet.Add('clientName', 'hani 5');
                    jsonbjet.Add('phoneNumber', '+96655555');
                    jsonbjet.Add('idNumber', '651');
                    jsonbjet.Add('birthDate', '');
                    jsonbjet.Add('email', 'hani5@hani.com');
                    jsonbjet.Add('propertyType', '');
                    jsonbjet.Add('usage', '');
                    jsonbjet.Add('blockNumber', '');
                    jsonbjet.Add('plotNumber', '');
                    jsonbjet.Add('deedNumber', '1003');
                    jsonbjet.Add('deedImage', '');
                    jsonbjet.Add('streetName', '');
                    jsonbjet.Add('landArea', '');
                    jsonbjet.Add('netSalePrice', '200.35');
                    jsonbjet.Add('totalSalePrice', '');
                    jsonbjet.Add('netLandValue', '');
                    jsonbjet.Add('tax', '');
                    jsonbjet.Add('commission', '');
                    jsonbjet.Add('totalAmount', '');
                    jsonbjet.Add('transferReceipt', '');
                    jsonbjet.Add('fullNameExternalMarketing', 'external marketer 01');
                    jsonbjet.Add('phoneExternalMarketing', '+9999999');
                    jsonbjet.Add('emailExternalMarketing', 'marketer01@gmail.com');
                    jsonbjet.Add('commisibanExternalMarketingsion', '');
                    jsonbjet.Add('marketers', '');
                    jsonbjet.Add('marketer', 'RV10020,RV10038,');
                    jsonbjet.WriteTo(jsonbjettext);

                    Content.WriteFrom(jsonbjettext);

                    HttpRequestMessage.GetHeaders(ContentHeaders);
                    HttpRequestMessage.Method := 'POST';
                    HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/Sandbox-03/ODataV4/MStest_CreateSalesOrderMarketerForm?company=ALINMA%20FOR%20REAL%20ESTATE');
                    HttpRequestMessage.GetHeaders(ContentHeaders);
                    HttpRequestMessage.Content(Content);
                    HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
                    //    HttpClient.Post('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/Sandbox-03/ODataV4/MStest_CreateSalesOrderMarketerForm?company=ALINMA%20FOR%20REAL%20ESTATE', Content, HttpResponseMessage);
                    HttpResponseMessage.Content.ReadAs(ResponseBody);
                    Message(ResponseBody);
                end;
            }
            action(POST2)
            {
                Caption = 'Post2';

                trigger OnAction()
                var
                    HttpClient: HttpClient;
                    lHttpHeaders: HttpHeaders;
                    Content: HttpContent;
                    HttpRequestMessage: HttpRequestMessage;
                    HttpResponseMessage: HttpResponseMessage;

                    AccessToken: Text;
                    ResponseBody: Text;

                    comp: Text;
                    compGuid: Guid;
                    iye: Record Item;

                    jsonbjet: JsonObject;
                    jsonbjettext: text;
                begin
                    //Content.GetHeaders(ContentHeaders);

                    // Obtain access token
                    //  AccessToken := getToken();

                    // Set Authorization header
                    // HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
                    /*
                                        jsonbjet.Add('planName', 'test');
                                        jsonbjet.Add('saleType', '');
                                        jsonbjet.Add('saleSource', '');
                                        jsonbjet.Add('clientName', 'hani 5');
                                        jsonbjet.Add('phoneNumber', '+96655555');
                                        jsonbjet.Add('idNumber', '651');
                                        jsonbjet.Add('birthDate', '');
                                        jsonbjet.Add('email', 'hani5@hani.com');
                                        jsonbjet.Add('propertyType', '');
                                        jsonbjet.Add('usage', '');
                                        jsonbjet.Add('blockNumber', '');
                                        jsonbjet.Add('plotNumber', '');
                                        jsonbjet.Add('deedNumber', '1003');
                                        jsonbjet.Add('deedImage', '');
                                        jsonbjet.Add('streetName', '');
                                        jsonbjet.Add('landArea', '');
                                        jsonbjet.Add('netSalePrice', '200.35');
                                        jsonbjet.Add('totalSalePrice', '');
                                        jsonbjet.Add('netLandValue', '');
                                        jsonbjet.Add('tax', '');
                                        jsonbjet.Add('commission', '');
                                        jsonbjet.Add('totalAmount', '');
                                        jsonbjet.Add('transferReceipt', '');
                                        jsonbjet.Add('fullNameExternalMarketing', 'external marketer 01');
                                        jsonbjet.Add('phoneExternalMarketing', '+9999999');
                                        jsonbjet.Add('emailExternalMarketing', 'marketer01@gmail.com');
                                        jsonbjet.Add('commisibanExternalMarketingsion', '');
                                        jsonbjet.Add('marketers', '');
                                        jsonbjet.Add('marketer', 'RV10020,RV10038,');
                    wael@gmail.com
                                       */
                    /*       jsonbjet.Add('custNo', 'test');
                          jsonbjet.Add('custName', '');
                          jsonbjet.Add('custEmail', 'hani5@hani.com');
                          jsonbjet.Add('custPhone', '+9984');
                          jsonbjet.Add('pieceNo', 'MBOUTH-20');
                          jsonbjet.Add('piecePrice', '651');


                          jsonbjet.WriteTo(jsonbjettext);

                          Content.WriteFrom(jsonbjettext);
                          Content.GetHeaders(lHttpHeaders);
                          lHttpHeaders.Clear();
                          lHttpHeaders.Add('Content-Type', 'application/json');
                          HttpRequestMessage.Content := Content;
                          HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/Sandbox-03/ODataV4/ConstrcApi_CreateSI?company=ALINMA%20FOR%20CONSTRUCTION');
                          HttpRequestMessage.Method('POST');
                          HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
                          /*    lHttpContent.WriteFrom(InStreamRequest);
                                              lHttpContent.GetHeaders(lHttpHeaders);
                                              lHttpHeaders.Clear();
                                              lHttpHeaders.Add('Content-Type', 'application/json');
                                              lHttpRequest.Content := lHttpContent;
                                              lHttpRequest.SetRequestUri(Hotel."Revenue API Url");
                                              lHttpRequest.Method := 'POST';
                                              lHttpClient.Send(lHttpRequest, HttpResponse);
                                              HttpResponse.Content.ReadAs(InStreamResponse);
                                              */

                    //    HttpClient.Post('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/Sandbox-03/ODataV4/MStest_CreateSalesOrderMarketerForm?company=ALINMA%20FOR%20REAL%20ESTATE', Content, HttpResponseMessage);
                    //  HttpResponseMessage.Content.ReadAs(ResponseBody);
                    comp := Format(132.3 * 256);
                    Message(comp);
                end;
            }
            action(Print)
            {
                Caption = 'Print';

                trigger OnAction()
                var
                    SI_HttpClient: HttpClient;
                    SI_HttpHeaders: HttpHeaders;
                    SI_Content: HttpContent;
                    SI_HttpRequestMessage: HttpRequestMessage;
                    SI_HttpResponseMessage: HttpResponseMessage;

                    SI_AccessToken: Text;
                    SI_ResponseBody: Text;


                    SI_jsonbjet: JsonObject;
                    SI_jsonbjettext: text;

                    res: text;
                    resjson: JsonObject;
                    value: JsonToken;
                    valueText: text;
                begin

                    // Obtain access token
                    SI_AccessToken := getToken();

                    // Set Authorization header
                    SI_HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + SI_AccessToken);

                    SI_jsonbjet.Add('reportNO', 50106);
                    SI_jsonbjet.Add('parameters', '<?xml version="1.0" standalone="yes"?><ReportParameters name="PrintQuotationReport" id="50106"><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(1),Field3=1(101018))</DataItem><DataItem name="Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="Marketer">VERSION(1) SORTING(Field50001,Field50003)</DataItem></DataItems></ReportParameters>');



                    SI_jsonbjet.WriteTo(SI_jsonbjettext);

                    SI_Content.WriteFrom(SI_jsonbjettext);


                    SI_Content.GetHeaders(SI_HttpHeaders);
                    SI_HttpHeaders.Clear();
                    SI_HttpHeaders.Add('Content-Type', 'application/json');
                    SI_HttpRequestMessage.Content := SI_Content;
                    SI_HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/PROD/ODataV4/MStest_RunReport?company=ALINMA%20FOR%20REAL%20ESTATE');
                    SI_HttpRequestMessage.Method('POST');
                    SI_HttpClient.Send(SI_HttpRequestMessage, SI_HttpResponseMessage);

                    SI_HttpResponseMessage.Content.ReadAs(res);
                    resjson.ReadFrom(res);
                    resjson.Get('value', value);
                    value.WriteTo(valueText);
                    //  Message(valueText);
                    valueText := valueText.Replace('=', '%3D');
                    valueText := valueText.Replace('+', '%2B');
                    valueText := valueText.Replace('/', '%2F');
                    valueText := valueText.Replace('"', '');
                    //Message(valueText);

                    SendDocumentToWhatsApp(valueText);
                end;
            }
            action(Blob)
            {
                Caption = 'Attachment';
                trigger OnAction()
                var
                    Base64Convert: Codeunit "Base64 Convert";
                    incDoc: Record "Incoming Document Attachment";

                    InStr: InStream;
                    LargeText: Text;
                    TempBlob: Codeunit "Temp Blob";
                begin
                    incDoc.SetRange("Incoming Document Entry No.", 656);
                    if incDoc.FindSet() then begin
                        incDoc.GetContent(TempBlob);
                        TempBlob.CreateInStream(InStr);

                        //InStr.ReadText(LargeText);
                        // LargeText.
                        LargeText := Base64Convert.ToBase64(InStr, false);
                        LargeText := LargeText.Replace('=', '%3D');
                        LargeText := LargeText.Replace('+', '%2B');
                        LargeText := LargeText.Replace('/', '%2F');
                        //LargeText := LargeText.Replace('"', '');
                        SendDocumentToWhatsApp(LargeText);
                        //Message(LargeText);
                        // incDocTenantMedia.Get()
                        // Base64Convert.ToBase64()
                    end;
                end;
            }


        }
    }


    local procedure getToken(): Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        IsSuccessful: Boolean;
        uri: Text;
        AccessToken: Text;
        responseText: Text;
        JSONManagement: Codeunit "JSON Management";
        lJsonObjectLine: JsonObject;
    begin

        uri := 'https://login.microsoftonline.com/9b540f11-2b5c-4c74-bb40-a4d22950e763/oauth2/v2.0/token';
        //RequestURI := 'https://httpcats.com/418.json';

        content.WriteFrom('grant_type=client_credentials&client_id=49867617-f917-4774-b0d1-c404c9fb8cc3&client_secret=UlO8Q~3suj98sBMh.~4PQSwIPkyw6EmG9kbFCa2E&scope=https://api.businesscentral.dynamics.com/.default');

        // Replace the default content type header with a header associated with this request
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in 
        // the content associated with the request message
        request.Content := content;

        request.SetRequestUri(uri);
        request.Method := 'POST';

        IsSuccessful := client.Send(request, response);

        if not IsSuccessful then begin
            // handle the error
        end;

        if not response.IsSuccessStatusCode() then begin
            // handle the error
        end;

        // Read the response content as json.
        response.Content.ReadAs(responseText);
        ;
        // GetJsonToken(lJsonObjectHeader, 'type').AsValue().AsText();
        JSONManagement.InitializeObject(responseText);
        JSONManagement.GetArrayPropertyValueAsStringByName('access_token', AccessToken);
        exit(AccessToken);
    end;

    ////
    /// 
    /// 
    /// 
    procedure SendDocumentToWhatsApp(reportB64: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        Base64Text: Text;
        Base64EncodedText: Text;
        ErrorMessage: Text;
        FileName: Text;
        InstanceID: Text;
        Token: Text;
        ToPhoneNumber: Text;
        FileData: InStream;
        FilePath: Text;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
        ResultCode: Integer;
        FileManagement: Codeunit "File Management";
        base64report: Text;
        caption: Text;

    begin
        // Set up variables
        InstanceID := 'instance95060';  // Your instance ID
        Token := 'y6d5yjg7fj3z7stt';       // Your token
        ToPhoneNumber := '+966536636046';// Recipient phone number
        FileName := 'Quotation 101018.pdf';
        caption := 'Dear Customer this is your quotation ';
        // Read the file and convert to Base64

        Base64EncodedText := reportB64;
        // Base64Text := FileManagement.Base64EncodeInStream(FileData);
        //Base64EncodedText := Uri.EncodeDataString(Base64Text); // URL-encode the base64 string
        // Prepare the request
        HttpContent.WriteFrom('token=' + Token + '&to=' + ToPhoneNumber + '&document=' + Base64EncodedText + '&filename=' + FileName + '&caption=' + caption);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Create the HTTP request
        HttpRequestMessage.SetRequestUri('https://api.ultramsg.com/' + InstanceID + '/messages/document');
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content := HttpContent;

        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            ResultCode := HttpResponseMessage.HttpStatusCode;

            if ResultCode = 200 then
                Message('Document sent successfully: %1', ResponseText)
            else
                Error('Failed to send document. Status Code: %1. Response: %2', ResultCode, ResponseText);
        end else begin
            HttpResponseMessage.Content.ReadAs(ErrorMessage);
            Error('Request failed: %1', ErrorMessage);
        end;
    end;
    /// 
    /// 
    /// 
    /// 
    var
        myInt: Integer;

}

/*
               ApplicationArea = All;
               Caption = 'create Paymnet Journal';
               trigger OnAction()
               var
                   PayJournal: Record "Gen. Journal Line";
                   NoSeri: Codeunit "No. Series";
               begin

                   PayJournal.Init();
                   PayJournal."Posting Date" := Today;
                   PayJournal."Line No." := 10000;
                   PayJournal.Validate("Posting Date");
                   PayJournal."Journal Template Name" := 'PAYMENT';
                   PayJournal."Source Code" := 'PAYMENTJNL';
                   PayJournal."Journal Batch Name" := 'Test';
                   PayJournal.Validate("Journal Batch Name");
                   PayJournal."Document No." := NoSeri.GetNextNo('GJNL-PMT');
                   PayJournal."Document Type" := Enum::"Gen. Journal Document Type"::Payment;
                   PayJournal."Account Type" := Enum::"Gen. Journal Account Type"::"Bank Account";
                   PayJournal."Account No." := 'RB10001';
                   PayJournal.Validate("Account No.");

                   PayJournal.Description := '101018' + 'سداد امر بيع ';

                   PayJournal.Amount := 40000.92;
                   PayJournal.Validate(Amount);

                   PayJournal."Bal. Account Type" := Enum::"Gen. Journal Account Type"::Customer;
                   PayJournal."Bal. Account No." := 'C00020';
                   PayJournal.Validate("Bal. Account No.");

                   PayJournal."Payment Method Code" := 'BANK';
                   PayJournal.Validate("Payment Method Code");
                   PayJournal.Insert();

                   Message('Doen');




               end;

               */


