table 50202 "Business Case Setup"
{
    Caption = 'Business Case Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "Activate"; Boolean)
        {

        }
        field(3; "Customer Template Code"; Code[20])
        {
            TableRelation = "Customer Templ.".Code;
        }
        field(4; "Vendor Template Code"; Code[20])
        {
            TableRelation = "Vendor Templ.".Code;
        }
        field(5; "Auto Create Vendor"; Boolean)
        {
            Caption = 'Auto Create Vendor';
        }
        field(6; "Fiscal Data Endpoint"; Code[250])
        {
            Caption = 'Fiscal Data Endpoint';
        }
        field(7; "Transaction Data Endpoint"; Code[250])
        {
            Caption = 'Transaction Data Endpoint';
        }
        field(8; "API Key"; Text[250])
        {
            Caption = 'API Key';
            DataClassification = ToBeClassified;
        }
        field(9; "Commission Item No."; Code[20])
        {
            Caption = 'Commission Item No.';
            TableRelation = Item;
        }
        field(10; "AdsGMO Item No."; Code[20])
        {
            Caption = 'AdsGMO Item No.';
            TableRelation = Item;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
