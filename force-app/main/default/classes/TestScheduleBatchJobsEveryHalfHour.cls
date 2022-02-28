@IsTest
private class TestScheduleBatchJobsEveryHalfHour {
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
