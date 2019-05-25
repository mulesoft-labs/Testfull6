trigger SolnAsessement_RelatedFieldsAfterUpdate on Profile_Qualification__c (after insert) {
    if (Trigger.isInsert) {
        List<Opportunity> opps = new List<Opportunity>();
        for (Profile_Qualification__c  te : Trigger.new) {
            Opportunity o = [SELECT Tech_Assessment__c, Id from Opportunity where Id=:te.Opportunity__c];
            if(o.Tech_Assessment__c == null){
                o.Tech_Assessment__c  = te.Id;
                opps.add(o);
            }
        }
        if(!opps.isEmpty()){
            update opps;
        }
    }
}