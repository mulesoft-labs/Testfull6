trigger PRM_CompetencyTrigger on Competency__c (before insert, before update) {
if(trigger.isInsert){
        if( trigger.isBefore ){
        
        PRM_CompetencyTriggerHelper.populateFieldsOnCompetency(Trigger.New);
        
     } 
} 


     
if( trigger.isUpdate ){
        if( trigger.isBefore ){
            // code to fire on Before Update
             For(Competency__c c:Trigger.New)
            {
                if(c.Rejected__c && (c.Rejection_Reason__c == null || c.Rejection_Reason__c == ''))
                {
                    c.addError('Please Enter Rejection Reason.');
                } 
            }
            
            
            
            
        }
        
    } 

}