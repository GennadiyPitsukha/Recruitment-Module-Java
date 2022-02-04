public class AccountInvocableService {
    @InvocableMethod(label='Work with tasks' category='Account')
    public static void accountInvocableService(List<ID> ids) {
        List<Task> taskList = new List<Task>();
        List<User> userList = [
            SELECT Id
            FROM User
            WHERE IsActive = true
        ];
        for (Account acc : [
            SELECT Id, Name, CreatedDate, LastModifiedDate, (SELECT Id, OwnerId FROM Tasks)
            FROM Account
            WHERE Id IN :ids
        ]) {
            if (acc.CreatedDate == acc.LastModifiedDate) {
                taskList.add(new Task(
                    Subject = 'Negotiations with ' + acc.Name,
                    WhatId = acc.Id
                ));
            } else if (acc.CreatedDate != acc.LastModifiedDate && acc.Tasks.size() >= 3) {
                User randomUser = getRandomUser(userList);
                for(Task task : acc.Tasks) {
                    task.OwnerId = randomUser.Id;
                    taskList.add(task);
                }
            }
        }
        upsert taskList;
    }

    private static User getRandomUser(List<User> users) {
        Integer max = users.size();
        return users.get(rnd(max));

    }
    private static Integer rnd(Integer max) {
	    return (Integer) (Math.random() * max);
    }
}
