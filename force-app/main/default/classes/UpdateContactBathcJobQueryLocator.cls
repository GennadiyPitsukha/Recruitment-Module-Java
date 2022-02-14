public class UpdateContactBathcJobQueryLocator implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator ('SELECT Id, AccountId,Is_Synced__c, Account.BillingStreet, Account.BillingCity, ' +
        'Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.BillingLatitude, ' +
        'Account.BillingLongitude, Account.BillingGeocodeAccuracy FROM Contact WHERE Is_Synced__c = false AND AccountId != null');
    }

    public void execute(Database.BatchableContext BC, List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        List<sObject> recordsToUpdate = new List<sObject>();
        for (Contact contact : contacts) {
            contact.Is_Synced__c = true;
            contact.MailingStreet = contact.Account.BillingStreet;
            contact.MailingCity = contact.Account.BillingCity;
            contact.MailingState = contact.Account.BillingState;
            contact.MailingPostalCode = contact.Account.BillingPostalCode;
            contact.MailingCountry = contact.Account.BillingCountry;
            contact.MailingLatitude = contact.Account.BillingLatitude;
            contact.MailingLongitude = contact.Account.BillingLongitude;
            contact.MailingGeocodeAccuracy = contact.Account.BillingGeocodeAccuracy;
            accountIds.add(contact.AccountId);
            recordsToUpdate.add(contact);
        }
        for (Id accountId : accountIds) {
            recordsToUpdate.add(new Account(
                    Id = accountId,
                    Updated_By_Contact__c = true
                ));
        }
        update recordsToUpdate;
    }

    public void finish(Database.BatchableContext BC) {
    }
}
