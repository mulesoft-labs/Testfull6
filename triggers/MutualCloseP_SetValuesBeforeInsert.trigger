trigger MutualCloseP_SetValuesBeforeInsert on Mutual_Close_Plan__c (before insert) {
    List<Mutual_Close_Plan__c> mcPlans = new List<Mutual_Close_Plan__c>();
    if (Trigger.isInsert) 
    {
        for (Mutual_Close_Plan__c mcPlan : Trigger.new) {
            Opportunity o = [SELECT Id from Opportunity where Id=:mcPlan.Opportunity__c];
            mcPlans.add(mcPlan);
        }
    }
}