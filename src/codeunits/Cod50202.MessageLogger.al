namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

codeunit 50202 "Message Logger"
{
    procedure FnLogProcessingError(EntryNo: Integer; ErrorText: Text)
    var
        MessagesLogsRec: Record "Message Logs";
    begin
        if not MessagesLogsRec.Get(EntryNo) then
            exit;

        MessagesLogsRec."Status" := MessagesLogsRec."Status"::Failed;
        MessagesLogsRec."Error Message" := ErrorText;
        MessagesLogsRec."Processed At" := CurrentDateTime;
        MessagesLogsRec.Modify(true);
    end;

    procedure FnLogToMessageLogs(var IntegrationMessage: Record Messages)
    var
        MessageLogsRec: Record "Message Logs";
        MessageID: Code[20];
        SearchText: Text[250];
    begin

        MessageID := CopyStr(Format(IntegrationMessage."Entry No."), 1, MaxStrLen(MessageID));

        MessageLogsRec.Init();
        MessageLogsRec."Message ID" := MessageID;
        MessageLogsRec.Direction := IntegrationMessage.Direction;
        MessageLogsRec.Status := IntegrationMessage.Status;
        MessageLogsRec.Payload := IntegrationMessage.Payload;
        MessageLogsRec."Message Type" := IntegrationMessage."Message Type";

        // Processed At: set to current time
        MessageLogsRec."Processed At" := CurrentDateTime();

        // Build a short searchable text from payload and content type
        SearchText := '';
        if IntegrationMessage.Payload <> '' then
            SearchText := CopyStr(IntegrationMessage.Payload, 1, MaxStrLen(MessageLogsRec."Search Text"));
        if (IntegrationMessage."Content Type" <> '') and (SearchText = '') then
            SearchText := CopyStr(IntegrationMessage."Content Type", 1, MaxStrLen(MessageLogsRec."Search Text"));

        MessageLogsRec.Validate("Search Text", SearchText);

        // Default values
        MessageLogsRec.Restored := false;
        MessageLogsRec."Error Code" := '';
        MessageLogsRec."Error Message" := '';

        MessageLogsRec.Insert();
    end;
}
