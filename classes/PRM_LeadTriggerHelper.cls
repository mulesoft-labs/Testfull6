/*********************************************************************
*
*   Class Name: PRM_LeadTriggerHelper
*
*   Description: Helper class to handle logic for all trigger
*   events on the Lead Object
*
**********************************************************************
*
*   Date        Author              Change
*   07/04/14    Chris               Added three method populateLeadManagerOnInsert,
                                    populateLeadManagerOnUpdate,populateLeadManager 
                                    to handle populate the Lead.Channel_Account_Maanger__c 
                                    field with the Owner of the Partner's Account.
    7/9/2014    Chris               Added a new field populate on line 85
*********************************************************************/        

public class PRM_LeadTriggerHelper{

    //Method to populate the Lead.Channel_Account_Maanger__c field with the Owner of the Partner's Account on insert lead.
    /*public static void populateLeadManagerOnInsert( List<Lead> newList ){
        List<Lead> updateLeadList = new List<Lead>();
        
        Map<Id, User> users = new Map<Id,User>( [SELECT ContactId FROM User WHERE UserType ='Partner' OR UserType='PowerPartner' ] );
        Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'PRM Deal Registration'].Id;
        
        for( Lead l : newList ){
            if( users.containsKey( l.OwnerId ) && l.RecordTypeId == recordTypeId ){
                updateLeadList.add( l );
            }
        }
        
        populateAccountManagerOnLead( updateLeadList );
    }
    
    //Method to populate the Lead.Channel_Account_Maanger__c field with the Owner of the Partner's Account on update lead.
    public static void populateLeadManagerOnUpdate( List<Lead> newList, Map<Id,Lead> oldMap ){
        List<Lead> addAccountManagerLeadList = new List<Lead>();
        List<Lead> removeAccountManagerLeadList = new List<Lead>();
        
        Map<Id, User> users = new Map<Id,User>( [SELECT ContactId FROM User WHERE UserType ='Partner' OR UserType='PowerPartner' ] );
        Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'PRM Deal Registration'].Id;
        
        for( Lead l : newList ){
            Lead oldLead = oldMap.get( l.Id ); 
            if( users.containsKey( l.OwnerId ) && l.RecordTypeId == recordTypeId && 
                ( l.OwnerId != oldLead.OwnerId || l.RecordTypeId != oldLead.RecordTypeId ) ){
               addAccountManagerLeadList.add( l );
            }
            
            if( users.containsKey( oldLead.OwnerId ) && oldLead.RecordTypeId == recordTypeId &&
                ( l.OwnerId != oldLead.OwnerId || l.RecordTypeId != oldLead.RecordTypeId ) ){
                removeAccountManagerLeadList.add( l );
            }
        }
       
        populateAccountManagerOnLead( addAccountManagerLeadList );    
        removeAccountManagerOnLead( removeAccountManagerLeadList );     
        
       
    }
    
    public static void removeAccountManagerOnLead( List<Lead> leads ){  
        List<Lead> leadsToUpdate = new List<Lead>();
        for( Lead lead : leads ){
       
            lead.Channel_Account_Manager__c = null;
            //added by chris on 7/9/2014
            lead.Partner_Contact__c = null;
            leadsToUpdate.add( lead );
        }
    
    }
    
    public static void populateAccountManagerOnLead( List<Lead> leads ){
        List<Lead> leadsToUpdate = new List<Lead>();
        
        Map<Id,Id> userIdToContactIdMap = new Map<Id,Id>();
        Map<Id,Id> userIdToAccountOwnerIdMap = new Map<Id,Id>();
        
        for( User u : [SELECT ContactId,Contact.Account.OwnerId,LastName FROM User WHERE UserType ='Partner' OR UserType='PowerPartner']){
            userIdToContactIdMap.put( u.Id,u.ContactId );
            userIdToAccountOwnerIdMap.put( u.Id,u.Contact.Account.OwnerId );
        }
        
        for( Lead l : leads){
            l.Channel_Account_Manager__c = userIdToAccountOwnerIdMap.get( l.OwnerId );
            l.Partner_Contact__c = userIdToContactIdMap.get( l.OwnerId ); 
            leadsToUpdate.add( l );
        }
       
    }*/

}