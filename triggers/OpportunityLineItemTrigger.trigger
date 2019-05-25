trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update, before delete) {	

	if(Trigger.isBefore && Trigger.isInsert){		
		CMsOpportunityLineItemTriggerHandler.onBeforeInsert(Trigger.new);
	}

	if(Trigger.isBefore && Trigger.isUpdate){
		CMsOpportunityLineItemTriggerHandler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
	}

	if(Trigger.isBefore && Trigger.isDelete){
		CMsOpportunityLineItemTriggerHandler.onBeforeDelete(Trigger.oldMap);
	}
	
}