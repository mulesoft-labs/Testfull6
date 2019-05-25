trigger OppPlan_RelatedFieldAfterInsert on Opportunity_Plan__c (after insert) 
{
    //This trigger updates the Opportunity Plan look-up field in Opportunity.
   
    List<Opportunity> opps = new List<Opportunity>();
    
    if (Trigger.isInsert) {
        for (Opportunity_Plan__c oppPlan : Trigger.new) {
            Opportunity o = [SELECT Opportunity_Plan__c,Id from Opportunity where Id=:oppPlan.Opportunity__c];
            if(o.Opportunity_Plan__c == null){
                o.Opportunity_Plan__c=oppPlan.Id;
                opps.add(o);
            }
        }
        
        if(!opps.isEmpty()){
            update opps;
        }
    }
}