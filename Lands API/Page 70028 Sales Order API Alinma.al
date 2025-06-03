namespace Alinma.API.V2;

using Microsoft.Integration.Entity;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Vendor;
using Microsoft.Finance.Currency;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Shipping;
using Microsoft.Integration.Graph;
using Microsoft.Sales.History;
using Microsoft.Sales.Posting;
using Microsoft.Utilities;
using System.Reflection;
using Microsoft.Foundation.NoSeries;
using System.Text;
using System.Environment.Configuration;
using System.Azure.Identity;
using Microsoft.EServices.EDocument;
using Microsoft.API.V2;
using System.IO;
using System.Utilities;

page 70028 "APIV2 - Sales Orders Alinma"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Sales Order';
    EntitySetCaption = 'Sales Orders';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'salesOrder';
    EntitySetName = 'salesOrders';
    ODataKeyFields = Id;
    APIPublisher = 'Alinma';
    APIGroup = 'powerAutomate';
    PageType = API;
    SourceTable = "Sales Order Entity Buffer";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Id));
                    end;
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("No."));
                    end;
                }
                field(externalDocumentNumber; Rec."External Document No.")
                {
                    Caption = 'External Document No.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("External Document No."))
                    end;
                }
                field(orderDate; Rec."Document Date")
                {
                    Caption = 'Order Date';

                    trigger OnValidate()
                    begin
                        DocumentDateVar := Rec."Document Date";
                        DocumentDateSet := true;

                        RegisterFieldSet(Rec.FieldNo("Document Date"));
                    end;
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';

                    trigger OnValidate()
                    begin
                        PostingDateVar := Rec."Posting Date";
                        PostingDateSet := true;

                        RegisterFieldSet(Rec.FieldNo("Posting Date"));
                    end;
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';

                    trigger OnValidate()
                    begin
                        if not SellToCustomer.GetBySystemId(Rec."Customer Id") then
                            Error(CouldNotFindSellToCustomerErr);

                        Rec."Sell-to Customer No." := SellToCustomer."No.";
                        RegisterFieldSet(Rec.FieldNo("Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Sell-to Customer No."));
                    end;
                }

                field(customerNumber; Rec."Sell-to Customer No.")
                {
                    Caption = 'Customer No.';

                    trigger OnValidate()
                    begin
                        if SellToCustomer."No." <> '' then begin
                            if SellToCustomer."No." <> Rec."Sell-to Customer No." then
                                Error(SellToCustomerValuesDontMatchErr);
                            exit;
                        end;

                        if not SellToCustomer.Get(Rec."Sell-to Customer No.") then
                            Error(CouldNotFindSellToCustomerErr);

                        Rec."Customer Id" := SellToCustomer.SystemId;
                        RegisterFieldSet(Rec.FieldNo("Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Sell-to Customer No."));
                    end;
                }
                field(customerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field(billToName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-to Name';
                    Editable = false;
                }
                field(billToCustomerId; Rec."Bill-to Customer Id")
                {
                    Caption = 'Bill-to Customer Id';

                    trigger OnValidate()
                    begin
                        if not BillToCustomer.GetBySystemId(Rec."Bill-to Customer Id") then
                            Error(CouldNotFindBillToCustomerErr);

                        Rec."Bill-to Customer No." := BillToCustomer."No.";
                        RegisterFieldSet(Rec.FieldNo("Bill-to Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Bill-to Customer No."));
                    end;
                }
                field(billToCustomerNumber; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';

                    trigger OnValidate()
                    begin
                        if BillToCustomer."No." <> '' then begin
                            if BillToCustomer."No." <> Rec."Bill-to Customer No." then
                                Error(BillToCustomerValuesDontMatchErr);
                            exit;
                        end;

                        if not BillToCustomer.Get(Rec."Bill-to Customer No.") then
                            Error(CouldNotFindBillToCustomerErr);

                        Rec."Bill-to Customer Id" := BillToCustomer.SystemId;
                        RegisterFieldSet(Rec.FieldNo("Bill-to Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Bill-to Customer No."));
                    end;
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';

                    trigger OnValidate()
                    begin
                        if xRec."Ship-to Name" <> Rec."Ship-to Name" then begin
                            Rec."Ship-to Code" := '';
                            RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                            RegisterFieldSet(Rec.FieldNo("Ship-to Name"));
                        end;
                    end;
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';

                    trigger OnValidate()
                    begin
                        if xRec."Ship-to Contact" <> Rec."Ship-to Contact" then begin
                            Rec."Ship-to Code" := '';
                            RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                            RegisterFieldSet(Rec.FieldNo("Ship-to Contact"));
                        end;
                    end;
                }
                field(sellToAddressLine1; Rec."Sell-to Address")
                {
                    Caption = 'Sell-to Address Line 1';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to Address"));
                    end;
                }
                field(sellToAddressLine2; Rec."Sell-to Address 2")
                {
                    Caption = 'Sell-to Address Line 2';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to Address 2"));
                    end;
                }
                field(sellToCity; Rec."Sell-to City")
                {
                    Caption = 'Sell-to City';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to City"));
                    end;
                }
                field(sellToCountry; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'Sell-to Country/Region Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to Country/Region Code"));
                    end;
                }
                field(sellToState; Rec."Sell-to County")
                {
                    Caption = 'Sell-to State';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to County"));
                    end;
                }
                field(sellToPostCode; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to Post Code"));
                    end;
                }
                field(billToAddressLine1; Rec."Bill-to Address")
                {
                    Caption = 'Bill-to Address Line 1';
                    Editable = false;
                }
                field(billToAddressLine2; Rec."Bill-to Address 2")
                {
                    Caption = 'Bill-to Address Line 2';
                    Editable = false;
                }
                field(billToCity; Rec."Bill-to City")
                {
                    Caption = 'Bill-to City';
                    Editable = false;
                }
                field(billToCountry; Rec."Bill-to Country/Region Code")
                {
                    Caption = 'Bill-to Country/Region Code';
                    Editable = false;
                }
                field(billToState; Rec."Bill-to County")
                {
                    Caption = 'BillTo State';
                    Editable = false;
                }
                field(billToPostCode; Rec."Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code';
                    Editable = false;
                }
                field(shipToAddressLine1; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address Line 1';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to Address"));
                    end;
                }
                field(shipToAddressLine2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address Line 2';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to Address 2"));
                    end;
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to City"));
                    end;
                }
                field(shipToCountry; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to Country/Region Code"));
                    end;
                }
                field(shipToState; Rec."Ship-to County")
                {
                    Caption = 'Ship-to State';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to County"));
                    end;
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to Post Code"));
                    end;
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shortcut Dimension 1 Code"));
                    end;
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shortcut Dimension 2 Code"));
                    end;
                }
                field(currencyId; Rec."Currency Id")
                {
                    Caption = 'Currency Id';

                    trigger OnValidate()
                    begin
                        if Rec."Currency Id" = BlankGUID then
                            Rec."Currency Code" := ''
                        else begin
                            if not Currency.GetBySystemId(Rec."Currency Id") then
                                Error(CurrencyIdDoesNotMatchACurrencyErr);

                            Rec."Currency Code" := Currency.Code;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(currencyCode; CurrencyCodeTxt)
                {
                    Caption = 'Currency Code';

                    trigger OnValidate()
                    begin
                        Rec."Currency Code" :=
                          GraphMgtGeneralTools.TranslateCurrencyCodeToNAVCurrencyCode(
                            LCYCurrencyCode, COPYSTR(CurrencyCodeTxt, 1, MAXSTRLEN(LCYCurrencyCode)));

                        if Currency.Code <> '' then begin
                            if Currency.Code <> Rec."Currency Code" then
                                Error(CurrencyValuesDontMatchErr);
                            exit;
                        end;

                        if Rec."Currency Code" = '' then
                            Rec."Currency Id" := BlankGUID
                        else begin
                            if not Currency.Get(Rec."Currency Code") then
                                Error(CurrencyCodeDoesNotMatchACurrencyErr);

                            Rec."Currency Id" := Currency.SystemId;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    Caption = 'Prices Include Tax';

                    trigger OnValidate()
                    var
                        SalesLine: Record "Sales Line";
                    begin
                        if Rec."Prices Including VAT" then begin
                            SalesLine.SetRange("Document No.", Rec."No.");
                            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                            if SalesLine.FindFirst() then
                                if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax" then
                                    Error(CannotEnablePricesIncludeTaxErr);
                        end;
                        RegisterFieldSet(Rec.FieldNo("Prices Including VAT"));
                    end;
                }
                field(paymentTermsId; Rec."Payment Terms Id")
                {
                    Caption = 'Payment Terms Id';

                    trigger OnValidate()
                    begin
                        if Rec."Payment Terms Id" = BlankGUID then
                            Rec."Payment Terms Code" := ''
                        else begin
                            if not PaymentTerms.GetBySystemId(Rec."Payment Terms Id") then
                                Error(PaymentTermsIdDoesNotMatchAPaymentTermsErr);

                            Rec."Payment Terms Code" := PaymentTerms.Code;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Payment Terms Id"));
                        RegisterFieldSet(Rec.FieldNo("Payment Terms Code"));
                    end;
                }
                field(shipmentMethodId; Rec."Shipment Method Id")
                {
                    Caption = 'Shipment Method Id';

                    trigger OnValidate()
                    begin
                        if Rec."Shipment Method Id" = BlankGUID then
                            Rec."Shipment Method Code" := ''
                        else begin
                            if not ShipmentMethod.GetBySystemId(Rec."Shipment Method Id") then
                                Error(ShipmentMethodIdDoesNotMatchAShipmentMethodErr);

                            Rec."Shipment Method Code" := ShipmentMethod.Code;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Shipment Method Id"));
                        RegisterFieldSet(Rec.FieldNo("Shipment Method Code"));
                    end;
                }
                field(salesperson; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Salesperson Code"));
                    end;
                }
                field(partialShipping; PartialOrderShipping)
                {
                    Caption = 'Partial Shipping';

                    trigger OnValidate()
                    begin
                        ProcessPartialShipping();
                    end;
                }
                field(requestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    Caption = 'Requested Delivery Date';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Requested Delivery Date"));
                    end;
                }
                part(dimensionSetLines; "APIV2 - Dimension Set Lines")
                {
                    Caption = 'Dimension Set Lines';
                    EntityName = 'dimensionSetLine';
                    EntitySetName = 'dimensionSetLines';
                    SubPageLink = "Parent Id" = field(Id), "Parent Type" = const("Sales Order");
                }
                part(salesOrderLines; "APIV2 - Sales Order Lines")
                {
                    Caption = 'Lines';
                    EntityName = 'salesOrderLine';
                    EntitySetName = 'salesOrderLines';
                    SubPageLink = "Document Id" = field(Id);
                }
                field(discountAmount; Rec."Invoice Discount Amount")
                {
                    Caption = 'Discount Amount';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Invoice Discount Amount"));
                        InvoiceDiscountAmount := Rec."Invoice Discount Amount";
                        DiscountAmountSet := true;
                    end;
                }
                field(discountAppliedBeforeTax; Rec."Discount Applied Before Tax")
                {
                    Caption = 'Discount Applied Before Tax';
                    Editable = false;
                }
                field(totalAmountExcludingTax; Rec.Amount)
                {
                    Caption = 'Total Amount Excluding Tax';
                    Editable = false;
                }
                field(totalTaxAmount; Rec."Total Tax Amount")
                {
                    Caption = 'Total Tax Amount';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Total Tax Amount"));
                    end;
                }
                field(totalAmountIncludingTax; Rec."Amount Including VAT")
                {
                    Caption = 'Total Amount Including Tax';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Amount Including VAT"));
                    end;
                }
                field(fullyShipped; Rec."Completely Shipped")
                {
                    Caption = 'Fully Shipped';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Completely Shipped"));
                    end;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }
                field(phoneNumber; Rec."Sell-to Phone No.")
                {
                    Caption = 'Phone No.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to Phone No."));
                    end;
                }
                field(email; Rec."Sell-to E-Mail")
                {
                    Caption = 'Email';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to E-Mail"));
                    end;
                }
                part(attachments; "APIV2 - Attachments")
                {
                    Caption = 'Attachments';
                    EntityName = 'attachment';
                    EntitySetName = 'attachments';
                    SubPageLink = "Document Id" = field(Id), "Document Type" = const("Sales Order");
                }
                part(documentAttachments; "APIV2 - Document Attachments")
                {
                    Caption = 'Document Attachments';
                    EntityName = 'documentAttachment';
                    EntitySetName = 'documentAttachments';
                    SubPageLink = "Document Id" = field(Id), "Document Type" = const("Sales Order");
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
        if HasWritePermission then
            GraphMgtSalesOrderBuffer.RedistributeInvoiceDiscounts(Rec);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        GraphMgtSalesOrderBuffer.PropagateOnDelete(Rec);

        exit(false);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckSellToCustomerSpecified();

        GraphMgtSalesOrderBuffer.PropagateOnInsert(Rec, TempFieldBuffer);
        SetDates();

        UpdateDiscount();

        SetCalculatedFields();

        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if xRec.Id <> Rec.Id then
            Error(CannotChangeIDErr);

        GraphMgtSalesOrderBuffer.PropagateOnModify(Rec, TempFieldBuffer);
        UpdateDiscount();

        SetCalculatedFields();

        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    trigger OnOpenPage()
    begin
        CheckPermissions();
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        SellToCustomer: Record "Customer";
        BillToCustomer: Record "Customer";
        Currency: Record "Currency";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        GraphMgtSalesOrderBuffer: Codeunit "Graph Mgt - Sales Order Buffer";
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        APIV2SendSalesDocument: Codeunit "APIV2 - Send Sales Document";
        LCYCurrencyCode: Code[10];
        CurrencyCodeTxt: Text;
        CannotChangeIDErr: Label 'The "id" cannot be changed.', Comment = 'id is a field name and should not be translated.';
        SellToCustomerNotProvidedErr: Label 'A "customerNumber" or a "customerId" must be provided.', Comment = 'customerNumber and customerId are field names and should not be translated.';
        SellToCustomerValuesDontMatchErr: Label 'The sell-to customer values do not match to a specific Customer.';
        BillToCustomerValuesDontMatchErr: Label 'The bill-to customer values do not match to a specific Customer.';
        CouldNotFindSellToCustomerErr: Label 'The sell-to customer cannot be found.';
        CouldNotFindBillToCustomerErr: Label 'The bill-to customer cannot be found.';
        PartialOrderShipping: Boolean;
        SalesOrderPermissionsErr: Label 'You do not have permissions to read Sales Orders.';
        CurrencyValuesDontMatchErr: Label 'The currency values do not match to a specific Currency.';
        CurrencyIdDoesNotMatchACurrencyErr: Label 'The "currencyId" does not match to a Currency.', Comment = 'currencyId is a field name and should not be translated.';
        CurrencyCodeDoesNotMatchACurrencyErr: Label 'The "currencyCode" does not match to a Currency.', Comment = 'currencyCode is a field name and should not be translated.';
        PaymentTermsIdDoesNotMatchAPaymentTermsErr: Label 'The "paymentTermsId" does not match to a Payment Terms.', Comment = 'paymentTermsId is a field name and should not be translated.';
        ShipmentMethodIdDoesNotMatchAShipmentMethodErr: Label 'The "shipmentMethodId" does not match to a Shipment Method.', Comment = 'shipmentMethodId is a field name and should not be translated.';
        CannotFindOrderErr: Label 'The order cannot be found.';
        CannotEnablePricesIncludeTaxErr: Label 'The "pricesIncludeTax" cannot be set to true if VAT Calculation Type is Sales Tax.', Comment = 'pricesIncludeTax is a field name and should not be translated.';
        DiscountAmountSet: Boolean;
        InvoiceDiscountAmount: Decimal;
        BlankGUID: Guid;
        DocumentDateSet: Boolean;
        DocumentDateVar: Date;
        PostingDateSet: Boolean;
        PostingDateVar: Date;
        HasWritePermission: Boolean;

    local procedure SetCalculatedFields()
    begin
        CurrencyCodeTxt := GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(LCYCurrencyCode, Rec."Currency Code");
        PartialOrderShipping := (Rec."Shipping Advice" = Rec."Shipping Advice"::Partial);
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(DiscountAmountSet);
        Clear(InvoiceDiscountAmount);

        PartialOrderShipping := false;
        TempFieldBuffer.DeleteAll();
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        if TempFieldBuffer.FindLast() then
            LastOrderNo := TempFieldBuffer.Order + 1;

        Clear(TempFieldBuffer);
        TempFieldBuffer.Order := LastOrderNo;
        TempFieldBuffer."Table ID" := Database::"Sales Invoice Entity Aggregate";
        TempFieldBuffer."Field ID" := FieldNo;
        TempFieldBuffer.Insert();
    end;

    local procedure CheckSellToCustomerSpecified()
    begin
        if (Rec."Sell-to Customer No." = '') and
           (Rec."Customer Id" = BlankGUID)
        then
            Error(SellToCustomerNotProvidedErr);
    end;

    local procedure ProcessPartialShipping()
    begin
        if PartialOrderShipping then
            Rec."Shipping Advice" := Rec."Shipping Advice"::Partial
        else
            Rec."Shipping Advice" := Rec."Shipping Advice"::Complete;

        RegisterFieldSet(Rec.FieldNo("Shipping Advice"));
    end;

    local procedure CheckPermissions()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        if not SalesHeader.ReadPermission() then
            Error(SalesOrderPermissionsErr);

        HasWritePermission := SalesHeader.WritePermission();
    end;

    local procedure UpdateDiscount()
    var
        SalesHeader: Record "Sales Header";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
    begin
        if not DiscountAmountSet then begin
            GraphMgtSalesOrderBuffer.RedistributeInvoiceDiscounts(Rec);
            exit;
        end;

        SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."No.");
        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
    end;

    local procedure SetDates()
    begin
        if not (DocumentDateSet or PostingDateSet) then
            exit;

        TempFieldBuffer.Reset();
        TempFieldBuffer.DeleteAll();

        if DocumentDateSet then begin
            Rec."Document Date" := DocumentDateVar;
            RegisterFieldSet(Rec.FieldNo("Document Date"));
        end;

        if PostingDateSet then begin
            Rec."Posting Date" := PostingDateVar;
            RegisterFieldSet(Rec.FieldNo("Posting Date"));
        end;

        GraphMgtSalesOrderBuffer.PropagateOnModify(Rec, TempFieldBuffer);
        Rec.Find();
    end;

    local procedure GetOrder(var SalesHeader: Record "Sales Header")
    begin
        if not SalesHeader.GetBySystemId(Rec.Id) then
            Error(CannotFindOrderErr);
    end;

    local procedure PostWithShipAndInvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        OrderNo: Code[20];
        OrderNoSeries: Code[20];
    begin
        APIV2SendSalesDocument.CheckDocumentIfNoItemsExists(SalesHeader);
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
        OrderNo := SalesHeader."No.";
        OrderNoSeries := SalesHeader."No. Series";
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        SalesHeader.SendToPosting(Codeunit::"Sales-Post");
        SalesInvoiceHeader.SetCurrentKey("Order No.");
        SalesInvoiceHeader.SetRange("Pre-Assigned No. Series", '');
        SalesInvoiceHeader.SetRange("Order No. Series", OrderNoSeries);
        SalesInvoiceHeader.SetRange("Order No.", OrderNo);
        exit(SalesInvoiceHeader.FindFirst());
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; DocumentId: Guid; ObjectId: Integer; ResultCode: WebServiceActionResultCode)
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(ObjectId);
        ActionContext.AddEntityKey(Rec.FieldNo(Id), DocumentId);
        ActionContext.SetResultCode(ResultCode);
    end;








    //******** Added By Alinma Developer B_API

    local procedure createPurchaseInvoice(var Vendor_NO: Code[20]; SO_No: Code[20]; Percentage: Decimal)
    var
        cpt: Integer;
        PurcInvHeader: Record "Purchase Header";
        PurcInvLine: array[20] of Record "Purchase line";
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        marketer: Record Marketer;
        purchRelease: Codeunit "Purchase Manual Release";
        vendorRec: Record Vendor;
        LineAmt: Decimal;
        HasLines: Boolean;
    begin
        cpt := 1;
        HasLines := false;

        SalesHeader.SetRange("Document Type", enum::"Sales Document Type"::Order);
        SalesHeader.SetRange("No.", SO_No);

        if not SalesHeader.FindFirst() then
            Error('Sales order %1 not found.', SO_No);

        if not SalesHeader."With Commission?" then
            exit;

        if not VendorRec.Get(Vendor_NO) then
            Error('Vendor %1 not found.', Vendor_NO);

        // create PI Lines
        SalesLines.SetRange("Document Type", enum::"Sales Document Type"::Order);
        SalesLines.SetRange("Document No.", SO_No);
        if SalesLines.FindSet() then begin
            repeat
                LineAmt := Round(SalesLines."Commission Without VAT" * Percentage, 0.01);

                if LineAmt <> 0 then begin
                    if not HasLines then begin
                        // create PI Header
                        PurcInvHeader.Init();
                        PurcInvHeader."Document Type" := Enum::"Purchase Document Type"::Invoice;
                        PurcInvHeader."Posting Date" := today;
                        PurcInvHeader."Vendor Invoice No." := SO_No;
                        PurcInvHeader."Buy-from Vendor No." := Vendor_NO;
                        PurcInvHeader.Validate("Assigned User ID", 'SULAIMAN');
                        PurcInvHeader.Validate("Buy-from Vendor No.", Vendor_NO);
                        PurcInvHeader."Shortcut Dimension 2 Code" := SalesLines."Shortcut Dimension 2 Code";
                        PurcInvHeader.InitInsert();
                        PurcInvHeader.Insert();
                    end;
                    HasLines := true;

                    PurcInvLine[cpt].init();
                    PurcInvLine[cpt]."Document Type" := enum::"Purchase Document Type"::Invoice;
                    PurcInvLine[cpt]."Document No." := PurcInvHeader."No.";
                    PurcInvLine[cpt].Type := SalesLines.type;
                    //PurcInvLine[cpt]."No." := SalesLines."No.";
                    PurcInvLine[cpt].Validate("No.", SalesLines."No.");
                    PurcInvLine[cpt]."Line No." := SalesLines."Line No.";
                    PurcInvLine[cpt].Description := SalesLines.Description;
                    //PurcInvLine[cpt].Validate("No.");
                    //PurcInvLine[cpt].Quantity := 1;
                    PurcInvLine[cpt].Validate(Quantity, 1);
                    PurcInvLine[cpt]."Unit of Measure Code" := SalesLines."Unit of Measure Code";
                    PurcInvLine[cpt]."Dimension Set ID" := SalesLines."Dimension Set ID";
                    PurcInvLine[cpt]."Direct Unit Cost" := SalesLines."Commission Without VAT" * Percentage;

                    PurcInvLine[cpt].Validate("Gen. Bus. Posting Group", VendorRec."Gen. Bus. Posting Group");
                    PurcInvLine[cpt]."Shortcut Dimension 2 Code" := SalesLines."Shortcut Dimension 2 Code";
                    PurcInvLine[cpt].Validate("Direct Unit Cost");
                    PurcInvLine[cpt].Insert();
                    cpt := cpt + 1;
                end;
            until SalesLines.Next() = 0;
        end;

        if HasLines then
            purchRelease.Run(PurcInvHeader);
    end;

    ////        Create Sales Invoice for Adminstration service 
    /// 
    /// 
    /// 
    /// 
    local procedure createSaleInvoiceAS(SaleOrderNo: Code[20])
    var
        SaleHeaderSO: Record "Sales Header";
        SaleHeaderSI: Record "Sales Header";
        SaleLineSI: Record "Sales line";
        SaleLineSO: Record "Sales line";
        cpt: Integer;

    begin

        SaleHeaderSO.SetRange("Document Type", Enum::"Sales Document Type"::Order);
        SaleHeaderSO.SetRange("No.", SaleOrderNo);
        if SaleHeaderSO.FindSet() then begin

            SaleHeaderSI.Init();
            SaleHeaderSI."Document Type" := Enum::"Sales Document Type"::Invoice;
            SaleHeaderSI."bill-to Customer No." := 'C00040';
            SaleHeaderSI."sell-to Customer No." := 'C00040';
            SaleHeaderSI."Shortcut Dimension 2 Code" := SaleHeaderSO."Shortcut Dimension 2 Code";
            SaleHeaderSI."Shortcut Dimension 1 Code" := SaleHeaderSO."Shortcut Dimension 1 Code";
            SaleHeaderSI."Dimension Set ID" := SaleHeaderSO."Dimension Set ID";
            SaleHeaderSI."Posting Date" := Today;
            SaleHeaderSI.Validate("sell-to Customer No.");
            SaleHeaderSI.Validate("bill-to Customer No.");
            SaleHeaderSI."External Document No." := SaleOrderNo;
            SaleHeaderSI.InitInsert();
            SaleHeaderSI.insert();

            SaleLineSO.SetRange("Document Type", Enum::"Sales Document Type"::Order);
            SaleLineSO.SetRange("Document No.", SaleOrderNo);

            if SaleLineSO.FindFirst() then begin

                SaleLineSI."Document Type" := Enum::"Sales Document Type"::Invoice;
                SaleLineSI."Document No." := SaleHeaderSI."No.";

                SaleLineSI.Type := SaleLineSO.Type;
                SaleLineSI."No." := SaleLineSO."No.";
                SaleLineSI."line No." := SaleLineSO."line No.";
                SaleLineSI.Validate("No.");
                SaleLineSI.Description := SaleLineSO.Description;
                SaleLineSI."Dimension Set ID" := SaleLineSO."Dimension Set ID";
                SaleLineSI.Quantity := SaleLineSO.Quantity;
                SaleLineSI.Validate(Quantity);
                SaleLineSI."Unit Price" := SaleLineSO."Net Value" * 0.0125;


                //  SaleLineSI."VAT Bus. Posting Group" := 'DOMESTIC';
                // SaleLineSI."VAT Prod. Posting Group" := 'STAND(15%)';

                SaleLineSI.Validate("Unit Price");
                // SaleLineSI[cpt].Validate("VAT Prod. Posting Group");
                // SaleLineSI[cpt].Validate("VAT Bus. Posting Group");


                SaleLineSI.Insert();

            end;


        end;
    end;

    ////
    /// 
    /// 
    /// 

    //******************************** Sales Invoice ********************///////

    local procedure createSaleInvoice(SaleOrderNo: Code[20])
    var
        SaleHeaderSO: Record "Sales Header";
        SaleHeaderSI: Record "Sales Header";
        SaleLineSI: array[20] of Record "Sales line";
        SaleLineSO: Record "Sales line";
        cpt: Integer;

    begin

        SaleHeaderSO.SetRange("Document Type", Enum::"Sales Document Type"::Order);
        SaleHeaderSO.SetRange("No.", SaleOrderNo);

        if not SaleHeaderSO.FindFirst() then
            Error('Sales order %1 not found.', SaleOrderNo);
        //This is checking for if the customer have a commission or not
        if not SaleHeaderSO."With Commission?" then
            exit;

        if SaleHeaderSO.FindSet() then begin
            SaleHeaderSI.Init();
            SaleHeaderSI."Document Type" := Enum::"Sales Document Type"::Invoice;
            SaleHeaderSI."bill-to Customer No." := SaleHeaderSO."bill-to Customer No.";
            SaleHeaderSI."sell-to Customer No." := SaleHeaderSO."sell-to Customer No.";
            SaleHeaderSI."Shortcut Dimension 1 Code" := SaleHeaderSO."Shortcut Dimension 1 Code";
            SaleHeaderSI."Shortcut Dimension 2 Code" := SaleHeaderSO."Shortcut Dimension 2 Code";
            SaleHeaderSI."Dimension Set ID" := SaleHeaderSO."Dimension Set ID";
            SaleHeaderSI."Posting Date" := Today;
            SaleHeaderSI.Validate("sell-to Customer No.");
            SaleHeaderSI.Validate("bill-to Customer No.");
            SaleHeaderSI.Validate("Assigned User ID", 'SULAIMAN');
            SaleHeaderSI."External Document No." := SaleOrderNo;
            SaleHeaderSI.InitInsert();
            SaleHeaderSI.insert(true);

            SaleLineSO.SetRange("Document Type", Enum::"Sales Document Type"::Order);
            SaleLineSO.SetRange("Document No.", SaleOrderNo);
            cpt := 1;
            if SaleLineSO.FindSet() then begin
                repeat
                    SaleLineSI[cpt].Init();
                    SaleLineSI[cpt]."Document Type" := Enum::"Sales Document Type"::Invoice;
                    SaleLineSI[cpt]."Document No." := SaleHeaderSI."No.";

                    SaleLineSI[cpt].Type := SaleLineSO.Type;
                    SaleLineSI[cpt]."No." := SaleLineSO."No.";
                    SaleLineSI[cpt]."line No." := SaleLineSO."line No.";
                    SaleLineSI[cpt].Description := SaleLineSO.Description;
                    SaleLineSI[cpt]."Dimension Set ID" := SaleLineSO."Dimension Set ID";
                    SaleLineSI[cpt].Quantity := SaleLineSO.Quantity;
                    SaleLineSI[cpt].Validate(Quantity);
                    SaleLineSI[cpt]."Unit Price" := SaleLineSO."Commission Without VAT";
                    SaleLineSI[cpt]."Unit of Measure Code" := SaleLineSO."Unit of Measure Code";
                    SaleLineSI[cpt]."Gen. Prod. Posting Group" := SaleLineSO."Gen. Prod. Posting Group";
                    SaleLineSI[cpt]."Shortcut Dimension 1 Code" := SaleLineSO."Shortcut Dimension 1 Code";
                    SaleLineSI[cpt]."Shortcut Dimension 2 Code" := SaleLineSO."Shortcut Dimension 2 Code";

                    SaleLineSI[cpt]."VAT Bus. Posting Group" := 'DOMESTIC';
                    SaleLineSI[cpt]."VAT Prod. Posting Group" := 'STAND(15%)';

                    SaleLineSI[cpt].Validate("Unit Price");
                    SaleLineSI[cpt].Validate("VAT Prod. Posting Group");
                    SaleLineSI[cpt].Validate("VAT Bus. Posting Group");


                    SaleLineSI[cpt].Insert(true);
                    cpt := cpt + 1;
                until SaleLineSO.Next() = 0;
            end;


        end;
    end;



    //********************** Journal payment ********

    local procedure createPaymtJnl(SalesOrder_No: code[20])
    var
        PayJournal: Record "Gen. Journal Line";
        PayJournal2: Record "Gen. Journal Line";
        PayJournalAtt: Record "Gen. Journal Line";
        incomDoc: Record "Incoming Document";
        salesHeader: Record "Sales Header";
        salesLine: Record "Sales line";
        landRec: Record Land;
        landRec1: Record Land;
        NoSeri: Codeunit "No. Series";

        Amount: Decimal;
        //cpt: Integer;
        LandCode: Code[20];
    begin
        //cpt := 0;
        Amount := 0;
        salesHeader.SetRange("Document Type", Enum::"Sales Document Type"::Order);
        salesHeader.SetRange("No.", SalesOrder_No);
        salesLine.SetRange("Document Type", Enum::"Sales Document Type"::Order);
        salesLine.SetRange("Document No.", SalesOrder_No);

        if salesLine.FindSet() then begin
            repeat
                Amount := salesLine."Commission With VAT" + Amount;
                landRec1.SetRange("Instrument number", salesLine."No.");
                if landRec1.FindFirst() then begin
                    LandCode := landRec1."Land Code"; // Assign the Land Code if found
                end;
            until salesLine.Next() = 0;
        end;
        /*PayJournal2.SetRange("Journal Template Name", 'PAYMENT');
        PayJournal2.SetRange("Journal Batch Name", 'FORM');
        PayJournal2.SetRange("Source Code", 'PAYMENTJNL');
        if PayJournal2.FindSet() then cpt := PayJournal2.Count();*/

        if not salesHeader.FindFirst() then
            Error('Sales order %1 not found.', SalesOrder_No);
        //This is checking for if the customer have a commission or not
        if not salesHeader."With Commission?" then
            exit;

        if salesHeader.FindSet() then begin
            PayJournal.Init();
            PayJournal."Posting Date" := Today;
            //PayJournal."Line No." := cpt * 10000 + 10000;
            PayJournal2.Reset();
            PayJournal."Line No." := PayJournal2.GetNewLineNo('PAYMENT', 'FORM');
            PayJournal."Document No." := SalesOrder_No;
            PayJournal.Validate("Posting Date");
            PayJournal."Journal Template Name" := 'PAYMENT';
            PayJournal."Source Code" := 'PAYMENTJNL';
            PayJournal."Journal Batch Name" := 'FORM';
            PayJournal.Validate("Journal Batch Name");
            PayJournal."Document No." := NoSeri.GetNextNo('GJNL-PMT');
            PayJournal."Document Type" := Enum::"Gen. Journal Document Type"::Payment;
            PayJournal."Account Type" := Enum::"Gen. Journal Account Type"::"Bank Account";
            PayJournal."Account No." := 'RB10001';
            PayJournal.Validate("Account No.");


            PayJournal.Description := LandCode + ' ' + salesHeader."Sell-to Customer Name" + ' ' + SalesOrder_No + ' ' + 'سداد امر بيع ';

            PayJournal.Amount := Amount;
            PayJournal.Validate(Amount);

            PayJournal."Bal. Account Type" := Enum::"Gen. Journal Account Type"::Customer;
            PayJournal."Bal. Account No." := salesHeader."Sell-to Customer No.";
            PayJournal.Validate("Bal. Account No.");

            PayJournal."Payment Method Code" := 'BANK';
            PayJournal.Validate("Payment Method Code");
            PayJournal.Insert();
            /// Attachemnt 
            /// 
            if salesHeader.IDs <> '' then begin


                PayJournalAtt.SetRange(SystemId, salesHeader.IDs);
                if PayJournalAtt.FindSet() then begin
                    PayJournal."Incoming Document Entry No." := PayJournalAtt."Incoming Document Entry No.";
                    PayJournalAtt."Incoming Document Entry No." := 0;
                    PayJournalAtt.Modify();
                    incomDoc.SetRange("Entry No.", PayJournal."Incoming Document Entry No.");
                    if incomDoc.FindFirst() then begin
                        incomDoc."Related Record ID" := PayJournal.RecordId;
                        incomDoc.Description := 'Red Palm Sales Order ' + SalesOrder_No;
                        incomDoc.Modify();
                    end;
                end;
            end;
        end;
        landRec.SetRange("Instrument number", salesLine."No.");
        if landRec.FindSet() then begin
            landRec.Status := landRec.Status::Sold;
            landRec.Modify();
        end;
        //PayJournal.Insert();

    end;

    /////
    /// 
    /// 
    /// 

    local procedure getToken(): Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        IsSuccessful: Boolean;
        uri: Text;
        AccessToken: Text;
        responseText: Text;
        JSONManagement: Codeunit "JSON Management";
        lJsonObjectLine: JsonObject;
    begin

        uri := 'https://login.microsoftonline.com/9b540f11-2b5c-4c74-bb40-a4d22950e763/oauth2/v2.0/token';
        //RequestURI := 'https://httpcats.com/418.json';

        content.WriteFrom('grant_type=client_credentials&client_id=bc5388d5-324e-4cae-8e02-49ffeaa5419f&client_secret=sTH8Q~S5XCp3v7r4LSIO6e~-13OfATf2Xme56bNw&scope=https://api.businesscentral.dynamics.com/.default');

        // Replace the default content type header with a header associated with this request
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in 
        // the content associated with the request message
        request.Content := content;

        request.SetRequestUri(uri);
        request.Method := 'POST';

        IsSuccessful := client.Send(request, response);

        if not IsSuccessful then begin
            // handle the error
        end;

        if not response.IsSuccessStatusCode() then begin
            // handle the error
        end;

        // Read the response content as json.
        response.Content.ReadAs(responseText);
        ;
        // GetJsonToken(lJsonObjectHeader, 'type').AsValue().AsText();
        JSONManagement.InitializeObject(responseText);
        JSONManagement.GetArrayPropertyValueAsStringByName('access_token', AccessToken);
        exit(AccessToken);
    end;

    ////
    /// 
    /// 
    /// 
    /// 
    ///  create payment lines in construction company
    /// 

    local procedure createPaymtJnlConstruction(SalesOrder_No: code[20])
    var
        PayJournal: array[10] of Record "Gen. Journal Line";
        PayJournal2: Record "Gen. Journal Line";
        salesHeader: Record "Sales Header";
        salesLine: Record "Sales line";
        NoSeri: Codeunit "No. Series";
        cust: Record Customer;
        cust2: Record Customer;
        cpt: Decimal;
        cpt2: Decimal;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        land: Record Land;
        landRec1: Record Land;
        LandCode: Code[20];

        PriceText: Text;
        CustEmailText: Text;
        piecePriceText: Text;

        //  parameter for Sales Invoice
        SI_HttpClient: HttpClient;
        SI_HttpHeaders: HttpHeaders;
        SI_Content: HttpContent;
        SI_HttpRequestMessage: HttpRequestMessage;
        SI_HttpResponseMessage: HttpResponseMessage;

        SI_AccessToken: Text;
        SI_ResponseBody: Text;


        SI_jsonbjet: JsonObject;
        SI_jsonbjettext: text;

        // parameter fpr purhcase invooice 
        PI_HttpClient: HttpClient;
        PI_HttpHeaders: HttpHeaders;
        PI_Content: HttpContent;
        PI_HttpRequestMessage: HttpRequestMessage;
        PI_HttpResponseMessage: HttpResponseMessage;

        PI_AccessToken: Text;
        PI_ResponseBody: Text;


        PI_jsonbjet: JsonObject;
        PI_jsonbjettext: text;

    begin
        if salesLine.FindSet() then begin
            repeat
                landRec1.SetRange("Instrument number", salesLine."No.");
                if landRec1.FindFirst() then begin
                    LandCode := landRec1."Land Code"; // Assign the Land Code if found
                end;
            until salesLine.Next() = 0;
        end;

        cpt := 0;

        PayJournal2.SetRange("Journal Template Name", 'PAYMENT');
        PayJournal2.SetRange("Journal Batch Name", 'LANDS');
        PayJournal2.SetRange("Source Code", 'PAYMENTJNL');
        if PayJournal2.FindSet() then cpt2 := PayJournal2.Count();
        salesLine.SetRange("Document No.", SalesOrder_No);
        if salesLine.FindSet() then begin
            repeat
                land.Reset();
                land.SetRange("Instrument number", salesLine."No.");
                if land.FindSet() then begin
                    if land.IsOwnedByQuaedAlinma then begin
                        //createSaleInvoiceAS(Rec."No.");
                        cpt := cpt + 1;
                        PayJournal[cpt].ChangeCompany('ALINMA FOR CONSTRUCTION');
                        PayJournal2.ChangeCompany('ALINMA FOR CONSTRUCTION');
                        cust.ChangeCompany('ALINMA FOR CONSTRUCTION');
                        PurchHeader.ChangeCompany('ALINMA FOR CONSTRUCTION');
                        PurchLine.ChangeCompany('ALINMA FOR CONSTRUCTION');


                        cust2.SetRange("No.", Rec."Sell-to Customer No.");
                        if cust2.FindSet() then begin
                            CustEmailText := cust2."E-Mail";

                        end;




                        ////
                        /// 
                        /// 
                        /// 
                        /// 
                        ///***** Create Sales Invoice 
                        // Obtain access token
                        SI_AccessToken := getToken();

                        // Set Authorization header
                        SI_HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + SI_AccessToken);

                        SI_jsonbjet.Add('custNo', cust2."No.");
                        SI_jsonbjet.Add('custName', cust2.Name);
                        SI_jsonbjet.Add('custEmail', cust2."E-Mail");
                        SI_jsonbjet.Add('custPhone', cust2."Phone No.");
                        SI_jsonbjet.Add('pieceNo', land."Land Code");
                        PriceText := Format(salesLine."Net Value");
                        SI_jsonbjet.Add('piecePrice', PriceText);


                        SI_jsonbjet.WriteTo(SI_jsonbjettext);

                        SI_Content.WriteFrom(SI_jsonbjettext);


                        SI_Content.GetHeaders(SI_HttpHeaders);
                        SI_HttpHeaders.Clear();
                        SI_HttpHeaders.Add('Content-Type', 'application/json');
                        SI_HttpRequestMessage.Content := SI_Content;
                        SI_HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/PROD/ODataV4/ConstrcApi_CreateSI?company=ALINMA%20FOR%20CONSTRUCTION');
                        SI_HttpRequestMessage.Method('POST');
                        SI_HttpClient.Send(SI_HttpRequestMessage, SI_HttpResponseMessage);
                        ////
                        /// 
                        ///     
                        ///***** Create Purchase Invoice 
                        ////
                        /// 
                        ///
                        // Obtain access token
                        /*PI_AccessToken := getToken();

                        // Set Authorization header
                        PI_HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + PI_AccessToken);

                        PI_jsonbjet.Add('pieceNo', land."Land Code");
                        piecePriceText := Format(salesLine."Net Value" * 0.0125);
                        PI_jsonbjet.Add('piecePrice', piecePriceText);
                        PI_jsonbjet.WriteTo(PI_jsonbjettext);

                        PI_Content.WriteFrom(PI_jsonbjettext);
                        PI_Content.GetHeaders(PI_HttpHeaders);
                        PI_HttpHeaders.Clear();
                        PI_HttpHeaders.Add('Content-Type', 'application/json');
                        PI_HttpRequestMessage.Content := PI_Content;
                        PI_HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/PROD/ODataV4/ConstrcApi_CreatePI?company=ALINMA%20FOR%20CONSTRUCTION');
                        PI_HttpRequestMessage.Method('POST');
                        PI_HttpClient.Send(PI_HttpRequestMessage, PI_HttpResponseMessage);*/
                        /// 
                        /// 
                        /// 

                        ////
                        /// 
                        /// 

                        PayJournal[cpt].Init();

                        PayJournal[cpt]."Posting Date" := Today;
                        PayJournal[cpt]."Line No." := 20000 + Random(10000);
                        PayJournal[cpt].Validate("Posting Date");
                        PayJournal[cpt]."Journal Template Name" := 'PAYMENT';
                        PayJournal[cpt]."Source Code" := 'PAYMENTJNL';
                        PayJournal[cpt]."Journal Batch Name" := 'LANDS';
                        PayJournal[cpt].Validate("Journal Batch Name");
                        PayJournal[cpt]."Document No." := NoSeri.GetNextNo('GJNL-PMT');
                        PayJournal[cpt]."Document Type" := PayJournal[cpt]."Document Type"::Payment;
                        PayJournal[cpt]."Account Type" := PayJournal[cpt]."Account Type"::"Bank Account";
                        PayJournal[cpt]."Account No." := 'C10003';
                        // PayJournal.Validate("Account No.");

                        PayJournal[cpt].Description := LandCode + ' ' + Rec."Sell-to Customer Name" + ' ' + SalesOrder_No + ' ' + 'حوالة';

                        PayJournal[cpt].Amount := salesLine."Net Value";
                        PayJournal[cpt].Validate(Amount);

                        PayJournal[cpt]."Bal. Account Type" := PayJournal[cpt]."Bal. Account Type"::Customer;
                        cust.SetRange("E-Mail", CustEmailText);
                        if cust.FindSet() then PayJournal[cpt]."Bal. Account No." := cust."No.";
                        // PayJournal.Validate("Bal. Account No.");

                        PayJournal[cpt]."Payment Method Code" := 'BANK';
                        PayJournal[cpt].Validate("Payment Method Code");
                        PayJournal[cpt].Insert();





                    end;
                end;
            until salesLine.Next() = 0;
        end;

    end;

    // send whats app message to customer 
    /// 
    /// 
    /// 
    /// 

    procedure sendQuotation2Cust()
    var

        cust: Record Customer;
        SI_HttpClient: HttpClient;
        SI_HttpHeaders: HttpHeaders;
        SI_Content: HttpContent;
        SI_HttpRequestMessage: HttpRequestMessage;
        SI_HttpResponseMessage: HttpResponseMessage;

        SI_AccessToken: Text;
        SI_ResponseBody: Text;


        SI_jsonbjet: JsonObject;
        SI_jsonbjettext: text;

        res: text;
        resjson: JsonObject;
        value: JsonToken;
        valueText: text;
    begin


        SI_AccessToken := getToken();

        // Set Authorization header
        SI_HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + SI_AccessToken);

        SI_jsonbjet.Add('reportNO', 50106);
        SI_jsonbjet.Add('parameters', '<?xml version="1.0" standalone="yes"?><ReportParameters name="PrintQuotationReport" id="50106"><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(1),Field3=1(' + Rec."No." + '))</DataItem><DataItem name="Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="Marketer">VERSION(1) SORTING(Field50001,Field50003)</DataItem></DataItems></ReportParameters>');



        SI_jsonbjet.WriteTo(SI_jsonbjettext);

        SI_Content.WriteFrom(SI_jsonbjettext);


        SI_Content.GetHeaders(SI_HttpHeaders);
        SI_HttpHeaders.Clear();
        SI_HttpHeaders.Add('Content-Type', 'application/json');
        SI_HttpRequestMessage.Content := SI_Content;
        SI_HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/9b540f11-2b5c-4c74-bb40-a4d22950e763/PROD/ODataV4/MStest_RunReport?company=ALINMA%20FOR%20REAL%20ESTATE');
        SI_HttpRequestMessage.Method('POST');
        SI_HttpClient.Send(SI_HttpRequestMessage, SI_HttpResponseMessage);

        SI_HttpResponseMessage.Content.ReadAs(res);
        resjson.ReadFrom(res);
        resjson.Get('value', value);
        value.WriteTo(valueText);
        //  Message(valueText);
        valueText := valueText.Replace('=', '%3D');
        valueText := valueText.Replace('+', '%2B');
        valueText := valueText.Replace('/', '%2F');
        valueText := valueText.Replace('"', '');
        //Message(valueText);
        cust.SetRange("No.", Rec."Sell-to Customer No.");
        if cust.FindSet() then
            SendDocumentToWhatsApp(valueText, cust."Phone No.", Rec."No.");
    end;

    local procedure SendDocumentToWhatsApp(reportB64: Text; customerPhoneNo: Text; saleOrderNo: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        Base64Text: Text;
        Base64EncodedText: Text;
        ErrorMessage: Text;
        FileName: Text;
        InstanceID: Text;
        Token: Text;
        ToPhoneNumber: Text;
        FileData: InStream;
        FilePath: Text;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
        ResultCode: Integer;
        FileManagement: Codeunit "File Management";
        base64report: Text;
        caption: Text;

    begin
        // Set up variables
        InstanceID := 'instance95060';  // Your instance ID
        Token := 'y6d5yjg7fj3z7stt';       // Your token
        ToPhoneNumber := customerPhoneNo;// Recipient phone number
        FileName := 'Sales Quotation ' + saleOrderNo + '.pdf';
        caption := 'Dear Customer this is your quotation ';
        // Read the file and convert to Base64

        Base64EncodedText := reportB64;
        // Base64EncodedText := Base64EncodedText.Replace('=', '%3D');
        // Base64EncodedText := Base64EncodedText.Replace('+', '%2B');
        // Base64EncodedText := Base64EncodedText.Replace('/', '%2F');
        // Base64EncodedText := Base64EncodedText.Replace('"', '');
        // Prepare the request
        HttpContent.WriteFrom('token=' + Token + '&to=' + ToPhoneNumber + '&document=' + Base64EncodedText + '&filename=' + FileName + '&caption=' + caption);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Create the HTTP request
        HttpRequestMessage.SetRequestUri('https://api.ultramsg.com/' + InstanceID + '/messages/document');
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content := HttpContent;

        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            ResultCode := HttpResponseMessage.HttpStatusCode;
        end;
        //     if ResultCode = 200 then
        //         Message('Document sent successfully: %1', ResponseText)
        //     else
        //         Error('Failed to send document. Status Code: %1. Response: %2', ResultCode, ResponseText);
        // end else begin
        //     HttpResponseMessage.Content.ReadAs(ErrorMessage);
        //     Error('Request failed: %1', ErrorMessage);
        // end;
    end;
    ////
    /// 
    /// 
    /// 
    /// 


    local procedure SendInvTaxToWhatsApp(reportB64: Text; customerPhoneNo: Text; saleOrderNo: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        Base64Text: Text;
        Base64EncodedText: Text;
        ErrorMessage: Text;
        FileName: Text;
        InstanceID: Text;
        Token: Text;
        ToPhoneNumber: Text;
        FileData: InStream;
        FilePath: Text;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
        ResultCode: Integer;
        FileManagement: Codeunit "File Management";
        base64report: Text;
        caption: Text;

    begin
        // Set up variables
        InstanceID := 'instance95060';  // Your instance ID
        Token := 'y6d5yjg7fj3z7stt';       // Your token
        ToPhoneNumber := customerPhoneNo;// Recipient phone number
        FileName := 'Retax Invoice ' + saleOrderNo + '.pdf';
        caption := 'Dear Customer , please find above the retax invoice ';
        // Read the file and convert to Base64

        Base64EncodedText := reportB64;
        // Base64EncodedText := Base64EncodedText.Replace('=', '%3D');
        // Base64EncodedText := Base64EncodedText.Replace('+', '%2B');
        // Base64EncodedText := Base64EncodedText.Replace('/', '%2F');
        // Base64EncodedText := Base64EncodedText.Replace('"', '');
        // Prepare the request
        HttpContent.WriteFrom('token=' + Token + '&to=' + ToPhoneNumber + '&document=' + Base64EncodedText + '&filename=' + FileName + '&caption=' + caption);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Create the HTTP request
        HttpRequestMessage.SetRequestUri('https://api.ultramsg.com/' + InstanceID + '/messages/document');
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content := HttpContent;

        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            ResultCode := HttpResponseMessage.HttpStatusCode;
        end;
        //     if ResultCode = 200 then
        //         Message('Document sent successfully: %1', ResponseText)
        //     else
        //         Error('Failed to send document. Status Code: %1. Response: %2', ResultCode, ResponseText);
        // end else begin
        //     HttpResponseMessage.Content.ReadAs(ErrorMessage);
        //     Error('Request failed: %1', ErrorMessage);
        // end;
    end;
    /// 
    /// 
    /// 
    /// 
    /// 
    /// 
    /// 
    /////
    /// 
    procedure sendRetaxInvToCust()
    var
        Base64Convert: Codeunit "Base64 Convert";
        cust: Record Customer;
        incDoc: Record "Incoming Document Attachment";
        saleHeader: Record "Sales Header";
        InStr: InStream;
        LargeText: Text;
        TempBlob: Codeunit "Temp Blob";
    begin
        saleHeader.SetRange("No.", rec."No.");
        if saleHeader.FindSet() then begin
            incDoc.SetRange("Incoming Document Entry No.", saleHeader."Incoming Document Entry No.");
            incDoc.SetFilter(Name, '*tax*');
            if incDoc.FindSet() then begin
                incDoc.GetContent(TempBlob);
                TempBlob.CreateInStream(InStr);

                LargeText := Base64Convert.ToBase64(InStr, false);
                LargeText := LargeText.Replace('=', '%3D');
                LargeText := LargeText.Replace('+', '%2B');
                LargeText := LargeText.Replace('/', '%2F');
                cust.SetRange("No.", Rec."Sell-to Customer No.");
                if cust.FindSet() then
                    SendInvTaxToWhatsApp(LargeText, cust."Phone No.", Rec."No.");

            end;
        end;
    end;

    /// 
    /// 
    /// 
    /// 
    [ServiceEnabled]
    [Scope('Cloud')]
    procedure CreatePurch_Invoices(var ActionContext: WebServiceActionContext)
    var
        marketer: Record Marketer;
    begin

        //createPurchaseInvoice(Rec."No.");
        Marketer.SetRange("Document No.", rec."No.");
        if Marketer.FindSet() then begin
            repeat
                createPurchaseInvoice(Marketer."No.", Rec."No.", Marketer.Percentage);
            until Marketer.Next() = 0;
        end;
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;




    [ServiceEnabled]
    [Scope('Cloud')]
    procedure CreateSales_Invoices(var ActionContext: WebServiceActionContext)
    var

    begin

        createSaleInvoice(rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    /*[ServiceEnabled]
    [Scope('Cloud')]
    procedure CreateSales_InvoicesAS(var ActionContext: WebServiceActionContext)
    var

    begin

        createSaleInvoiceAS(rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;*/

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure CreatePayment_Lines(var ActionContext: WebServiceActionContext)
    var

    begin

        createPaymtJnl(rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure CreatePayment_LinesConstr(var ActionContext: WebServiceActionContext)
    var

    begin

        createPaymtJnlConstruction(rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure sendWhatsappToCust(var ActionContext: WebServiceActionContext)
    var

    begin

        sendQuotation2Cust();
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure sendInvTaxToCust(var ActionContext: WebServiceActionContext)
    var

    begin

        sendRetaxInvToCust();
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;
}