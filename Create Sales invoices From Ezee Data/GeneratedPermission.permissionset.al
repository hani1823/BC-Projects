permissionset 50070 "Ezee permission"
{
    Assignable = true;
    Permissions = tabledata "eZee Revenue Header2" = RIMD,
        tabledata "eZee Revenue Line2" = RIMD,
        table "eZee Revenue Header2" = X,
        table "eZee Revenue Line2" = X,
        query "Ezee Invoice by folio" = X,
        query "Ezee Invoice by folio Lines" = X;
}