namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

codeunit 50200 Utilities
{
    var
        BusinessCaseSetupRec: Record "Business Case Setup";
        MessageLogger: Codeunit "Message Logger";

    local procedure GetJsonValue(JsonObject: JsonObject; KeyName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(KeyName, JsonToken) then
            exit(JsonToken.AsValue().AsText());
        exit('');
    end;

    local procedure GetBusinessSetup()
    begin
        if not BusinessCaseSetupRec.Get() then
            BusinessCaseSetupRec.Init();
    end;

    local procedure ProcessFiscalData(var MessagesPar: Record Messages)
    var
        JsonObject: JsonObject;
        MessageContent: Text;
        CustomerNo: Code[20];
        VendorNo: Code[20];
    begin

        GetBusinessSetup();
        MessageContent := MessagesPar.Payload;

        if not JsonObject.ReadFrom(MessageContent) then begin
            MessageLogger.LogProcessingError(MessagesPar."Entry No.", 'Invalid JSON format in message');
            Error('Invalid JSON format in message');
        end;

        CustomerNo := ProcessCustomerData(MessagesPar, JsonObject);

        if BusinessCaseSetupRec."Auto Create Vendor" then
            VendorNo := ProcessVendorData(MessagesPar, JsonObject);

        // Log success with created records
        MessageLogger.LogProcessingSuccess(
            MessagesPar."Entry No.",
            CustomerNo,
            VendorNo,
            ''
        );
    end;

    local procedure ProcessCustomerData(var MessagesPar: Record Messages; JsonObject: JsonObject): Code[20]
    var
        Customer: Record Customer;
        CustomerTempl: Record "Customer Templ.";
        actorExternalId: Text;
        actorType: Text;
        CustomerName: Text;
        Address: Text;
        Address2: Text;
        City: Text;
        PostCode: Text;
        CountryCode: Text;
        Email: Text;
        PhoneNo: Text;
        taxId: Text;
        iban: Text;
        partnerDealType: Text;
    begin
        // Parse JSON
        actorExternalId := GetJsonValue(JsonObject, 'actorExternalId');
        actorType := GetJsonValue(JsonObject, 'actorType');
        CustomerName := GetJsonValue(JsonObject, 'legalName');
        PostCode := GetJsonValue(JsonObject, 'postalCode');
        City := GetJsonValue(JsonObject, 'cityName');
        CountryCode := GetJsonValue(JsonObject, 'countryCode');
        Address := GetJsonValue(JsonObject, 'addressLine1');
        Address2 := GetJsonValue(JsonObject, 'addressLine2');
        PhoneNo := GetJsonValue(JsonObject, 'phone');
        Email := GetJsonValue(JsonObject, 'email');
        taxId := GetJsonValue(JsonObject, 'taxId');
        iban := GetJsonValue(JsonObject, 'iban');
        partnerDealType := GetJsonValue(JsonObject, 'partnerDealType');

        // Check if customer exists
        Customer.SetRange("No.", actorExternalId);
        if not Customer.FindFirst() then begin
            // Create new customer
            Customer.Init();
            Customer."No." := actorExternalId;
            Customer.Insert(true);
        end;

        // Update customer fields
        Customer.Validate(Name, CopyStr(CustomerName, 1, MaxStrLen(Customer.Name)));
        Customer.Validate(Address, CopyStr(Address, 1, MaxStrLen(Customer.Address)));
        Customer.Validate(City, CopyStr(City, 1, MaxStrLen(Customer.City)));
        Customer.Validate("Post Code", CopyStr(PostCode, 1, MaxStrLen(Customer."Post Code")));
        Customer.Validate("Country/Region Code", CopyStr(CountryCode, 1, MaxStrLen(Customer."Country/Region Code")));
        Customer.Validate("E-Mail", CopyStr(Email, 1, MaxStrLen(Customer."E-Mail")));
        Customer.Validate("Phone No.", CopyStr(PhoneNo, 1, MaxStrLen(Customer."Phone No.")));
        Customer.Validate("VAT Registration No.", CopyStr(taxId, 1, MaxStrLen(Customer."VAT Registration No.")));

        if BusinessCaseSetupRec."Customer Template Code" <> '' then begin
            if CustomerTempl.Get(BusinessCaseSetupRec."Customer Template Code") then begin

                if CustomerTempl."Gen. Bus. Posting Group" <> '' then
                    Customer."Gen. Bus. Posting Group" := CustomerTempl."Gen. Bus. Posting Group";
                if CustomerTempl."VAT Bus. Posting Group" <> '' then
                    Customer."VAT Bus. Posting Group" := CustomerTempl."VAT Bus. Posting Group";
                if CustomerTempl."Customer Posting Group" <> '' then
                    Customer."Customer Posting Group" := CustomerTempl."Customer Posting Group";
            end;
        end;

        Customer."Last Date Modified" := Today;
        Customer.Modify(true);

        exit(Customer."No.");
    end;

    local procedure ProcessVendorData(var IntegrationMessage: Record Messages; JsonObject: JsonObject): Code[20]
    var
        Vendor: Record Vendor;
        VendorTempl: Record "Vendor Templ.";
        VendorCode: Code[20];
        VendorName: Text;
        Address: Text;
        Address2: Text;
        City: Text;
        PostCode: Text;
        CountryCode: Text;
        Email: Text;
        PhoneNo: Text;
        VATRegNo: Text;
        taxId: Text;
        iban: Text;
        partnerDealType: Text;
    begin

        VendorCode := GetJsonValue(JsonObject, 'actorExternalId');
        //actorType := GetJsonValue(JsonObject, 'actorType');
        VendorName := GetJsonValue(JsonObject, 'legalName');
        PostCode := GetJsonValue(JsonObject, 'postalCode');
        City := GetJsonValue(JsonObject, 'cityName');
        CountryCode := GetJsonValue(JsonObject, 'countryCode');
        Address := GetJsonValue(JsonObject, 'addressLine1');
        Address2 := GetJsonValue(JsonObject, 'addressLine2');
        PhoneNo := GetJsonValue(JsonObject, 'phone');
        Email := GetJsonValue(JsonObject, 'email');
        taxId := GetJsonValue(JsonObject, 'taxId');
        iban := GetJsonValue(JsonObject, 'iban');
        partnerDealType := GetJsonValue(JsonObject, 'partnerDealType');

        // Check if vendor exists
        Vendor.SetRange("VAT Registration No.", VATRegNo);
        if not Vendor.FindFirst() then begin
            // Create new vendor
            Vendor.Init();
            Vendor."No." := VendorCode;
            Vendor.Insert(true);
        end;

        // Update vendor fields
        Vendor.Validate(Name, CopyStr(VendorName, 1, MaxStrLen(Vendor.Name)));
        Vendor.Validate(Address, CopyStr(Address, 1, MaxStrLen(Vendor.Address)));
        Vendor.Validate(City, CopyStr(City, 1, MaxStrLen(Vendor.City)));
        Vendor.Validate("Post Code", CopyStr(PostCode, 1, MaxStrLen(Vendor."Post Code")));
        Vendor.Validate("Country/Region Code", CopyStr(CountryCode, 1, MaxStrLen(Vendor."Country/Region Code")));
        Vendor.Validate("E-Mail", CopyStr(Email, 1, MaxStrLen(Vendor."E-Mail")));
        Vendor.Validate("Phone No.", CopyStr(PhoneNo, 1, MaxStrLen(Vendor."Phone No.")));
        Vendor.Validate("VAT Registration No.", CopyStr(VATRegNo, 1, MaxStrLen(Vendor."VAT Registration No.")));

        // Apply template settings
        if BusinessCaseSetupRec."Vendor Template Code" <> '' then
            if VendorTempl.Get(BusinessCaseSetupRec."Customer Template Code") then begin

                if VendorTempl."Gen. Bus. Posting Group" <> '' then
                    Vendor."Gen. Bus. Posting Group" := VendorTempl."Gen. Bus. Posting Group";
                if VendorTempl."VAT Bus. Posting Group" <> '' then
                    Vendor."VAT Bus. Posting Group" := VendorTempl."VAT Bus. Posting Group";
                if VendorTempl."Vendor Posting Group" <> '' then
                    Vendor."Vendor Posting Group" := VendorTempl."Vendor Posting Group";
            end;

        Vendor."Last Date Modified" := Today;
        Vendor.Modify(true);

        exit(Vendor."No.");
    end;
}
