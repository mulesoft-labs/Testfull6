/* 11/11/16 Santoshi Added acount team member logic 
*@updated Date: 11/8/2016 JoJo Zhao(Perficient)
*       Add test branch for Call the watchdog screening request
*/

trigger AccountTrigger on Account (after insert, after update) {
    System.debug(LoggingLevel.ERROR, '************************* --------> TRIGGER --> Inside AccountTrigger ');
    
    AccountTriggerHandler atriggerHandler = new AccountTriggerHandler();
    if(Trigger.isAfter && Trigger.isInsert){
	    System.debug(LoggingLevel.ERROR, '************************* --------> TRIGGER --> Inside AccountTrigger ---> AFTER INSERT');        
        AccountTriggerHelper.updateAccountTeamMember(trigger.new,null); 
    }
    if(Trigger.isAfter && Trigger.isUpdate){
	    System.debug(LoggingLevel.ERROR, '************************* --------> TRIGGER --> Inside AccountTrigger ---> AFTER UPDATE');        
        AccountTriggerHelper.updateAccountTeamMember(trigger.new,trigger.oldMap);
    }
    //skip the execution for UNIT Testing to avoid redudant Execution
    //if(!Test.isRunningTest()){
        //handle inserts
        if(Trigger.isInsert){
            atriggerHandler.onAfterInsert(trigger.newMap);
            // Call to update Account Team Member            
        }
        //handle updates
        if(Trigger.isUpdate){
		    System.debug(LoggingLevel.ERROR, 'Inside AccountTrigger 1 ---> isUpdate --> ');            
            atriggerHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
        } 
    //}
}