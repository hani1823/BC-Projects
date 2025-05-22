pageextension 50070 MyExtension extends "Hotel Card"
{


    actions
    {
        addfirst(Documents)
        {
            action(CreateSalesInv)
            {

                Caption = 'Create BC Sales Invoices ';
                ApplicationArea = all;
                trigger OnAction()
                var
                    getdate: page "Date-Time Dialog";
                    MyQuery: Query "Ezee Invoice by folio";
                    MyQueryLines: Query "Ezee Invoice by folio Lines";
                    EzeeRevenueLines: Record "eZee Revenue Line2";
                    EzeeRevenueHeader: Record "eZee Revenue Header2";
                    hotel: Record Hotel;
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    DimMgt: Codeunit DimensionManagement;
                    TempDim: Record "Dimension Set Entry" temporary;

                    counter1: integer;

                begin
                    counter1 := 0;


                    Clear(getdate);
                    hotel.Reset();
                    getdate.RunModal();
                    CurrPage.GetRecord(hotel);

                    EzeeRevenueHeader.SetRange("Hotel Code", hotel.Code);
                    //EzeeRevenueHeader.SetRange("Check Out Date", getdate.GetDate());

                    // looking for headers
                    //MyQuery.SetRange(MyQuery.Check_Out_Date, getdate.GetDate());
                    MyQuery.SetRange(MyQuery.Hotel_Code, hotel.Code);
                    MyQuery.SetFilter(MyQuery.Bill_No____Invoice_No_, '<>%1', '');
                    MyQuery.SetFilter(MyQuery.Total_Amount, '<>%1', 0);
                    if MyQuery.Open() then begin
                        while MyQuery.Read() do begin
                            counter1 := counter1 + 1;
                            // Create Sales Invoices
                            Clear(SalesHeader);
                            SalesHeader.Reset();
                            SalesHeader.Init();
                            if hotel.Code = '25364' then begin
                                SalesHeader.Validate("Sell-to Customer No.", 'HC1002');
                            end else begin
                                if hotel.Code = '29667' then SalesHeader.Validate("Sell-to Customer No.", 'HC1003');
                            end;

                            SalesHeader.Validate("Document Date", Today());
                            SalesHeader.Validate("Posting Date", getdate.GetDate());
                            SalesHeader."No." := MyQuery.Bill_No____Invoice_No_;
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                            SalesHeader."Hotel Code" := hotel.Code;
                            SalesHeader."Currency Factor" := 1;
                            SalesHeader.Insert(True);

                            // Looking for lines
                            MyQueryLines.SetRange(MyQueryLines.Hotel_Code, hotel.Code);
                            MyQueryLines.SetRange(MyQueryLines.Folio_No_, MyQuery.Folio_No_);
                            if MyQueryLines.Open() then begin
                                while MyQueryLines.Read() do begin
                                    case MyQueryLines.Charge_Name of
                                        'Room Charges':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 10000;
                                                SalesLine.Validate("No.", 'EZE-RE-10010');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '133', false, false);
                                                SalesLine.Insert(True);
                                            end;

                                        'Municipality city Tax':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 20000;
                                                SalesLine.Validate("No.", 'EZE-RE-10026');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '133', false, false);
                                                SalesLine.Insert(True);
                                            end;


                                        'Laundry':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 30000;
                                                SalesLine.Validate("No.", 'EZE-RE-10015');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '121', false, false);
                                                SalesLine.Insert(True);
                                            end;


                                        'Breakfast':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 40000;
                                                SalesLine.Validate("No.", 'EZE-RE-10017');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '118', false, false);
                                                DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '118', false, false);
                                                SalesLine.Insert(True);
                                            end;

                                        'No Show Revenue':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 50000;
                                                SalesLine.Validate("No.", 'EZE-RE-10009');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '133', false, false);
                                                SalesLine.Insert(True);
                                            end;

                                        'Use the dining hall':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 60000;
                                                SalesLine.Validate("No.", 'EZE-RE-10016');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '118', false, false);
                                                SalesLine.Insert(True);
                                            end;
                                        'Round Off':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 70000;
                                                SalesLine.Validate("No.", 'EZE-RE-10011');
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                if MyQueryLines.Amount < 0 then begin
                                                    SalesLine.Validate("Unit Price", 0);
                                                end;
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '133', false, false);
                                                SalesLine.Insert(True);
                                            end;
                                        'OTHER REVENUE':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 80000;
                                                SalesLine.Validate("No.", 'EZE-RE-10025');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '111', false, false);
                                                SalesLine.Insert(True);
                                            end;

                                        //// Lunch
                                        'Lunch':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 90000;
                                                //118
                                                SalesLine.Validate("No.", 'EZE-RE-10022');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '118', false, false);
                                                SalesLine.Insert(True);
                                            end;

                                        //// Dinner

                                        'Dinner':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 100000;
                                                SalesLine.Validate("No.", 'EZE-RE-10018');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '118', false, false);
                                                SalesLine.Insert(True);
                                            end;

                                        /////Late Checkout Charges
                                        'Late Checkout Charges':
                                            begin
                                                Clear(SalesLine);
                                                SalesLine.Reset();
                                                SalesLine.Init();
                                                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                                SalesLine."Document No." := SalesHeader."No.";
                                                SalesLine.Type := SalesLine.Type::Item;
                                                SalesLine."Line No." := 110000;
                                                SalesLine.Validate("No.", 'EZE-RE-10008');
                                                SalesLine.Validate(Quantity, 1);
                                                SalesLine.Validate("Unit Price", MyQueryLines.Amount);
                                                SalesLine."Dimension Set ID" := DimMgt.SetDimensionValue(SalesLine."Dimension Set ID", 'DEP.', '133', false, false);
                                                SalesLine.Insert(True);
                                            end;
                                    end;
                                end;
                            end;
                            //calculate header totals
                            SalesHeader.CalcFields(Amount, "Amount Including VAT");
                        end;
                    end;
                    Message(' %1 invoices has been created', counter1);
                end;
            }

            action(getEzeeData)
            {
                Caption = 'Get Ezee invoices Data';
                ApplicationArea = all;
                trigger OnAction()
                var


                    getdate: page "Date-Time Dialog";

                    lHttpClient: HttpClient;
                    lHttpHeaders: HttpHeaders;
                    lHttpContent: HttpContent;
                    lHttpRequest: HttpRequestMessage;

                    lJsonObjectHeader, lJsonObjectLine : JsonObject;
                    lJsonToken, lJsonTokenLine : JsonToken;
                    lJsonArrayHeader, lJsonArrayLine : JsonArray;
                    lResponseText: Text;
                    i, j, lArrayHeaderCount : Integer;

                    datefilter: text[20];

                //Counter2: Integer;
                //Counter3: Integer;
                begin
                    //Counter2 := 0;
                    //Counter3 := 0;
                    CurrPage.GetRecord(Hotel);
                    Clear(OutStreamRequest);
                    Clear(OutStreamResponse);
                    Clear(InStreamRequest);
                    Clear(InStreamResponse);
                    TmpBlobRequest.CreateOutStream(OutStreamRequest);
                    TmpBlobRequest.CreateInStream(InStreamRequest);
                    TmpBlobResponse.CreateOutStream(OutStreamResponse);
                    TmpBlobResponse.CreateInStream(InStreamResponse);
                    Clear(getdate);
                    getdate.RunModal();
                    datefilter := Format(Date2DMY(getdate.GetDate(), 3)) + '-' + Format(Date2DMY(getdate.GetDate(), 2)) + '-' + Format(Date2DMY(getdate.GetDate(), 1));
                    BuildApiRequestBody(datefilter, datefilter, 'XERO_GET_TRANSACTION_DATA', true);
                    lHttpContent.WriteFrom(InStreamRequest);
                    lHttpContent.GetHeaders(lHttpHeaders);
                    lHttpHeaders.Clear();
                    lHttpHeaders.Add('Content-Type', 'application/json');
                    lHttpRequest.Content := lHttpContent;
                    lHttpRequest.SetRequestUri(Hotel."Revenue API Url");
                    lHttpRequest.Method := 'POST';
                    lHttpClient.Send(lHttpRequest, HttpResponse);
                    HttpResponse.Content.ReadAs(InStreamResponse);

                    if lJsonArrayHeader.ReadFrom(InStreamResponse) then begin
                        eZeeRevenueHeader.DeleteAll();
                        eZeeRevenueLine.DeleteAll();
                        lArrayHeaderCount := lJsonArrayHeader.Count;
                        for i := 0 to lJsonArrayHeader.Count - 1 do begin
                            //Counter2 := Counter2 + 1;
                            lJsonArrayHeader.Get(i, lJsonToken);
                            lJsonObjectHeader := lJsonToken.AsObject();
                            if not eZeeRevenueHeader.Get(Hotel.Code, GetJsonToken(lJsonObjectHeader, 'record_id').AsValue().AsText()) then begin
                                //Counter3 := Counter3 + 1;

                                eZeeRevenueHeader.Reset();
                                eZeeRevenueHeader.Init();
                                eZeeRevenueHeader."Hotel Code" := Hotel.Code;
                                eZeeRevenueHeader."Record Unique Id" := GetJsonToken(lJsonObjectHeader, 'record_id').AsValue().AsText();
                                eZeeRevenueHeader."Record Date" := GetJsonToken(lJsonObjectHeader, 'record_date').AsValue().AsDate();
                                eZeeRevenueHeader."Check In Date" := GetJsonToken(lJsonObjectHeader, 'reference1').AsValue().AsDate();
                                eZeeRevenueHeader."Check Out Date" := GetJsonToken(lJsonObjectHeader, 'reference2').AsValue().AsDate();
                                eZeeRevenueHeader."Reservasion No." := GetJsonToken(lJsonObjectHeader, 'reference3').AsValue().AsText();
                                eZeeRevenueHeader."Folio No." := GetJsonToken(lJsonObjectHeader, 'reference4').AsValue().AsText();
                                eZeeRevenueHeader."Guest Name" := CopyStr(GetJsonToken(lJsonObjectHeader, 'reference5').AsValue().AsText(), 1, MaxStrLen(eZeeRevenueHeader."Guest Name"));
                                eZeeRevenueHeader."Reference 6" := GetJsonToken(lJsonObjectHeader, 'reference6').AsValue().AsText();
                                eZeeRevenueHeader.Source := GetJsonToken(lJsonObjectHeader, 'reference7').AsValue().AsText();
                                eZeeRevenueHeader."Bill No. / Invoice No." := GetJsonToken(lJsonObjectHeader, 'reference8').AsValue().AsText();
                                eZeeRevenueHeader."Bill To" := CopyStr(GetJsonToken(lJsonObjectHeader, 'reference9').AsValue().AsText(), 1, MaxStrLen(eZeeRevenueHeader."Bill To"));
                                eZeeRevenueHeader."Voucher No." := GetJsonToken(lJsonObjectHeader, 'reference10').AsValue().AsText();
                                eZeeRevenueHeader."Reference 11" := GetJsonToken(lJsonObjectHeader, 'reference11').AsValue().AsText();
                                eZeeRevenueHeader."Reference 12" := GetJsonToken(lJsonObjectHeader, 'reference12').AsValue().AsText();
                                eZeeRevenueHeader."Room No." := GetJsonToken(lJsonObjectHeader, 'reference13').AsValue().AsText();
                                eZeeRevenueHeader."Room Type" := GetJsonToken(lJsonObjectHeader, 'reference14').AsValue().AsText();
                                eZeeRevenueHeader."Rate Type" := GetJsonToken(lJsonObjectHeader, 'reference15').AsValue().AsText();
                                eZeeRevenueHeader."Market Code" := GetJsonToken(lJsonObjectHeader, 'reference16').AsValue().AsText();
                                eZeeRevenueHeader."Identity Type" := GetJsonToken(lJsonObjectHeader, 'reference17').AsValue().AsText();
                                eZeeRevenueHeader."Identity No." := GetJsonToken(lJsonObjectHeader, 'reference18').AsValue().AsText();
                                eZeeRevenueHeader."Email of Billing Contact" := GetJsonToken(lJsonObjectHeader, 'reference19').AsValue().AsText();
                                eZeeRevenueHeader."Address of Billing Contact" := CopyStr(GetJsonToken(lJsonObjectHeader, 'reference20').AsValue().AsText(), 1, MaxStrLen(eZeeRevenueHeader."Address of Billing Contact"));
                                eZeeRevenueHeader."Telephone of Billing Contact" := GetJsonToken(lJsonObjectHeader, 'reference21').AsValue().AsText();
                                eZeeRevenueHeader."Gross Amount" := GetJsonToken(lJsonObjectHeader, 'gross_amount').AsValue().AsDecimal();
                                eZeeRevenueHeader."Flat Discount" := GetJsonToken(lJsonObjectHeader, 'flat_discount').AsValue().AsDecimal();
                                eZeeRevenueHeader."Adjustment Amount" := GetJsonToken(lJsonObjectHeader, 'adjustment_amount').AsValue().AsDecimal();
                                eZeeRevenueHeader."Add Less Amount" := GetJsonToken(lJsonObjectHeader, 'add_less_amount').AsValue().AsDecimal();
                                eZeeRevenueHeader."Total Amount" := GetJsonToken(lJsonObjectHeader, 'total_amount').AsValue().AsDecimal();
                                eZeeRevenueHeader."Amount Paid" := GetJsonToken(lJsonObjectHeader, 'amount_paid').AsValue().AsDecimal();
                                eZeeRevenueHeader.Balance := GetJsonToken(lJsonObjectHeader, 'balance').AsValue().AsDecimal();
                                eZeeRevenueHeader.Insert();




                                eZeeRevenueLine.Reset();
                                eZeeRevenueLine.SetRange("Hotel Code", Hotel.Code);
                                eZeeRevenueLine.SetRange("Header Unique Id", eZeeRevenueHeader."Record Unique Id");
                                if lJsonObjectHeader.Get('detail', lJsonTokenLine) then begin
                                    lJsonArrayLine := lJsonTokenLine.AsArray();
                                    for j := 0 to lJsonArrayLine.Count - 1 do begin
                                        lJsonArrayLine.Get(j, lJsonTokenLine);
                                        lJsonObjectLine := lJsonTokenLine.AsObject();
                                        eZeeRevenueLine.Init();
                                        eZeeRevenueLine."Line No." := 0;
                                        eZeeRevenueLine."Hotel Code" := Hotel.Code;
                                        eZeeRevenueLine."Header Unique Id" := eZeeRevenueHeader."Record Unique Id";
                                        eZeeRevenueLine."Header Record Date" := eZeeRevenueHeader."Record Date";
                                        eZeeRevenueLine."Header Check In Date" := eZeeRevenueHeader."Check In Date";
                                        eZeeRevenueLine."Header Check Out Date" := eZeeRevenueHeader."Check Out Date";
                                        eZeeRevenueLine."Folio No." := eZeeRevenueHeader."Folio No.";
                                        eZeeRevenueLine."Rental Id" := GetJsonToken(lJsonObjectLine, 'detail_record_id').AsValue().AsText();
                                        eZeeRevenueLine."Rental Date" := GetJsonToken(lJsonObjectLine, 'detail_record_date').AsValue().AsDate();
                                        eZeeRevenueLine."Reference Id" := GetJsonToken(lJsonObjectLine, 'reference_id').AsValue().AsText();
                                        eZeeRevenueLine."Reference Name" := GetJsonToken(lJsonObjectLine, 'reference_name').AsValue().AsText();
                                        eZeeRevenueLine."Single Ledger Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref1_id').AsValue().AsText();
                                        eZeeRevenueLine."Single Ledger Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref1_value').AsValue().AsText();
                                        eZeeRevenueLine."Room Name Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref2_id').AsValue().AsText();
                                        eZeeRevenueLine."Room Name Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref2_value').AsValue().AsText();
                                        eZeeRevenueLine."Room Type Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref3_id').AsValue().AsText();
                                        eZeeRevenueLine."Room Type Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref3_value').AsValue().AsText();
                                        eZeeRevenueLine."Rate Type Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref4_id').AsValue().AsText();
                                        eZeeRevenueLine."Rate Type Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref4_value').AsValue().AsText();
                                        eZeeRevenueLine."Room Charge Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref5_id').AsValue().AsText();
                                        eZeeRevenueLine."Room Charge Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref5_value').AsValue().AsText();
                                        eZeeRevenueLine."Slab Tax Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref6_id').AsValue().AsText();
                                        eZeeRevenueLine."Slab Tax Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref6_value').AsValue().AsText();
                                        eZeeRevenueLine."Source Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref7_id').AsValue().AsText();

                                        eZeeRevenueLine."Source Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref7_value').AsValue().AsText();
                                        eZeeRevenueLine."Market Code Ref. Id" := GetJsonToken(lJsonObjectLine, 'sub_ref8_id').AsValue().AsText();
                                        eZeeRevenueLine."Market Code Ref. Value" := GetJsonToken(lJsonObjectLine, 'sub_ref8_value').AsValue().AsText();
                                        if not Evaluate(eZeeRevenueLine.Amount, GetJsonToken(lJsonObjectLine, 'amount').AsValue().AsText()) then
                                            eZeeRevenueLine.Amount := 0;
                                        if not Evaluate(eZeeRevenueLine."Tax Per", GetJsonToken(lJsonObjectLine, 'taxper').AsValue().AsText()) then
                                            eZeeRevenueLine."Tax Per" := 0;
                                        eZeeRevenueLine."Slab Tax Id" := GetJsonToken(lJsonObjectLine, 'slabtaxunkid').AsValue().AsText();
                                        eZeeRevenueLine."Slab Tax Name" := GetJsonToken(lJsonObjectLine, 'slabtax').AsValue().AsText();
                                        eZeeRevenueLine."Slab Range" := GetJsonToken(lJsonObjectLine, 'slab').AsValue().AsText();
                                        eZeeRevenueLine."Charge Name" := GetJsonToken(lJsonObjectLine, 'charge_name').AsValue().AsText();
                                        eZeeRevenueLine."Master Unique Id" := GetJsonToken(lJsonObjectLine, 'masterunkid').AsValue().AsText();
                                        eZeeRevenueLine."Parent Master Unique Id" := GetJsonToken(lJsonObjectLine, 'parentmasterunkid').AsValue().AsText();
                                        eZeeRevenueLine.Description := GetJsonToken(lJsonObjectLine, 'description').AsValue().AsText();
                                        eZeeRevenueLine."Tax Type" := GetJsonToken(lJsonObjectLine, 'Taxtype').AsValue().AsText();
                                        eZeeRevenueLine."POS Data" := GetJsonToken(lJsonObjectLine, 'posdata').AsValue().AsText();
                                        eZeeRevenueLine."POS Tax Name" := GetJsonToken(lJsonObjectLine, 'POSTaxName').AsValue().AsText();
                                        eZeeRevenueLine."POS Tax Percentage" := GetJsonToken(lJsonObjectLine, 'POSTaxPercent').AsValue().AsText();
                                        eZeeRevenueLine.Insert();
                                    end;
                                end;
                            end;
                        end;
                    end else begin
                        HttpResponse.Content.ReadAs(lResponseText);
                        Error('Could not read data due to following API error: ' + lResponseText);
                    end;
                    //Message(' %1 counter2, %2 counter3, %3 lJsonArrayHeader.Count ', Counter2, Counter3, lJsonArrayHeader.Count);

                end;



            }



        }
    }
    local procedure BuildApiRequestBody(pFromDate: Text; pToDate: Text; pRequestFor: Text; pWithIsCheckout: Boolean)
    var
        lJsonObjectHeader: JsonObject;
    begin
        // ValidateDate(pFromDate);
        // ValidateDate(pToDate);
        lJsonObjectHeader.Add('auth_code', Hotel."API Auth. Code");
        lJsonObjectHeader.Add('hotel_code', Hotel."API Hotel Code");
        lJsonObjectHeader.Add('fromdate', pFromDate);
        lJsonObjectHeader.Add('todate', pToDate);
        lJsonObjectHeader.Add('ischeckout', 'true');
        lJsonObjectHeader.Add('requestfor', pRequestFor);
        lJsonObjectHeader.WriteTo(OutStreamRequest);
    end;

    local procedure ValidateDate(var pDate: Date)
    begin
        if pDate = 0D then
            pDate := Today;
    end;

    local procedure GetJsonToken(pJsonObject: JsonObject; pTokenKey: Text) rJsonToken: JsonToken
    begin
        if pJsonObject.Get(pTokenKey, rJsonToken) then;
    end;

    local procedure GetJsonTokenText(pJsonObject: JsonObject; pTokenKey: Text) rTextValue: Text
    var
        lJsonToken: JsonToken;
    begin
        if not TryGetTokenAsText(GetJsonToken(pJsonObject, pTokenKey), rTextValue) then
            rTextValue := '';
    end;

    local procedure GetJsonTokenDecimal(pJsonObject: JsonObject; pTokenKey: Text) rDecimalValue: Decimal
    var
        lJsonToken: JsonToken;
    begin
        if not TryGetTokenAsDecimal(GetJsonToken(pJsonObject, pTokenKey), rDecimalValue) then
            rDecimalValue := 0;
    end;

    [TryFunction]
    local procedure TryGetTokenAsText(pJsonToken: JsonToken; var pTextValue: Text)
    begin
        pTextValue := pJsonToken.AsValue().AsText();
    end;

    [TryFunction]
    local procedure TryGetTokenAsDecimal(pJsonToken: JsonToken; var pDecimalValue: Decimal)
    begin
        pDecimalValue := pJsonToken.AsValue().AsDecimal();
    end;

    var

        eZeeRevenueHeader: Record "eZee Revenue Header2";
        eZeeRevenueLine: Record "eZee Revenue Line2";


        Hotel, HotelBuffer : Record Hotel;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";



        Date: Record Date;
        TmpBlobRequest, TmpBlobResponse : Codeunit "Temp Blob";
        eZeeRetrieveMastersMgmt: Codeunit "eZee Retrieve Masters Mgmt.";
        PaymentType: Option Inwards,Outwards,Journal;
        CustomerNo: Code[20];
        APIDateFilters: FilterPageBuilder;
        eZeeSetupOK: Boolean;
        PaymentJrnlLineNo, GenJrnlLineNo : Integer;
        NoOfRecords, ProgressBar : array[2] of integer;
        Window: Dialog;
        InStreamRequest, InStreamResponse : InStream;
        OutStreamRequest, OutStreamResponse : OutStream;
        HttpResponse: HttpResponseMessage;
}