trigger TechEnvironmentBeforeInsert on Profile_Qualification__c (before insert) {
    if (Trigger.isInsert) {
        for (Profile_Qualification__c  te : Trigger.new) {
            Opportunity o = [SELECT AccountId, Id from Opportunity where Id=:te.Opportunity__c];
            te.Account__c = o.AccountId;
            
        }       
    }
}