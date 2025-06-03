pageextension 50560 "EXT Sales Order" extends "Sales Order"
{


    actions
    {
        addafter("F&unctions")
        {
            action(sendQuoteWhats)
            {
                Caption = 'Send Quotation in WhatsApp';
                ApplicationArea = all;
                Image = "Invoicing-MDL-Send";
                trigger OnAction()
                var
                begin
                    sendQuotation2Cust();
                end;

            }
            action(sendRetaxInvWhats)
            {
                Caption = 'Send Retax Invoice in WhatsApp';
                ApplicationArea = all;
                Image = SendAsPDF;
                trigger OnAction()
                var
                begin
                    sendRetaxInvToCust();
                end;

            }

        }
    }

    procedure sendQuotation2Cust()
    var

        cust: Record Customer;
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


        SI_AccessToken := getToken();

        // Set Authorization header
        SI_HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + SI_AccessToken);

        SI_jsonbjet.Add('reportNO', 50106);
        SI_jsonbjet.Add('parameters', '<?xml version="1.0" standalone="yes"?><ReportParameters name="PrintQuotationReport" id="50106"><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(1),Field3=1(' + Rec."No." + '))</DataItem><DataItem name="Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="Marketer">VERSION(1) SORTING(Field50001,Field50003)</DataItem></DataItems></ReportParameters>');



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
        // Message(valueText);

        cust.SetRange("No.", Rec."Sell-to Customer No.");
        if cust.FindSet() then
            SendDocumentToWhatsApp(valueText, Rec."Sell-to Phone No.", Rec."No.");
    end;

    local procedure SendDocumentToWhatsApp(reportB64: Text; customerPhoneNo: Text; saleOrderNo: Text)
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
        ToPhoneNumber := customerPhoneNo;// Recipient phone number
        FileName := 'Sales Quotation ' + saleOrderNo + '.pdf';
        caption := 'Dear Customer this is your quotation ';
        // Read the file and convert to Base64

        Base64EncodedText := reportB64;
        // Base64EncodedText := Base64EncodedText.Replace('=', '%3D');
        // Base64EncodedText := Base64EncodedText.Replace('+', '%2B');
        // Base64EncodedText := Base64EncodedText.Replace('/', '%2F');
        // Base64EncodedText := Base64EncodedText.Replace('"', '');
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
        end;
        if ResultCode = 200 then
            Message('Document sent successfully: %1', ResponseText)
        else
            Error('Failed to send document. Status Code: %1. Response: %2', ResultCode, ResponseText);

    end;
    ////


    local procedure SendInvTaxToWhatsApp(reportB64: Text; customerPhoneNo: Text; saleOrderNo: Text)
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
        ToPhoneNumber := customerPhoneNo;// Recipient phone number
        FileName := 'Retax Invoice ' + saleOrderNo + '.pdf';
        caption := 'عزيزي العميل نرفق لكم فاتورة ضريبة التصرفات العقارية ، الرجاء سداد ';
        // Read the file and convert to Base64

        Base64EncodedText := reportB64;
        // Base64EncodedText := Base64EncodedText.Replace('=', '%3D');
        // Base64EncodedText := Base64EncodedText.Replace('+', '%2B');
        // Base64EncodedText := Base64EncodedText.Replace('/', '%2F');
        // Base64EncodedText := Base64EncodedText.Replace('"', '');
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
        end;
        if ResultCode = 200 then
            Message('Document sent successfully: %1', ResponseText)
        else
            Error('Failed to send document. Status Code: %1. Response: %2', ResultCode, ResponseText);

    end;

    procedure sendRetaxInvToCust()
    var
        Base64Convert: Codeunit "Base64 Convert";
        cust: Record Customer;
        incDoc: Record "Incoming Document Attachment";
        saleHeader: Record "Sales Header";
        InStr: InStream;
        LargeText: Text;
        TempBlob: Codeunit "Temp Blob";
    begin
        saleHeader.SetRange("No.", rec."No.");
        if saleHeader.FindSet() then begin
            incDoc.SetRange("Incoming Document Entry No.", saleHeader."Incoming Document Entry No.");
            incDoc.SetFilter(Name, '*tax*');
            if incDoc.FindSet() then begin
                incDoc.GetContent(TempBlob);
                TempBlob.CreateInStream(InStr);

                LargeText := Base64Convert.ToBase64(InStr, false);
                LargeText := LargeText.Replace('=', '%3D');
                LargeText := LargeText.Replace('+', '%2B');
                LargeText := LargeText.Replace('/', '%2F');

                cust.SetRange("No.", Rec."Sell-to Customer No.");
                if cust.FindSet() then
                    SendInvTaxToWhatsApp(LargeText, Rec."Sell-to Phone No.", Rec."No.");

            end;
        end;
    end;

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

        content.WriteFrom('grant_type=client_credentials&client_id=bc5388d5-324e-4cae-8e02-49ffeaa5419f&client_secret=sTH8Q~S5XCp3v7r4LSIO6e~-13OfATf2Xme56bNw&scope=https://api.businesscentral.dynamics.com/.default');

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
}