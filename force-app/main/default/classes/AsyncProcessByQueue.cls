public class AsyncProcessByQueue implements Queueable {
    private List<Id> accountIds;
    public AsyncProcessByQueue(List<Id> listAccountIds) {
        this.accountIds = listAccountIds;
    }
    public void execute(QueueableContext context) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact contact : [
            SELECT Id, AccountId, Processed_By_Queue__c, Is_Synced__c
            FROM Contact
            WHERE AccountId IN :accountIds
        ]) {
            contact.Is_Synced__c = false;
            contact.Processed_By_Queue__c = true;
            contactsToUpdate.add(contact);
        }
        update contactsToUpdate;
    }
}
