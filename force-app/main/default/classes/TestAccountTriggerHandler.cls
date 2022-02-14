@IsTest
public class TestAccountTriggerHandler {
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
    static void testInsertAccount() {
        List<Account> testAccountList = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            testAccountList.add(new Account(
                Name = 'Test Account ' + i,
                BillingCountry = 'Country ' + i,
                BillingState = 'State ' + i,
                BillingCity = 'City ' + i,
                BillingStreet = 'Street ' + i,
                BillingPostalCode = 'Code ' + i
            ));
        }
        Test.startTest();
        insert testAccountList;
        Test.stopTest();
        List<Account> actualAccountList = [
            SELECT Id, ShippingCountry, BillingCountry,
                ShippingState, BillingState,
                ShippingCity, BillingCity,
                ShippingStreet, BillingStreet,
                ShippingPostalCode, BillingPostalCode
            FROM Account
            WHERE Id IN :testAccountList
        ];
        for (Account account : actualAccountList) {
            System.assertEquals(account.BillingCity, account.ShippingCity);
        }
    }

    @IsTest
    static void testUpdateAccount() {
        List<Account> accountListToUpdate = new List<Account>();
        List<Account> accountList = [
            SELECT Id, Name, ShippingCountry, BillingCountry,
                ShippingState, BillingState,
                ShippingCity, BillingCity,
                ShippingStreet, BillingStreet,
                ShippingPostalCode, BillingPostalCode
            FROM Account
            WHERE Name LIKE 'TA%'
        ];
        for (Account account : accountList) {
            account.BillingCountry = 'BC ' + account.Name;
            account.BillingState = 'BS ' + account.Name;
            account.BillingCity = 'BC ' + account.Name;
            account.BillingStreet = 'BS ' + account.Name;
            account.BillingPostalCode = 'BPC ' + account.Name;
            accountListToUpdate.add(account);
        }
        Test.startTest();
        update accountListToUpdate;
        Test.stopTest();
        for (Account account : [
            SELECT Id, Name, ShippingCountry, BillingCountry,
                ShippingState, BillingState,
                ShippingCity, BillingCity,
                ShippingStreet, BillingStreet,
                ShippingPostalCode, BillingPostalCode
            FROM Account
            WHERE Name LIKE 'TA%'
        ]) {
            System.assertEquals(account.BillingCity, account.ShippingCity);
        }
        for (Contact contact : [
            SELECT Id, Processed_By_Future__c, Is_Synced__c
            FROM Contact
            WHERE LastName LIKE 'Test Contact for%'
        ]) {
            System.assertEquals(true, contact.Processed_By_Future__c);
            System.assertEquals(false, contact.Is_Synced__c);
        }
    }
}
