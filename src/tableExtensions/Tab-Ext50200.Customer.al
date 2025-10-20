namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

using Microsoft.Sales.Customer;

tableextension 50200 Customer extends Customer
{
    fields
    {
        field(50200; "Last Updated Date/Time"; DateTime)
        {
            Caption = 'Last Updated Date/Time';
            DataClassification = CustomerContent;
        }
        field(50201; "Actorexternal ID "; Code[20])
        {
            Caption = 'Actorexternal ID ';
            DataClassification = CustomerContent;
        }
    }
}
