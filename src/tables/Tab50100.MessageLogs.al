table 50200 "Message Logs"
{
    Caption = 'Message Logs';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Message ID"; Code[20])
        {
            Caption = 'Message ID';
            OptimizeForTextSearch = true;
        }
        field(3; Direction; Enum "Message Direction")
        {
            Caption = 'Direction';
        }
        field(4; "Processed At"; DateTime)
        {
            Caption = 'Processed At';
        }
        field(5; Status; Enum Status)
        {
            Caption = 'Status';
        }
        field(6; Payload; Text[2048])
        {
            Caption = 'Payload';
        }
        field(7; "Search Text"; Text[250])
        {
            Caption = 'Search Text';
            OptimizeForTextSearch = true;
        }
        field(8; Restored; Boolean)
        {
            Caption = 'Restored';
        }
        field(9; "Error Code"; Code[50])
        {
            Caption = 'Error Code';
        }
        field(10; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(11; "Message Type"; Enum "Message Type")
        {
            Caption = 'Message Type';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(status; "Message Type", Status)
        {

        }
    }
}
