public class PRM_CompetencyTriggerHelper{

     public static void populateFieldsOnCompetency( List<Competency__c> Competencies){
        if(UserInfo.getUserType() != 'Standard'){
         User u = [SELECT Accountid,ContactId,Contact.Account.OwnerId,LastName FROM User 
         WHERE (UserType ='Partner' OR UserType='PowerPartner')
                AND Id = : UserInfo.getUserId() 
         ];
        
        for(Competency__c c : Competencies){
            c.Partner_Account__c = u.Accountid;
            c.Partner_Contact__c = u.ContactId;
            c.Channel_Account_Manager__c= u.Contact.Account.OwnerId;
        }
        
      }  
       
   }

}