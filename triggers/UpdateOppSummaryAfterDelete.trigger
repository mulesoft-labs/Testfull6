trigger UpdateOppSummaryAfterDelete on Mutual_Close_Plan__c (after delete) {

    List<Mutual_Close_Plan__c> mcPlans = new List<Mutual_Close_Plan__c>();
    for(Mutual_Close_Plan__c mcp:Trigger.old)
    { 
           System.debug ('Opportunity Id ' + mcp.Opportunity__c);
           mcPlans = [SELECT Opportunity__c, Action_Owner__c, Due_Date__c, Mutual_Close_Action_Name__c, Id 
                       FROM Mutual_Close_Plan__c  
                       WHERE Opportunity__c=:mcp.Opportunity__c AND Is_Completed__c =:false
                       ORDER BY CreatedDate DESC LIMIT 5];
            System.debug ('Size' + mcPlans.size ());
            Opportunity o = [SELECT Mutual_Close_Plan_Summary__c, Id from Opportunity where Id=:mcp.Opportunity__c];
            o.Mutual_Close_Plan_Summary__c = '';
            if (mcPlans.size () > 0)
            {
                integer i = mcPlans.size()-1;
                integer j = 1;
                while(i>=0){                   
                       o.Mutual_Close_Plan_Summary__c= o.Mutual_Close_Plan_Summary__c + '\n' + j + '. ' +
                                                        mcPlans[i].Due_Date__c.format() + '; ' + 
                                                        mcPlans[i].Mutual_Close_Action_Name__c + '; ' +
                                                        mcPlans[i].Action_Owner__c +  '\n';
                         
                        j++;              
                       i--;  
                }
                update o;
            }
     }
   
}