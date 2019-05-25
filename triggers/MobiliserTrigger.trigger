trigger MobiliserTrigger on Mobiliser__c (after delete, after insert, after update) {
    MobiliserTriggerHelper.processMobiliser(trigger.new,trigger.old);
}