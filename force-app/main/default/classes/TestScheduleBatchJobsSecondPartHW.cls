@IsTest
public class TestScheduleBatchJobsSecondPartHW {
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
    }

    @IsTest
    static void testScheduleBatchJobsSecondPartHW() {
        Test.startTest();
        String jobId = System.schedule('testScheduledApex',
        ScheduleBatchJobsSecondPartHW.CRON_EXP_1,
            new ScheduleBatchJobsSecondPartHW());
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE id = :jobId];
        System.assertEquals(ScheduleBatchJobsSecondPartHW.CRON_EXP_1,
            ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-02-14 11:00:00',
        String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}