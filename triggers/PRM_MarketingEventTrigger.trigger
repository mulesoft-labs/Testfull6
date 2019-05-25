trigger PRM_MarketingEventTrigger on Marketing_Event__c (before insert, before update) {
if(trigger.isInsert){
        if( trigger.isBefore ){
        
        PRM_MarketingEventTriggerHelper.populateFieldsOnMarketingEvents(Trigger.New);
        
     } 
} 
if( trigger.isUpdate ){
        if( trigger.isBefore ){
            // code to fire on Before Update
             For(Marketing_Event__c c:Trigger.New)
            {
                if(c.Rejected__c && (c.Rejection_Reason__c == null || c.Rejection_Reason__c == ''))
                {
                    c.addError('Please Enter Rejection Reason.');
                } 
            }
            
            
            
            
        }
        
    } 

}