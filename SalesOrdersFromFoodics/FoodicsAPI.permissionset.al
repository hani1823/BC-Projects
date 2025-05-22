namespace FoodicsAPI;

permissionset 50100 FoodicsAPI
{
    Assignable = true;
    Permissions = tabledata "Foodics Branch"=RIMD,
        tabledata "Foodics Setup"=RIMD,
        table "Foodics Branch"=X,
        table "Foodics Setup"=X,
        codeunit "Foodics Integration Mgr"=X,
        page "Foodics Branches"=X,
        page "Foodics Setup"=X;
}