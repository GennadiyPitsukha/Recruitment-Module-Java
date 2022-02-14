public class ScheduleBatchJobsEveryHalfHour implements Schedulable {
    public static String CRON_EXP_1 = '0 0 * 13,14 2 ? 2022';
    public static String CRON_EXP_2 = '0 30 * 13,14 2 ? 2022';
    public void execute(SchedulableContext ctx) {
        UpdateTaskBatch updateTaskBatch = new UpdateTaskBatch();
        Database.executeBatch(updateTaskBatch);
        AccountContactAddressSync accountContactAddressSync = new AccountContactAddressSync();
        Database.executeBatch(accountContactAddressSync);
    }
}
