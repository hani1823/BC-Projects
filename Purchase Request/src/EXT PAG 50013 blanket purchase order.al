pageextension 50013 "Blanket Purch Order EXt" extends "Blanket Purchase Order"
{
    Caption = 'Purchase Request';


    layout
    {
        addfirst(General)
        {
            field(Description; Rec.Description)
            {
                ApplicationArea = all;
                Visible = true;
                Editable = hide;
                Enabled = true;
            }

        }


        modify("Expected Receipt Date")
        {
            Visible = true;
        }


        modify("No.")
        {
            Visible = false;
        }
        modify("Pay-to Address")
        {

            Visible = false;
        }


        modify("Buy-from Vendor No.")
        {
            Caption = 'Request No';
            Visible = false;


        }
        modify("Buy-from Vendor Name")
        {
            Caption = 'Request Type';
            Visible = false;

            /*  trigger OnLookup(var Text: Text): Boolean

              var
                  VendorRec: Record Vendor;
              begin
                  VendorRec.Reset();
                  VendorRec.SetFilter("No.", 'HV100311');
                  if Page.RunModal(Page::"Vendor List", VendorRec) = Action::LookupOK then begin
                      Rec."Buy-from Vendor Name" := VendorRec.Name;
                      Rec."Buy-from Vendor No." := VendorRec."No.";
                  end;

              end;
                 trigger OnAfterValidate() begin

                 end;
*/
        }
        modify("Buy-from")
        {
            Visible = false;
        }

        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = false;
        }

        modify("Order Date")
        {
            Visible = true;
        }
        modify("Vendor Shipment No.")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Invoice Details")
        {
            Visible = false;
        }
        modify("Shipping and Payment")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }

        modify("Assigned User ID")
        {
            Editable = false;
        }




    }




    actions
    {
        addlast("F&unctions")
        {

            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Make Order(s)';
                trigger OnAction()
                var
                    MyQuery: Query "Vendor List in PR";
                    CombinationText: Text;
                    vendorInPO: Record Vendor;
                    po: array[100] of Record "Purchase Header";
                    PR_Lines_ToBe_inserted: Record "Purchase Line";
                    PO_Lines_ToBe_inserted: Record "Purchase Line";
                    cpt: Integer;

                begin
                    if Rec.Status = Rec.Status::Released then begin


                        MyQuery.SetFilter(MyQuery.Document_No_, rec."No.");
                        MyQuery.SetFilter(MyQuery.Vendor_No_, '<>%1', '');
                        MyQuery.SetRange(MyQuery.IsCreated, false);
                        cpt := 0;
                        if MyQuery.Open() then begin
                            while MyQuery.Read() do begin
                                vendorInPO.Reset();
                                vendorInPO.SetRange("No.", MyQuery.Vendor_No_);
                                if vendorInPO.FindSet() then begin
                                    cpt := cpt + 1;

                                    // po.Init();
                                    po[cpt]."Pay-to Vendor No." := vendorInPO."No.";
                                    po[cpt]."Buy-from Vendor No." := vendorInPO."No.";
                                    po[cpt]."Pay-to Name" := vendorInPO.Name;
                                    po[cpt]."Pay-to Address" := vendorInPO.Address;
                                    po[cpt]."Pay-to City" := vendorInPO.City;
                                    po[cpt]."Due Date" := Today;
                                    po[cpt]."Document Type" := Enum::"Purchase Document Type"::Order;
                                    //po."Shortcut Dimension 1 Code" := vendor.
                                    po[cpt]."Vendor Posting Group" := vendorInPO."Vendor Posting Group";
                                    po[cpt]."Invoice Disc. Code" := vendorInPO."No.";
                                    po[cpt]."Gen. Bus. Posting Group" := vendorInPO."Gen. Bus. Posting Group";
                                    po[cpt]."VAT Country/Region Code" := vendorInPO."Country/Region Code";
                                    po[cpt]."Buy-from Vendor Name" := vendorInPO.Name;
                                    po[cpt]."Buy-from Address" := vendorInPO.Address;
                                    po[cpt]."Buy-from City" := vendorInPO.City;
                                    po[cpt]."Pay-to Country/Region Code" := vendorInPO."Country/Region Code";
                                    po[cpt]."Buy-from Country/Region Code" := vendorInPO."Country/Region Code";
                                    po[cpt]."VAT Bus. Posting Group" := vendorInPO."VAT Bus. Posting Group";
                                    po[cpt]."Prepayment Due Date" := Today;
                                    po[cpt]."Pay-to Contact No." := vendorInPO."Primary Contact No.";
                                    po[cpt]."Buy-from Contact No." := vendorInPO."Primary Contact No.";
                                    po[cpt]."Price Calculation Method" := vendorInPO."Price Calculation Method";
                                    po[cpt]."Purchase Request No." := Rec."No.";
                                    po[cpt].InitInsert();
                                    //po[cpt].Insert();

                                    if (po[cpt].Insert() = true) then begin
                                        //// insert Po Lines

                                        PR_Lines_ToBe_inserted.SetRange("Document Type", Enum::"Purchase Document Type"::"Blanket Order");
                                        PR_Lines_ToBe_inserted.SetRange("Document No.", Rec."No.");
                                        PR_Lines_ToBe_inserted.SetRange(IsCreated, false);
                                        PR_Lines_ToBe_inserted.SetRange("Vendor No.", po[cpt]."Buy-from Vendor No.");
                                        if PR_Lines_ToBe_inserted.FindSet() then begin
                                            repeat
                                                PO_Lines_ToBe_inserted.Init();
                                                PO_Lines_ToBe_inserted."Document No." := po[cpt]."No.";
                                                PO_Lines_ToBe_inserted."Document Type" := Enum::"Purchase Document Type"::Order;
                                                PO_Lines_ToBe_inserted."Buy-from Vendor No." := po[cpt]."Buy-from Vendor No.";

                                                PO_Lines_ToBe_inserted."Pay-to Vendor No." := po[cpt]."Buy-from Vendor No.";

                                                // Lines
                                                PO_Lines_ToBe_inserted.Description := PR_Lines_ToBe_inserted.Description;
                                                PO_Lines_ToBe_inserted."No." := PR_Lines_ToBe_inserted."No.";
                                                PO_Lines_ToBe_inserted.Type := PR_Lines_ToBe_inserted.Type;
                                                PO_Lines_ToBe_inserted."Line No." := PR_Lines_ToBe_inserted."Line No.";
                                                PO_Lines_ToBe_inserted."Shortcut Dimension 1 Code" := PR_Lines_ToBe_inserted."Shortcut Dimension 1 Code";
                                                PO_Lines_ToBe_inserted."Shortcut Dimension 2 Code" := PR_Lines_ToBe_inserted."Shortcut Dimension 2 Code";
                                                PO_Lines_ToBe_inserted."Dimension Set ID" := PR_Lines_ToBe_inserted."Dimension Set ID";



                                                // Qty 
                                                PO_Lines_ToBe_inserted.Quantity := PR_Lines_ToBe_inserted.Quantity;
                                                PO_Lines_ToBe_inserted."Qty. to Invoice" := PR_Lines_ToBe_inserted.Quantity;
                                                PO_Lines_ToBe_inserted."Qty. to Receive" := PR_Lines_ToBe_inserted.Quantity;
                                                PO_Lines_ToBe_inserted."Outstanding Quantity" := PR_Lines_ToBe_inserted.Quantity;

                                                // Qty base
                                                PO_Lines_ToBe_inserted."Quantity (Base)" := PR_Lines_ToBe_inserted.Quantity;
                                                PO_Lines_ToBe_inserted."Outstanding Qty. (Base)" := PR_Lines_ToBe_inserted.Quantity;
                                                PO_Lines_ToBe_inserted."Qty. to Invoice (Base)" := PR_Lines_ToBe_inserted.Quantity;
                                                PO_Lines_ToBe_inserted."Qty. to Receive (Base)" := PR_Lines_ToBe_inserted.Quantity;
                                                // Qty Diffrence
                                                //PO_Lines_ToBe_inserted."LSC Quantity Difference" := PR_Lines_ToBe_inserted."LSC Quantity Difference";


                                                // Date 
                                                PO_Lines_ToBe_inserted."Planned Receipt Date" := PR_Lines_ToBe_inserted."Planned Receipt Date";
                                                PO_Lines_ToBe_inserted."Order Date" := rec."Order Date";
                                                PO_Lines_ToBe_inserted."Expected Receipt Date" := PR_Lines_ToBe_inserted."Expected Receipt Date";
                                                PO_Lines_ToBe_inserted."Requested Receipt Date" := PR_Lines_ToBe_inserted."Requested Receipt Date";


                                                // Vendor
                                                //  PO_Lines_ToBe_inserted."Buy-from Vendor No." := rec."Buy-from Vendor No.";
                                                //  PO_Lines_ToBe_inserted."Pay-to Vendor No." := rec."Pay-to Vendor No.";

                                                // Measure
                                                PO_Lines_ToBe_inserted."Unit of Measure Code" := PR_Lines_ToBe_inserted."Unit of Measure Code";
                                                PO_Lines_ToBe_inserted."Unit of Measure" := PR_Lines_ToBe_inserted."Unit of Measure";

                                                // Vat 
                                                PO_Lines_ToBe_inserted."VAT %" := PR_Lines_ToBe_inserted."VAT %";

                                                // Posting Group
                                                PO_Lines_ToBe_inserted."Posting Group" := PR_Lines_ToBe_inserted."Posting Group";
                                                PO_Lines_ToBe_inserted."Gen. Bus. Posting Group" := PR_Lines_ToBe_inserted."Gen. Bus. Posting Group";
                                                PO_Lines_ToBe_inserted."Gen. Prod. Posting Group" := PR_Lines_ToBe_inserted."Gen. Prod. Posting Group";
                                                PO_Lines_ToBe_inserted."VAT Prod. Posting Group" := PR_Lines_ToBe_inserted."VAT Prod. Posting Group";
                                                PO_Lines_ToBe_inserted."VAT Bus. Posting Group" := PR_Lines_ToBe_inserted."VAT Bus. Posting Group";

                                                // Other
                                                PO_Lines_ToBe_inserted."VAT Identifier" := PR_Lines_ToBe_inserted."VAT Identifier";
                                                PO_Lines_ToBe_inserted."Item Category Code" := PR_Lines_ToBe_inserted."Item Category Code";
                                                PO_Lines_ToBe_inserted."Price Calculation Method" := PR_Lines_ToBe_inserted."Price Calculation Method";
                                                PO_Lines_ToBe_inserted."Safety Lead Time" := PR_Lines_ToBe_inserted."Safety Lead Time";

                                                // jobs
                                                PO_Lines_ToBe_inserted."Job No." := PR_Lines_ToBe_inserted."Job No.";
                                                PO_Lines_ToBe_inserted."Job Planning Line No." := PR_Lines_ToBe_inserted."Job Planning Line No.";
                                                PO_Lines_ToBe_inserted."Job Task No." := PR_Lines_ToBe_inserted."Job Task No.";

                                                PR_Lines_ToBe_inserted.IsCreated := true;
                                                PR_Lines_ToBe_inserted.Modify();

                                                PO_Lines_ToBe_inserted.Insert();

                                            until PR_Lines_ToBe_inserted.Next() = 0;

                                        end;

                                    end;


                                end else
                                    Error('Vendor Not Found');

                            end;
                            MyQuery.Close();
                        end else
                            Error('Lines can not be found');
                        Commit();
                    end else
                        Error('Purchase Request is not released yet');
                end;
            }
        }
    }




    trigger OnOpenPage()
    var
    begin
        hide := true;
        if (Rec.Status = rec.Status::"Pending Approval") OR (Rec.Status = rec.Status::Released) then begin
            hide := false;

        end;
    end;

    var
        [InDataSet]
        hide: boolean;

}