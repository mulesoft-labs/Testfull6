/*********************************************************************
*
*   File Name: LeadTrigger.trigger
*
*   File Description: Generic trigger for the Lead object
*
**********************************************************************
*
*   Date        Author            Change
*
*   07/03/14    Robert            Added before insert handling so that
*                                 validation is performed on lead before insert
*   02/20/14    Andrew            Initial Creation                          
*
*********************************************************************/
        
trigger LeadTrigger on Lead (before insert, after insert, before update, after update)
{
    
    LeadTriggerHandler oHandler = new LeadTriggerHandler();
    if(trigger.isBefore && trigger.isInsert){
        oHandler.onBeforeInsert(Trigger.new); 
    }
    if(trigger.isAfter&& trigger.isInsert ){
        oHandler.onAfterInsert(Trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate){
        oHandler.onBeforeUpdate(Trigger.New, Trigger.OldMap);   
    }
    if(trigger.isAfter && trigger.isUpdate){
        oHandler.onAfterUpdate(Trigger.New, Trigger.OldMap);   
    }
}