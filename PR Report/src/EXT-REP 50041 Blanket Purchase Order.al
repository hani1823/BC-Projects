reportextension 50041 "EXT Blanket Purchase Order" extends "Blanket Purchase Order"
{
    dataset
    {
        add("Purchase Header")
        {
            column(ApproverStatus_1; ApproverStatus[1]) { }
            column(ApproverStatus_2; ApproverStatus[2]) { }
            column(ApproverStatus_3; ApproverStatus[3]) { }
            column(ApproverStatus_4; ApproverStatus[4]) { }
            column(ApproverStatus_5; ApproverStatus[5]) { }
            column(ApproverStatus_6; ApproverStatus[6]) { }
            column(Posting_Date; "Posting Date") { }
            column(Assigned_User_ID; Assigned_User_ID) { }
            column(CustomerNote; NoteManagement.GetNotesForRecordRef(MyRecordRef))
            {

            }
            column(Shortcut_Dimension_1_Code; Shortcut_Dimension_1) { }
            column(Shortcut_Dimension_2_Code; Shortcut_Dimension_2) { }


        }

        add(RoundLoop)
        {
            column(HotelDim; DimValue[1]) { }
            column(EmployeeDim; DimValue[2]) { }
            column(DepartementDim; DimValue[3]) { }

        }
        modify(RoundLoop)
        {
            trigger OnAfterAfterGetRecord()
            var
                DimenValue: Record "Dimension Value";
                dim_entry: Record "Dimension Set Entry";

            begin


                if CompanyName = 'ALINMA FOR HOTELING' then begin

                    //*** hotels***\\
                    dim_entry.SetRange("Dimension Set ID", "Purchase Line"."Dimension Set ID");
                    dim_entry.SetRange("Dimension Code", 'HOTELS');
                    if dim_entry.FindSet() then begin
                        DimenValue.SetRange("Dimension Code", 'HOTELS');
                        DimenValue.SetRange(Code, dim_entry."Dimension Value Code");
                        if DimenValue.FindSet() then DimValue[1] := DimenValue.Name;
                    end;
                end else
                    //*** Construction***\\
                    if CompanyName = 'ALINMA FOR CONSTRUCTION' then begin
                        dim_entry.Reset();
                        DimenValue.Reset();

                    end;
                ;

                //*** Employee***\\
                dim_entry.Reset();
                DimenValue.Reset();
                dim_entry.SetRange("Dimension Set ID", "Purchase Line"."Dimension Set ID");
                dim_entry.SetRange("Dimension Code", 'EMPLOYEE');
                if dim_entry.FindSet() then begin

                    DimenValue.SetRange("Dimension Code", 'EMPLOYEE');
                    DimenValue.SetRange(Code, dim_entry."Dimension Value Code");
                    if DimenValue.FindSet() then DimValue[2] := DimenValue.Name;
                end;


                //*** Departement***\\
                dim_entry.Reset();
                DimenValue.Reset();
                dim_entry.SetRange("Dimension Set ID", "Purchase Line"."Dimension Set ID");
                dim_entry.SetRange("Dimension Code", 'DEP.');
                if dim_entry.FindSet() then begin

                    DimenValue.SetRange("Dimension Code", 'DEP.');
                    DimenValue.SetRange(Code, dim_entry."Dimension Value Code");
                    if DimenValue.FindSet() then DimValue[3] := DimenValue.Name;
                end;

            end;

        }
        modify("Purchase Header")
        {

            trigger OnAfterAfterGetRecord()
            var
                AppEntry: Record "Approval Entry";
                users: Record User;
                dimValue: Record "Dimension Value";
            begin

                MyRecordRef.GetTable("Purchase Header");

                users.SetRange("User Name", "Assigned User ID");

                if users.FindSet() then begin
                    Assigned_User_ID := users."Full Name";

                end;

                if CompanyName = 'ALINMA FOR HOTELING' then begin

                    ////******* 1st app *******\\\
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'AABDELGHANY');
                    AppEntry.SetFilter(Status, 'Approved');
                    //AppEntry.SetAscending("Last Date-Time Modified", false);
                    if AppEntry.FindSet() then begin
                        ApproverStatus[1] := Format(AppEntry.Status);
                    end;

                    ////******* 2nd app *******\\\
                    AppEntry.Reset();
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'ABED KHAWAJA');
                    AppEntry.SetFilter(Status, 'Approved');
                    // AppEntry.SetAscending("Last Date-Time Modified", false);
                    if AppEntry.FindSet() then begin
                        ApproverStatus[2] := Format(AppEntry.Status);
                    end;


                    ////******* 3rd app *******\\\
                    AppEntry.Reset();
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'MALSUBAIHI');
                    AppEntry.SetFilter(Status, 'Approved');
                    //  AppEntry.SetAscending("Last Date-Time Modified", false);
                    if AppEntry.FindSet() then begin
                        ApproverStatus[3] := Format(AppEntry.Status);
                    end;


                    ////******* 4th app *******\\\
                    AppEntry.Reset();
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'AKD');
                    AppEntry.SetFilter(Status, 'Approved');
                    if AppEntry.FindSet() then begin
                        ApproverStatus[4] := Format(AppEntry.Status);
                    end;

                    ////******* 5th app *******\\\
                    AppEntry.Reset();
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'MMG');
                    AppEntry.SetFilter(Status, 'Approved');
                    if AppEntry.FindSet() then begin
                        ApproverStatus[5] := Format(AppEntry.Status);
                    end;


                    ////******* 6th app *******\\\
                    AppEntry.Reset();
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'AF');
                    AppEntry.SetFilter(Status, 'Approved');
                    if AppEntry.FindSet() then begin
                        ApproverStatus[6] := Format(AppEntry.Status);
                    end;


                end else
                    if CompanyName = 'ALINMA FOR CONSTRUCTION' then begin
                        ////******* 1st app *******\\\
                        AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                        AppEntry.SetRange("Document No.", "No.");
                        AppEntry.SetRange("Approver ID", 'AABDELGHANY');
                        AppEntry.SetFilter(Status, 'Approved');

                        if AppEntry.FindSet() then begin
                            ApproverStatus[1] := Format(AppEntry.Status);
                        end;

                        ////******* 2nd app *******\\\
                        AppEntry.Reset();
                        AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                        AppEntry.SetRange("Document No.", "No.");
                        AppEntry.SetRange("Approver ID", 'NABILSABRA77');
                        AppEntry.SetFilter(Status, 'Approved');
                        if AppEntry.FindSet() then begin
                            ApproverStatus[2] := Format(AppEntry.Status);
                        end;


                        /////////********** dimensions
                        dimValue.Reset();
                        dimValue.SetRange("Dimension Code", 'PROJECTS');
                        dimValue.SetRange(Code, "Shortcut Dimension 2 Code");
                        if dimValue.FindSet() then Shortcut_Dimension_2 := dimValue.Name;

                    end else
                        if CompanyName = 'Wafer Co.' then begin
                            ////******* 1st app *******\\\
                            AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                            AppEntry.SetRange("Document No.", "No.");
                            AppEntry.SetRange("Approver ID", 'AABDELGHANY');
                            AppEntry.SetFilter(Status, 'Approved');

                            if AppEntry.FindSet() then begin
                                ApproverStatus[1] := Format(AppEntry.Status);
                            end;

                            ////******* 2nd app *******\\\
                            AppEntry.Reset();
                            AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::"Blanket Order");
                            AppEntry.SetRange("Document No.", "No.");
                            AppEntry.SetRange("Approver ID", 'NABILSABRA77');
                            AppEntry.SetFilter(Status, 'Approved');
                            if AppEntry.FindSet() then begin
                                ApproverStatus[2] := Format(AppEntry.Status);
                            end;


                            /////////********** dimensions
                            dimValue.Reset();
                            dimValue.SetRange("Dimension Code", 'PROJECTS');
                            dimValue.SetRange(Code, "Shortcut Dimension 2 Code");
                            if dimValue.FindSet() then Shortcut_Dimension_2 := dimValue.Name;

                        end;
            end;

        }
    }




    var
        ApproverStatus: array[6] of Text[100];
        DimValue: array[4] of Text[100];
        Assigned_User_ID: Text[100];
        NoteManagement: Codeunit NoteManagement;
        MyRecordRef: RecordRef;
        Shortcut_Dimension_2: Text[50];
        Shortcut_Dimension_1: Text[50];

}