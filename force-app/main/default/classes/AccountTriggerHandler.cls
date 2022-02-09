public with sharing class AccountTriggerHandler {
    public static void beforeInsert (List<Account> newAccounts) {
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

    public static void beforeUpdate(Map<Id, Account> newAccounts, Map<Id, Account> oldAccounts) {
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
        }
        System.debug('This text was called from beforeUpdate');
    }
}
