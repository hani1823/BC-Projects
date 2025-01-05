namespace Update;

permissionset 50100 "Update Dimensions"
{
    Assignable = true;
    Permissions = codeunit "Force Update All DimSet" = X,
        codeunit "Force Update DimSet" = X,
        codeunit "Insert Dimensions Manual" = X;
}