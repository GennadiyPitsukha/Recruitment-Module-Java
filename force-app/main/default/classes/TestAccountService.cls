@IsTest
public class TestAccountService {
    @IsTest
    static void testCreateAccountWithTask() {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 100; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i
            ));
        }
        Test.startTest();
        insert accounts;
        Test.stopTest();
        List<Task> taskList = [
            SELECT Id, WhatId
            FROM Task
        ];
        System.assertEquals(100, taskList.size(), 'There must be one Task which related to the each Account record!');
    }
}
