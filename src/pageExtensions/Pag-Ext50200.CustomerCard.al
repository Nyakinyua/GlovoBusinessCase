// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.GLOVOBUSINESSCASE;

using Microsoft.Sales.Customer;

pageextension 50200 CustomerCard extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Last Updated Date/Time"; Rec."Last Updated Date/Time")
            {
                ApplicationArea = All;
                Caption = 'Last Updated Date/Time';
                Editable = false;
            }
        }
    }
}