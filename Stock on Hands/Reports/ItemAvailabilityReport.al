report 50130 ItemAvailabilityReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Stock on hand';
    DefaultRenderingLayout = MyExcelLayout;

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(Item_No; qr_Item_No)
            {

            }
            column(Description; Description)
            {

            }
            column(BaseUnit; BaseUnit)
            {

            }
            column(Unit_Cost; Unit_Cost)
            {

            }
            column(Stock_On_Hand; qr_StockOnHand)
            {

            }
            column(Total_Cost; qr_Cost_Amount)
            {

            }
            column(Quantity_Purchases; qr_InQuantity_Purchases)
            {

            }
            column(Total_Purchases; qr_Purchases)
            {

            }
            column(Quantity_Consumed; qr_InQuantity_Consumed)
            {

            }
            column(Total_Consumption; qr_Consumption)
            {

            }
            column("Gen_Prod_Posting_Group"; Gen_Prod_Posting_Group)
            {

            }
            column(Item_Catogry; Item_Catogry_desc)
            {

            }
            column(Location_Code; qr_Location_Code)
            {

            }
            column(StartDate; StartDate)
            {

            }
            column(EndDate; EndDate)
            {

            }



            trigger OnAfterGetRecord()
            begin
                qr_Cost_Amount := 0;
                qr_StockOnHand := 0;
                qr_InQuantity_Consumed := 0;
                qr_InQuantity_Purchases := 0;
                qr_Consumption := 0;
                qr_Purchases := 0;
                Unit_Cost := 0;
                if qr_Base.Read() then begin
                    qr_Item_No := qr_Base.Item_No_;
                    qr_Location_Code := qr_Base.Location_Code;

                    //Get the Description from the "Item List" table
                    begin
                        if DescRec.Get(qr_Base.Item_No_) then
                            Description := DescRec.Description;
                    end;

                    //Get the BaseUnit from the "Item List" table
                    begin
                        if BaseUnitRec.Get(qr_Base.Item_No_) then
                            BaseUnit := BaseUnitRec."Base Unit of Measure";
                    end;

                    //Get the UnitCost from the "Item List" table
                    begin
                        if UnitCostRec.Get(qr_Base.Item_No_) then
                            Unit_Cost := UnitCostRec."Unit Cost";
                    end;

                    //Get the "Gen. Prod. Posting Group" from the "Item List" table
                    begin
                        if GenProdPGRec.Get(qr_Base.Item_No_) then
                            Gen_Prod_Posting_Group := GenProdPGRec."Gen. Prod. Posting Group";
                    end;

                    //Get the "Item Catogry code" from the "Item List" table
                    begin
                        if ItemCatRec.Get(qr_Base.Item_No_) then
                            Item_Catogry := ItemCatRec."Item Category Code";
                    end;

                    //Get the "Item Catogry Description" from the "Item Catogry" table
                    begin
                        if ItemCatDescRec.Get(ItemCatRec."Item Category Code") then
                            Item_Catogry_desc := ItemCatDescRec.Description;
                    end;

                    //creating In Quantity
                    qr_In.SetRange(qr_In.Item_No_, qr_Base.Item_No_);
                    qr_In.SetRange(qr_In.Location_Code, qr_Base.Location_Code);

                    //filter the data of qr_In to make the range based on the entered data (The entered dates)
                    CASE TRUE OF
                        (StartDate <> 0D) and (EndDate <> 0D):
                            //if StartDate not equal to the default value and EndDate not equal to the default value set the range
                            qr_In.SetRange(qr_In.Posting_Date, StartDate, EndDate);
                        (StartDate <> 0D):
                            qr_In.SetRange(qr_In.Posting_Date, StartDate, DMY2Date(31, 12, 9999));
                        (EndDate <> 0D):
                            qr_In.SetRange(qr_In.Posting_Date, 0D, EndDate);
                        (StartDate = 0D) and (EndDate = 0D):
                            qr_In.SetRange(qr_In.Posting_Date, 0D, DMY2Date(31, 12, 9999));
                    END;

                    qr_In.Open();
                    while qr_In.Read() do begin
                        qr_StockOnHand += qr_In.Quantity;
                        if qr_In.Quantity < 0 then
                            qr_InQuantity_Consumed += qr_In.Quantity
                        else
                            qr_InQuantity_Purchases += qr_In.Quantity;

                        qr_Cost_Amount := Unit_Cost * qr_StockOnHand;
                        qr_Consumption := Unit_Cost * qr_InQuantity_Consumed;
                        qr_Purchases := Unit_Cost * qr_InQuantity_Purchases;

                    end;
                    qr_In.Close();

                    //if the Pre and In and Post equal to 0 then skip
                    if (qr_InQuantity_Consumed = 0) and (qr_InQuantity_Purchases = 0) then
                        CurrReport.Skip();
                end
                else begin
                    CurrReport.Skip();
                end;
            end;



            trigger OnPreDataItem()
            begin
                Counter := 0;

                //if the location code given set the filter else all records will be given
                IF loc <> '' THEN
                    qr_Base.SetFilter(qr_Base.Location_Code, loc);

                qr_Base.Open();
                while qr_Base.Read do begin
                    Counter += 1;
                end;
                SetRange(Number, 1, Counter);
                qr_Base.TopNumberOfRows(Counter);
                qr_Base.Open();
            end;

            trigger OnPostDataItem()
            begin
                qr_Base.Close();
                qr_In.Close();
            end;

        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {

            area(Content)
            {

                group(Filter)
                {
                    field("Location Code"; loc)
                    {
                        ApplicationArea = All;
                        DrillDown = true;
                        trigger OnDrillDown()
                        begin
                            if PAGE.RunModal(PAGE::"Location List", LocationRec) = ACTION::LookupOK then
                                loc := LocationRec.Code;
                        end;
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = all;
                    }
                }

            }

        }


        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    rendering
    {
        layout(MyExcelLayout)
        {
            Type = Excel;
            LayoutFile = 'Layouts/StockOnHand.xlsx';
        }
        layout(MyRDCL)
        {
            Type = RDLC;
            LayoutFile = 'Layouts/StockOnHand.rdl';
        }
    }

    var
        //Queries
        qr_Base: Query ItemAvailabilityQuery;
        qr_In: Query ItemAvailabilityQuery;

        //Records
        DescRec: Record Item;
        BaseUnitRec: Record Item;
        GenProdPGRec: Record Item;
        UnitCostRec: Record Item;
        LocationRec: Record "Location";
        ItemCatRec: Record Item;
        ItemCatDescRec: Record "Item Category";

        //Items
        Description: Text;
        BaseUnit: Text;
        Unit_Cost: Decimal;
        Gen_Prod_Posting_Group: Code[30];
        Item_Catogry: Text;
        Item_Catogry_desc: Text;

        counter: Integer;
        loc: Code[20];
        StartDate: Date;
        EndDate: Date;

        //Query items
        qr_Location_Code: Text;
        qr_InQuantity_Consumed: Decimal;
        qr_InQuantity_Purchases: Decimal;
        qr_StockOnHand: Decimal;
        qr_Consumption: Decimal;
        qr_Purchases: Decimal;
        qr_Item_No: Code[30];
        qr_Cost_Amount: Decimal;
}