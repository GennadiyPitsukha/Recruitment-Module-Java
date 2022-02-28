@IsTest
private class TestScheduleBatchJobsSecondPartHW {
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