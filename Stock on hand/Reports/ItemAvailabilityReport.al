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
            column(Location_Code; qr_Location_Code)
            {

            }
            column(Unit_Cost; Unit_Cost)
            {

            }
            column(Cost_Amount; qr_Cost_Amount)
            {

            }
            column(BaseUnit; BaseUnit)
            {

            }
            column("Gen_Prod_Posting_Group"; Gen_Prod_Posting_Group)
            {

            }
            column(Item_Catogry; Item_Catogry_desc)
            {

            }
            column(StartDate; StartDate)
            {

            }
            column(EndDate; EndDate)
            {

            }
            column(PreQuantity; qr_PreQuantity)
            {

            }
            column(InQuantity; qr_InQuantity)
            {

            }
            column(PostQuantity; qr_PostQuantity)
            {

            }
            column(Stock_On_Hand; qr_StockOnHand)
            {

            }

            trigger OnAfterGetRecord()
            begin
                qr_Cost_Amount := 0;
                qr_StockOnHand := 0;
                qr_PreQuantity := 0;
                qr_InQuantity := 0;
                qr_PostQuantity := 0;
                Unit_Cost := 0;
                if qr_Base.Read() then begin
                    qr_Item_No := qr_Base.Item_No_;
                    qr_Location_Code := qr_Base.Location_Code;
                    qr_StockOnHand := qr_Base.Quantity;

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


                    //creating Pre Quantity
                    qr_Pre.SetRange(qr_Pre.Item_No_, qr_Base.Item_No_);
                    qr_Pre.SetRange(qr_Pre.Location_Code, qr_Base.Location_Code);
                    qr_Pre.SetFilter(qr_Pre.Posting_Date, '<%1', StartDate);
                    qr_Pre.Open();
                    if qr_Pre.Read() then begin
                        qr_PreQuantity := qr_Pre.Quantity;
                    end;
                    qr_Pre.Close();

                    //creating In Quantity
                    qr_In.SetRange(qr_In.Item_No_, qr_Base.Item_No_);
                    qr_In.SetRange(qr_In.Location_Code, qr_Base.Location_Code);
                    qr_In.SetRange(qr_In.Posting_Date, StartDate, EndDate);
                    qr_In.Open();
                    if qr_In.Read() then begin
                        qr_InQuantity := qr_In.Quantity;
                        qr_Cost_Amount := qr_In.Cost_Amount_Actual;
                    end;
                    qr_In.Close();

                    //creating Post Quantity
                    qr_Post.SetRange(qr_Post.Item_No_, qr_Base.Item_No_);
                    qr_Post.SetRange(qr_Post.Location_Code, qr_Base.Location_Code);
                    qr_Post.SetFilter(qr_Post.Posting_Date, '>%1', EndDate);
                    qr_Post.Open();

                    if qr_Post.Read() then begin
                        qr_PostQuantity := qr_Post.Quantity;
                    end;
                    qr_Post.Close();

                    //if the Pre and In and Post equal to 0 then skip
                    if (qr_PreQuantity = 0) and (qr_InQuantity = 0) and (qr_PostQuantity = 0) then
                        CurrReport.Skip();
                end
                else begin
                    CurrReport.Skip();
                end;
            end;



            trigger OnPreDataItem()
            begin
                Counter := 0;
                qr_Base.SetFilter(qr_Base.Location_Code, loc);

                //filter the data of qr_In to make the range based on the entered data (The entered dates)
                CASE TRUE OF
                    (StartDate <> 0D) and (EndDate <> 0D):
                        //if StartDate not equal to the default value and EndDate not equal to the default value set the range
                        qr_In.SetRange(qr_In.Posting_Date, StartDate, EndDate);
                    (StartDate <> 0D):
                        qr_In.SetRange(qr_In.Posting_Date, StartDate, DMY2Date(31, 12, 9999));
                    (EndDate <> 0D):
                        qr_In.SetRange(qr_In.Posting_Date, 0D, EndDate);
                END;

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
                qr_Pre.Close();
                qr_Post.Close();
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
        qr_Pre: Query ItemAvailabilityQuery;
        qr_In: Query ItemAvailabilityQuery;
        qr_Post: Query ItemAvailabilityQuery;

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
        qr_Posting_Date: Date;
        qr_PreQuantity: Decimal;
        qr_InQuantity: Decimal;
        qr_PostQuantity: Decimal;
        qr_StockOnHand: Decimal;
        qr_Item_No: Code[30];
        qr_Cost_Amount: Decimal;



}