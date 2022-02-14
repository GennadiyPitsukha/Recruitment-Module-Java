public with sharing class UpdateContactsByFuture {
    @Future
    public static void updateContacts() {
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Account account : [
            SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
                (
                    SELECT Id, Processed_By_Future__c, Is_Synced__c
                    FROM Contacts
                )
                FROM Account
                LIMIT 150
        ]) {
            if (account.BillingCountry != null ||
                account.BillingCountry != null ||
                account.BillingState != null ||
                account.BillingCity != null ||
                account.BillingStreet != null ||
                account.BillingPostalCode != null) {
                    for (Contact contact : account.Contacts) {
                        contact.Is_Synced__c = false;
                        contact.Processed_By_Future__c = true;
                        contactsToUpdate.add(contact);
                    }
            }
        }
        update contactsToUpdate;
    }
}
