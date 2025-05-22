codeunit 50148 "GenJnl MandatoryDims"
{
    //--------------------------------------
    // 1) Send Approval (Batch & Line)
    //--------------------------------------
    [EventSubscriber(ObjectType::Codeunit,
                     Codeunit::"Approvals Mgmt.",
                     'OnSendGeneralJournalBatchForApproval', '', false, false)]
    local procedure BlockBatchApproval(var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        EnsureBatchDimsFilled(GenJournalBatch);
    end;

    [EventSubscriber(ObjectType::Codeunit,
                     Codeunit::"Approvals Mgmt.",
                     'OnSendGeneralJournalLineForApproval', '', false, false)]
    local procedure BlockLineApproval(var GenJournalLine: Record "Gen. Journal Line")
    begin
        EnsureDimsFilled(GenJournalLine);
    end;

    //--------------------------------------
    // 2) Post / Preview (Line only — works always)
    //--------------------------------------
    [EventSubscriber(ObjectType::Codeunit,
                     Codeunit::"Gen. Jnl.-Post Line",
                     'OnBeforePostGenJnlLine', '', false, false)]
    local procedure BlockLinePost(
        var GenJournalLine: Record "Gen. Journal Line";
        Balancing: Boolean)
    begin
        EnsureDimsFilled(GenJournalLine);
    end;

    //--------------------------------------
    // 3) Helpers
    //--------------------------------------
    local procedure EnsureBatchDimsFilled(var Batch: Record "Gen. Journal Batch")
    var
        Line: Record "Gen. Journal Line";
    begin
        if Database.CompanyName() <> 'ALINMA FOR HOTELING' then
            exit;

        Line.SetRange("Journal Template Name", Batch."Journal Template Name");
        Line.SetRange("Journal Batch Name", Batch.Name);
        if Line.FindSet() then
            repeat
                EnsureDimsFilled(Line); // يرمى Error إذا أى سطر ناقص
            until Line.Next() = 0;
    end;

    local procedure EnsureDimsFilled(var Line: Record "Gen. Journal Line")
    var
        DimMgt: Codeunit DimensionManagement;
        Codes: array[8] of Code[20];
    begin
        if Database.CompanyName() <> 'ALINMA FOR HOTELING' then
            exit;

        DimMgt.GetShortcutDimensions(Line."Dimension Set ID", Codes);
        if Codes[2] = '' then
            Error('Hotel (Shortcut Dimension 2) must not be blank.');
        if Codes[4] = '' then
            Error('Department (Shortcut Dimension 4) must not be blank.');
    end;
}
