report 50105 SalesOrderReport
{
    DefaultRenderingLayout = SalesOrderArabic;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "Document Type", "No.";
            column(Order_No; "No.")
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Customer_ID; "Customer ID")
            {

            }
            column(Date_of_Birth; "Date of Birth")
            {

            }
            column(Sell_to_Address; "Sell-to Address")
            {

            }
            column(Sell_to_Post_Code; "Sell-to Post Code")
            {

            }
            column(Sell_to_City; "Sell-to City")
            {

            }
            column(Sell_to_County; "Sell-to County")
            {

            }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code")
            {

            }
            column(Sell_to_E_Mail; "Sell-to E-Mail")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(Company_Name; CompanyInfo.Name)
            {

            }
            column(Company_Address; CompanyInfo.Address)
            {

            }
            column(Company_Address2; CompanyInfo."Address 2")
            {

            }
            column(Company_Post_Code; CompanyInfo."Post Code")
            {

            }
            column(Company_City; CompanyInfo.City)
            {

            }
            column(Company_Region; CompanyInfo."Country/Region Code")
            {

            }
            column(Plan_Name; "Plan Name")
            {

            }
            column(Plan_Code; "Plan Code")
            {

            }
            column(Owner_Name; "Owner Name")
            {

            }
            column(Payment_Method; "Payment Method")
            {

            }
            column(Bank_Type; "Bank Type")
            {

            }
            column(Sale_Source; "Sale Source")
            {

            }
            column(Conveyance_Agent; "Conveyance Agent")
            {

            }
            column(Cheque_Number; "Cheque Number")
            {

            }
            column(Conveyance_Date; "Conveyance Date")
            {

            }
            column(Conveyance_Bank; "Conveyance Bank")
            {

            }
            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                DataItemTableView = sorting("Document No.", "Line No.");

                column(Price_Per_Meter; "Price Per Meter")
                {

                }
                column(Commission_With_VAT; "Commission With VAT")
                {

                }
                column(Total_Commission_With_VAT; "Total Commission With VAT")
                {
                }
                column(Commission_Without_VAT; "Commission Without VAT")
                {

                }
                column(Total_Commission_Without_VAT; "Total Commission Without VAT")
                {
                }
                column(Inclusive_Value; "Inclusive Value")
                {

                }
                column(Total_Inclusive_Value; "Total Inclusive Value")
                {
                }
                column(Net_Value; "Net Value")
                {

                }
                column(Total_Net_Value; "Total Net Value")
                {
                }
                column(Retax_Value; "Retax Value")
                {

                }
                column(Total_Retax; "Total Retax")
                {
                }
                column(Total_Vat_of_Commission; "Total Vat of Commission")
                {

                }
                column(Description; Description)
                {

                }

                column(Instrument_number; Instrument_number)
                {

                }
                column("Area"; AreaRec)
                {

                }
                column(Using_of_Land; Using_of_Land)
                {

                }
                column(Type_of_Land; Type_of_Land)
                {

                }
                column(Street; Street)
                {

                }
                column(Block_number; Block_number)
                {

                }
                column(Piece_number; Piece_number)
                {

                }
                column(Land_Code; "Land Code")
                {

                }
                trigger OnAfterGetRecord()
                var
                    LandRec: Record Land;
                    salesLineRec: Record "Sales Line";
                    SalesHeaderRec: Record "Sales Header";
                    itemRec: Record item;
                    CustRec: Record Customer;
                begin
                    salesLineRec.SetRange("Document No.", "Sales Header"."No.");
                    if salesLineRec.FindSet() then begin
                        repeat
                            LandRec.Reset();
                            LandRec.SetRange("Plan Name", "Sales Header"."Plan Name");
                            LandRec.SetRange("Owner Name", "Sales Header"."Owner Name");
                            LandRec.SetRange("Instrument number", Line."No.");
                            if LandRec.FindSet() then begin
                                Instrument_number := LandRec."Instrument number";
                                AreaRec := LandRec."Area";
                                Using_of_Land := LandRec."Using of Land";
                                Type_of_Land := LandRec."Type of Land";
                                Street := LandRec.Street;
                                Block_number := LandRec."Block number";
                                Piece_number := LandRec."Piece number";
                            end;
                        until salesLineRec.Next() = 0;
                    end;
                    //Getting Land Code
                    ItemRec.SetRange("No.", "No.");
                    if ItemRec.FindFirst() then begin
                        "Land Code" := ItemRec."No. 2";
                    end;

                    //Getting Cust ID AND Date of Birth
                    CustRec.SetRange("No.", "Sales Header"."Sell-to Customer No.");
                    if CustRec.FindFirst() then begin
                        "Customer ID" := CustRec."Customer ID";
                        "Date of Birth" := CustRec."Date of Birth";
                    end;
                end;
            }
            dataitem(Marketer; Marketer)
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                DataItemTableView = sorting("No.", "Document No.");
                column("Marketer_No"; "No.")
                {

                }
                column(Name; Name)
                {

                }
                column(Percentage; Percentage)
                {

                }
                column(Commission; Commission)
                {

                }

            }
        }
    }
    rendering
    {
        layout(SalesOrderEnglish)
        {
            Type = RDLC;
            LayoutFile = 'Land/Layouts/SalesOrderRDLC English.rdl';
        }
        layout(SalesOrderArabic)
        {
            Type = RDLC;
            LayoutFile = 'Land/Layouts/SalesOrderRDLC Arabic.rdl';
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
    end;

    var
        Instrument_number: Code[20];
        AreaRec: Decimal;
        Using_of_Land: Text[30];
        Type_of_Land: Text[30];
        Street: Text[150];
        Block_number: Integer;
        Piece_number: Integer;
        CompanyInfo: Record "Company Information";
        "Land Code": Code[20];
        "Customer ID": Code[10];
        "Date of Birth": Date;
}