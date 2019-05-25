/*
 *@Author:      Narasimha (Perficient)
 *@CreatedDate: 01/21/2015
 *@Desc: single trigger for all Partner_Influence__c object events.
*/
trigger PartnerInfluenceTrigger on Partner_Influence__c (before insert, after insert,before update, after update, before delete, after delete) {
	
	//Skip this trigger if the static variable CMsTriggerRunCounter.skipPartnerInfleunceTrigger == true
    if(CMsTriggerRunCounter.skipPartnerInfleunceTrigger){
        return;
    }
    
	if(Trigger.isAfter && Trigger.isInsert){
		//if(!Test.isRunningTest()){
			PartnerInfluenceTriggerHandler prtHandler = new PartnerInfluenceTriggerHandler();
			prtHandler.handlerAfterInsert(Trigger.new,Trigger.newMap,Trigger.oldMap);
		//}
	}
	if(Trigger.isAfter && Trigger.isUpdate){
		//if(!Test.isRunningTest()){
			PartnerInfluenceTriggerHandler prtHandler = new PartnerInfluenceTriggerHandler();
			prtHandler.handlerAfterUpdate(Trigger.new,Trigger.oldMap);
		//}
	}

	
	if(Trigger.isBefore && Trigger.isInsert){
		PartnerInfluenceTriggerHandler prtHandler = new PartnerInfluenceTriggerHandler();
		prtHandler.handleBeforeInsert(Trigger.new);
	}

    if(Trigger.isBefore && Trigger.isUpdate){
		PartnerInfluenceTriggerHandler prtHandler = new PartnerInfluenceTriggerHandler();
		prtHandler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);
	}
    
	if(Trigger.isBefore && Trigger.isDelete){
		PartnerInfluenceTriggerHandler prtHandler = new PartnerInfluenceTriggerHandler();
		prtHandler.handleBeforeDelete(Trigger.old);
	}
    
	if(Trigger.isAfter && Trigger.isDelete){
		PartnerInfluenceTriggerHandler prtHandler = new PartnerInfluenceTriggerHandler();
		prtHandler.handlerAfterDelete(Trigger.oldMap);
	}
	
}