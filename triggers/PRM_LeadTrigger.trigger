/*********************************************************************
*  Trigger Name - PRM_LeadTrigger 
*  Description: Generic trigger for the Lead object
*
*  Date        Author            Change
*  7/7/14      Chris             Initial Creation                          
*
*********************************************************************/
trigger PRM_LeadTrigger on Lead ( before insert, before update,after insert,after update) {
    // code to fire on insert of Lead
    /*if( trigger.isInsert ){
        if( trigger.isBefore ){
            // code to fire on Before Insert
            PRM_LeadTriggerHelper.populateLeadManagerOnInsert(Trigger.new);
        }
    }
    
    // code to fire on update of Lead
    if( trigger.isUpdate ){
        if( trigger.isBefore ){
            // code to fire on Before Update
             For(lead l:Trigger.New)
            {
                if(l.Rejected__c && (l.Rejection_Reason__c == null || l.Rejection_Reason__c == ''))
                {
                    l.addError('Please Enter Rejection Reason.');
                } 
            }
            
            PRM_LeadTriggerHelper.populateLeadManagerOnUpdate( Trigger.New, Trigger.OldMap );
        }
    }*/
}