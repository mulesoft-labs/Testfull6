/**
*  Author:-     Andrew (Mondaycall)
*  Created:-    2/24/2014
*  Description:-  SC_Action__c Trigger
*  Revision:-  
**/
trigger SCActionTrigger on SC_Action__c (after Insert) {
  SCActionTriggerHandler oHandler = new SCActionTriggerHandler();
  
  //After Insert event
  if(Trigger.isAfter && Trigger.isInsert){
    oHandler.onAfterInsert(Trigger.NewMap, Trigger.oldMap);
  }
  
}