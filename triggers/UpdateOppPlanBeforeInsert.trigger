trigger UpdateOppPlanBeforeInsert on Mutual_Close_Plan__c (before insert) {
    List<Mutual_Close_Plan__c> mcPlans = new List<Mutual_Close_Plan__c>();
    if (Trigger.isInsert) 
    {
        for (Mutual_Close_Plan__c mcPlan : Trigger.new) {
            Opportunity o = [SELECT Opportunity_Plan__c, Id from Opportunity where Id=:mcPlan.Opportunity__c];
            mcPlan.Opportunity_Plan__c = o.Opportunity_Plan__c;
            mcPlans.add(mcPlan);
        }
    }
}