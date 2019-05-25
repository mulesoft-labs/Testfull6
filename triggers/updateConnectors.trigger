trigger updateConnectors on Opportunity (after update) {
   /*for (Opportunity opp : Trigger.new) {
      Opportunity oldOpp = Trigger.oldMap.get(opp.id);
      if ((opp.Amount != oldOpp.Amount) || (opp.ExpectedRevenue != oldOpp.ExpectedRevenue) || (opp.isWon != oldOpp.isWon) || (opp.isClosed != oldOpp.isClosed)) {
          List<Extension_Opportunity__c> connectors;
          connectors = [Select id, ExpectedRevenue__c, BookedRevenue__c, LostRevenue__c, Status__c from Extension_Opportunity__c where Opportunity__c=:opp.id];
          for(Extension_Opportunity__c c : connectors)
          {
             c.ExpectedRevenue__c = 0;
             c.BookedRevenue__c = 0;
             c.LostRevenue__c = 0;
    
             if (opp.isClosed == true && opp.isWon == true){
                 c.Status__c = 'Won';
                 c.BookedRevenue__c = opp.Amount;
             }    
             else if (opp.isClosed == true && opp.isWon == false) {
                 c.Status__c = 'Lost';
                 c.LostRevenue__c = opp.Amount;
             }
             else if (opp.isClosed == false) {
                 c.Status__c = 'In Progress'; 
                 c.ExpectedRevenue__c = opp.ExpectedRevenue;
             }    
             
             update c;
         }
     }

   }*/

}