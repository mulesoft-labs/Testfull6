trigger UpdateOppAfterUpdate on Account (after update) {
    /*
        List<Opportunity> opps = new List<Opportunity>();
        for (Account a : Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(a.ID);
            if (a.Company_Description__c != oldAccount.Company_Description__c)
            {
                //List of Open Opportunities
                List<Opportunity> oppList = [SELECT StageName,Company_Description__c, Id from Opportunity where AccountId=:a.Id];
                if(oppList.size() > 0)
                {
                    for(Opportunity o: oppList)
                    {
                        if (o.StageName != 'Closed Won' && o.StageName != 'Closed Lost'){
                            o.Company_Description__c = a.Company_Description__c;
                            opps.add(o);
                        }
                    }
                }
            }
        }
        if(!opps.isEmpty()){ 
            update opps;
        }
    */
}