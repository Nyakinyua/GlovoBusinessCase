namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

using Microsoft.Sales.Document;

tableextension 50201 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50200; "Campain ID"; Code[100])
        {
            Caption = 'Campain ID';
            DataClassification = ToBeClassified;
        }
    }
}
