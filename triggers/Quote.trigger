trigger Quote on SBQQ__Quote__c (before insert, after insert, before update, after update, before delete) {
    
    System.debug(LoggingLevel.ERROR, '$$$$$$$$$$--------> Inside Quote ---> CMsTriggerRunCounter.skipQuoteTrigger --> '+CMsTriggerRunCounter.skipQuoteTrigger);
    //Skip this trigger if the static variable CMsTriggerRunCounter.skipQuoteTrigger == true
    if(CMsTriggerRunCounter.skipQuoteTrigger){
        return;
    }
    
    /*
    if(Trigger.isInsert && Trigger.isAfter){
        QuoteHandler.onAfterInsert(Trigger.newMap);
    }
    */
    if(Trigger.isUpdate && Trigger.isAfter){
        QuoteHandler.isAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isInsert){       
        QuoteHandler.handleBeforeInsert(Trigger.new);       
    }
    if(Trigger.isBefore && Trigger.isUpdate){       
        QuoteHandler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isDelete){       
        QuoteHandler.handleBeforeDelete(Trigger.old);
    }
}