@IsTest
private class TestUpdateTaskBatch {
    @TestSetup
    static void setup() {
        List<Account> testAccountList = new List<Account>();
        List<Task> testTaskList = new List<Task>();
        for (Integer i = 0; i < 10; i++) {
            testAccountList.add(new Account(
                Name='Account '+ i,
                BillingCity = 'New York',
                BillingCountry = 'USA'
            ));
        }
        insert testAccountList;
        for (Account account : testAccountList) {
            testTaskList.add(new Task(
                Subject = 'Test Task for ' + account.Name,
                WhatId = account.Id,
                Is_Synced__c = false
            ));
        }
        for (Integer i = 0; i < 10; i++) {
            testTaskList.add(new Task(
                Subject = 'Test Task without Account ' + i,
                Is_Synced__c = false
            ));
        }
        insert testTaskList;
    }
    @isTest
    static void testUpdateTaskBatch() {
        Test.startTest();
        UpdateTaskBatch batch = new UpdateTaskBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        for (Task task : [
            SELECT Id, Is_Synced__c, Account_Owner__c, Account.Owner.Name, Account.Updated_By_Task__c
            FROM Task
        ]) {
            if (task.AccountId != null) {
                System.assertEquals(true, task.Account.Updated_By_Task__c, 'Should be checked as updated');
                System.assertEquals(task.Account.Owner.Name, task.Account_Owner__c, 'Account owner name was not set');
            }
            System.assertEquals(true, task.Is_Synced__c, 'Should be checked as Synced');
        }
    }
}