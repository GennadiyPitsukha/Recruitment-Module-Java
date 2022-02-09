@IsTest
public class TestAccountTriggerHandler {
    @TestSetup
    static void makeData() {
        List<Account> testAccountList = new List<Account>();
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
    }

    @IsTest
    static void testIsertAccount() {
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
        List<Account> actualAccountList = [
            SELECT Id, Name, ShippingCountry, BillingCountry,
                ShippingState, BillingState,
                ShippingCity, BillingCity,
                ShippingStreet, BillingStreet,
                ShippingPostalCode, BillingPostalCode
            FROM Account
            WHERE Name LIKE 'TA%'
        ];
        for (Account account : actualAccountList) {
            System.assertEquals(account.BillingCity, account.ShippingCity);
        }
    }
}
