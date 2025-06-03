pageextension 50135 "Sales Order Ext1" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Plan Name"; Rec."Plan Name")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                ShowMandatory = true;
                Editable = Rec."Sell-to Customer Name" <> '';

                //run the NameLookup page and show the list and set the values of Plan Name and Plan Code
                trigger OnLookup(var Text: Text): Boolean
                begin
                    DimPlanRec.Reset();
                    if Page.RunModal(Page::"Plan Name Lookup", DimPlanRec) = Action::LookupOK then begin
                        Rec."Plan Name" := DimPlanRec.Name;
                        Rec."Plan Code" := DimPlanRec.Code;
                        CurrPage.Update(true);
                    end;
                end;

                /*validation of the Plan Name field if the field is empty or not, if not empty then if the entered value is the same
                value as exist in the Dimension Value or not, if not an error message appear*/
                trigger OnValidate()
                begin
                    if Rec."Plan Name" <> '' then begin
                        DimPlanRec.Reset();
                        DimPlanRec.SetRange(Name, Rec."Plan Name");
                        if not DimPlanRec.FindFirst() then begin
                            Rec."Plan Name" := '';
                            Rec."Plan Code" := '';
                            Error('The entered Plan Name is not valid. Please select a valid Plan Name from the lookup page.');
                        end
                        else begin
                            Rec."Plan Code" := DimPlanRec.Code;
                        end;
                    end;
                end;
            }
            field("Owner Name"; Rec."Owner Name")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                ShowMandatory = true;
                Editable = Rec."Plan Name" <> '';

                //run the OwnerNameLookup page and show the list and set the values of Owner Name
                trigger OnLookup(var Text: Text): Boolean
                var
                    OwnerQueryRec: Record TempTableForOwnerQuery;
                    OwnerNameLookup: Page "Owner Name Lookup";
                begin
                    OwnerQueryRec.Reset();
                    OwnerQueryRec.SetRange("Plan Name", Rec."Plan Name");

                    OwnerNameLookup.SetTableView(OwnerQueryRec);
                    OwnerNameLookup.LookupMode(true);
                    OwnerNameLookup.SetPlanName(Rec."Plan Name");

                    if OwnerNameLookup.RunModal() = ACTION::LookupOK then begin
                        OwnerNameLookup.GetRecord(OwnerQueryRec);
                        Rec."Owner Name" := OwnerQueryRec."Owner Name";
                        CurrPage.Update(true);
                    end;

                end;

                /*validation of the Owner Name field if the field is empty or not, if not empty then if the entered value is the same
                value as exist in the Land table or not, if not an error message appear*/
                trigger OnValidate()
                var
                    LandRec: Record Land;
                begin
                    if Rec."Owner Name" <> '' then begin
                        LandRec.Reset();
                        LandRec.SetRange("Plan Name", Rec."Plan Name");
                        LandRec.SetRange("Owner Name", Rec."Owner Name");
                        if not LandRec.FindFirst() then begin
                            Rec."Owner Name" := '';
                            Error('The entered Owner Name is not valid for the selected Plan Name. Please select a valid Owner Name from the lookup page.');
                        end;
                    end;
                end;
            }
        }

        //This line used to make the part of SalesLines unenabled until these three conditions be true
        modify(SalesLines)
        {
            Enabled = (NOT ShowFields) OR ((Rec."Plan Name" <> '') AND (Rec."Owner Name" <> ''));
        }
        modify("Sell-to Contact")
        {
            Visible = (NOT ShowFields);
        }
        modify("Sell-to Address")
        {
            Visible = (NOT ShowFields);
        }
        modify("Sell-to Address 2")
        {
            Visible = (NOT ShowFields);
        }
        modify("Sell-to City")
        {
            Visible = (NOT ShowFields);
        }
        modify("Sell-to Post Code")
        {
            Visible = (NOT ShowFields);
        }
        modify("Sell-to Country/Region Code")
        {
            Visible = (NOT ShowFields);
        }
        modify("Sell-to Contact No.")
        {
            Visible = (NOT ShowFields);
        }
        modify(SellToMobilePhoneNo)
        {
            Visible = (NOT ShowFields);
        }
        modify("No. of Archived Versions")
        {
            Visible = (NOT ShowFields);
        }
        modify("Promised Delivery Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("Your Reference")
        {
            Visible = (NOT ShowFields);
        }
        modify("Salesperson Code")
        {
            Visible = (NOT ShowFields);
        }
        modify("Campaign No.")
        {
            Visible = (NOT ShowFields);
        }
        modify("Opportunity No.")
        {
            Visible = (NOT ShowFields);
        }
        modify("Responsibility Center")
        {
            Visible = (NOT ShowFields);
        }
        modify("Assigned User ID")
        {
            Visible = (NOT ShowFields);
        }
        modify("Work Description")
        {
            Visible = (NOT ShowFields);
        }
        modify("Document Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("VAT Reporting Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("Order Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("Due Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("Requested Delivery Date")
        {
            Visible = (NOT ShowFields);
        }
        modify("External Document No.")
        {
            Visible = (NOT ShowFields);
        }
        addafter("Sell-to Customer Name")
        {
            field("Customer ID"; "Customer ID")
            {
                ApplicationArea = all;
                Visible = ShowFields;

                // make the edit able in the customer table 
                trigger OnValidate()
                var
                    CustRec: Record Customer;
                begin
                    if "Customer ID" <> '' then begin
                        CustRec.Reset();
                        CustRec.SetRange("No.", Rec."Sell-to Customer No.");
                        if CustRec.FindFirst() then begin
                            CustRec."Customer ID" := "Customer ID";
                            CustRec.Modify();
                        end;
                    end;
                end;
            }
            field("Date of Birth"; "Date of Birth")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                //allow the changing in customer table
                trigger OnValidate()
                var
                    DOBRec: Record Customer;
                begin
                    if "Date of Birth" <> 0D then begin
                        DOBRec.Reset();
                        DOBRec.SetRange("No.", Rec."Sell-to Customer No.");
                        if DOBRec.FindFirst() then begin
                            DOBRec."Date of Birth" := "Date of Birth";
                            DOBRec.Modify();
                        end;
                    end;
                end;
            }
        }
        addbefore(Status)
        {
            field("Payment Method"; Rec."Payment Method")
            {
                ApplicationArea = all;
                Caption = 'Type of Sale';
                Visible = ShowFields;
                trigger OnValidate()
                begin
                    ShowBankType();
                    CurrPage.Update();
                end;
            }
            field("Bank Type"; Rec."Bank Type")
            {
                ApplicationArea = all;
                Visible = ShowFields;
                Editable = BankTypeCheck;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("Sale Source"; Rec."Sale Source")
            {
                ApplicationArea = all;
                Visible = ShowFields;

                trigger OnValidate()
                var
                    MarketerPage: Page "Marketer Page";
                    MarketerRec: Record Marketer;
                begin
                    MarketerRec.SetRange("Document No.", Rec."No.");
                    if MarketerRec.FindSet() then begin
                        repeat
                            ResetValues2();
                            MarketerPage.IsMarketerDomestic();
                            MarketerPage.IsMarketerAgent();
                            MarketerPage.setCommission();
                        until MarketerRec.Next() = 0;
                    end;
                    CurrPage.Update(true);
                end;
            }
            field("Conveyance Agent"; Rec."Conveyance Agent")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
            field("SREM No."; Rec."SREM No.")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
            field("RETax No."; Rec."RETax No.")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
            field("Cheque Number"; Rec."Cheque Number")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
            field("Conveyance Date"; Rec."Conveyance Date")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
            field("Conveyance Bank"; Rec."Conveyance Bank")
            {
                ApplicationArea = all;
                Visible = ShowFields;
            }
            field("with Commission?"; Rec."with Commission?")
            {
                ShowMandatory = true;
                ApplicationArea = all;
                Visible = ShowFields;

            }
        }
    }

    actions
    {
        addafter("&Print")
        {
            action("Sales Order")
            {
                ApplicationArea = All;
                Image = Print;
                Visible = ShowFields;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::SalesOrderReport, true, false, SalesHeader);
                end;
            }

        }
        addbefore("Sales Order")
        {
            action("Print Quotation")
            {
                ApplicationArea = All;
                Image = Print;
                Visible = ShowFields;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::PrintQuotationReport, true, false, SalesHeader);
                end;
            }
        }
        addafter("Sales Order")
        {
            action("Print Contract")
            {
                ApplicationArea = All;
                Image = Print;
                Visible = ShowFields;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::PrintContractReport, true, false, SalesHeader);
                end;
            }
        }
        addafter("Print Contract")
        {
            action("Set Commission Manually")
            {
                ApplicationArea = All;
                Visible = ShowFields;
                Image = PostingEntries;
                trigger OnAction()
                var
                    MarketerRec: Record Marketer;
                begin
                    MarketerRec.Reset();
                    MarketerRec.SetRange("Document No.", Rec."No.");

                    if MarketerRec.FindSet() then begin
                        repeat
                            MarketerRec.Percentage := 0.0;
                            MarketerRec.Commission := 0.0;
                            MarketerRec.IsManual := true;
                            MarketerRec.Modify();
                        until MarketerRec.Next() = 0;
                    end;
                    CurrPage.Update();
                end;
            }
            action("Set Commission Automatically")
            {
                ApplicationArea = All;
                Visible = ShowFields;
                Image = SelectEntries;
                trigger OnAction()
                var
                    MarketerRec: Record Marketer;
                    marketerPage: page "Marketer Page";
                begin
                    MarketerRec.Reset();
                    MarketerRec.SetRange("Document No.", Rec."No.");

                    if MarketerRec.FindSet() then begin
                        repeat
                            MarketerRec.IsManual := false;
                            MarketerRec.Modify();
                            MarketerPage.IsMarketerDomestic();
                            marketerPage.IsMarketerAgent();
                            MarketerPage.SetCommission();
                        until MarketerRec.Next() = 0;
                    end;
                    CurrPage.Update();
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        ShowFields := Database.CompanyName() = 'ALINMA FOR REAL ESTATE';
        ShowBankType();
    end;

    trigger OnAfterGetRecord()
    var
        CustRec: Record Customer;
        OwnerRec: Record Owners;
    begin
        CustRec.Reset();
        CustRec.SetRange("No.", Rec."Sell-to Customer No.");
        if CustRec.FindFirst() then begin
            "Customer ID" := CustRec."Customer ID";
            "Date of Birth" := CustRec."Date of Birth";
        end;
    end;

    local procedure ShowBankType()
    Begin
        if Rec."Payment Method" = Rec."Payment Method"::"بنك" then begin
            BankTypeCheck := true;
            CurrPage.Update();
        end
        else begin
            BankTypeCheck := false;
            Rec."Bank Type" := Rec."Bank Type"::" ";
            CurrPage.Update();
        end;
    End;

    local procedure ResetValues2()
    var
        MarketerRec: Record Marketer;
    begin
        MarketerRec.SetRange("Document No.", Rec."No.");
        if MarketerRec.FindSet() then begin
            repeat
                MarketerRec.Percentage := 0.0;
                MarketerRec.Commission := 0.0;
                MarketerRec.Modify();
            until MarketerRec.Next() = 0;
        end;
    end;

    var
        ShowFields: Boolean;
        BankTypeCheck: Boolean;
        DimPlanRec: Record "Dimension Value";
        "Customer ID": Code[10];
        "Date of Birth": Date;

}