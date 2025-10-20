namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

page 50202 "Business Case Setup"
{
    ApplicationArea = All;
    Caption = 'Business Case Setup';
    PageType = Card;
    SourceTable = "Business Case Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Activate; Rec.Activate)
                {
                    ToolTip = 'Specifies the value of the Activate field.', Comment = '%';
                }
                field("Auto Create Vendor"; Rec."Auto Create Vendor")
                {
                    ToolTip = 'Specifies the value of the Auto Create Vendor field.', Comment = '%';
                }
            }
            group(Templates)
            {
                Caption = 'Templates';
                field("Customer Template Code"; Rec."Customer Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer template';
                }
                field("Vendor Template Code"; Rec."Vendor Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor template';
                }
            }
            group(Items)
            {
                Caption = 'Transaction Items';
                field("Commission Item No."; Rec."Commission Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item for commission lines';
                }
                field("AdsGMO Item No."; Rec."AdsGMO Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item for advertising lines';
                }
            }
            group(API)
            {
                Caption = 'API Configuration';
                field("API Endpoint URL"; Rec."Fiscal Data Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fiscal Data endpoint URL';
                }
                field("Transaction Data Endpoint"; Rec."Transaction Data Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction data endpoint URL';
                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the API key';
                    ExtendedDatatype = Masked;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
