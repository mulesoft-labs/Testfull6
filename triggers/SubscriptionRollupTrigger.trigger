trigger SubscriptionRollupTrigger on SBQQ__Subscription__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
  if(CMsTriggerRunCounter.skipSubscriptionTrigger == true) {
    return;
  }
  SubscriptionRollupTriggerHandler handler = new SubscriptionRollupTriggerHandler(Trigger.isExecuting, Trigger.size);

  if(Trigger.isInsert && Trigger.isAfter){
    SubscriptionRollupTriggerHandler.OnAfterInsert(Trigger.newMap);
  } else if(Trigger.isUpdate && Trigger.isAfter){
    SubscriptionRollupTriggerHandler.OnAfterUpdate(Trigger.newMap,Trigger.oldMap);
  } else if(Trigger.isDelete && Trigger.isAfter){
    SubscriptionRollupTriggerHandler.OnAfterDelete(Trigger.oldMap);
  } else if(Trigger.isUnDelete){
    SubscriptionRollupTriggerHandler.OnUndelete(Trigger.newMap);
  }
}