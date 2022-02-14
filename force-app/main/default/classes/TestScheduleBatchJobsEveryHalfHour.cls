@IsTest
public class TestScheduleBatchJobsEveryHalfHour {
    @TestSetup
    static void makeData(){
        List<Account> testAccountList = new List<Account>();
        List<Contact> testContactList = new List<Contact>();
        List<Task> testTaskList = new List<Task>();
        for (Integer i = 0; i < 100; i++) {
            testAccountList.add(new Account(
                Name = 'TA ' + i,
                BillingCountry = 'BC ' + i,
                BillingState = 'BS ' + i,
                BillingCity = 'BC ' + i,
                BillingStreet = 'BS ' + i,
                BillingPostalCode = 'BPC ' + i
            ));
        }
        insert testAccountList;
        for (Account account : testAccountList) {
            testContactList.add(new Contact(
                LastName = 'Test Contact for ' + account.Name,
                AccountId = account.Id,
                Is_Synced__c = false
            ));
        }
        insert testContactList;
        for (Account account : testAccountList) {
            testTaskList.add(new Task(
                Subject = 'Test Task for ' + account.Name,
                WhatId = account.Id,
                Is_Synced__c = false
            ));
        }
        insert testTaskList;
    }

    @IsTest
    static void testScheduleBatchJobsEveryHalfHour() {
        Test.startTest();
        String jobId = System.schedule('testScheduledApex',
        ScheduleBatchJobsEveryHalfHour.CRON_EXP_1,
            new ScheduleBatchJobsEveryHalfHour());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
            NextFireTime
            FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(ScheduleBatchJobsEveryHalfHour.CRON_EXP_1,
            ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-02-14 01:00:00',
            String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}
