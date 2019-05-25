trigger OppPlan_SetValuesBeforeInsert on Opportunity_Plan__c (before insert) 
{
    //This trigger copies the Company_Description__c from opportunity. Since this Company_Description__c is long test formula fields cannot be used 
    List<Opportunity_Plan__c> oppPlans = new List<Opportunity_Plan__c>();
    if (Trigger.isInsert) 
    {
        for (Opportunity_Plan__c oppPlan : Trigger.new) {
            Opportunity o = [SELECT Opportunity_Plan__c, Company_Description__c, Id from Opportunity where Id=:oppPlan.Opportunity__c];
            oppPlan.Company_Description__c = o.Company_Description__c;
            oppPlan.Company_Description__c = o.Company_Description__c;
            oppPlans.add(oppPlan);
        }
    }
}