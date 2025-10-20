namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

using Microsoft.Sales.Customer;

pageextension 50201 "Customer List" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("Actorexternal ID "; Rec."Actorexternal ID ")
            {
                ApplicationArea = All;
                Caption = 'Actorexternal ID ';
                Editable = false;
            }
        }

    }
}
