trigger QuoteLineTrigger on SBQQ__QuoteLine__c (before insert, after insert, before update, after update, before delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            QuoteLineHandler.onAfterInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            QuoteLineHandler.onAfterUpdate(Trigger.new);            
        }    
    }

    if(Trigger.isBefore && Trigger.isInsert){       
        QuoteLineHandler.handleBeforeInsert(Trigger.new);       
    }
    if(Trigger.isBefore && Trigger.isUpdate){       
        QuoteLineHandler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isDelete){       
        QuoteLineHandler.handleBeforeDelete(Trigger.old);
    }
}