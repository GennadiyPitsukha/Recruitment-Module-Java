@IsTest
private class TestUpdateContactBathcJobQueryLocator {
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
                AccountId = account.Id,
                Is_Synced__c = false
            ));
        }
        insert testContactList;
    }

    @IsTest
    static void testAddressSync() {
        Test.startTest();
        UpdateContactBathcJobQueryLocator batch = new UpdateContactBathcJobQueryLocator();
        Database.executeBatch(batch);
        Test.stopTest();
        for (Contact contact : [
            SELECT
                Id,
                AccountId,
                Is_Synced__c,
                Account.BillingStreet,
                Account.BillingCity,
                Account.BillingState,
                Account.BillingPostalCode,
                Account.BillingCountry,
                Account.Updated_By_Contact__c,
                MailingStreet,
                MailingCity,
                MailingState,
                MailingPostalCode,
                MailingCountry
            FROM Contact
            WHERE AccountId != null
        ]) {
            System.assertEquals(true, contact.Account.Updated_By_Contact__c, 'Should be checked as updated');
            System.assertEquals(contact.MailingStreet, contact.Account.BillingStreet, 'Account BillingStreet and Contact MailingStreet must match');
            System.assertEquals(contact.MailingCity, contact.Account.BillingCity, 'Account BillingCity and Contact MailingCity must match');
            System.assertEquals(contact.MailingState, contact.Account.BillingState, 'Account BillingState and Contact MailingState must match');
            System.assertEquals(contact.MailingPostalCode, contact.Account.BillingPostalCode, 'Account BillingPostalCode and Contact MailingPostalCode must match');
            System.assertEquals(contact.MailingCountry, contact.Account.BillingCountry, 'Account BillingCountry and Contact MailingCountry must match');
            System.assertEquals(true, contact.Is_Synced__c, 'Should be checked as Synced');
        }
    }
}
