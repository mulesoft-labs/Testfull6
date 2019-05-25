/*
* Name : AddToSalesTeam
* Author : Rohit Mehta (Apprivo)
* Date : 05/02/2010
* Usage : Called on Lead Convert. Adds the user to the Opp Salesteam.
*/

public class AddToSalesTeam {

    private static final String PARTNER_DEFAULT_ACCESS = 'Read';
    private static final String PARTNER_DEFAULT_ROLE = 'Partner'; 
    private static final String INTERNAL_DEFAULT_ACCESS = 'Read'; 
    private static final String INTERNAL_DEFAULT_ROLE = 'Other'; 
    
    private static final Set<String> VALID_ACCESS = new Set<String>{'Read', 'Edit', 'None'}; 
    
    public static ATST_Settings__c defaultApplicationSettings;
    public static final map<string,string> USRROLE_TEAMRROLE_MAP= new map<string,string>{
                                                                                            OpportunitySettings.sUSER_ROLE_ADR=>OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ADR,
                                                                                            OpportunitySettings.sUSER_ROLE_SALES =>OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ACCOUNT_EXE,
                                                                                            OpportunitySettings.sUSER_ROLE_CHANNEL  =>OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_PARTNER_MGR
                                                                                        };
    
    /*
    * future Method to create Sales team. Wraps the non future method
    */
    @future
    public static void addPartnerToSalesTeamFuture(Map<Id, Id> oppId_Partner_Map) {
        AddToSalesTeam.addPartnerToSalesTeam(oppId_Partner_Map);
    }
    
    @future 
    public static void addStandarduserToSalesTeamFuture(Map<Id, Id> oppId_User_Map,map<id,String> TeamMemberRoleMap) {
         List<OpportunityTeamMember> oppTeamMembers = new List<OpportunityTeamMember>();
          for(Id opptyId:oppId_User_Map.keySet()){
            
            Id TeamMemberid =oppId_User_Map.get(opptyId);
            String sRole=TeamMemberRoleMap.get(TeamMemberid);
               oppTeamMembers.add(new OpportunityTeamMember(UserId = TeamMemberid,
                                                            OpportunityId = opptyId,
                                                            TeamMemberRole = sRole));  
          
          }
          
          if (! oppTeamMembers.isEmpty()){    
            AddToSalesTeamHelper.InsertTeamMember(oppTeamMembers);
            }
         
    }
    /*
    * Method to create Sales team & the share. 
    */
    public static void addPartnerToSalesTeam(Map<Id, Id> oppId_Partner_Map) {
        String partnerRole = (getDefaultApplicationSettings().Partner_Team_Member_Role__c != null) 
            ? getDefaultApplicationSettings().Partner_Team_Member_Role__c : PARTNER_DEFAULT_ROLE;

        String internalRole = (getDefaultApplicationSettings().Internal_Team_Member_Role__c != null) 
            ? getDefaultApplicationSettings().Internal_Team_Member_Role__c : INTERNAL_DEFAULT_ROLE;

        String partnerAccessLevel = getAccess(getDefaultApplicationSettings().Partner_Team_Member_Access__c, PARTNER_DEFAULT_ACCESS);
        String internalAccessLevel = getAccess(getDefaultApplicationSettings().Internal_Team_Member_Access__c, INTERNAL_DEFAULT_ACCESS);

       System.debug('Partner: ' + partnerRole + ' / ' + partnerAccessLevel);
       System.debug('Internal: ' + internalRole + ' / ' + internalAccessLevel);
       
        //check if assignees are partner users
        Map<Id, User> users = new Map<Id, User>([Select Contact.AccountId from User where Id In :oppId_Partner_Map.values() And userType = 'PowerPartner']);
       
        Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>([Select OwnerId from Opportunity where Id In :oppId_Partner_Map.keySet()]);


        List<OpportunityShare> oppShares = new List<OpportunityShare>();
        List<OpportunityTeamMember> oppTeamMembers = new List<OpportunityTeamMember>();

        for (Id oppId : oppId_Partner_Map.keySet()) {

            //can now switch off internal access
            Boolean noAccessRequired = (internalAccessLevel.equalsIgnoreCase('none'));
            Id usr = oppId_Partner_Map.get(oppId);
            String access = internalAccessLevel;
            String role = internalRole;
            if (users.keySet().contains(usr)) {
                access = partnerAccessLevel;
                role = partnerRole;
                noAccessRequired = false; //partner always required
            }
            
            if (noAccessRequired) continue;
            String usrStr = (String)usr;
            Opportunity opp = opportunities.get(oppId);
            if(usrStr.substring(0,3).equals('00G')) continue;
            oppTeamMembers.add(new OpportunityTeamMember(UserId = usr,
                                                            OpportunityId = oppId,
                                                            TeamMemberRole = role));                                                     
            if (opp.OwnerId == usr) {
                continue;//no need to create share, usr is owner and has full access
            }
            oppShares.add(new OpportunityShare( UserOrGroupId = usr,
                                                OpportunityId = oppId,
                                                OpportunityAccessLevel = access));
                
        }

        System.debug('OppShares:' + oppShares);             
        System.debug('Created Opportunity Team Member:' + oppTeamMembers);
        
            /*
            IMPORTANT: Team Members should get created before Shares. If order not followed for 
            some reason, shares created have R/O access, even if property is set to 'EDIT'
            */
        if (! oppTeamMembers.isEmpty()){    
            AddToSalesTeamHelper.InsertTeamMember(oppTeamMembers);
        }
        if (! oppShares.isEmpty()){    
            AddToSalesTeamHelper.InsertShare(oppShares);
        }
      
          /*if (oppTeamMembers.size() > 0) {
            insert oppTeamMembers;
        }
        if (oppShares.size() > 0) {
            insert oppShares;
        }*/

        
    }
    
