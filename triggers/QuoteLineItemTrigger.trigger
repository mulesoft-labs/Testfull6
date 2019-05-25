trigger QuoteLineItemTrigger on QuoteLineItem (before insert, before update, before delete) {
	if(Trigger.isBefore && Trigger.isInsert){
		QuoteLineItemTriggerHandler handler = new QuoteLineItemTriggerHandler();
		handler.handleBeforeInsert(Trigger.new);
		
	}
	if(Trigger.isBefore && Trigger.isUpdate){
		QuoteLineItemTriggerHandler handler = new QuoteLineItemTriggerHandler();
		handler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);
	}
	if(Trigger.isBefore && Trigger.isDelete){
		QuoteLineItemTriggerHandler handler = new QuoteLineItemTriggerHandler();
		handler.handleBeforeDelete(Trigger.old);
	}
}