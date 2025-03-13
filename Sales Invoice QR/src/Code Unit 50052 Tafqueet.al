codeunit 50052 "Tafqueet2"
{
    procedure Tafqueet(amount: Decimal) ReturnText: Text;
    var
        decimalpart: Decimal;
        TMB: Decimal;
        BigThan1000: Text;
    begin

        decimalpart := (amount * 100) mod 100;

        if decimalpart = 0 then begin
            BigThan1000 := Thounsands(amount div 1000);
            ReturnText := BigThan1000 + under1000(amount) + ' ريال';//+ ' و' + under1000(decimalpart) + ' هللة';

        end else begin
            TMB := amount div 1000;
            BigThan1000 := Thounsands(TMB);
            ReturnText := BigThan1000 + under1000(amount) + ' ريال' + ' و' + under1000(decimalpart) + ' هللة';
        end;

    end;


    local procedure under1000(amount: Decimal) ReturnText: Text;
    var
        hundred: integer;
        hundred_Text: text;
        hundred_waw: text;

        tens: Integer;
        tens_Text: text;
        tens_waw: text;

        ones: integer;
        ones_Text: text;

        waw: Text;

    begin

        hundred_Text := '';
        hundred_waw := '';


        tens_Text := '';
        tens_waw := '';


        ones_Text := '';



        amount := Round(amount, 1, '<');
        if ((amount div 1000) <> 0) and ((amount mod 1000) <> 0) then
            waw := ' و';

        amount := amount mod 1000;

        ones := amount MOD 10;
        tens := amount MOD 100 - ones;
        hundred := amount - tens - ones;

        if (amount MOD 100 = 0) OR (amount < 100) then begin
            hundred_waw := '';
        end else
            hundred_waw := ' و ';

        if ((amount MOD 100) mod 10 = 0) OR (tens = 10) OR (amount < 10) OR (IsUnder10((amount MOD 100))) then begin
            tens_waw := '';
        end else
            tens_waw := ' و ';


        case hundred of
            100:
                hundred_Text := 'مئة';
            200:
                hundred_Text := 'مئتان';
            300:
                hundred_Text := 'ثلاث مئة';
            400:
                hundred_Text := 'أربع مئة';
            500:
                hundred_Text := 'خمس مئة';
            600:
                hundred_Text := 'ستة مئة';
            700:
                hundred_Text := 'سبع مئة';
            800:
                hundred_Text := 'ثمان مئة';
            900:
                hundred_Text := 'تسع مئة';
            0:
                hundred_Text := '';
        end;

        case tens of
            10:
                tens_Text := Tenses(amount MOD 100);
            20:
                tens_Text := 'عشرون';
            30:
                tens_Text := 'ثلاثون';
            40:
                tens_Text := 'أربعون';
            50:
                tens_Text := 'خمسون';
            60:
                tens_Text := 'ستون';
            70:
                tens_Text := 'سبعون';
            80:
                tens_Text := 'ثمانون';
            90:
                tens_Text := 'تسعون';
            0:
                tens_Text := '';
        end;




        if tens <> 10 then begin
            case ones of
                1:
                    ones_Text := 'واحد';
                2:
                    ones_Text := 'إثنان';
                3:
                    ones_Text := 'ثلاثة';
                4:
                    ones_Text := 'أربعة';
                5:
                    ones_Text := 'خمسة';
                6:
                    ones_Text := 'ستة';
                7:
                    ones_Text := 'سبعة';
                8:
                    ones_Text := 'ثمانية';
                9:
                    ones_Text := 'تسعة';
                0:
                    ones_Text := '';
            end;
        end;



        ReturnText := waw + hundred_Text + hundred_waw + ones_Text + tens_waw + tens_Text;
    end;

    local procedure under1000withoutWaW(amount: Decimal) ReturnText: Text;
    var
        hundred: integer;
        hundred_Text: text;
        hundred_waw: text;

        tens: Integer;
        tens_Text: text;
        tens_waw: text;

        ones: integer;
        ones_Text: text;

        waw: Text;

    begin

        hundred_Text := '';
        hundred_waw := '';


        tens_Text := '';
        tens_waw := '';


        ones_Text := '';



        amount := Round(amount, 1, '<');
        if ((amount div 1000) <> 0) and ((amount mod 1000) <> 0) then
            waw := ' و';

        amount := amount mod 1000;

        ones := amount MOD 10;
        tens := amount MOD 100 - ones;
        hundred := amount - tens - ones;

        if (amount MOD 100 = 0) OR (amount < 100) then begin
            hundred_waw := '';
        end else
            hundred_waw := ' و ';

        if ((amount MOD 100) mod 10 = 0) OR (tens = 10) OR (amount < 10) OR (IsUnder10((amount MOD 100))) then begin
            tens_waw := '';
        end else
            tens_waw := ' و ';


        case hundred of
            100:
                hundred_Text := 'مئة';
            200:
                hundred_Text := 'مئتان';
            300:
                hundred_Text := 'ثلاث مئة';
            400:
                hundred_Text := 'أربع مئة';
            500:
                hundred_Text := 'خمس مئة';
            600:
                hundred_Text := 'ستة مئة';
            700:
                hundred_Text := 'سبع مئة';
            800:
                hundred_Text := 'ثمان مئة';
            900:
                hundred_Text := 'تسع مئة';
            0:
                hundred_Text := '';
        end;

        case tens of
            10:
                tens_Text := Tenses(amount MOD 100);
            20:
                tens_Text := 'عشرون';
            30:
                tens_Text := 'ثلاثون';
            40:
                tens_Text := 'أربعون';
            50:
                tens_Text := 'خمسون';
            60:
                tens_Text := 'ستون';
            70:
                tens_Text := 'سبعون';
            80:
                tens_Text := 'ثمانون';
            90:
                tens_Text := 'تسعون';
            0:
                tens_Text := '';
        end;




        if tens <> 10 then begin
            case ones of
                1:
                    ones_Text := 'واحد';
                2:
                    ones_Text := 'إثنان';
                3:
                    ones_Text := 'ثلاثة';
                4:
                    ones_Text := 'أربعة';
                5:
                    ones_Text := 'خمسة';
                6:
                    ones_Text := 'ستة';
                7:
                    ones_Text := 'سبعة';
                8:
                    ones_Text := 'ثمانية';
                9:
                    ones_Text := 'تسعة';
                0:
                    ones_Text := '';
            end;
        end;



        ReturnText := hundred_Text + hundred_waw + ones_Text + tens_waw + tens_Text;
    end;

    local procedure Tenses(amount10: Decimal) returnedValue: Text;
    begin
        case amount10 of
            10:
                returnedValue := 'عشرة';
            11:
                returnedValue := 'إحدى عشر';
            12:
                returnedValue := 'إثنا عشر';

            13:
                returnedValue := 'ثلاثة عشر';

            14:
                returnedValue := 'أربعة عشر';

            15:
                returnedValue := 'خمسة عشر';

            16:
                returnedValue := 'ستة عشر';

            17:
                returnedValue := 'سبعة عشر';

            18:
                returnedValue := 'ثمانية عشر';
            19:
                returnedValue := 'تسعة عشر';
        end;
    end;


    local procedure Thounsands(amount: Decimal) ReturnText: Text;
    var
        millions: text;
        waw: Text;
        ones: Decimal;
        tenses: Decimal;
        hundrers: Decimal;

    begin
        if ((amount div 1000) <> 0) and ((amount mod 1000) <> 0) then
            waw := ' و';
        if amount >= 1000 then begin

            millions := millions(amount div 1000);
            amount := amount mod 1000;
        end;

        tenses := amount mod 100;
        if IsUnder10(tenses) = false then begin
            case amount of
                0:
                    ReturnText := '';
                1:
                    ReturnText := 'ألف';
                2:
                    ReturnText := 'ألفان';
                3:
                    ReturnText := 'ثلاثة آلاف';
                4:
                    ReturnText := 'أربعة آلاف';
                5:
                    ReturnText := 'خمسة آلاف';
                6:
                    ReturnText := 'ستة آلاف';
                7:
                    ReturnText := 'سبعة آلاف';
                8:
                    ReturnText := 'ثمانية آلاف';
                9:
                    ReturnText := 'تسعة آلاف';
                10:
                    ReturnText := 'عشرة آلاف';
                else
                    ReturnText := under1000(amount) + ' ألف ';

            end;
        end else begin

            if amount mod 10 = 1 then begin
                ReturnText := under1000(amount);
                ReturnText := ReturnText.Replace('واحد', 'ألف');
            end;
            if amount mod 10 = 2 then begin
                ReturnText := under1000(amount);
                ReturnText := ReturnText.Replace('إثنان', 'ألفان');
            end;

            if (amount mod 10 <> 2) AND (amount mod 10 <> 1) then begin
                ReturnText := under1000(amount) + ' آلاف ';
            end;
        end;





        ReturnText := millions + waw + ReturnText;
    end;



    local procedure millions(amount: Decimal) ReturnText: Text;
    var
        billions: text;
        waw: Text;
        tenses: Decimal;
    begin
        if ((amount div 1000) <> 0) and ((amount mod 1000) <> 0) then
            waw := ' و';
        if amount > 999 then begin

            billions := billions(amount div 1000);
            amount := amount mod 1000;
        end;
        tenses := amount mod 100;
        if IsUnder10(tenses) = false then begin
            case amount of
                0:
                    ReturnText := '';
                1:
                    ReturnText := 'مليون';
                2:
                    ReturnText := 'مليونان';
                3:
                    ReturnText := 'ثلاثة ملايين';
                4:
                    ReturnText := 'أربعة ملايين';
                5:
                    ReturnText := 'خمسة ملايين';
                6:
                    ReturnText := 'ستة ملايين';
                7:
                    ReturnText := 'سبعة ملايين';
                8:
                    ReturnText := 'ثمانية ملايين';
                9:
                    ReturnText := 'تسعة ملايين';
                10:
                    ReturnText := 'عشرة ملايين';
                else
                    ReturnText := under1000(amount) + ' مليون ';

            end;

        end else begin

            if amount mod 10 = 1 then begin
                ReturnText := under1000(amount);
                ReturnText := ReturnText.Replace('واحد', 'مليون');
            end;
            if amount mod 10 = 2 then begin
                ReturnText := under1000(amount);
                ReturnText := ReturnText.Replace('إثنان', 'مليونان');
            end;
            if (amount mod 10 <> 2) AND (amount mod 10 <> 1) then begin
                ReturnText := under1000(amount) + ' ملايين ';
            end;
        end;

        ReturnText := billions + waw + ReturnText;
    end;


    local procedure billions(amount: Decimal) ReturnText: Text;
    var
        tenses: Decimal;
    begin
        tenses := amount mod 100;
        if IsUnder10(tenses) = false then begin
            case amount of
                0:
                    ReturnText := '';
                1:
                    ReturnText := 'مليار ';
                2:
                    ReturnText := 'ملياران';
                3:
                    ReturnText := 'ثلاثة ملايير';
                4:
                    ReturnText := 'أربعة ملايير';
                5:
                    ReturnText := 'خمسة ملايير';
                6:
                    ReturnText := 'ستة ملايير';
                7:
                    ReturnText := 'سبعة ملايير';
                8:
                    ReturnText := 'ثمانية ملايير';
                9:
                    ReturnText := 'تسعة ملايير';
                10:
                    ReturnText := 'عشرة ملايير';
                else
                    ReturnText := under1000(amount) + ' مليار ';
            end;
        end else begin

            if amount mod 10 = 1 then begin
                ReturnText := under1000(amount);
                ReturnText := ReturnText.Replace('واحد', 'مليار');
            end;
            if amount mod 10 = 2 then begin
                ReturnText := under1000(amount);
                ReturnText := ReturnText.Replace('إثنان', 'ملياران');
            end;
            if (amount mod 10 <> 2) AND (amount mod 10 <> 1) then begin
                ReturnText := under1000(amount) + ' ملايير ';
            end;
        end;
    end;


    local procedure IsUnder10(number: Decimal) Result: Boolean
    var

    begin
        case number of
            1:
                Result := true;
            2:
                Result := true;
            3:
                Result := true;
            4:
                Result := true;
            5:
                Result := true;
            6:
                Result := true;
            7:
                Result := true;
            8:
                Result := true;
            9:
                Result := true;
            10:
                Result := true;
            else
                Result := false;

        end;
    end;

    var
        myInt: Integer;
}