codeunit 50558 "ConstrcApi"
{

    procedure CreateSI(
        custNo: Text;
        custName: Text;
        custEmail: Text;
        custPhone: Text;
        pieceNo: text;
        piecePrice: text
    )
    var
        saleHeader: Record "Sales Header";
        saleLine: Record "Sales Line";

        customer: Record Customer;
        Newcustomer: Record Customer;
        pieceAmount: Decimal;

        land: Record Item;
        NoSeri: Codeunit "No. Series";
    begin

        saleHeader.Init();
        saleHeader."Document Type" := Enum::"Sales Document Type"::Invoice;
        saleHeader."No." := NoSeri.GetNextNo('S-INV');


        customer.SetRange("Phone No.", custPhone);
        if customer.FindSet() then begin

            saleHeader."Bill-to Customer No." := customer."No.";
            saleHeader."Sell-to Customer No." := customer."No.";



        end else begin
            /// create customer 
            Newcustomer."No." := NoSeri.GetNextNo('CUST');
            Newcustomer.Name := custName;
            Newcustomer."Phone No." := custPhone;
            Newcustomer."E-Mail" := custEmail;
            Newcustomer."Gen. Bus. Posting Group" := 'DOMESTIC';
            Newcustomer."VAT Bus. Posting Group" := 'DOMESTIC';
            Newcustomer."Customer Posting Group" := 'LANDS';
            Newcustomer."Currency Code" := 'SAR';
            Newcustomer."Payment Terms Code" := '14 DAYS';
            Newcustomer."Payment Method Code" := 'CASH';
            Newcustomer."Zatca Customer Type" := Newcustomer."Zatca Customer Type"::Individual;
            Newcustomer.Insert();

            // Create Default Dimensions for the new customer
            CreateDefaultDimensionsForCustomer(Newcustomer."No.");
            saleHeader."Bill-to Customer No." := Newcustomer."No.";
            saleHeader."Sell-to Customer No." := Newcustomer."No.";
        end;





        saleHeader."Posting Date" := Today;
        saleHeader."Document Date" := Today;
        saleHeader.Validate("Sell-to Customer No.");
        saleHeader.Validate("Bill-to Customer No.");


        saleHeader.Validate("Posting Date");
        saleHeader.Validate("Document Date");
        saleHeader.Insert();

        // create sale lien
        saleLine.Init();
        saleLine."Document Type" := Enum::"Sales Document Type"::Invoice;
        saleLine."Document No." := saleHeader."No.";
        saleLine.Type := Enum::"Sales Line Type"::Item;
        saleLine."Line No." := 10000;
        saleLine."No." := pieceNo;
        saleLine.Validate("No.");
        Evaluate(pieceAmount, piecePrice);
        saleLine.Quantity := 1;
        saleLine."Unit Price" := pieceAmount;


        saleLine.Validate(Quantity);
        saleLine.Validate("Unit Price");
        saleLine.Insert();
    end;

    local procedure CreateDefaultDimensionsForCustomer(CustomerNo: Code[20])
    var
        DefaultDim: Record "Default Dimension";
    // If you need to validate the Dimension Code or Dimension Value Code
    // you can also record lookup in "Dimension Value" etc. 
    begin
        // === 1) BUS-UNIT / CONSTRUCT ===
        // Upsert logic (check if it exists, otherwise insert)
        if DefaultDim.Get(Database::Customer, CustomerNo, 'BUS-UNIT') then begin
            DefaultDim.Validate("Dimension Value Code", 'CONSTRUCT');
            DefaultDim.Modify();
        end else begin
            DefaultDim.Init();
            DefaultDim."Table ID" := Database::Customer;  // Link to Customer
            DefaultDim."No." := CustomerNo;
            DefaultDim."Dimension Code" := 'BUS-UNIT';
            DefaultDim.Validate("Dimension Value Code", 'CONSTRUCT');
            DefaultDim.Insert();
        end;

        // === 2) PROJECTS ===
        if DefaultDim.Get(Database::Customer, CustomerNo, 'PROJECTS') then begin
            DefaultDim.Modify();
        end else begin
            DefaultDim.Init();
            DefaultDim."Table ID" := Database::Customer;  // Link to Customer
            DefaultDim."No." := CustomerNo;
            DefaultDim."Dimension Code" := 'PROJECTS';
            DefaultDim.Insert();
        end;
    end;

    procedure CreatePI(

            pieceNo: text;
            piecePrice: text
        )
    var
        purchHeader: Record "Purchase Header";
        purchLine: Record "Purchase Line";
        servicePrice: Decimal;

    begin

        purchHeader.Init();
        purchHeader."Document Type" := Enum::"Purchase Document Type"::Invoice;
        purchHeader."Buy-from Vendor No." := 'CV10220';
        purchHeader."Posting Date" := Today;
        purchHeader.Validate("Buy-from Vendor No.");
        purchHeader.Validate("Posting Date");
        purchHeader.InitInsert();
        purchHeader.Insert();

        purchLine.Init();
        purchLine."Document No." := purchHeader."No.";
        purchLine."Document Type" := Enum::"Purchase Document Type"::Invoice;
        purchLine.Type := Enum::"Purchase Line Type"::Item;
        purchLine."Line No." := 1000;
        purchLine."No." := 'SER-00016';
        purchLine.Validate("No.");
        purchLine.Quantity := 1;

        Evaluate(servicePrice, piecePrice);
        purchLine."Direct Unit Cost" := servicePrice;
        purchLine.Validate("Direct Unit Cost");

        purchLine.Insert()


    end;
}