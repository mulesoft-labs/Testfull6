trigger UpdateOppAfterInsert on Account (after insert) {
    /*
        List<Opportunity> opps = new List<Opportunity>();
        for (Account a : Trigger.new) 
        {
            //List of Open Opportunitie
            List<Opportunity> oppList = [SELECT StageName, Company_Description__c, Id from Opportunity where AccountId=:a.Id];
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
        if(!opps.isEmpty()){ 
            update opps;
        }
        */
}