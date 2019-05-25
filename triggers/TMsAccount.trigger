trigger TMsAccount on Account (before insert,before update,after insert,after update, before delete, after delete) {
    if(CMsTriggerRunCounter.skipAccountTrigger) {
        return;
    }
    new CMsAccountTriggerHandler().handle();
}