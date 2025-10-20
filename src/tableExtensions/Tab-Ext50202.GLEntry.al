namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

using Microsoft.Finance.GeneralLedger.Ledger;

tableextension 50202 "G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50200; "Allow Dimension Correction"; Boolean)
        {
            Caption = 'Allow Dimension Correction';
            DataClassification = ToBeClassified;
        }
    }
}