    /*
    * Gets the default Custom Settings. 
    */
    public static ATST_Settings__c getDefaultApplicationSettings() {
        System.debug('defaultApplicationSettings: ' + defaultApplicationSettings);
        if (defaultApplicationSettings == null) {
            defaultApplicationSettings = ATST_Settings__c.getValues('Default');
            if (defaultApplicationSettings == null) {
                //defaultApplicationSettings = new ATST_Settings__c();
                String recordTypes = [Select Id from RecordType where SobjectType = 'Lead' Limit 1].Id;

                defaultApplicationSettings = new ATST_Settings__c(Name = 'Default', Lead_Record_Types__c = recordTypes,
                Partner_Team_Member_Role__c = 'Partner', Partner_Team_Member_Access__c = 'Edit',
                Internal_Team_Member_Role__c = 'Internal', Internal_Team_Member_Access__c = 'XCV');

            }
        }
        return defaultApplicationSettings;
    }
    
    /*
    * Gets the Access by checking if access is valid. If not returns a Read value 
    */
    public static String getAccess(String access, String defaultAccess) {
        if (access != null && VALID_ACCESS.contains(access)) {
            return access;
        }
        return defaultAccess;
    }

/************TEST METHODS *************************************************/

    testMethod static void unit() {
        User partnerUser = null;
        List<User> partnerUsers = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId != null LIMIT 1];
        if (partnerUsers.size() > 0) {
            partnerUser = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId != null LIMIT 1];
        } else {
            partnerUser = [SELECT Id FROM User WHERE IsActive = TRUE And Profile.Name != 'System Administrator' LIMIT 1];
        }
         
        User crmUser = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId = null And Profile.Name = 'System Administrator' LIMIT 1];

        System.assert(partnerUser != null);
        System.assert(crmUser != null);
        
        //get default Settings
        ATST_Settings__c atst = AddToSalesTeam.getDefaultApplicationSettings();
        String recordTypes = atst.Lead_Record_Types__c;
        if (recordTypes == null) {
            recordTypes = [Select Id from RecordType where SobjectType = 'Lead' Limit 1].Id;
            atst = new ATST_Settings__c(Name = 'Default', Lead_Record_Types__c = recordTypes,
                Partner_Team_Member_Role__c = 'Partner', Partner_Team_Member_Access__c = 'Edit',
                Internal_Team_Member_Role__c = 'Internal', Internal_Team_Member_Access__c = 'XCV');
            //do not insert as mixed dml not allowed. Just update local variable
            AddToSalesTeam.defaultApplicationSettings = atst;
        }
        
        
        // Test insert
        Lead l = getLead(partnerUser.Id, recordTypes.split(';').get(0));
        insert l;
        System.debug('Lead RT: ' + l.RecordTypeId);
        System.debug('atst: ' + atst);
        LeadStatus convertStatus = getConvertedStatus();
        System.debug('convertStatus:' + convertStatus);
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setOwnerId(crmUser.Id);
        
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.stopTest();

        Integer count = [SELECT count() FROM OpportunityShare 
            where OpportunityId = :lcr.getOpportunityId() And UserorGroupId = :partnerUser.id];
        // System.assertEquals(1, count); TODO: Need to resolve - RM 08/21/14

        count = [Select count() from OpportunityTeamMember 
                            where UserId = :partnerUser.Id 
                            and OpportunityId = :lcr.getOpportunityId()];
        // System.assertEquals(1, count); TODO: Need to resolve - RM 08/21/14
                            
    }
