trigger AccountTrigger on Account (before insert, before update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.beforeInsert(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
    }
}