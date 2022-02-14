public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> newAccounts) {
        List<Account> insertAccounts = new List<Account>();
        for (Account account : newAccounts) {
            if (account.ShippingCountry == null) {
               account.ShippingCountry = account.BillingCountry;
               account.ShippingState = account.BillingState;
               account.ShippingCity = account.BillingCity;
               account.ShippingStreet = account.BillingStreet;
               account.ShippingPostalCode = account.BillingPostalCode;
               insertAccounts.add(account);
            }
        }
        System.debug('This text was called from beforeInsert');
    }
    public static void afterInsert(Map<Id, Account> newAccounts) {
        AccountService.createTasks(newAccounts.keyset());
    }

    public static void beforeUpdate(Map<Id, Account> newAccounts, Map<Id, Account> oldAccounts) {
        List<Id> accountWithChangedBillingAdress = new List<Id>();
        for (ID idKey : newAccounts.keyset()) {
            Account newAccount = newAccounts.get(idKey);
            Account oldAccount = oldAccounts.get(idKey);
            if (oldAccount.ShippingCountry == newAccount.ShippingCountry && 
                newAccount.BillingCountry != oldAccount.ShippingCountry) {
                    newAccount.ShippingCountry = newAccount.BillingCountry;
                    newAccount.ShippingState = newAccount.BillingState;
                    newAccount.ShippingCity = newAccount.BillingCity;
                    newAccount.ShippingStreet = newAccount.BillingStreet;
                    newAccount.ShippingPostalCode = newAccount.BillingPostalCode;
            }
            if (newAccount.BillingCountry != oldAccount.BillingCountry ||
                newAccount.BillingCountry != oldAccount.BillingCountry ||
                newAccount.BillingState != oldAccount.BillingState ||
                newAccount.BillingCity != oldAccount.BillingCity ||
                newAccount.BillingStreet != oldAccount.BillingStreet ||
                newAccount.BillingPostalCode != oldAccount.BillingPostalCode) {
                    accountWithChangedBillingAdress.add(idKey);
            }
        }
        AsyncProcessByQueue queue = new AsyncProcessByQueue(accountWithChangedBillingAdress);
        System.enqueueJob(queue);
        if(!System.isBatch()) {
        AccountTriggerHandler.contactsProcessedByFuture(accountWithChangedBillingAdress);
        }
        System.debug('This text was called from beforeUpdate');
    }

    @Future
    public static void contactsProcessedByFuture(List<Id> accountIds) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact contact : [
            SELECT Id, Processed_By_Future__c, Is_Synced__c
            FROM Contact
            WHERE AccountId IN :accountIds
        ]) {
            contact.Processed_By_Future__c = true;
            contact.Is_Synced__c = false;
            contactsToUpdate.add(contact);
        }
        update contactsToUpdate;
    }
}
