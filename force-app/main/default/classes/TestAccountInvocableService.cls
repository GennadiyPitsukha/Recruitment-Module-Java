@IsTest
public class TestAccountInvocableService {
    @TestSetup
    static void makeData() {
        Account acct = new Account(Name = 'Second Test Account');
        insert acct;
        List<Task> taskList = new List<Task>();
        for(Integer i = 0; i < 4; i++) {
            taskList.add(new Task(
                Subject = 'Test Task for ' + acct.Name,
                WhatId = acct.Id
            ));
        }
        insert taskList;
    }

    @IsTest
    static void testCreateAccountWithTask() {
        Account acct = new Account(Name = 'Test Account');
        Test.startTest();
        insert acct;
        Test.stopTest();
        List<Task> taskList = [
            SELECT Id, WhatId
            FROM Task
            WHERE WhatId = :acct.Id
        ];
        System.assertEquals(1, taskList.size(), 'There must be one Task which related to the Account record!');
    }

    @IsTest
    static void testUpdateAccount() {
        Account acct = [
            SELECT Id, BillingCity
            FROM Account
            WHERE Name = 'Second Test Account'
        ];
        acct.BillingCity = 'Misk';
        Test.startTest();
        update acct;
        Test.stopTest();
        List<Task> taskList = [
            SELECT Id, OwnerId
            FROM Task
            WHERE WhatId = :acct.Id
        ];
        String userId;
        for (Task tsk : taskList) {
            if(userId == null){
                userId = tsk.OwnerId;
            }
            System.assertEquals(userId, tsk.OwnerId, 'Assigned users should be the same!');
        }
    }
}
