@IsTest
private class TestUpdateContactsByQueue {
    @TestSetup
    static void makeData() {
        List<Account> testAccountList = new List<Account>();
        List<Contact> testContactList = new List<Contact>();
        for (Integer i = 0; i < 150; i++) {
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
    static void testUpdateContactsByFuture() {
        Test.startTest();
        UpdateContactsByQueue queue = new UpdateContactsByQueue();
        System.enqueueJob(queue);
        Test.stopTest();
        List<Contact> updatedContacts = [
            SELECT Id, Processed_By_Queue__c, Is_Synced__c
            FROM Contact
        ];
        for (Contact contact : updatedContacts) {
            System.assertEquals(true, contact.Processed_By_Queue__c);
            System.assertEquals(false, contact.Is_Synced__c);
        }
    }
}