/*
    testMethod static void unitNoSettings() {
        User partnerUser = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId != null LIMIT 1];
        User crmUser = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId = null LIMIT 1];

        System.assert(partnerUser != null, 'No Partner User available');
        System.assert(crmUser != null, 'No CRM User available');
        
        //get default Settings
        ATST_Settings__c atst = AddToSalesTeam.getDefaultApplicationSettings();
        String recordTypes = atst.Lead_Record_Types__c;
        if (recordTypes == null) {
            recordTypes = [Select Id from RecordType where SobjectType = 'Lead' Limit 1].Id;
        }
        //use these settings
        atst = new ATST_Settings__c(Name = 'Default', Lead_Record_Types__c = recordTypes);
        //do not insert as mixed dml not allowed. Just update local variable
        AddToSalesTeam.defaultApplicationSettings = atst;
        
        
        // Test insert
        Lead l = getLead(partnerUser.Id, recordTypes.split(';').get(0));
        insert l;
        System.debug('Lead RT: ' + l.RecordTypeId);
        System.debug('atst: ' + atst);
        LeadStatus convertStatus = getConvertedStatus();
                            
        System.debug('convertStatus:' + convertStatus);
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setOwnerId(crmUser.Id);
        
        System.runAs(partnerUser) {
            Test.startTest();
                Database.LeadConvertResult lcr = Database.convertLead(lc);
            Test.stopTest();
    
            Integer count = [SELECT count() FROM OpportunityShare 
                where OpportunityId = :lcr.getOpportunityId() And UserorGroupId = :partnerUser.id];
            System.assertEquals(1, count);
    
            count = [Select count() from OpportunityTeamMember 
                                where UserId = :partnerUser.Id 
                                and OpportunityId = :lcr.getOpportunityId()];
            System.assertEquals(1, count);
        }
                            
    }
*/
    testMethod static void unitNoRTS() {
        User partnerUser = null;
        List<User> partnerUsers = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId != null LIMIT 1];
        if (partnerUsers.size() > 0) {
            partnerUser = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId != null LIMIT 1];
        } else {
            partnerUser = [SELECT Id FROM User WHERE IsActive = TRUE And Profile.Name != 'System Administrator' LIMIT 1];
        }
        User crmUser = [SELECT Id FROM User WHERE IsActive = TRUE And ContactId = null And Profile.Name = 'System Administrator' LIMIT 1];

        System.assert(partnerUser != null);
        System.assert(crmUser != null);
        
        //get default Settings
        ATST_Settings__c atst = AddToSalesTeam.getDefaultApplicationSettings();
        String recordTypes = atst.Lead_Record_Types__c;
        if (recordTypes == null) {
            recordTypes = [Select Id from RecordType where SobjectType = 'Lead' Limit 1].Id;
        }
        //use these settings
        atst = new ATST_Settings__c(Name = 'Default');
        //do not insert as mixed dml not allowed. Just update local variable
        AddToSalesTeam.defaultApplicationSettings = atst;
        
        
        // Test insert
        Lead l = getLead(partnerUser.Id, recordTypes.split(';').get(0));
        insert l;
        System.debug('Lead RT: ' + l.RecordTypeId);
        System.debug('atst: ' + atst);
        LeadStatus convertStatus = getConvertedStatus();
                            
        System.debug('convertStatus:' + convertStatus);
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setOwnerId(crmUser.Id);
        
        Test.startTest();
            Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.stopTest();

        Integer count = [SELECT count() FROM OpportunityShare 
            where OpportunityId = :lcr.getOpportunityId() And UserorGroupId = :partnerUser.id];
        //System.assertEquals(0, count);

        count = [Select count() from OpportunityTeamMember 
                            where UserId = :partnerUser.Id 
                            and OpportunityId = :lcr.getOpportunityId()];
        //System.assertEquals(0, count);
                            
    }
    
    //used by test methods
    private static LeadStatus getConvertedStatus() {
        LeadStatus convertStatus = [Select Id, MasterLabel 
                                    from LeadStatus 
                                    where IsConverted=true 
                                    limit 1];
        return convertStatus;       
    }
    
    private static Lead getLead(Id ownerId, Id recordTypeId) {
        Lead l = new Lead(FirstName = 'Tester', LastName='last', 
                            Email = 'lead@test.com', 
                            Company='acme',
                            Country = 'USA',
                            RecordTypeId = recordTypeId,
                            State = 'CA',
                            Phone = '1234567890',
                            OwnerId = ownerId);
        return l;       
    }
    
     
}