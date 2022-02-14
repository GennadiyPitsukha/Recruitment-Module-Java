public class UpdateTaskBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator ('SELECT Id, AccountId, Account.Owner.Name, Is_Synced__c, Account_Owner__c ' +
                                        'FROM Task WHERE Is_Synced__c = false');
    }

    public void execute(Database.BatchableContext BC, List<Task> tasks) {
        Set<Id> accountIds = new Set<Id>();
        List<sObject> recordsToUpdate = new List<sObject>();
        for (Task task : tasks) {
            task.Is_Synced__c = true;
            if (task.AccountId != null) {
                task.Account_Owner__c = task.Account.Owner.Name;
                accountIds.add(task.AccountId);
            }
            recordsToUpdate.add(task);
        }
        for (Id accountId : accountIds) {
            recordsToUpdate.add(new Account(
                    Id = accountId,
                    Updated_By_Task__c = true
                ));
        }
        update recordsToUpdate;
    }

    public void finish(Database.BatchableContext BC) {
    }
}
