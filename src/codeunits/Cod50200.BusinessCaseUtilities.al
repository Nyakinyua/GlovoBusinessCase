namespace GLOVOBUSINESSCASE.GLOVOBUSINESSCASE;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;

codeunit 50200 BusinessCaseUtilities
{
    var
        BusinessCaseSetupRec: Record "Business Case Setup";
        MessageLogger: Codeunit "Message Logger";

    local procedure FnGetJsonValue(JsonObject: JsonObject; KeyName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(KeyName, JsonToken) then
            exit(JsonToken.AsValue().AsText());
        exit('');
    end;

    local procedure FnGetBusinessSetup()
    begin
        if not BusinessCaseSetupRec.Get() then
            BusinessCaseSetupRec.Init();
    end;

    procedure FnProcessFiscalData(var MessagesPar: Record Messages)
    var
        JsonObject: JsonObject;
        MessageContent: Text;
        CustomerNo: Code[20];
    begin

        FnGetBusinessSetup();
        MessageContent := MessagesPar.Payload;

        if not JsonObject.ReadFrom(MessageContent) then begin
            MessageLogger.FnLogProcessingError(MessagesPar."Entry No.", 'Invalid JSON format in message');
            Error('Invalid JSON format in message');
        end;

        CustomerNo := FnProcessCustomerData(MessagesPar, JsonObject);

        // Log success with created records
        MessageLogger.FnLogToMessageLogs(MessagesPar);
    end;

    local procedure FnProcessCustomerData(var MessagesPar: Record Messages; JsonObject: JsonObject): Code[20]
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
        VendorNo: Code[20];
    begin
        // Parse JSON
        actorExternalId := FnGetJsonValue(JsonObject, 'actorExternalId');
        actorType := FnGetJsonValue(JsonObject, 'actorType');
        CustomerName := FnGetJsonValue(JsonObject, 'legalName');
        PostCode := FnGetJsonValue(JsonObject, 'postalCode');
        City := FnGetJsonValue(JsonObject, 'cityName');
        CountryCode := FnGetJsonValue(JsonObject, 'countryCode');
        Address := FnGetJsonValue(JsonObject, 'addressLine1');
        Address2 := FnGetJsonValue(JsonObject, 'addressLine2');
        PhoneNo := FnGetJsonValue(JsonObject, 'phone');
        Email := FnGetJsonValue(JsonObject, 'email');
        taxId := FnGetJsonValue(JsonObject, 'taxId');
        iban := FnGetJsonValue(JsonObject, 'iban');
        partnerDealType := FnGetJsonValue(JsonObject, 'partnerDealType');

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
        //if action type relates to vendor based on assumption
        if actorType = 'VENDOR' then
            if BusinessCaseSetupRec."Auto Create Vendor" then
                VendorNo := FnProcessVendorData(MessagesPar, JsonObject);

        exit(Customer."No.");
    end;

    local procedure FnProcessVendorData(var IntegrationMessage: Record Messages; JsonObject: JsonObject): Code[20]
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

        VendorCode := FnGetJsonValue(JsonObject, 'actorExternalId');
        VendorName := FnGetJsonValue(JsonObject, 'legalName');
        PostCode := FnGetJsonValue(JsonObject, 'postalCode');
        City := FnGetJsonValue(JsonObject, 'cityName');
        CountryCode := FnGetJsonValue(JsonObject, 'countryCode');
        Address := FnGetJsonValue(JsonObject, 'addressLine1');
        Address2 := FnGetJsonValue(JsonObject, 'addressLine2');
        PhoneNo := FnGetJsonValue(JsonObject, 'phone');
        Email := FnGetJsonValue(JsonObject, 'email');
        taxId := FnGetJsonValue(JsonObject, 'taxId');
        iban := FnGetJsonValue(JsonObject, 'iban');
        partnerDealType := FnGetJsonValue(JsonObject, 'partnerDealType');

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

    procedure FnProcessTransactionData(var MessagesPar: Record Messages)
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        JsonObject: JsonObject;
        MessageContent: Text;
        commissionAmountText: Text;
        adsGMOText: Text;
        gmvText: Text;
        campaignId: Text;
        orderId: Text;
        commissionAmount: Decimal;
        adsGMO: Decimal;
        gmv: Decimal;
        orderCode: Code[20];
    begin
        FnGetBusinessSetup();

        MessageContent := MessagesPar.Payload;
        if not JsonObject.ReadFrom(MessageContent) then begin
            MessageLogger.FnLogProcessingError(MessagesPar."Entry No.", 'Invalid JSON format in transaction message');
            Error('Invalid JSON format in transaction message');
        end;

        // Read fields from JSON (text first, then evaluate to decimals)
        commissionAmountText := FnGetJsonValue(JsonObject, 'commissionAmount');
        adsGMOText := FnGetJsonValue(JsonObject, 'adsGMO');
        gmvText := FnGetJsonValue(JsonObject, 'gmv');
        campaignId := FnGetJsonValue(JsonObject, 'campaignId');
        orderId := FnGetJsonValue(JsonObject, 'OrderID');
        orderCode := FnGetJsonValue(JsonObject, 'OrderCode');

        // Convert to decimals when possible
        if not EVALUATE(commissionAmount, commissionAmountText) then
            commissionAmount := 0;
        if not EVALUATE(adsGMO, adsGMOText) then
            adsGMO := 0;
        if not EVALUATE(gmv, gmvText) then
            gmv := 0;

        // Validate configuration items
        if BusinessCaseSetupRec."Commission Item No." = '' then begin
            MessageLogger.FnLogProcessingError(MessagesPar."Entry No.", 'Commission Item No. is not configured in Business Case Setup');
            exit;
        end;
        if BusinessCaseSetupRec."AdsGMO Item No." = '' then begin
            MessageLogger.FnLogProcessingError(MessagesPar."Entry No.", 'AdsGMO Item No. is not configured in Business Case Setup');
            exit;
        end;

        // Create sales invoice header
        SalesHeaderRec.Init();
        SalesHeaderRec.Validate("Document Type", SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.Validate("External Document No.", orderCode);
        SalesHeaderRec.Insert(true);

        // Commission line (taxable) - include GMV in description so it is available on invoice layout
        if commissionAmount <> 0 then begin
            if not ItemRec.Get(BusinessCaseSetupRec."Commission Item No.") then begin
                MessageLogger.FnLogProcessingError(MessagesPar."Entry No.", 'Commission Item No. not found: ' + BusinessCaseSetupRec."Commission Item No.");
            end else begin
                SalesLineRec.Init();
                SalesLineRec.Validate("Document Type", SalesHeaderRec."Document Type");
                SalesLineRec.Validate("Document No.", SalesHeaderRec."No.");
                SalesLineRec.Validate(Type, SalesLineRec.Type::Item);
                SalesLineRec.Validate("No.", BusinessCaseSetupRec."Commission Item No.");
                SalesLineRec.Validate(Quantity, 1);
                SalesLineRec.Validate("Unit Price", commissionAmount);
                SalesLineRec.Validate(Description, 'Commission (Order: ' + orderId + ') | GMV: ' + Format(gmv));
                SalesLineRec.Insert(true);
            end;
        end;

        // AdsGMO line (taxable) - include Campaign ID in description and as an additional field
        if adsGMO <> 0 then begin
            if not ItemRec.Get(BusinessCaseSetupRec."AdsGMO Item No.") then begin
                MessageLogger.FnLogProcessingError(MessagesPar."Entry No.", 'AdsGMO Item No. not found: ' + BusinessCaseSetupRec."AdsGMO Item No.");
            end else begin
                SalesLineRec.Init();
                SalesLineRec.Validate("Document Type", SalesHeaderRec."Document Type");
                SalesLineRec.Validate("Document No.", SalesHeaderRec."No.");
                SalesLineRec.Validate(Type, SalesLineRec.Type::Item);
                SalesLineRec.Validate("No.", BusinessCaseSetupRec."AdsGMO Item No.");
                SalesLineRec.Validate(Quantity, 1);
                SalesLineRec.Validate("Unit Price", adsGMO);
                SalesLineRec.Validate(Description, 'AdsGMO (Campaign: ' + campaignId + ') | Order: ' + orderId);
                SalesLineRec.Validate("Campaign ID", campaignId);
                SalesLineRec.Insert(true);
            end;
        end;
        // Log success with created sales invoice
        // Log success with created records
        MessageLogger.FnLogToMessageLogs(MessagesPar);
    end;

}
