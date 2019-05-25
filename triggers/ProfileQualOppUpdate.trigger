trigger ProfileQualOppUpdate on Profile_Qualification__c (after insert) 
{  
    if (Trigger.isInsert) {
        List<Opportunity> opps = new List<Opportunity>();
        for (Profile_Qualification__c pq : Trigger.new) {
            Opportunity o = [SELECT Profile_and_Qualifications__c, Id from Opportunity where Id=:pq.Opportunity__c];
            o.Profile_and_Qualifications__c = pq.Id;
            opps.add(o);
        }
        if(!opps.isEmpty()){
            update opps;
        }
    }
}