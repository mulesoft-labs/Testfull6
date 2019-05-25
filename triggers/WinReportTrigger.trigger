/**
*   Author:-        Andrew (Mondaycall)
*   Created:-       2/24/2014
*   Description:-   Win_Report__c Trigger
*   Revision:-  
**/
trigger WinReportTrigger on Win_Report__c (before update, before insert) {
    WinReportTriggerHandler oHandler = new WinReportTriggerHandler();
    
    if(Trigger.isBefore && Trigger.isInsert){
        //oHandler.onBeforeInsert(Trigger.New);
    }else if(Trigger.isBefore && Trigger.isUpdate){
        //oHandler.onBeforeUpdate(Trigger.New);       
    }
    
}