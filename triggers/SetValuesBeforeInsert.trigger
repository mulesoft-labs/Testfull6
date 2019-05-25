trigger SetValuesBeforeInsert on SC_Action__c (before insert) {
     //List<Solution_Consulting_Action__c> scaList = new List<Solution_Consulting_Action__c>();
     
     String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
     for (SC_Action__c sca : Trigger.new)
     {
         if(sca.Opportunity__c != null){
              sca.Opportunity_Link__c = sfdcURL + sca.Opportunity__c;  
              List<Opportunity> oList = [SELECT 
                   Opportunity_Plan__c,Tech_Assessment__c, Id, AccountId
                   FROM Opportunity where Id=:sca.Opportunity__c ORDER By LastModifiedDate DESC LIMIT 1];
              if(oList.size()>0)
              {
                  sca.Solution_Assessment__c = oList[0].Tech_Assessment__c;
                  sca.Account__c = oList[0].AccountId;
                  List<OpportunityContactRole> contactRolesList = new List<OpportunityContactRole> ([SELECT Id, OpportunityId, ContactId, Role from OpportunityContactRole where OpportunityId=:oList[0].Id]);
                  if(contactRolesList.size()>0)
                  {  
                       List<String> ContactIds = new List<String>();
                       for(OpportunityContactRole contactRole:contactRolesList){
                           ContactIds.add(contactRole.ContactId);
                       }
                       
                       List<Contact> contactList = [SELECT Id, FirstName, LastName, Title from Contact where Id IN:ContactIds];
 
                       for(OpportunityContactRole cRole:contactRolesList){
                           for(Contact c:contactList){
                               if(c.Id == cRole.ContactId){
                                   if(sca.Attendees_Roles__c == null){
                                       sca.Attendees_Roles__c = c.FirstName + ' ' + c.LastName + ' : ' + c.Title + ' : ' + cRole.Role + '\n';
                                   }else{
                                       sca.Attendees_Roles__c = sca.Attendees_Roles__c + c.FirstName + ' ' + c.LastName + ' : ' + c.Title + ' : ' + cRole.Role + '\n';
                                   }
                                }
                           
                           }
                       }//FOR CONTACT ROLE                         
                  }                 
                }
              }         
        
         //Put most recent solution assessment
         if(sca.Account__c != null){   
             List<Profile_Qualification__c> pqList = [SELECT Id
                   FROM Profile_Qualification__c where Account__c=:sca.Account__c ORDER By LastModifiedDate DESC LIMIT 1];
             if(pqList.size()>0)
             {
                   sca.Solution_Assessment__c = pqList[0].Id;
             }
         }
         
         //sca.On_Site1__c = 'No';
     }
}