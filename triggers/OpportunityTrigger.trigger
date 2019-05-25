/**
*   Author:-        Andrew (Mondaycall)
*   Created:-       2/20/2014
*   Description:-   Opportunity Trigger
*   Revision:-      
*                   03/01/2014  - Andrew (Mondaycall)   Create loss report when opportunity get lost  (on After Update)
*                   03/01/2014  - Andrew (Mondaycall)   Create Win report When opportunity stage changed to Awaiting Paperwork (On After Update)
*                   01/08/2015 - Perficient, Narasimha  Create Opportunity Team members on different scenraios and validate Mutual close plan activity.
**/
trigger OpportunityTrigger on Opportunity (before insert,after insert, before update, after update, after delete)
{
    System.debug(LoggingLevel.ERROR, '$$$$$$$$$$ --------> TRIGGER --> Inside OpportunityTrigger ---> CMsTriggerRunCounter.skipOppTrigger --> '+CMsTriggerRunCounter.skipOppTrigger);
    //Skip this trigger if the static variable CMsTriggerRunCounter.skipOppTrigger == true
    if(CMsTriggerRunCounter.skipOppTrigger){
        return;
    }    
    
    if(Trigger.isBefore && Trigger.isInsert){
    	System.debug(LoggingLevel.ERROR, '$$$$$$$$$$ --------> TRIGGER -->  Inside OpportunityTrigger ---> BEFORE INSERT');
        OpportunityTriggerHandler oHandler = new OpportunityTriggerHandler();
        oHandler.onBeforeInsert(Trigger.new);   
    }    
    else if(Trigger.isAfter)
    {
    	System.debug(LoggingLevel.ERROR, '$$$$$$$$$$ --------> TRIGGER -->  Inside OpportunityTrigger ---> AFTER');
       OpportunityTeamMemberManager opptyTeamMemberMangerObj = new OpportunityTeamMemberManager();
        if(Trigger.isInsert)
        {
    		System.debug(LoggingLevel.ERROR, '$$$$$$$$$$ --------> TRIGGER --> Inside OpportunityTrigger ---> AFTER INSERT');
            OpportunityTriggerHandler oHandler = new OpportunityTriggerHandler();
            oHandler.onAfterInsert(trigger.newMap);
            
            if(!Utilities.currentUser.Trigger_Override__c && !CMsTriggerRunCounter.skipOppTeamMemberCopy){
                	opptyTeamMemberMangerObj.createOppTeamMember(null,trigger.newMap,true,false); //create Oppty Team Members on different scenarios
            }
            if(!CMsTriggerRunCounter.skipPartnerInfleunceTrigger){
            	opptyTeamMemberMangerObj.createPartnerDetailsRecords(trigger.newMap);         //create Partner details record 
        	}
        }
        else if(Trigger.isUpdate)
        {
    		System.debug(LoggingLevel.ERROR, '$$$$$$$$$$--------> TRIGGER --> Inside OpportunityTrigger ---> AFTER UPDATE');
            if(!Utilities.currentUser.Trigger_Override__c && !CMsTriggerRunCounter.skipOppTeamMemberCopy){
                opptyTeamMemberMangerObj.createOppTeamMember(trigger.oldMap,trigger.newMap,false,true); //create Oppty Team Members
            }
            
            OpportunityTriggerHandler oHandler = new OpportunityTriggerHandler();
            oHandler.onAfterUpdate(Trigger.NewMap, Trigger.oldMap);
            if(!TriggerRecursiveHandler.hasRun())
            {
                // Create Chatter Post when Opportunity Probability is at 10%                
                SCNotifications.notifyAt10Percent(Trigger.oldMap, Trigger.newMap);  
            }
        }
    }
    else if(Trigger.isBefore && Trigger.isUpdate)
    {
    	System.debug(LoggingLevel.ERROR, '$$$$$$$$$$--------> Inside OpportunityTrigger ---> BEFORE UPDATE');
        OpportunityTriggerHandler oHandler = new OpportunityTriggerHandler();
         oHandler.onBeforeUpdate(Trigger.NewMap, Trigger.oldMap);        
 
        // Updates an Opportunity's lead source to the Primary Contact's lead
        // source when its probability is 10%
        // Changed to only execute when test is running due to conflict with validation rule in PROD - RM 08/22/14
        if(Test.isRunningTest())
        {
            Opportunity10Percent.setLeadSourceToPrimaryContactLeadSource(Trigger.new);
        }        
    }    
    
    if(Trigger.isAfter && Trigger.isDelete){
    	System.debug(LoggingLevel.ERROR, '$$$$$$$$$$--------> Inside OpportunityTrigger ---> AFTER DELETE');
        OpportunityTriggerHandler oHandler = new OpportunityTriggerHandler();
        oHandler.afterDelete(Trigger.old);
    }
}