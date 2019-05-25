/**
*   Author:-        Narasimha(Perficient)
*   Created:-       01/09/2015
*   Description:-   OpportunityTeamMemberTrigger
                    handle all the Trigger events to the OpportunityTeamMemberHandler class
*   Revision:-      
*                  
**/   
trigger OpportunityTeamMemberTrigger on OpportunityTeamMember (before insert, after insert, before update, after update, before delete) {
	System.debug(LoggingLevel.ERROR, 'Inside OpportunityTeamMemberTrigger Trigger');      
	System.debug(LoggingLevel.ERROR, 'Inside OpportunityTeamMemberTrigger Trigger --> Utilities.currentUser.Trigger_Override__c --> '+ Utilities.currentUser.Trigger_Override__c);                                        
    if(!Utilities.currentUser.Trigger_Override__c){
        if(Trigger.isBefore && Trigger.isInsert){
            OpportunityTeamMemberHandler.onBeforeInsert(trigger.new);
        }
        else if(Trigger.isAfter && Trigger.isInsert){
            OpportunityTeamMemberHandler.onAfterInsert(trigger.new);
        }
        else if(Trigger.isBefore && Trigger.isUpdate){
            OpportunityTeamMemberHandler.onBeforeUpdate(trigger.oldMap,trigger.newMap);
        }
        else if(Trigger.isAfter && Trigger.isUpdate){
            OpportunityTeamMemberHandler.onAfterUpdate(trigger.oldMap,trigger.newMap);
        }
        else if(Trigger.isBefore && Trigger.isDelete){
            OpportunityTeamMemberHandler.onBeforeDelete(trigger.old);
        }
   } 
}