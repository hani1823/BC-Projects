codeunit 50051 Base64ConvertTwo
{
    procedure TextToBase64String(Value: Text) ReturnValue: Text;
    var
        BinaryValue: text;
        Length: Integer;
    begin
        // Divide value into blocks of 3 bytes
        Length := StrLen(Value);
        BinaryValue := TextToBinary(Value, 8);
        ReturnValue := ConvertBinaryValueToBase64String(BinaryValue, Length);
    end;

    procedure StreamToBase64String(Value: InStream) ReturnValue: Text;
    var
        SingleByte: Byte;
        Length: Integer;
        BinaryValue: Text;
    begin
        while not Value.EOS do begin
            Value.Read(SingleByte, 1);
            Length += 1;
            BinaryValue += ByteToBinary(SingleByte, 8);
        end;

        ReturnValue := ConvertBinaryValueToBase64String(BinaryValue, Length);
    end;

    procedure FromBase64StringToText(Value: Text) ReturnValue: Text;
    var
        BinaryValue: Text;
    begin
        BinaryValue := ConvertBase64StringToBinaryValue(Value);
        ReturnValue := BinaryToText(BinaryValue);
    end;

    procedure FromBase64StringToStream(Value: Text; var ReturnValue: OutStream);
    var
        BinaryValue: Text;
    begin
        BinaryValue := ConvertBase64StringToBinaryValue(Value);
        BinaryToStream(BinaryValue, ReturnValue);
    end;

    procedure ConvertBinaryValueToBase64String(Value: Text; Length: Integer) ReturnValue: Text;
    var
        Length2: Integer;
        PaddingCount: Integer;
        BlockCount: Integer;
        Pos: Integer;
        CurrentByte: text;
        i: Integer;
    begin
        if Length MOD 3 = 0 then begin
            PaddingCount := 0;
            BlockCount := Length / 3;
        end else begin
            PaddingCount := 3 - (Length MOD 3);
            BlockCount := (Length + PaddingCount) / 3;
        end;

        Length2 := Length + PaddingCount;
        Value := PadStr(Value, Length2 * 8, '0');

        // Loop through bytes in groups of 6 bits
        Pos := 1;
        while Pos < Length2 * 8 do begin
            CurrentByte := CopyStr(Value, Pos, 6);
            ReturnValue += GetBase64Char(BinaryToInt(CurrentByte));
            pos += 6;
        end;

        // Replace last characters with '='
        for i := 1 to PaddingCount do begin
            Pos := StrLen(ReturnValue) - i + 1;
            ReturnValue[Pos] := '=';
        end;

    end;


    procedure ConvertBinaryValueToBase64String2(Value: Text) ReturnValue: Text;
    var
        Length: Integer;
        Length2: Integer;
        PaddingCount: Integer;
        PaddingText: Text;
        BlockCount: Integer;
        Pos: Integer;
        CurrentByte: text;
        i: Integer;
    begin
        Length := StrLen(Value);

        if Length MOD 6 = 0 then begin
            PaddingCount := 0;
            BlockCount := Length / 6;
        end else begin
            PaddingCount := 6 - (Length MOD 6);
            BlockCount := (Length + PaddingCount) / 6;
        end;

        Length2 := Length + PaddingCount;
        Value := PadStr(Value, Length2, '0');

        // Loop through bytes in groups of 6 bits
        Pos := 1;

        while Pos < Length2 do begin
            CurrentByte := CopyStr(Value, Pos, 6);
            ReturnValue += GetBase64Char(BinaryToInt(CurrentByte));
            pos += 6;
        end;

        // Replace last characters with '='
        // Replace last characters with '='
        if PaddingCount = 4 then begin
            PaddingText := '==';
        end else
            if PaddingCount = 2 then begin
                PaddingText := '=';
            end;
        ReturnValue := ReturnValue + PaddingText;

    end;


    procedure ConvertBase64StringToBinaryValue(Value: Text) ReturnValue: Text;
    var
        BinaryValue: Text;
        i: Integer;
        IntValue: Integer;
        PaddingCount: Integer;
    begin
        for i := 1 to StrLen(Value) do begin
            if Value[i] = '=' then
                PaddingCount += 1;

            IntValue := GetBase64Number(Value[i]);
            BinaryValue += IncreaseStringLength(IntToBinary(IntValue), 6);
        end;

        for i := 1 to PaddingCount do
            BinaryValue := CopyStr(BinaryValue, 1, StrLen(BinaryValue) - 8);

        ReturnValue := BinaryValue;
    end;

    procedure ConvertBase16StringToBinaryValue(Value: Text) ReturnValue: Text;
    var
        BinaryValue: Text;
        i: Integer;
        IntValue: Integer;
        PaddingCount: Integer;
    begin
        for i := 1 to StrLen(Value) do begin
            if Value[i] = '=' then
                PaddingCount += 1;

            IntValue := GetBase16Number(Value[i]);
            BinaryValue += IncreaseStringLength(IntToBinary(IntValue), 4);
        end;

        for i := 1 to PaddingCount do
            BinaryValue := CopyStr(BinaryValue, 1, StrLen(BinaryValue) - 8);

        ReturnValue := BinaryValue;
    end;

    local procedure TextToBinary(Value: text; ByteLength: Integer) ReturnValue: text;
    var
        IntValue: Integer;
        i: Integer;
        BinaryValue: text;
    begin
        for i := 1 to StrLen(value) do begin
            IntValue := value[i];
            BinaryValue := IntToBinary(IntValue);
            BinaryValue := IncreaseStringLength(BinaryValue, ByteLength);
            ReturnValue += BinaryValue;
        end;
    end;

    local procedure BinaryToText(Value: Text) ReturnValue: Text;
    var
        Buffer: BigText;
        Pos: Integer;
        SingleByte: Text;
        CharValue: Text;
    begin
        Buffer.AddText(Value);

        Pos := 1;
        while Pos < Buffer.Length do begin
            Buffer.GetSubText(SingleByte, Pos, 8);
            CharValue[1] := BinaryToInt(SingleByte);
            ReturnValue += CharValue;
            Pos += 8;
        end;
    end;

    local procedure BinaryToStream(Value: Text; var ReturnValue: OutStream);
    var
        Buffer: BigText;
        Pos: Integer;
        SingleByte: Text;
        ByteValue: Byte;
    begin
        Buffer.AddText(Value);

        Pos := 1;
        while Pos < Buffer.Length do begin
            Buffer.GetSubText(SingleByte, Pos, 8);
            ByteValue := BinaryToInt(SingleByte);
            ReturnValue.Write(ByteValue, 1);
            Pos += 8;
        end;
    end;

    local procedure ByteToBinary(Value: Byte; ByteLenght: Integer) ReturnValue: Text;
    var
        BinaryValue: Text;
    begin
        BinaryValue := IntToBinary(Value);
        BinaryValue := IncreaseStringLength(BinaryValue, ByteLenght);
        ReturnValue := BinaryValue;
    end;

    procedure IntToBinary(Value: integer) ReturnValue: text;
    begin
        while Value >= 1 do begin
            ReturnValue := Format(Value MOD 2) + ReturnValue;
            Value := Value DIV 2;
        end;
    end;

    local procedure BinaryToInt(Value: Text) ReturnValue: Integer;
    var
        Multiplier: BigInteger;
        IntValue: Integer;
        i: Integer;
    begin
        Multiplier := 1;
        for i := StrLen(Value) downto 1 do begin
            Evaluate(IntValue, CopyStr(Value, i, 1));
            ReturnValue += IntValue * Multiplier;
            Multiplier *= 2;
        end;
    end;

    local procedure IncreaseStringLength(Value: Text; ToLength: Integer) ReturnValue: Text;
    var
        ExtraLength: Integer;
        ExtraText: Text;
    begin
        ExtraLength := ToLength - StrLen(Value);

        if ExtraLength < 0 then
            exit;

        ExtraText := PadStr(ExtraText, ExtraLength, '0');
        ReturnValue := ExtraText + Value;
    end;

    local procedure GetBase64Char(Value: Integer): text;
    var
        chars: text;
        i: Integer;
    begin
        chars := Base64Chars;
        exit(chars[Value + 1]);
    end;

    procedure GetBase16Char(Value: Integer): text;
    var
        chars: text;
        i: Integer;
    begin
        chars := Base16Chars;
        exit(chars[Value + 1]);
    end;

    procedure GetBase64Number(Value: text): Integer;
    var
        chars: text;
    begin
        if Value = '=' then
            exit(0);

        chars := Base64Chars;
        exit(StrPos(chars, Value) - 1);
    end;

    procedure GetBase16Number(Value: text): Integer;
    var
        chars: text;
    begin
        if Value = '=' then
            exit(0);

        chars := Base16Chars;
        exit(StrPos(chars, Value) - 1);
    end;

    local procedure Base64Chars(): text;
    begin
        exit('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/');
    end;

    local procedure Base16Chars(): text;
    begin
        exit('0123456789ABCDEF');
    end;

    procedure ConvertBase16(theInput: Text) theOutput: Text;
    var
        aInt: Integer;
        aRight: Integer;
        aIndex: Integer;
        aLeft: Integer;
    begin
        FOR aIndex := 1 TO STRLEN(theInput) DO BEGIN
            aInt := theInput[aIndex];
            aLeft := ROUND(aInt / 16, 1, '<');
            aRight := aInt MOD 16;
            theOutput += HexValue(aLeft) + HexValue(aRight);
        END;
    end;




    local procedure HexValue(theValue: Integer): Text[1];
    begin
        CASE theValue OF
            0 .. 9:
                EXIT(FORMAT(theValue));
            10:
                EXIT('A');
            11:
                EXIT('B');
            12:
                EXIT('C');
            13:
                EXIT('D');
            14:
                EXIT('E');
            15:
                EXIT('F');
        END;
    end;

    procedure HexToInt(hexStr: Text): Integer
    var
        len, base, decVal, i, j : Integer;
    begin
        base := 1;
        decVal := 0;
        len := strlen(hexStr);

        for i := 0 to len - 1 do begin
            j := len - i;
            if (hexStr[j] >= '0') and (hexStr[j] <= '9') then begin
                decVal += (hexStr[j] - 48) * base;
                base := base * 16;
            end else
                if (hexStr[j] >= 'A') and (hexStr[j] <= 'F') then begin
                    decVal += (hexStr[j] - 55) * base;
                    base := base * 16;
                end;
        end;

        exit(decVal);
    end;

    procedure Int2Hex(num: Integer): Text
    begin
        if num < 16 then
            exit('0' + TypeHelper.IntToHex(num))
        else
            exit(TypeHelper.IntToHex(num));
    end;


    var
        TypeHelper: Codeunit "Type Helper";

}