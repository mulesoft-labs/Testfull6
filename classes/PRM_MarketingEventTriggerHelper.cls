public class PRM_MarketingEventTriggerHelper{

     public static void populateFieldsOnMarketingEvents( List<Marketing_Event__c > MarketingEvents){
        if(UserInfo.getUserType() != 'Standard'){
         User u = [SELECT Accountid,ContactId,Contact.Account.OwnerId,LastName FROM User 
         WHERE (UserType ='Partner' OR UserType='PowerPartner')
                AND Id = : UserInfo.getUserId() 
         ];
        
        for(Marketing_Event__c c : MarketingEvents){
            c.Partner_Account__c = u.Accountid;
            c.Partner_Contact__c = u.ContactId;
            c.Channel_Account_Manager__c= u.Contact.Account.OwnerId;
            /*c.Global_Channel_Manager__c=label.Global_Channel_Manager; commented out by Jose to add regional approvals by field marketing */
        }
        
      }  
       
   }

}