/**
*	Author:- 		Andrew (Mondaycall)
*	Created:-		2/24/2014
*	Description:-	Win_Report__c Trigger
*	Revision:-	
**/
trigger LossReportTrigger on Loss_Report__c (before update, before insert) {
	LossReportTriggerHandler oHandler = new LossReportTriggerHandler();
	
	if(Trigger.isBefore && Trigger.isInsert){
		oHandler.onBeforeInsert(Trigger.New);
	}else if(Trigger.isBefore && Trigger.isUpdate){
		oHandler.onBeforeUpdate(Trigger.New);		
	}
	
}