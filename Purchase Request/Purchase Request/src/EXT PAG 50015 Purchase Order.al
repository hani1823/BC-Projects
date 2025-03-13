pageextension 50015 "Purch Order EXT" extends "Purchase Order"
{

    layout
    {
        addlast(General)
        {
            field("Purchase Request No."; Rec."Purchase Request No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addfirst(navigation)
        {
            action(PurchaseRequest)
            {
                Caption = 'Get Purchase Request Lines';
                ApplicationArea = Suite;
                trigger OnAction()
                var
                    PR_Lines: Record "Purchase Line";
                    PO_Lines: Record "Purchase Line";
                    SUB_Lines: Record "Purchase Line";
                    SUB_Lines_2: Record "Purchase Line";
                    cpt: Integer;
                    L_BlanketOrder: page "Blanket Purchase Orders";
                    subBlanketPO: Page "Purchase Request Lines";
                    L_BlanketpurchOrder: Record "Purchase Header";
                    F_BlanketpurchOrder: Record "Purchase Header";
                begin

                    L_BlanketOrder.LOOKUPMODE(TRUE);
                    L_BlanketpurchOrder.SetRange(Status, Enum::"Purchase Document Status"::Released);
                    ///L_BlanketpurchOrder.Status
                    L_BlanketOrder.SetTableView(L_BlanketpurchOrder);

                    IF L_BlanketOrder.RUNMODAL = ACTION::LookupOK THEN begin

                        L_BlanketOrder.GetRecord(F_BlanketpurchOrder);
                        subBlanketPO.LookupMode(TRUE);
                        SUB_Lines.SetRange("Document No.", F_BlanketpurchOrder."No.");
                        subBlanketPO.SetTableView(SUB_Lines);

                        IF subBlanketPO.RunModal = Action::LookupOK then begin
                            SUB_Lines_2.Init();
                            subBlanketPO.SetSelectionFilter(SUB_Lines_2);
                            if SUB_Lines_2.FindSet() then begin
                                repeat

                                    PO_Lines.Init();
                                    PO_Lines."Document No." := rec."No.";
                                    PO_Lines."Document Type" := rec."Document Type";
                                    rec."Purchase Request No." := SUB_Lines_2."Document No.";
                                    // Lines
                                    PO_Lines.Description := SUB_Lines_2.Description;
                                    PO_Lines."No." := SUB_Lines_2."No.";

                                    PO_Lines.Type := SUB_Lines_2.Type;
                                    PO_Lines."Line No." := SUB_Lines_2."Line No.";
                                    PO_Lines."Shortcut Dimension 1 Code" := SUB_Lines_2."Shortcut Dimension 1 Code";
                                    PO_Lines."Shortcut Dimension 2 Code" := SUB_Lines_2."Shortcut Dimension 2 Code";
                                    PO_Lines."Dimension Set ID" := SUB_Lines_2."Dimension Set ID";



                                    // Qty 
                                    PO_Lines.Quantity := SUB_Lines_2.Quantity;
                                    PO_Lines."Qty. to Invoice" := SUB_Lines_2.Quantity;
                                    PO_Lines."Qty. to Receive" := SUB_Lines_2.Quantity;
                                    PO_Lines."Outstanding Quantity" := SUB_Lines_2.Quantity;

                                    // Qty base
                                    PO_Lines."Quantity (Base)" := SUB_Lines_2.Quantity;
                                    PO_Lines."Outstanding Qty. (Base)" := SUB_Lines_2.Quantity;
                                    PO_Lines."Qty. to Invoice (Base)" := SUB_Lines_2.Quantity;
                                    PO_Lines."Qty. to Receive (Base)" := SUB_Lines_2.Quantity;
                                    // Qty Diffrence
                                    //PO_Lines."LSC Quantity Difference" := SUB_Lines_2."LSC Quantity Difference";


                                    // Date 
                                    PO_Lines."Planned Receipt Date" := rec."Order Date";
                                    PO_Lines."Order Date" := rec."Order Date";
                                    PO_Lines."Expected Receipt Date" := rec."Order Date";

                                    // Vendor
                                    PO_Lines."Buy-from Vendor No." := rec."Buy-from Vendor No.";
                                    PO_Lines."Pay-to Vendor No." := rec."Pay-to Vendor No.";

                                    // Measure
                                    PO_Lines."Unit of Measure Code" := SUB_Lines_2."Unit of Measure Code";
                                    PO_Lines."Unit of Measure" := SUB_Lines_2."Unit of Measure";

                                    // Vat 
                                    PO_Lines."VAT %" := SUB_Lines_2."VAT %";

                                    // Posting Group
                                    PO_Lines."Posting Group" := SUB_Lines_2."Posting Group";
                                    PO_Lines."Gen. Bus. Posting Group" := SUB_Lines_2."Gen. Bus. Posting Group";
                                    PO_Lines."Gen. Prod. Posting Group" := SUB_Lines_2."Gen. Prod. Posting Group";
                                    PO_Lines."VAT Prod. Posting Group" := SUB_Lines_2."VAT Prod. Posting Group";
                                    PO_Lines."VAT Bus. Posting Group" := SUB_Lines_2."VAT Bus. Posting Group";

                                    // Other
                                    PO_Lines."VAT Identifier" := SUB_Lines_2."VAT Identifier";
                                    PO_Lines."Item Category Code" := SUB_Lines_2."Item Category Code";
                                    PO_Lines."Price Calculation Method" := SUB_Lines_2."Price Calculation Method";
                                    PO_Lines."Safety Lead Time" := SUB_Lines_2."Safety Lead Time";




                                    PO_Lines.Insert(true);

                                until SUB_Lines_2.Next() = 0;
                                Commit();
                            end else
                                Message('The Purchase Request has not been realesed yet or The purchase Order is not open');


                        end;


                    end;
                end;

            }
        }
    }
    local procedure GetLineNo(P_PruchHeader: Record "Purchase Header"): Integer
    var
        L_PurchLine: Record "Purchase Line";
    begin
        L_PurchLine.SetRange("Document Type", P_PruchHeader."Document Type");
        L_PurchLine.SetRange("Document No.", P_PruchHeader."No.");
        if L_PurchLine.FindLast() then
            exit(L_PurchLine."Line No." + 10000)
        else
            exit(10000)
    end;



}