@IsTest
private class TestAccountManager {
    @isTest
    static void testGetAccountById() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://enotcorporation-dev-ed.my.salesforce.com/services/apexrest/Account/'
            + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        Test.startTest();
        Account thisAccount = AccountManager.getAccountById();
        Test.stopTest();
        System.assert(thisAccount != null);
        System.assertEquals('Test Account', thisAccount.Name);
    }

    @isTest
    static void testCreateAccount() {
        Test.startTest();
        ID thisAccountId = AccountManager.createAccount('Test Account 0', 'Other', 'billingStreet', 'billingCity', 'billingState',
            'billingPostalCode', 'billingCountry', '80291234567', 'Media');
        Test.stopTest();
        System.assert(thisAccountId != null);
        Account thisAccount = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :thisAccountId
        ];
        System.assert(thisAccount != null);
        System.assertEquals(thisAccount.Name, 'Test Account 0');
    }

    @isTest
    static void testDeleteAccount() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://enotcorporation-dev-ed.my.salesforce.com/services/apexrest/Account/'
            + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        Test.startTest();
        AccountManager.deleteAccount();
        Test.stopTest();
        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE Id = :recordId
        ];
        System.assert(accounts.size() == 0);
    }

    @isTest
    static void testUpsertAccount() {
        Test.startTest();
        ID account1Id = AccountManager.upsertAccount('Test Account 1', 'Other', 'billingStreet', 'billingCity', 'billingState',
           'billingPostalCode', 'billingCountry', '80291234567', 'Media', null);
        Test.stopTest();
        System.assert(account1Id != null);
        Account account1 = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :account1Id
        ];
        System.assert(account1 != null);
        System.assertEquals(account1.Name, 'Test Account 1');
        ID account2Id = AccountManager.upsertAccount('Test Account 2', 'Other', 'billingStreet', 'billingCity', 'billingState',
        'billingPostalCode', 'billingCountry', '80291234567', 'Media', account1Id);
        System.assertEquals(account1Id, account2Id);
        Account account2 = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :account2Id
        ];
        System.assert(account2 != null);
        System.assertEquals(account2.Name, 'Test Account 2');
    }

    @isTest
    static void testUpdateAccountFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://enotcorporation-dev-ed.my.salesforce.com/services/apexrest/Account/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone": "999999999"}');
        RestContext.request = request;
        Test.startTest();
        ID thisAccountId = AccountManager.updateAccountFields();
        Test.stopTest();
        System.assert(thisAccountId != null);
        Account thisAccount = [
            SELECT Id, Phone
            FROM Account
            WHERE Id = :thisAccountId
        ];
        System.assert(thisAccount != null);
        System.assertEquals(thisAccount.Phone, '999999999');
    }

    static Id createTestRecord() {
        Account accountTest = new Account(
            Name = 'Test Account',
            Type = 'Other',
            BillingStreet = 'billingStreet',
            BillingCity = 'billingCity',
            BillingState = 'billingState',
            BillingPostalCode = 'billingPostalCode',
            BillingCountry = 'billingCountry',
            Phone = '80291234567',
            Industry = 'Media'
        );
        insert accountTest;
        return accountTest.Id;
    }
}
