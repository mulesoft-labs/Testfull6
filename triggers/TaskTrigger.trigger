trigger TaskTrigger on Task (before insert,before update,after insert,after update, before delete, after delete, after undelete) {
    new TaskTriggerUtility().handle();
}