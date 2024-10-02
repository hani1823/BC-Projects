page 50131 "Marketer Page"
{
    Caption = 'Marketers';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = Marketer;

    layout
    {
        area(Content)
        {
            repeater("Marketers List")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    // This lines generate a lookup page of the Vendors list
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendorRec: Record Vendor;
                    begin
                        //VendorRec.SetRange("Gen. Bus. Posting Group", 'Agents');
                        if PAGE.RunModal(PAGE::"Vendor List", VendorRec) = ACTION::LookupOK then begin
                            Rec."No." := VendorRec."No.";
                            Rec.Name := VendorRec.Name;
                            ResetValues();
                            UpdateOutsideMarketer(VendorRec);
                            IsMarketerDomestic();
                            setCommission();
                            CurrPage.Update();
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
                field(percentage; Rec.percentage)
                {
                    ApplicationArea = all;

                    //Check section for the sum of all percentage to be between 0 and 1 
                    trigger OnValidate()
                    var
                        TotalPercentage: Decimal;
                        MarketerRec: Record Marketer;
                        salesLineRec: Record "Sales Line";
                        TotalCommissionWithoutVAT: Decimal;
                    begin
                        MarketerRec.SetRange("Document No.", Rec."Document No.");
                        if MarketerRec.FindSet() then begin
                            repeat
                                if MarketerRec."No." <> Rec."No." then
                                    TotalPercentage += MarketerRec.percentage;
                            until MarketerRec.Next() = 0;
                        end;
                        TotalPercentage += Rec.percentage;

                        if TotalPercentage > 1 then
                            Error('The sum of all records percentage must be 1 or less. Your current sum = %1', TotalPercentage);

                        if TotalPercentage < 0 then
                            Error('The sum of all records percentage must be 0 or more. Your current sum = %1', TotalPercentage);

                        SalesLineRec.SetRange("Document No.", Rec."Document No.");
                        SalesLineRec.SetFilter("Total Commission Without VAT", '>0');
                        if SalesLineRec.FindFirst() then
                            TotalCommissionWithoutVAT := SalesLineRec."Total Commission Without VAT";

                        Rec.Commission := TotalCommissionWithoutVAT * Rec.Percentage;
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }
                field(Commission; Rec.Commission)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(IsManual; Rec.IsManual)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Indicates if the commission is manually entered.';
                }
            }
        }
    }

    procedure setCommission()
    var
        salesLineRec: Record "Sales Line";
        SalesRec: Record "Sales Header";
        Marketer: Record Marketer;
        TotalCommissionWithoutVAT: Decimal;
        MarketerRec: Record Marketer;
        VendorRec: Record Vendor;
        Counter: Integer;
    begin
        if Rec.IsManual then
            exit;

        SalesRec.SetRange("No.", Rec."Document No.");
        if not SalesRec.FindFirst() then
            exit;

        salesLineRec.SetRange("Document No.", Rec."Document No.");
        salesLineRec.SetFilter("Total Commission Without VAT", '>0');
        if not salesLineRec.FindFirst() then
            exit;

        TotalCommissionWithoutVAT := salesLineRec."Total Commission Without VAT";

        MarketerRec.SetRange("Document No.", Rec."Document No.");
        if MarketerRec.FindSet() then begin
            repeat
                if VendorRec.Get(MarketerRec."No.") then begin
                    UpdateOutsideMarketer(VendorRec);
                end;
            until MarketerRec.Next() = 0;
        end;

        if MarketerRec.FindSet() then begin
            repeat
                if VendorRec.Get(MarketerRec."No.") then begin
                    if VendorRec."Gen. Bus. Posting Group" = 'DOMESTIC' then begin
                        OutsideMarketer := VendorRec."No.";
                        break;
                    end;
                end;
            until MarketerRec.Next() = 0;
        end;

        Counter := 0;
        MarketerRec.SetRange("Document No.", Rec."Document No.");
        if MarketerRec.FindSet() then begin
            repeat
                if VendorRec.Get(MarketerRec."No.") then begin
                    if VendorRec."Gen. Bus. Posting Group" = 'AGENTS' then begin
                        if (MarketerRec."No." <> 'RV10099') and
                        (MarketerRec."No." <> 'RV10079') and
                        (MarketerRec."No." <> 'RV10061') and
                        (MarketerRec."No." <> OutsideMarketer) then begin
                            Counter += 1;
                        end;
                    end;
                end;
            until MarketerRec.Next() = 0;
        end;

        if SalesRec."Sale Source" = SaleSourceEnum::"المالك" then begin
            if IsOutside = true then begin
                ResetValues();
                SonsComm := 0.2350; // Set only if not manually changed
                OutsideMarketerComm := 0.50;
                SupervisorComm := 0.005;
                SuleimanComm := 0.01;

                // Marketer 1 (Sons)
                InsertMarketer('RV10099', SonsComm, TotalCommissionWithoutVAT);

                // Marketer 2 (Outside Marketer)
                InsertMarketer(OutsideMarketer, OutsideMarketerComm, TotalCommissionWithoutVAT);

                // Marketer 3 (Supervisor)
                InsertMarketer('RV10079', SupervisorComm, TotalCommissionWithoutVAT);

                // Marketer 4 (Suleiman)
                InsertMarketer('RV10061', SuleimanComm, TotalCommissionWithoutVAT);

            end
            else begin
                ResetValues();
                SonsComm := 0.55;
                SupervisorComm := 0.005;
                SuleimanComm := 0.01;

                // Marketer 1 (Sons)
                InsertMarketer('RV10099', SonsComm, TotalCommissionWithoutVAT);

                // Marketer 2 (Supervisor)
                InsertMarketer('RV10079', SupervisorComm, TotalCommissionWithoutVAT);

                // Marketer 3 (Suleiman)
                InsertMarketer('RV10061', SuleimanComm, TotalCommissionWithoutVAT);
            end;


        end else if SalesRec."Sale Source" = SaleSourceEnum::"مكتب المبيعات" then begin
            if IsOutside = true then begin
                ResetValues();
                // Marketer 1 (Sons)
                InsertMarketer('RV10099', 0.2250, TotalCommissionWithoutVAT);

                // Marketer 2 (Outside Marketer)
                InsertMarketer(OutsideMarketer, 0.26, TotalCommissionWithoutVAT);

                // Marketer 3 (Supervisor)
                InsertMarketer('RV10079', 0.005, TotalCommissionWithoutVAT);

                // Marketer 4 (Suleiman)
                InsertMarketer('RV10061', 0.01, TotalCommissionWithoutVAT);

                // Marketer 5 (Sales Office)
                MarketerRec.SetRange("Document No.", Rec."Document No.");
                if MarketerRec.FindSet() then begin
                    repeat
                        if VendorRec.Get(MarketerRec."No.") then begin
                            if VendorRec."Gen. Bus. Posting Group" = 'AGENTS' then begin
                                if (MarketerRec."No." <> 'RV10099') and
                                   (MarketerRec."No." <> 'RV10079') and
                                   (MarketerRec."No." <> 'RV10061') and
                                   (MarketerRec."No." <> OutsideMarketer) then begin
                                    InsertMarketer(MarketerRec."No.", (0.25 / Counter), TotalCommissionWithoutVAT);
                                end;
                            end;
                        end;
                    until MarketerRec.Next() = 0;
                end;

            end else begin
                ResetValues();
                // Marketer 1 (Sons)
                InsertMarketer('RV10099', 0.29, TotalCommissionWithoutVAT);

                // Marketer 2 (Supervisor)
                InsertMarketer('RV10079', 0.005, TotalCommissionWithoutVAT);

                // Marketer 3 (Suleiman)
                InsertMarketer('RV10061', 0.01, TotalCommissionWithoutVAT);

                // Marketer 4 (Sales Office)
                MarketerRec.SetRange("Document No.", Rec."Document No.");
                if MarketerRec.FindSet() then begin
                    repeat
                        if VendorRec.Get(MarketerRec."No.") then begin
                            if VendorRec."Gen. Bus. Posting Group" = 'AGENTS' then begin
                                if (MarketerRec."No." <> 'RV10099') and
                                    (MarketerRec."No." <> 'RV10079') and
                                    (MarketerRec."No." <> 'RV10061') and
                                    (MarketerRec."No." <> OutsideMarketer) then begin
                                    InsertMarketer(MarketerRec."No.", (0.35 / Counter), TotalCommissionWithoutVAT);
                                end;
                            end;
                        end;
                    until MarketerRec.Next() = 0;
                end;
            end;
        end;
    end;

    local procedure InsertMarketer(MarketerNo: Code[20]; Percentage: Decimal; TotalCommission: Decimal)
    var
        Marketer: Record Marketer;
        Vendor: Record Vendor;
    begin
        Marketer.SetRange("Document No.", Rec."Document No.");
        Marketer.SetRange("No.", MarketerNo);

        if not Vendor.Get(MarketerNo) then
            exit;

        if Marketer.FindFirst() then begin
            Marketer.Percentage := Percentage;
            Marketer.Commission := TotalCommission * Percentage;
            Marketer.Modify();
        end else begin
            Marketer.Init();
            Marketer."Document No." := Rec."Document No.";
            Marketer."No." := MarketerNo;
            Marketer.Percentage := Percentage;
            Marketer.Commission := TotalCommission * Percentage;
            Marketer.Name := Vendor.Name;
            Marketer.Insert();
        end;
    end;

    procedure IsMarketerDomestic()
    var
        MarketerRec: Record Marketer;
        VendorRec: Record Vendor;
    begin
        MarketerRec.SetRange("Document No.", Rec."Document No.");
        IsOutside := false;

        if MarketerRec.FindSet() then begin
            repeat
                if VendorRec.Get(MarketerRec."No.") then begin
                    if VendorRec."Gen. Bus. Posting Group" = 'DOMESTIC' then begin
                        IsOutside := true;
                        break;
                    end;
                end;
            until MarketerRec.Next() = 0;
        end;
    end;

    local procedure UpdateOutsideMarketer(VendorRec: Record Vendor)
    begin
        if VendorRec."Gen. Bus. Posting Group" = 'DOMESTIC' then begin
            OutsideMarketer := VendorRec."No.";
        end;
    end;

    procedure SetSalesHeader(SalesHeader: Record "Sales Header")
    begin
        SalesRec := SalesHeader;
    end;

    trigger OnAfterGetCurrRecord()
    Begin
        IsMarketerDomestic();
    End;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document No." := SalesRec."No.";
        Rec.IsManual := false;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.IsManual then
            exit;
        IsMarketerDomestic();
        setCommission();
        Rec.IsManual := false;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        MarketerRec: Record Marketer;
    begin
        if MarketerRec.Get(Rec."No.", Rec."Document No.") then begin
            if Rec."No." = OutsideMarketer then begin
                IsOutside := false;
                setCommission();
            end;
        End;
    end;

    procedure ResetValues()
    var
        MarketerRec: Record Marketer;
    begin
        MarketerRec.SetRange("Document No.", Rec."Document No.");
        if MarketerRec.FindSet() then begin
            repeat
                MarketerRec.Percentage := 0.0;
                MarketerRec.Commission := 0.0;
                MarketerRec.Modify();
            until MarketerRec.Next() = 0;
        end;
    end;

    var
        SalesRec: Record "Sales Header";
        IsOutside: Boolean;
        OutsideMarketer: Code[20];
        SonsComm: Decimal;
        OutsideMarketerComm: Decimal;
        SupervisorComm: Decimal;
        SuleimanComm: Decimal;
}