trigger Opp_SetValuesBeforeUpdate on Opportunity (before update) {

    //commented by Teddy Zemedie, Trigger logic consolidated and trigger ready to be removed once testing is complete
    /*for (Opportunity o:trigger.new)
    {
         Opportunity oldOpp = Trigger.oldMap.get(o.ID);
         if(o.StageName != 'Closed Won' && o.StageName != 'Rejected Lead')
         {
             if (o.Probability != oldOpp.Probability)
             {
                if(o.Probability==10){
                     o.Date_Probability_10__c = System.TODAY();
                 }          
             }
            if (o.Name != oldOpp.Name)
            {
                o.Is_Opp_Name_Changed__c=true;
            }
        }
    }*/
}