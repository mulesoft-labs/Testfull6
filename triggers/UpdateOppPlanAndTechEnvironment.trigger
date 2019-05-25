trigger UpdateOppPlanAndTechEnvironment on Opportunity (after update) {

        List<Opportunity_Plan__c> oppPlans = new List<Opportunity_Plan__c>();
        List<Profile_Qualification__c> techEnvironments = new List<Profile_Qualification__c>();
        List<Opportunity> opps = new List<Opportunity>();
        
        for (Opportunity o : Trigger.new) {
            Opportunity oldOpportunity = Trigger.oldMap.get(o.ID);
            if (o.Name != oldOpportunity.Name)
            {
                //Update OppPlan Name
                List<Opportunity_Plan__c> oppPlanList = [SELECT Name, Id from Opportunity_Plan__c where Opportunity__c=:o.Id];
                if(oppPlanList.size()>0)
                {
                    for(Opportunity_Plan__c oppPlan: oppPlanList)
                    {
                        oppPlan.Name = o.Name + '-' + 'OppPlan';
                        oppPlans.add(oppPlan);
                    }
                }
                
                //Update Technical Environment
                List<Profile_Qualification__c> techEnvironmentList = [SELECT Name, Id from Profile_Qualification__c where Opportunity__c=:o.Id];
                if(techEnvironmentList.size()>0)
                {
                    for(Profile_Qualification__c techEnviron: techEnvironmentList)
                    {
                        techEnviron.Name = o.Name + '-' + 'TechEnvironment';
                        techEnvironments.add(techEnviron);
                    }
                }               
            }           
        }
        if(oppPlans.size() > 0){ 
            update oppPlans;
        }
        
        if(techEnvironments.size() > 0) {
            update techEnvironments;
        }
        
       for (Opportunity o : Trigger.new) {
            Opportunity oldOpportunity = Trigger.oldMap.get(o.ID);
            if (o.Name != oldOpportunity.Name)
            {
               Opportunity opp1 = [SELECT Is_Opp_Name_Changed__c, Id from Opportunity where Id=:o.Id];             
               opp1.Is_Opp_Name_Changed__c = false;
               opps.add(opp1);
            }
            
          }
       if(opps.size() > 0){
           update opps;
       
       }
}