permissionset 50559 GeneratedPermission
{
    Caption = 'Lands and Marketers';
    Assignable = true;
    Permissions = tabledata Contributors = RIMD,
        tabledata Land = RIMD,
        tabledata Marketer = RIMD,
        tabledata Owners = RIMD,
        tabledata TempTableForOwnerQuery = RIMD,
        table Contributors = X,
        table Land = X,
        table Marketer = X,
        table Owners = X,
        table TempTableForOwnerQuery = X,
        report PrintContractReport = X,
        report PrintQuotationReport = X,
        report SalesOrderReport = X,
        page "Land Page" = X,
        page "Marketer Page" = X,
        page "Owner Name Lookup" = X,
        page "Plan Name Lookup" = X,
        query OwnerQuery = X;
}