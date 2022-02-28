@IsTest
private class TestAsyncProcessByQueue {
    @TestSetup
    static void makeData() {
        List<Account> testAccountList = new List<Account>();
        List<Contact> testContactList = new List<Contact>();
        for (Integer i = 0; i < 100; i++) {
            testAccountList.add(new Account(
                Name = 'TA ' + i,
                BillingCountry = 'BC ' + i,
                BillingState = 'BS ' + i,
                BillingCity = 'BC ' + i,
                BillingStreet = 'BS ' + i,
                BillingPostalCode = 'BPC ' + i
            ));
        }
        insert testAccountList;
        for (Account account : testAccountList) {
            testContactList.add(new Contact(
                LastName = 'Test Contact for ' + account.Name,
                AccountId = account.Id
            ));
        }
        insert testContactList;
    }

    @IsTest
    static void testUpdateAccount() {
        List<Id> accountIds = new List<Id>();
        List<Account> accountList = [
            SELECT Id, Name, BillingCountry, BillingState, BillingCity, BillingStreet, BillingPostalCode
            FROM Account
            WHERE Name LIKE 'TA%'
        ];
        for (Account account : accountList) {
            accountIds.add(account.Id);
        }
        AsyncProcessByQueue queue = new AsyncProcessByQueue(accountIds);
        // startTest/stopTest block to force async processes to run
        Test.startTest();
        System.enqueueJob(queue);
        Test.stopTest();
        for (Contact contact : [
            SELECT Id, Processed_By_Queue__c, Is_Synced__c
            FROM Contact
            WHERE LastName LIKE 'Test Contact for%'
        ]) {
            System.assertEquals(true, contact.Processed_By_Queue__c);
            System.assertEquals(false, contact.Is_Synced__c);
        }
    }
}
