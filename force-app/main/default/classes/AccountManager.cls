@RestResource(urlMapping='/Account/*')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccountById() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/') + 1);
        Account result = [
            SELECT
                Id,
                Name,
                Type,
                BillingStreet,
                BillingCity,
                BillingState,
                BillingPostalCode,
                BillingCountry,
                Phone,
                Industry
            FROM Account
            WHERE Id = :accountId
        ];
        return result;
    }
    @HttpPost
    global static ID createAccount(String name, String type, String billingStreet, String billingCity,
    String billingState, String billingPostalCode, String billingCountry, String phone, String industry) {
        Account thisAccount = new Account(
            Name = name,
            Type = type,
            BillingStreet = billingStreet,
            BillingCity = billingCity,
            BillingState = billingState,
            BillingPostalCode = billingPostalCode,
            BillingCountry = billingCountry,
            Phone = phone,
            Industry = industry
        );
        insert thisAccount;
        return thisAccount.Id;
    }
    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [
            SELECT Id
            FROM Account
            WHERE Id = :accountId
        ];
        delete thisAccount;
    }
    @HttpPut
    global static ID upsertAccount(String name, String type, String billingStreet, String billingCity, String billingState,
     String billingPostalCode, String billingCountry, String phone, String industry, String id) {
        Account thisAccount = new Account(
            Id = id,
            Name = name,
            Type = type,
            BillingStreet = billingStreet,
            BillingCity = billingCity,
            BillingState = billingState,
            BillingPostalCode = billingPostalCode,
            BillingCountry = billingCountry,
            Phone = phone,
            Industry = industry
        );
        upsert thisAccount;
        return thisAccount.Id;
    }
    @HttpPatch
    global static ID updateAccountFields() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [
            SELECT Id
            FROM Account
            WHERE Id = :accountId
        ];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        for(String fieldName : params.keySet()) {
            thisAccount.put(fieldName, params.get(fieldName));
        }
        update thisAccount;
        return thisAccount.Id;
    }
}