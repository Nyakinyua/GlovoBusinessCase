namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

codeunit 50202 "Message Logger"
{
    procedure LogProcessingSuccess(EntryNo: Integer; CustomerNo: Code[20]; VendorNo: Code[20]; DocumentNo: Code[20])
    var
        MessagesLogsRec: Record "Message Logs";
    begin
        MessagesLogsRec.Init();
        MessagesLogsRec."Status" := MessagesLogsRec."Status"::Processed;
        MessagesLogsRec."Processed At" := CurrentDateTime;

        MessagesLogsRec.Modify(true);
    end;

    procedure LogProcessingError(EntryNo: Integer; ErrorText: Text)
    var
        MessagesLogsRec: Record "Message Logs";
    begin
        if not MessagesLogsRec.Get(EntryNo) then
            exit;

        MessagesLogsRec."Status" := MessagesLogsRec."Status"::Failed;
        MessagesLogsRec."Processed At" := CurrentDateTime;
        MessagesLogsRec.Modify(true);
    end;
}
