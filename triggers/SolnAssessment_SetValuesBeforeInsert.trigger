trigger SolnAssessment_SetValuesBeforeInsert on Profile_Qualification__c (before insert) {
    if (Trigger.isInsert) {
        for (Profile_Qualification__c  te : Trigger.new) {
            if(te.Opportunity__c != null)
            {
                Opportunity o = [SELECT AccountId, Id from Opportunity where Id=:te.Opportunity__c]; 
                if(te.Account__c == null)   {     
                    te.Account__c = o.AccountId;
                }
            }
            
        }       
    }
}