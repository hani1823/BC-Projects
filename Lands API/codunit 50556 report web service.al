codeunit 50556 "Report Web Service"
{
    procedure RunReport(reportno: integer; parameters: text; ReportFormat: Integer): text
    var
        OutS: OutStream;
        Inst: InStream;
        TempBlob: codeunit "Temp Blob";
        Base64: codeunit "base64 Convert";
    begin
        Tempblob.CreateOutStream(OutS);
        Report.SaveAs(Reportno, parameters, TextToOption(ReportFormat), OutS);
        TempBlob.CreateInStream(Inst);
        exit(Base64.ToBase64(Inst));
    end;

    local procedure TextToOption(textValue: Integer): ReportFormat
    var
    begin
        case textValue of
            1:
                exit(ReportFormat::PDF);
            2:
                exit(ReportFormat::HTML);
            3:
                exit(ReportFormat::Word);
            4:
                exit(ReportFormat::Excel);
            5:
                exit(ReportFormat::Xml);
        end;
    end;
}