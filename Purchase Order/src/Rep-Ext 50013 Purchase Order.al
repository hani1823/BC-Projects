reportextension 50013 "Purchase Order Ext" extends "Standard Purchase - Order"
{

    dataset
    {
        add("Purchase Line")
        {
            column(locationCode; "Location Code")
            {

            }
            column(locationCodelbl; FieldCaption("Location Code"))
            {

            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(Shortcut_Dimension_2_Code; Shortcut_Dimension_2) { }

        }

        add("Purchase Header")
        {
            column(ApproverStatus_1; ApproverStatus[1]) { }
            column(ApproverStatus_2; ApproverStatus[2]) { }
            column(ApproverStatus_3; ApproverStatus[3]) { }
        }
        modify("Purchase Header")
        {

            trigger OnAfterAfterGetRecord()
            var
                AppEntry: Record "Approval Entry";
                dimValue: Record "Dimension Value";
            begin

                if CompanyName = 'ALINMA FOR HOTELING' then begin


                    ////******* 1st app *******\\\
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'AABDELGHANY');
                    AppEntry.SetFilter(Status, 'Approved');
                    //AppEntry.SetAscending("Last Date-Time Modified", false);
                    if AppEntry.FindSet() then begin
                        ApproverStatus[1] := Format(AppEntry.Status);
                    end;

                    ////******* 2nd app *******\\\
                    AppEntry.Reset();
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'ABED KHAWAJA');
                    AppEntry.SetFilter(Status, 'Approved');
                    // AppEntry.SetAscending("Last Date-Time Modified", false);
                    if AppEntry.FindSet() then begin
                        ApproverStatus[2] := Format(AppEntry.Status);
                    end;


                    ////******* 3rd app *******\\\
                    AppEntry.Reset();
                    AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                    AppEntry.SetRange("Document No.", "No.");
                    AppEntry.SetRange("Approver ID", 'MALSUBAIHI');
                    AppEntry.SetFilter(Status, 'Approved');
                    //  AppEntry.SetAscending("Last Date-Time Modified", false);
                    if AppEntry.FindSet() then begin
                        ApproverStatus[3] := Format(AppEntry.Status);
                    end;

                end else
                    if CompanyName = 'ALINMA FOR CONSTRUCTION' then begin
                        ////******* 1st app *******\\\
                        AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                        AppEntry.SetRange("Document No.", "No.");
                        AppEntry.SetRange("Approver ID", 'NABILSABRA77');
                        AppEntry.SetFilter(Status, 'Approved');
                        //AppEntry.SetAscending("Last Date-Time Modified", false);
                        if AppEntry.FindSet() then begin
                            ApproverStatus[1] := Format(AppEntry.Status);
                        end;

                        ////******* 2nd app *******\\\
                        AppEntry.Reset();
                        AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                        AppEntry.SetRange("Document No.", "No.");
                        AppEntry.SetRange("Approver ID", 'ABED KHAWAJA');
                        AppEntry.SetFilter(Status, 'Approved');
                        // AppEntry.SetAscending("Last Date-Time Modified", false);
                        if AppEntry.FindSet() then begin
                            ApproverStatus[2] := Format(AppEntry.Status);
                        end;


                        ////******* 3rd app *******\\\
                        AppEntry.Reset();
                        AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                        AppEntry.SetRange("Document No.", "No.");
                        AppEntry.SetRange("Approver ID", 'MALSUBAIHI');
                        AppEntry.SetFilter(Status, 'Approved');
                        //  AppEntry.SetAscending("Last Date-Time Modified", false);
                        if AppEntry.FindSet() then begin
                            ApproverStatus[3] := Format(AppEntry.Status);
                        end;

                        /////////********** dimensions
                        dimValue.Reset();
                        dimValue.SetRange("Dimension Code", 'PROJECTS');
                        dimValue.SetRange(Code, "Shortcut Dimension 2 Code");
                        if dimValue.FindSet() then Shortcut_Dimension_2 := dimValue.Name;

                    end else
                        if CompanyName = 'Wafer Co.' then begin
                            ////******* 1st app *******\\\
                            AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                            AppEntry.SetRange("Document No.", "No.");
                            AppEntry.SetRange("Approver ID", 'NABILSABRA77');
                            AppEntry.SetFilter(Status, 'Approved');
                            //AppEntry.SetAscending("Last Date-Time Modified", false);
                            if AppEntry.FindSet() then begin
                                ApproverStatus[1] := Format(AppEntry.Status);
                            end;

                            ////******* 2nd app *******\\\
                            AppEntry.Reset();
                            AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                            AppEntry.SetRange("Document No.", "No.");
                            AppEntry.SetRange("Approver ID", 'ABED KHAWAJA');
                            AppEntry.SetFilter(Status, 'Approved');
                            // AppEntry.SetAscending("Last Date-Time Modified", false);
                            if AppEntry.FindSet() then begin
                                ApproverStatus[2] := Format(AppEntry.Status);
                            end;


                            ////******* 3rd app *******\\\
                            AppEntry.Reset();
                            AppEntry.SetRange("Document Type", Enum::"Approval Document Type"::Order);
                            AppEntry.SetRange("Document No.", "No.");
                            AppEntry.SetRange("Approver ID", 'MALSUBAIHI');
                            AppEntry.SetFilter(Status, 'Approved');
                            //  AppEntry.SetAscending("Last Date-Time Modified", false);
                            if AppEntry.FindSet() then begin
                                ApproverStatus[3] := Format(AppEntry.Status);
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
        ApproverStatus: array[4] of Text[100];
        Shortcut_Dimension_2: Text;
}