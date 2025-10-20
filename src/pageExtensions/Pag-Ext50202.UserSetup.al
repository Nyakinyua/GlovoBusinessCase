namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

using System.Security.User;

pageextension 50202 "User Setup" extends "User Setup"
{
    layout
    {
        addlast(Content)
        {
            field("Run Dimension Correction"; Rec."Run Dimension Correction")
            {
                ApplicationArea = All;
                Caption = 'Run Dimension Correction';
            }
        }
    }
}
