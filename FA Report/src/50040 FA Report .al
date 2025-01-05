report 50040 "FA Report"
{
    ExcelLayout = 'src/FA Report.xlsx';
    Caption = 'FA Report Alinma';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    PreviewMode = PrintLayout;
    DataAccessIntent = ReadOnly;

    dataset
    {

        dataitem("Fixed Asset"; "Fixed Asset")
        {
            //RequestFilterHeading = 'StartDate';
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(FA_Class_Code; "FA Class Code") { }
            column(FA_Posting_Group; "FA Posting Group") { }
            column(FA_Subclass_Code; "FA Subclass Code") { }
            column(Depreciation_Book_Code; depBook[1]) { }
            column(Depreciation_Method; depMethod) { }
            column(Depreciation_Starting_Date; StartDepDate) { }
            column(NofDepreciationYears; Nyears) { }
            column(FA_Posting_Group_Dep; depBook[2]) { }

            column(FA_value; FA_value) { }
            column(FA_value_After_Dep; FA_value_After_Dep) { }
            column(Dep_Value; Dep_Value) { }
            column(old_Dep_Valvue; old_Dep_Valvue) { }


            column(BusiUnit; Dimensions[1]) { }
            column(Hotels; Dimensions[2]) { }
            column(Responsible_Employee; "Responsible Employee") { }

            /*
                        dataitem("FA Ledger Entry"; "FA Ledger Entry")
                        {
                            DataItemLink = "FA No." = field("No.");
                            column(FA_Posting_Date; "FA Posting Date") { }
                            column(FA_Posting_Type; "FA Posting Type") { }
                            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { }
                            column(Amount; Amount) { }

                        }*/
            trigger OnAfterGetRecord()
            var
                FaDepBook: Record "FA Depreciation Book";
                FA_Led_Entr: Record "FA Ledger Entry";

                DefaultDim: Record "Default Dimension";
                dimValues: Record "Dimension Value";
            begin

                EndDate := CalcDate('<CM>', EndDate);

                //******************* Depreciation Book **********\\
                FaDepBook.SetRange("FA No.", "No.");

                if FaDepBook.FindSet() then begin
                    depBook[1] := FaDepBook."Depreciation Book Code";
                    depBook[2] := FaDepBook."FA Posting Group";
                    Nyears := FaDepBook."No. of Depreciation Years";
                    StartDepDate := FaDepBook."Depreciation Starting Date";
                    depMethod := FaDepBook."Depreciation Method";
                end;


                //************* Ledger Entries ****************\\
                FA_Led_Entr.SetRange("FA No.", "No.");
                FA_Led_Entr.CalcSums(Amount);
                FA_value_After_Dep := FA_Led_Entr.Amount;


                FA_Led_Entr.Reset();
                FA_Led_Entr.SetRange("FA No.", "No.");
                FA_Led_Entr.SetRange("FA Posting Type", Enum::"FA Ledger Entry FA Posting Type"::"Acquisition Cost");
                FA_Led_Entr.CalcSums(Amount);
                FA_value := FA_Led_Entr.Amount;

                FA_Led_Entr.Reset();
                FA_Led_Entr.SetRange("FA No.", "No.");
                FA_Led_Entr.SetFilter("FA Posting Date", '>=%1', StartDate);
                FA_Led_Entr.SetRange("FA Posting Type", Enum::"FA Ledger Entry FA Posting Type"::Depreciation);
                FA_Led_Entr.CalcSums(Amount);
                Dep_Value := FA_Led_Entr.Amount;


                FA_Led_Entr.Reset();
                FA_Led_Entr.SetRange("FA No.", "No.");
                FA_Led_Entr.SetFilter("FA Posting Date", '<%1', StartDate);
                FA_Led_Entr.SetRange("FA Posting Type", Enum::"FA Ledger Entry FA Posting Type"::Depreciation);
                FA_Led_Entr.CalcSums(Amount);
                old_Dep_Valvue := FA_Led_Entr.Amount;

                /// ********* Dimensions ************\\\
                //******* Bus Unit ********\\
                DefaultDim.SetRange("No.", "No.");
                DefaultDim.SetRange("Dimension Code", 'BUS-UNIT');
                if DefaultDim.FindSet() then begin
                    dimValues.SetRange("Dimension Code", 'BUS-UNIT');
                    dimValues.SetRange("Code", DefaultDim."Dimension Value Code");
                    if dimValues.FindSet() then begin
                        Dimensions[1] := dimValues.Name;
                    end;
                end;


                DefaultDim.Reset();
                dimValues.Reset();


                //******* Hotel ********\\
                DefaultDim.SetRange("No.", "No.");
                DefaultDim.SetRange("Dimension Code", 'HOTELS');
                if DefaultDim.FindSet() then begin
                    dimValues.SetRange("Dimension Code", 'HOTELS');
                    dimValues.SetRange("Code", DefaultDim."Dimension Value Code");
                    if dimValues.FindSet() then begin
                        Dimensions[2] := dimValues.Name;
                    end;
                end;


            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Dates Setup';
                    field(StartDate; StartDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'Ending Date';
                        ApplicationArea = All;

                    }
                }
            }
        }
    }
    var
        depBook: array[2] of Text[100];
        Nyears: Decimal;
        FA_PostingDate: Date;
        aquisitisionDate: date;
        Dimensions: array[3] of Text[100];
        StartDepDate: Date;
        StartDate: Date;
        EndDate: Date;
        depMethod: Enum "FA Depreciation Method";
        FA_value: Decimal;
        old_Dep_Valvue: Decimal;
        Dep_Value: Decimal;
        FA_value_After_Dep: Decimal;

}