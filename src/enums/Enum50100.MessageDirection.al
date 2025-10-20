namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;

enum 50200 "Message Direction"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Inbound)
    {
        Caption = 'Inbound';
    }
    value(2; Outbound)
    {
        Caption = 'Outbound';
    }
}
