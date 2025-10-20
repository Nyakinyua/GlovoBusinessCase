namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

page 50203 "Fiscal Messages API"
{
    APIGroup = 'integration';
    APIPublisher = 'businessCase';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'fiscalMessagesAPI';
    DelayedInsert = true;
    EntityName = 'fiscalMessage';
    EntitySetName = 'fiscalMessages';
    PageType = API;
    SourceTable = Messages;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(payload; Rec.Payload)
                {
                    Caption = 'Payload';
                }
                field(contentType; Rec."Content Type")
                {
                    Caption = 'Content Type';
                }
                field(messageType; Rec."Message Type")
                {
                    Caption = 'Message Type';
                }
                field(externalReference; Rec."External Reference")
                {
                    Caption = 'External Reference';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Status := Rec.Status::Received;
        Rec.Direction := Rec.Direction::Inbound;
        Rec."Received Date Time" := CurrentDateTime();
    end;
}
