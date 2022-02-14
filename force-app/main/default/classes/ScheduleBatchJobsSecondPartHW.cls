public class ScheduleBatchJobsSecondPartHW implements Schedulable {
    public static String CRON_EXP_1 = '0 0 * 14 2 ? 2022';
    public static String CRON_EXP_2 = '0 30 * 14 2 ? 2022';
    public void execute(SchedulableContext ctx) {
        UpdateContactBathcJobQueryLocator queryLocatorBatch = new UpdateContactBathcJobQueryLocator();
        Database.executeBatch(queryLocatorBatch);
        UpdateContactBatchJobIterable iterableBatch = new UpdateContactBatchJobIterable();
        Database.executeBatch(iterableBatch);
    }
}
