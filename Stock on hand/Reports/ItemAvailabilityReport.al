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
            column(Quantity; qr_Quantity)
            {

            }
            column(Location_Code; qr_Location_Code)
            {

            }
            column(BaseUnit; BaseUnit)
            {

            }

            trigger OnAfterGetRecord()
            begin
                if qr.Read() then begin
                    qr_Quantity := qr.Quantity;
                    qr_Item_No := qr.Item_No_;
                    qr_Location_Code := qr.Location_Code;
                    //Get the Description from the "Item List" table
                    begin
                        if DescRec.Get(qr.Item_No_) then
                            Description := DescRec.Description;
                    end;
                    //Get the BaseUnit from the "Item List" table
                    begin
                        if BaseUnitRec.Get(qr.Item_No_) then
                            BaseUnit := BaseUnitRec."Base Unit of Measure";
                    end;
                end
                else begin
                    CurrReport.Skip();
                end;
            end;



            trigger OnPreDataItem()
            begin
                Counter := 0;
                qr.SetFilter(qr.Location_Code, loc);
                //remove all zeros Quantity
                qr.SetFilter(qr.Quantity, '<>%1', 0);
                qr2.Open();
                while qr2.Read do begin
                    Counter += 1;
                end;
                SetRange(Number, 1, Counter);
                qr.TopNumberOfRows(Counter);
                qr.Open();
            end;

            trigger OnPostDataItem()
            begin
                qr.Close();
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
        qr: Query ItemAvailabilityQuery;
        qr2: Query ItemAvailabilityQuery;
        DescRec: Record Item;
        BaseUnitRec: Record Item;
        Description: Text;
        BaseUnit: Text;
        counter: Integer;
        qr_Location_Code: Text;
        qr_Quantity: Decimal;
        qr_Item_No: Code[30];
        LocationRec: Record "Location";
        loc: Code[20];
}