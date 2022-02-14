public class AccountService {
    @Future
    public static void createTasks(Set<Id> ids) {
        List<Task> taskList = new List<Task>();
        for (Account account : [
            SELECT Id, Name, CreatedDate, LastModifiedDate
            FROM Account
            WHERE Id IN :ids
        ]) {
            taskList.add(new Task(
                Subject = 'Negotiations with ' + account.Name,
                WhatId = account.Id,
                Is_Synced__c = false
            ));
        }
        insert taskList;
    }
}
