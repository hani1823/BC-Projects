namespace FoodicsAPI;

permissionset 50110 FoodicsAPI
{
    Assignable = true;
    Permissions = tabledata "Foodics Setup" = RIMD,
        table "Foodics Setup" = X,
        codeunit "Foodics Integration Mgr" = X,
        page "Foodics Setup" = X,
        tabledata "Foodics Accounts" = RIMD,
        tabledata "Foodics Consumption Branch" = RIMD,
        tabledata "Foodics Purchase Branch" = RIMD,
        table "Foodics Accounts" = X,
        table "Foodics Consumption Branch" = X,
        table "Foodics Purchase Branch" = X,
        page "Foodics Accounts" = X,
        page "Foodics Consumption Branches" = X,
        page "Foodics Date Selection" = X,
        page "Foodics Purchase Branches" = X,
        page "Foodics Sales Branches" = X,
        tabledata "Foodics Branch" = RIMD,
        table "Foodics Branch" = X;
}