/**
*   Author:-        Mondaycall
*   Created:-       2/20/2014
*   Description:-   Provides method to sync Account Team to OpporunityTeamMember
*   Revision:-   Perficient - Narasimha 01/08/2015
                 Opportunity Team Memebr Enhancements - Added new methods to support following functionalites
                                                        1. Create OpportunityTeamMember upon creating the opportunity
**/
public class OpportunityTeamMemberManager{
    static Set<String> eligibleType = new Set<String>{
            'New Business',
            'Add-On Business'
    };

    /* Opportunity Enhancement - start*/
    //OpportunityTeam Member Roles
    public string sTeammeberRole_SeniorManager = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_SENIOR_MGR;
    public string sTeammeberRole_SalesManager = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_SALES_MGR;
    public string sTeammeberRole_PartnerManager = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_PARTNER_MGR;
    public string sTeammeberRole_accExecutive = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ACCOUNT_EXE;
    public string sTeammeberRole_CSM = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_CSM;
    public string sTeammeberRole_CSR = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_CSR;
    // Added by Tia Xuan 12/02/2016
    public string sTeammeberRole_CSD = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_CSD;
    public string sTeammeberRole_ADR = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ADR;
    public string sTeammemberRole_EM = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER;
    public string sTeammemberRole_Partner = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_PARTNER;

    public string sUserRole_Sales = OpportunitySettings.sUSER_ROLE_SALES;
    public string sUserRole_Channel = OpportunitySettings.sUSER_ROLE_CHANNEL;
    public string sUserRole_ADR =OpportunitySettings.sUSER_ROLE_ADR;
    public string sStage_SubmittedClosing  = OpportunitySettings.sStage_SubmittedClosing;
    public string s7Stage_SubmittedClosing  = ConstantDeclarations.OPP_STAGE_SUBMIT_CLOSING;
    public string sType_Renewal = OpportunitySettings.sType_Renewal;

    //Opportunity type Picklist values
    public set<String> OpptyTypeSet = new set<String>{
            OpportunitySettings.sType_AddOnBusiness,
            OpportunitySettings.sType_Renewal,
            OpportunitySettings.sType_AddonBusinessRenewalpriceUplift
    };

    /*
       Method:createOppTeamMember
       Desc: Create/Update Opportunity Team Members based on Business Rules -
             add opportunity Owner, Account Owner, Opportunity owner Manager, Account team members.
    */
    public void createOppTeamMember(map<Id,Opportunity> opportunityOldMap,map<Id,Opportunity> opportunityNewMap, Boolean isInsert,Boolean isUpdate){
		System.debug(LoggingLevel.ERROR, 'Sid ----->>>> Inside ----> createOppTeamMember -----------> ');
		
        list<OpportunityTeamMember> lstCreateOpptyTeamMembers = new list<OpportunityTeamMember>();
        list<OpportunityTeamMember> lstDeleteOpptyMembers = new List<OpportunityTeamMember>();
        List<Opportunity> lstOppToUpdate = new list<Opportunity>();
        set<Id> opptyOwnerIdSet = new set<Id>();
        set<Id> opptyPrvOwnerIdSet = new set<Id>();
        map<Id,Id> opptyManagerMap = new map<Id,Id>();        //Opportunity owner
        map<Id,Id> opptyPrvManagerMap = new map<Id,Id>();
        map<id,id> OpptyAccountMapCMS = new map<Id,Id>();    //Account Team -CSM Role
        map<id,id> OpptyAccountMapCSR = new map<Id,Id>();    //Account Team -CSR Role
        map<id,id> OpptyAccountMapCSD = new map<Id,Id>();    //Account Team -CSD Role
        map<id,id> OpptyAccountMap = new map<Id,Id>();    //Account Team -Account Executive Role
        map<Id,Id> opptyLeadPassedByMap = new map<Id,Id>();  //Opportunity Lead_Passed_By for ADR
        map<Id,Id> opptyLeadPassedByMapEM = new map<Id,Id>();//Opportunity Lead_Passed_By for EM
        map<Id,Id> opptyLeadPassedByMapPartner = new map<Id,Id>();//Opportunity Lead_Passed_By for Partner
        Set<Id> opptyPrvLeadPassedBySet = new Set<Id> ();
        Set<Id> emptySet = new Set<Id>();
        Set<Id> changedOwnerOppoList = new Set<Id>();
        //added by teddy
        Set<Id> accountIdsForCMSCSRCSD = new Set<Id>();
        list<AccountTeamMember> accountTeamMemberRoles = new list<AccountTeamMember>();
        Set<Id> oppotunitiesForSplitSync = new Set<Id>();
        Map<Id,Id> opportunitiesForEngagementManager = new Map<Id,Id>();
        Map<Id,Id> opportunityAEToEngagmentManagerMap = new Map<Id,Id>();

        if(isInsert){
			System.debug(LoggingLevel.ERROR, 'Sid ----->>>> Inside ----> createOppTeamMember -----------> INSERT ----> ');            
            for(Opportunity opp:opportunityNewMap.values()){
                opptyOwnerIdSet.add(opp.OwnerId);
                OpptyAccountMap.put(opp.Id,opp.AccountId);
                oppotunitiesForSplitSync.add(opp.Id);
	            System.debug(LoggingLevel.ERROR, 'Insert --> opp.Type --> '+opp.Type);
            	System.debug(LoggingLevel.ERROR, 'Insert --> OpptyTypeSet --> '+OpptyTypeSet);
            	System.debug(LoggingLevel.ERROR, 'Insert --> Probability --> '+opp.Probability);
            	System.debug(LoggingLevel.ERROR, 'Insert --> Decimal.valueOf(label.CSMOpportunityProbability) --> '+Decimal.valueOf(label.CSMOpportunityProbability));
                if(String.isNotBlank(opp.Type) && OpptyTypeSet.Contains(opp.Type)  && opp.Probability < Decimal.valueOf(label.CSMOpportunityProbability)){
                    OpptyAccountMapCMS.put(opp.Id,opp.AccountId);
                    OpptyAccountMapCSR.put(opp.Id,opp.AccountId);
                    OpptyAccountMapCSD.put(opp.Id,opp.AccountId);
                    accountIdsForCMSCSRCSD.add(opp.AccountId);
                }
                System.debug(LoggingLevel.ERROR, 'Insert --> OpptyAccountMapCMS --> '+OpptyAccountMapCMS);
                System.debug(LoggingLevel.ERROR, 'Insert --> accountIdsForCMSCSRCSD --> '+accountIdsForCMSCSRCSD);
                if(opp.Lead_Passed_By__c != null ){
                    opptyLeadPassedByMap.put(opp.Id,opp.Lead_Passed_By__c);
                    opptyLeadPassedByMapEM.put(opp.Id,opp.Lead_Passed_By__c);
                    opptyLeadPassedByMapPartner.put(opp.Id,opp.Lead_Passed_By__c);
                }
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> opptyLeadPassedByMapEM --> '+opptyLeadPassedByMapEM);
            System.debug(LoggingLevel.ERROR, 'Insert --> opptyLeadPassedByMapPartner --> '+opptyLeadPassedByMapPartner);

            //fetch opportunityOwner User Records
            map<Id,User> OpptyOwnerObjmap = getUserObjMap(opptyOwnerIdSet);

            //fetch all account team members
            if(!accountIdsForCMSCSRCSD.isEmpty()){
                accountTeamMemberRoles = getAccountTeamMembers(accountIdsForCMSCSRCSD);
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> accountTeamMemberRoles --> '+accountTeamMemberRoles);

            //create team member objects for Lead Passed By
            opptyLeadPassedByMap = filterLeadPassedByMapToADRRoleUsers(opptyLeadPassedByMap);
            if(opptyLeadPassedByMap.size()>0){
                list<OpportunityTeamMember> lstOpptyMembers_LeadPassed = createTeamMemberObj(opptyLeadPassedByMap,sTeammeberRole_ADR);
                system.debug('*****'+lstOpptyMembers_LeadPassed);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_LeadPassed);
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> opptyLeadPassedByMapEM --> '+opptyLeadPassedByMapEM);
            System.debug(LoggingLevel.ERROR, 'Insert --> opptyLeadPassedByMapPartner --> '+opptyLeadPassedByMapPartner);
            //filterLeadPassedByMapToEMRoleUsers
            //create team member objects for Lead Passed By
            opptyLeadPassedByMapEM = filterLeadPassedByMapToEMRoleUsers(opptyLeadPassedByMapEM);
            System.debug(LoggingLevel.ERROR, 'Insert --> opptyLeadPassedByMapEM --> '+opptyLeadPassedByMapEM);
            if(opptyLeadPassedByMapEM.size()>0){
                list<OpportunityTeamMember> lstOpptyMembers_LeadPassed = createTeamMemberObj(opptyLeadPassedByMapEM,sTeammemberRole_EM);
                system.debug('*****'+lstOpptyMembers_LeadPassed);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_LeadPassed);
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> lstCreateOpptyTeamMembers --> '+lstCreateOpptyTeamMembers);

            opptyLeadPassedByMapPartner = filterLeadPassedByMapToPartnerRoleUsers(opptyLeadPassedByMapPartner);
            System.debug(LoggingLevel.ERROR, 'Insert --> opptyLeadPassedByMapPartner --> '+opptyLeadPassedByMapPartner);
            if(opptyLeadPassedByMapPartner.size()>0){
                list<OpportunityTeamMember> lstOpptyMembers_LeadPassed = createTeamMemberObj(opptyLeadPassedByMapPartner,sTeammemberRole_Partner);
                system.debug('*****'+lstOpptyMembers_LeadPassed);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_LeadPassed);
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> OpptyAccountMapCMS --> '+OpptyAccountMapCMS);
            if(OpptyAccountMapCMS.size()>0){
                //create Team member with CMS role from Account team
                map<Id,set<Id>> accTeamMap = getAccountTeamRoleCSM(OpptyAccountMapCMS, accountTeamMemberRoles);
                list<OpportunityTeamMember> lstOpptyMembers_CSMRole = createCSMTeamMemberObj(OpptyAccountMapCMS,accTeamMap,sTeammeberRole_CSM,opportunityNewMap);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_CSMRole);
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> lstCreateOpptyTeamMembers --> '+lstCreateOpptyTeamMembers);

            if(OpptyAccountMapCSR.size()>0){
                //create Team member with CSR role from Account team
                map<Id,set<Id>> accTeamCSRMap = getAccountTeamRoleCSR(OpptyAccountMapCSR, accountTeamMemberRoles);
                list<OpportunityTeamMember> lstOpptyMembers_CSRRole = createCSMTeamMemberObj(OpptyAccountMapCSR,accTeamCSRMap,sTeammeberRole_CSR,opportunityNewMap);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_CSRRole);
            }

            // 12/01/2016 Added Tia Xuan
            if(OpptyAccountMapCSD.size()>0){
                //create Team member with CSD role from Account team
                map<Id,set<Id>> accTeamCSDMap = getAccountTeamRoleCSD(OpptyAccountMapCSD, accountTeamMemberRoles);
                list<OpportunityTeamMember> lstOpptyMembers_CSDRole = createCSMTeamMemberObj(OpptyAccountMapCSD,accTeamCSDMap,sTeammeberRole_CSD,opportunityNewMap);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_CSDRole);
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> OpptyAccountMap --> '+OpptyAccountMap);
            if(OpptyAccountMap.size()>0){
                //add Opportunity Account Owner as Account Executive
                map<Id,Id> OpptyAccountOwner =getOpptyAccountOwner(OpptyAccountMap);
                list<OpportunityTeamMember> lstOpptyMembers_accExec = createTeamMemberObj(OpptyAccountOwner,sTeammeberRole_accExecutive);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_accExec);
            }
            System.debug(LoggingLevel.ERROR, 'Insert --> lstCreateOpptyTeamMembers --> '+lstCreateOpptyTeamMembers);            
            // add Opportunity owner to the Opportunity Team
            list<OpportunityTeamMember> lstaddOwnerAsTeamMem = addOpptyOwnerASTeamMember(OpptyOwnerObjmap,opportunityNewMap);
            lstCreateOpptyTeamMembers.addAll(lstaddOwnerAsTeamMem);

        }
        if(isUpdate){
			System.debug(LoggingLevel.ERROR, 'Sid ----->>>> Inside ----> createOppTeamMember -----------> UPDATE ----> ');            
            // Added by Tia Xuan 12/07/2016 - for adding role stick
            Set<Id> opportunitiesForExistingTeamMemberCheck = new Set<Id>();
            List<OpportunityTeamMember> existingOpportunityTeamMembers = new List<OpportunityTeamMember>();

            for(Id opptyId:opportunityNewMap.keySet()){
                Opportunity newOppty = opportunityNewMap.get(opptyId);
                Opportunity oldOppty= opportunityOldMap.get(opptyId);

                if((newOppty.StageName!=oldOppty.StageName  || newOppty.Type!=oldOppty.Type) && ((newOppty.StageName==sStage_SubmittedClosing || newOppty.StageName==s7Stage_SubmittedClosing) && newOppty.Type==sType_Renewal)){

                    OpptyAccountMap.put(newOppty.Id,newOppty.AccountId);
                    opportunitiesForExistingTeamMemberCheck.add(newOppty.Id);
                }

                System.debug(LoggingLevel.ERROR, 'SID ----> Inside UPDATE --> newOppty.OwnerId --> '+ newOppty.OwnerId);
                System.debug(LoggingLevel.ERROR, 'SID ----> Inside UPDATE --> oldOppty.OwnerId --> '+ oldOppty.OwnerId);
                
                if(newOppty.OwnerId!=oldOppty.OwnerId){
                	System.debug(LoggingLevel.ERROR, 'SID ----> Inside UPDATE --> Owner Changed');                    
                    opptyOwnerIdSet.add(newOppty.OwnerId);
                    opptyPrvOwnerIdSet.add(oldOppty.OwnerId);
                    // Added by Tia Xuan 12/07/2016 - for adding role stick
                    changedOwnerOppoList.add(newOppty.Id);
                    oppotunitiesForSplitSync.add(newOppty.Id);
                    opportunitiesForExistingTeamMemberCheck.add(newOppty.Id);

                    //re add Lead passed by role in case it is dropped by opportunity owner change
                    if(newOppty.Lead_Passed_By__c != null){
                        opptyLeadPassedByMap.put(newOppty.Id,newOppty.Lead_Passed_By__c);
                        opptyLeadPassedByMapEM.put(newOppty.Id,newOppty.Lead_Passed_By__c);
                        opptyLeadPassedByMapPartner.put(newOppty.Id,newOppty.Lead_Passed_By__c);
                    }
                    System.debug(LoggingLevel.ERROR, 'Update --> opptyLeadPassedByMapEM --> '+opptyLeadPassedByMapEM);
                    //re add success roles in case they were dropped during opportunity owner change
                	System.debug(LoggingLevel.ERROR, 'SID ----> Inside UPDATE --> newOppty.Type --> '+newOppty.Type);                    
                	System.debug(LoggingLevel.ERROR, 'SID ----> Inside UPDATE --> OpptyTypeSet --> '+OpptyTypeSet);                    
                	System.debug(LoggingLevel.ERROR, 'SID ----> Inside UPDATE --> newOppty.Probability --> '+newOppty.Probability);                    
                	System.debug(LoggingLevel.ERROR, 'SID ----> Inside UPDATE --> Decimal.valueOf(label.CSMOpportunityProbability) --> '+Decimal.valueOf(label.CSMOpportunityProbability));                    
                    
                    if(String.isNotBlank(newOppty.Type) && OpptyTypeSet.Contains(newOppty.Type)
                            && newOppty.Probability <= Decimal.valueOf(label.CSMOpportunityProbability)){
                        OpptyAccountMapCMS.put(newOppty.Id,newOppty.AccountId);
                        OpptyAccountMapCSR.put(newOppty.Id,newOppty.AccountId);
                        OpptyAccountMapCSD.put(newOppty.Id,newOppty.AccountId);
                        accountIdsForCMSCSRCSD.add(newOppty.AccountId);
                    }
                    System.debug(LoggingLevel.ERROR, 'SID ----> 1 ----> UPDATE --> OpptyAccountMapCMS --> '+ OpptyAccountMapCMS);
                    System.debug(LoggingLevel.ERROR, 'SID ----> 1----> UPDATE --> accountIdsForCMSCSRCSD --> '+ accountIdsForCMSCSRCSD);
                    System.debug(LoggingLevel.ERROR, 'SID ----> 1----> UPDATE --> OpptyAccountMapCSR --> '+ OpptyAccountMapCSR);
                    System.debug(LoggingLevel.ERROR, 'SID ----> 1----> UPDATE --> OpptyAccountMapCSD --> '+ OpptyAccountMapCSD);
                }

                //Added By Nikhil (If lead passed by is not blank, the lead passed by user should be on opp team with ADR role.)
                if((newOppty.Lead_Passed_By__c != oldOppty.Lead_Passed_By__c) && newOppty.Lead_Passed_By__c != null){
                    opptyLeadPassedByMap.put(newOppty.Id,newOppty.Lead_Passed_By__c);
                    opptyLeadPassedByMapEM.put(newOppty.Id,newOppty.Lead_Passed_By__c);
                    opptyLeadPassedByMapPartner.put(newOppty.Id,newOppty.Lead_Passed_By__c);

                    if(oldOppty.Lead_Passed_By__c != null){
                        opptyPrvLeadPassedBySet.add(oldOppty.Lead_Passed_By__c);
                    }
                    opportunitiesForExistingTeamMemberCheck.add(newOppty.Id);
                }

                System.debug(LoggingLevel.ERROR, 'Update --> opptyLeadPassedByMapEM --> '+opptyLeadPassedByMapEM);
                if(newOppty.Lead_Passed_By__c == null && newOppty.Lead_Passed_By__c != oldOppty.Lead_Passed_By__c ){
                    opptyPrvLeadPassedBySet.add(oldOppty.Lead_Passed_By__c);
                    opportunitiesForExistingTeamMemberCheck.add(newOppty.Id);
                }

                System.debug(LoggingLevel.ERROR, 'SID ----> newOppty.Type --> '+ newOppty.Type);
                System.debug(LoggingLevel.ERROR, 'SID ----> oldOppty.Type --> '+ oldOppty.Type);                
                System.debug(LoggingLevel.ERROR, 'SID ----> newOppty.Probability --> '+ newOppty.Probability);   
                System.debug(LoggingLevel.ERROR, 'SID ----> oldOppty.Probability --> '+ oldOppty.Probability);                
                
                if(String.isNotBlank(newOppty.Type) && OpptyTypeSet.Contains(newOppty.Type)
                        && newOppty.Probability <= Decimal.valueOf(label.CSMOpportunityProbability)
                        &&(newOppty.Type != oldOppty.Type || newOppty.Probability != oldOppty.Probability)){
                	System.debug(LoggingLevel.ERROR, 'SID ----> INSIDE IF --> ');
                    OpptyAccountMapCMS.put(newOppty.Id,newOppty.AccountId);
                    OpptyAccountMapCSR.put(newOppty.Id,newOppty.AccountId);
                    OpptyAccountMapCSD.put(newOppty.Id,newOppty.AccountId);
                    accountIdsForCMSCSRCSD.add(newOppty.AccountId);
                    opportunitiesForExistingTeamMemberCheck.add(newOppty.Id);
                }
                    System.debug(LoggingLevel.ERROR, 'SID ----> 2 ----> OpptyAccountMapCMS --> '+ OpptyAccountMapCMS);
                    System.debug(LoggingLevel.ERROR, 'SID ----> 2----> accountIdsForCMSCSRCSD --> '+ accountIdsForCMSCSRCSD);
                    System.debug(LoggingLevel.ERROR, 'SID ----> 2----> opportunitiesForExistingTeamMemberCheck --> '+ opportunitiesForExistingTeamMemberCheck);
                	System.debug(LoggingLevel.ERROR, 'SID ----> 2----> OpptyAccountMapCSR --> '+ OpptyAccountMapCSR);
                    System.debug(LoggingLevel.ERROR, 'SID ----> 2----> OpptyAccountMapCSD --> '+ OpptyAccountMapCSD);

                //check if opp needs engagment managaer role
                if(newOppty.Services_Amount__c > 0 && newOppty.isClosed == false && newOppty.Type != null && eligibleType.contains(newOppty.Type)
                        && (newOppty.Services_Amount__c != oldOppty.Services_Amount__c || newOppty.isClosed != oldOppty.isClosed || newOppty.type != oldOppty.type
                        || (newOppty.Added_EM_to_Team__c != oldOppty.Added_EM_to_Team__c && newOppty.Added_EM_to_Team__c == false))){
                    System.debug(LoggingLevel.ERROR, '2 --> @@@@@@@@@@@@@@@ -----> newOppty.Added_EM_to_Team__c --> '+newOppty.Added_EM_to_Team__c);
                    if(newOppty.Added_EM_to_Team__c == false) {
                        opportunitiesForEngagementManager.put(newOppty.Id, newOppty.OwnerId);
                        System.debug(LoggingLevel.ERROR, '2 --> @@@@@@@@@@@@@@@ -----> opportunitiesForEngagementManager --> '+opportunitiesForEngagementManager);
                        System.debug('@@@@@@@@@@@@ opportunitiesForEngagementManager: '+ opportunitiesForEngagementManager);
                        //fetch a map for AE to Engagement Manager
                        if(!opportunitiesForEngagementManager.isEmpty()){
                            opportunityAEToEngagmentManagerMap = getAEEngagementManagerMap(opportunitiesForEngagementManager.values());
                        }
                        System.debug('@@@@@@@@@@@@ opportunityAEToEngagmentManagerMap: '+ opportunityAEToEngagmentManagerMap);

                        //fetch all existing opportunity team members to check for deletion
                        if(!opportunitiesForExistingTeamMemberCheck.isEmpty()){
                            existingOpportunityTeamMembers = getOpportunityTeamMembers(opportunitiesForExistingTeamMemberCheck);
                        }

                        List<OpportunityTeamMember> tempOppTeamMem = addEMToTheOppTeam(opportunitiesForEngagementManager,opportunityAEToEngagmentManagerMap, existingOpportunityTeamMembers);
                        System.debug(LoggingLevel.ERROR, '2 --> @@@@@@@@@@@@@@@ -----> tempOppTeamMem --> '+tempOppTeamMem);
                        
                        if(tempOppTeamMem.size() > 0) {
                            lstCreateOpptyTeamMembers.addAll(tempOppTeamMem);
                            System.debug(LoggingLevel.ERROR, '2 --> @@@@@@@@@@@@@@@ -----> lstCreateOpptyTeamMembers --> ' + lstCreateOpptyTeamMembers);
                            lstOppToUpdate.add(new Opportunity(Id = newOppty.Id, Added_EM_to_Team__c = true));
                            System.debug(LoggingLevel.ERROR, '2 --> @@@@@@@@@@@@@@@ -----> lstOppToUpdate --> ' + lstOppToUpdate);
                        }
                    }
                    opportunitiesForExistingTeamMemberCheck.add(newOppty.Id);
                }

            }
            System.debug(LoggingLevel.ERROR, 'SID ----> UPDATE ----> accountIdsForCMSCSRCSD --> '+ accountIdsForCMSCSRCSD);
            //fetch all account team members
            if(!accountIdsForCMSCSRCSD.isEmpty()){
                accountTeamMemberRoles = getAccountTeamMembers(accountIdsForCMSCSRCSD);
            }
            System.debug(LoggingLevel.ERROR, 'SID ---->  UPDATE ----> accountTeamMemberRoles --> '+ accountTeamMemberRoles);

            //create team meber objects for Lead Passed By
            opptyLeadPassedByMap = filterLeadPassedByMapToADRRoleUsers(opptyLeadPassedByMap);
            if(opptyLeadPassedByMap.size()>0){
                list<OpportunityTeamMember> lstOpptyMembers_LeadPassed = createTeamMemberObj(opptyLeadPassedByMap,sTeammeberRole_ADR);
                system.debug('*****'+lstOpptyMembers_LeadPassed);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_LeadPassed);
            }

            opptyLeadPassedByMapEM = filterLeadPassedByMapToEMRoleUsers(opptyLeadPassedByMapEM);
            System.debug(LoggingLevel.ERROR, 'Sid --> Update --> opptyLeadPassedByMapEM --> '+opptyLeadPassedByMapEM);
            if(opptyLeadPassedByMapEM.size()>0){
                list<OpportunityTeamMember> lstOpptyMembers_LeadPassed = createTeamMemberObj(opptyLeadPassedByMapEM,sTeammemberRole_EM);
                system.debug('*****'+lstOpptyMembers_LeadPassed);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_LeadPassed);
            }
            System.debug(LoggingLevel.ERROR, 'Sid -->  UPDATE ----> lstCreateOpptyTeamMembers --> '+lstCreateOpptyTeamMembers);

            opptyLeadPassedByMapPartner = filterLeadPassedByMapToPartnerRoleUsers(opptyLeadPassedByMapPartner);
            System.debug(LoggingLevel.ERROR, 'Sid ---> Update --> opptyLeadPassedByMapPartner --> '+opptyLeadPassedByMapPartner);
            if(opptyLeadPassedByMapPartner.size()>0) {
                list<OpportunityTeamMember> lstOpptyMembers_LeadPassed = createTeamMemberObj(opptyLeadPassedByMapPartner,sTeammemberRole_Partner);
                system.debug('*****'+lstOpptyMembers_LeadPassed);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_LeadPassed);
            }

            System.debug(LoggingLevel.ERROR, 'SID ----> Update --> OpptyAccountMapCMS --> '+ OpptyAccountMapCMS);            
            if(OpptyAccountMapCMS.size()>0){
                //create Team member with CMS role from Account team
                map<Id,set<Id>> accTeamMap = getAccountTeamRoleCSM(OpptyAccountMapCMS, accountTeamMemberRoles);
	            System.debug(LoggingLevel.ERROR, 'SID ----> accTeamMap --> '+ accTeamMap);                            
                list<OpportunityTeamMember> lstOpptyMembers_CSMRole = createCSMTeamMemberObj(OpptyAccountMapCMS,accTeamMap,sTeammeberRole_CSM,opportunityNewMap);
	            System.debug(LoggingLevel.ERROR, 'SID ----> lstOpptyMembers_CSMRole --> '+ lstOpptyMembers_CSMRole);                            
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_CSMRole);
            }

            if(OpptyAccountMapCSR.size()>0){
                //create Team member with CSR role from Account team
                map<Id,set<Id>> accTeamCSRMap = getAccountTeamRoleCSR(OpptyAccountMapCSR, accountTeamMemberRoles);
                list<OpportunityTeamMember> lstOpptyMembers_CSRRole = createCSMTeamMemberObj(OpptyAccountMapCSR,accTeamCSRMap,sTeammeberRole_CSR,opportunityNewMap);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_CSRRole);
            }

            // 12/01/2016 Added Tia Xuan
            if(OpptyAccountMapCSD.size()>0){
                //create Team member with CSD role from Account team
                map<Id,set<Id>> accTeamCSDMap = getAccountTeamRoleCSD(OpptyAccountMapCSD, accountTeamMemberRoles);
                list<OpportunityTeamMember> lstOpptyMembers_CSDRole = createCSMTeamMemberObj(OpptyAccountMapCSD,accTeamCSDMap,sTeammeberRole_CSD,opportunityNewMap);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_CSDRole);
            }

            System.debug(LoggingLevel.ERROR, 'SID ----> OpptyAccountMapCSR --> '+ OpptyAccountMapCSR);                        
            if(OpptyAccountMapCSR.size()>0){
                //delte ALL Current CSM before adding new CSM
                //list<OpportunityTeamMember> lstOpptyMembers_PrvCSR = getCurrentCSMTeamMember(OpptyAccountMapCSR.keySet(),sTeammeberRole_CSR);
                list<OpportunityTeamMember> lstOpptyMembers_PrvCSR = getCurrentCSMTeamMember(existingOpportunityTeamMembers,sTeammeberRole_CSR);
                // Added by Tia Xuan 12/07/2016 - for adding role stick
                for (OpportunityTeamMember otm : lstOpptyMembers_PrvCSR){
                    if (!changedOwnerOppoList.contains(otm.OpportunityId)){
                        lstDeleteOpptyMembers.add(otm);
                    }
                }
            }

            // 12/01/2016 Added Tia Xuan
            if(OpptyAccountMapCSD.size()>0){
                //delte ALL Current CSM before adding new CSM
                list<OpportunityTeamMember> lstOpptyMembers_PrvCSD = getCurrentCSMTeamMember(existingOpportunityTeamMembers,sTeammeberRole_CSD);
                // Added by Tia Xuan 12/07/2016 - for adding role stick
                for (OpportunityTeamMember otm : lstOpptyMembers_PrvCSD){
                    if (!changedOwnerOppoList.contains(otm.OpportunityId)){
                        lstDeleteOpptyMembers.add(otm);
                    }
                }
            }

            System.debug(LoggingLevel.ERROR, 'SID ----> OpptyAccountMapCMS --> '+ OpptyAccountMapCMS);                        
            if(OpptyAccountMapCMS.size()>0){
                //delte ALL Current CSM before adding new CSM
                list<OpportunityTeamMember> lstOpptyMembers_PrvCSM = getCurrentCSMTeamMember(existingOpportunityTeamMembers,sTeammeberRole_CSM);
	            System.debug(LoggingLevel.ERROR, 'SID ----> lstOpptyMembers_PrvCSM --> '+ lstOpptyMembers_PrvCSM);            
                // Added by Tia Xuan 12/07/2016 - for adding role stick
                for (OpportunityTeamMember otm : lstOpptyMembers_PrvCSM){
                    if (!changedOwnerOppoList.contains(otm.OpportunityId)){
                        lstDeleteOpptyMembers.add(otm);
                    }
                }
            }
	        System.debug(LoggingLevel.ERROR, 'SID ----> UPDATE--> changedOwnerOppoList --> '+ changedOwnerOppoList);                        
	        System.debug(LoggingLevel.ERROR, 'SID ----> UPDATE--> lstDeleteOpptyMembers --> '+ lstDeleteOpptyMembers);            
	        System.debug(LoggingLevel.ERROR, 'SID ----> UPDATE--> OpptyAccountMap --> '+ OpptyAccountMap);            
            
            if(OpptyAccountMap.size()>0){
                //Rule - Update Account Executive
                map<Id,Id> OpptyAccountOwner =getOpptyAccountOwner(OpptyAccountMap);
                list<OpportunityTeamMember> lstCurrentOpptyTeamAccExe = getCurrentOpptyAccountExe(OpptyAccountMap,sTeammeberRole_accExecutive,OpptyAccountOwner, existingOpportunityTeamMembers);
                list<OpportunityTeamMember> lstOpptyMembers_accExec = createTeamMemberObj(OpptyAccountOwner,sTeammeberRole_accExecutive);
                lstCreateOpptyTeamMembers.addAll(lstOpptyMembers_accExec);
                lstDeleteOpptyMembers.addAll(lstCurrentOpptyTeamAccExe);//delete the Exisitng Sales team with Role Account Executives if userId different from Account Owner
            }
	        System.debug(LoggingLevel.ERROR, 'SID ----> UPDATE--> lstCreateOpptyTeamMembers --> '+ lstCreateOpptyTeamMembers);            
	        System.debug(LoggingLevel.ERROR, 'SID ----> UPDATE--> lstDeleteOpptyMembers --> '+ lstDeleteOpptyMembers);            

            //update the team member Sales manger  if the Opportunity owner is changed.
            //fetch opportunityOwner User Records
            //
            //Added by Tia Xuan 11/23/2016 - check for empty ownerId set
            map<Id,User> OpptyOwnerObjmap = new map<Id,User>();
            if (opptyOwnerIdSet.size() >0){
                OpptyOwnerObjmap = getUserObjMap(opptyOwnerIdSet);
                System.Debug('OpptyOwnerObjMap:' + OpptyOwnerObjmap);
            }


            if(opptyPrvOwnerIdSet.size()>0){
                //remove previous owner from Opportunity Team record
                list<OpportunityTeamMember> lstPreviousOwnerTeamMemberRec = prvOwnerTeamMemberRecords(opptyPrvOwnerIdSet,opportunityOldMap, existingOpportunityTeamMembers);
                lstDeleteOpptyMembers.addAll(lstPreviousOwnerTeamMemberRec);
            }

            if(OpptyOwnerObjmap.size()>0){
                // add Opportunity owner to the Opportunity Team
                list<OpportunityTeamMember> lstaddOwnerAsTeamMem = addOpptyOwnerASTeamMember(OpptyOwnerObjmap,opportunityNewMap);
                lstCreateOpptyTeamMembers.addAll(lstaddOwnerAsTeamMem);
            }

            if(opptyPrvLeadPassedBySet.size()>0){
                //remove previous owner from Opportunity Team record
                list<OpportunityTeamMember> lstPrvLeadPassedTeamMemRec = prvLeadPassedTeamMemberRecords(opptyPrvLeadPassedBySet,opportunityOldMap, existingOpportunityTeamMembers);
                lstDeleteOpptyMembers.addAll(lstPrvLeadPassedTeamMemRec);
            }
        }

        //remove duplicates before delete since multipe rules can add same record to delete list.
        lstDeleteOpptyMembers = removeDuplicatesAddedByRules(lstDeleteOpptyMembers);
	    System.debug(LoggingLevel.ERROR, 'SID ----> lstDeleteOpptyMembers --> '+ lstDeleteOpptyMembers);            

        if(!lstDeleteOpptyMembers.isEmpty()){
            //delte splits associated to team members to be deleted
            deleteOverlaySplitsForToBeDeletedOpportunityTeamMembers(lstDeleteOpptyMembers);

            //delete invalid team member roles
            Database.delete(lstDeleteOpptyMembers,false);
        }
        if(!lstOppToUpdate.isEmpty()){
            //insert new team member roles
            CMsTriggerRunCounter.skipOppTrigger = true;
            System.debug(LoggingLevel.ERROR, '3 --> @@@@@@@@@@@@@@@ -----> lstOppToUpdate --> '+lstOppToUpdate);
            update lstOppToUpdate;
            System.debug(LoggingLevel.ERROR, '3 --> @@@@@@@@@@@@@@@ -----> CMsTriggerRunCounter.skipOppTrigger --> '+CMsTriggerRunCounter.skipOppTrigger);
            CMsTriggerRunCounter.skipOppTrigger = false;
            System.debug(LoggingLevel.ERROR, '3 --> @@@@@@@@@@@@@@@ -----> CMsTriggerRunCounter.skipOppTrigger --> '+CMsTriggerRunCounter.skipOppTrigger);
            
        }

        if(!lstCreateOpptyTeamMembers.isEmpty()){
            //update the  Added_EM_to_Team__c flag
            Database.insert(lstCreateOpptyTeamMembers,false);
        }


        //recalculate splits for opportunities with owner change
        if(!oppotunitiesForSplitSync.isEmpty()){
            futureSyncOverlayOpportunitySplits (oppotunitiesForSplitSync);
        }

    }

    /* Check if EM needs to be added to the OppTeam
    */
    public list<OpportunityTeamMember> addEMToTheOppTeam(Map<Id,Id> opportunitiesForEngagementManager,Map<Id,Id> opportunityAEToEngagmentManagerMap, list<OpportunityTeamMember> existingOpportunityTeamMembers){
        System.debug(LoggingLevel.ERROR, '4 --> @@@@@@@@@@@@@@@ -----> opportunitiesForEngagementManager --> '+opportunitiesForEngagementManager);
        System.debug(LoggingLevel.ERROR, '4 --> @@@@@@@@@@@@@@@ -----> opportunityAEToEngagmentManagerMap --> '+opportunityAEToEngagmentManagerMap);
        System.debug(LoggingLevel.ERROR, '4 --> @@@@@@@@@@@@@@@ -----> existingOpportunityTeamMembers --> '+existingOpportunityTeamMembers);

        List<OpportunityTeamMember> listCreateOpptyTeamMembers = new List<OpportunityTeamMember>();
        //add enagagment manager as team member
        if(!opportunitiesForEngagementManager.isEmpty()){
            Map<Id,ID> opportunityToEnagementManagerMap = new Map<Id,Id>();
            for(Id oppId: opportunitiesForEngagementManager.keySet()){
                //Check if EM Mapping exists
                if(opportunityAEToEngagmentManagerMap.get(opportunitiesForEngagementManager.get(oppId)) != null){
                    Id currentEngagmentManagerId = opportunityAEToEngagmentManagerMap.get(opportunitiesForEngagementManager.get(oppId));
                    System.debug(LoggingLevel.ERROR, '4 --> @@@@@@@@@@@@@@@ -----> currentEngagmentManagerId --> '+currentEngagmentManagerId);
                    boolean currentEMRoleAlreadyExists = false;

                    //remove any previous engagement manager roles for opportunity if diffrent than the current Engagement manager
                    for(OpportunityTeamMember otm: existingOpportunityTeamMembers){
                        System.debug(LoggingLevel.ERROR, '4 --> @@@@@@@@@@@@@@@ -----> otm --> '+otm);
                        if(otm.OpportunityId == oppId && otm.TeamMemberRole == OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER){
                            currentEMRoleAlreadyExists = true;
                        }
                    }
                    //add a role for current Engagment manager if it already does not exist
                    if(currentEMRoleAlreadyExists == false){
                        opportunityToEnagementManagerMap.put(oppId, currentEngagmentManagerId);
                    }
                }
            }
            System.debug(LoggingLevel.ERROR, '4 --> @@@@@@@@@@@@@@@ -----> opportunityToEnagementManagerMap --> '+opportunityToEnagementManagerMap);
            if(!opportunityToEnagementManagerMap.isEmpty()){
                list<OpportunityTeamMember> lstOpptyMembers_EngagamentManagers = createTeamMemberObj(opportunityToEnagementManagerMap,OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER);
                listCreateOpptyTeamMembers.addAll(lstOpptyMembers_EngagamentManagers);
                return listCreateOpptyTeamMembers;
            }
        }
        System.debug(LoggingLevel.ERROR, '4 --> @@@@@@@@@@@@@@@ -----> listCreateOpptyTeamMembers --> '+listCreateOpptyTeamMembers);
        return listCreateOpptyTeamMembers;
    }

    /* added method to fix production issue.
    */
    public list<OpportunityTeamMember> removeDuplicatesAddedByRules(list<OpportunityTeamMember> lstExtOpptyMembers){
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  removeDuplicatesAddedByRules method --> lstExtOpptyMembers --> '+lstExtOpptyMembers);

        map<Id,OpportunityTeamMember> mapOpptyMember = new map<Id,OpportunityTeamMember>();
        for(OpportunityTeamMember opptyMem:lstExtOpptyMembers){
            mapOpptyMember.put(opptyMem.Id,opptyMem);
        }
        list<OpportunityTeamMember> opptyMemList = new list<OpportunityTeamMember>(mapOpptyMember.values());
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  removeDuplicatesAddedByRules method --> opptyMemList --> '+opptyMemList);
        return opptyMemList;
    }

    /*
      *Method:addOpptyOwnerASTeamMember
     * Desc:    Add opportunity Owner as Team Member
     */
    public list<OpportunityTeamMember> addOpptyOwnerASTeamMember(map<Id,User> OpptyOwnerObjmap,map<Id,Opportunity> opportunityNewMap){

        list<OpportunityTeamMember> lstOpptyTeamMember = new list<OpportunityTeamMember>();

        //create team meber objects for Opportunity owner role contains Channel
        map<Id,Id> mapOpptyChannelOwner = getOpptyOwnerMapWithRole(OpptyOwnerObjmap,opportunityNewMap,sUserRole_Channel);
        list<OpportunityTeamMember> lstOpptyMembers_Channel = createTeamMemberObj(mapOpptyChannelOwner,sTeammeberRole_PartnerManager);
        lstOpptyTeamMember.addAll(lstOpptyMembers_Channel);

        //create team meber objects for Opportunity owner role contains ADR
        map<Id,Id> mapOpptyADROwner = getOpptyOwnerMapWithRole(OpptyOwnerObjmap,opportunityNewMap,sUserRole_ADR);
        list<OpportunityTeamMember> lstOpptyMembers_ADR = createTeamMemberObj(mapOpptyADROwner,sTeammeberRole_ADR);
        lstOpptyTeamMember.addAll(lstOpptyMembers_ADR);

        //added by nikhil
        //create team meber objects for Opportunity owner role contains sales
        map<Id,Id> mapOpptySalesOwner = getOpptyOwnerMapWithRole(OpptyOwnerObjmap,opportunityNewMap,sUserRole_Sales);
        list<OpportunityTeamMember> lstOpptyMembers_SALES = createTeamMemberObj(mapOpptySalesOwner,sTeammeberRole_accExecutive);
        lstOpptyTeamMember.addAll(lstOpptyMembers_SALES);

        return lstOpptyTeamMember;
    }

    /*
      Method:prvOwnerTeamMemberRecords
      Desc: Remove all opportunity pervious owners from team - exclude if the opportunity was created from lead conversion and previous owner is lead converter
      															and ADR, parnter manager roles.
    */

    public list<OpportunityTeamMember> prvOwnerTeamMemberRecords(set<id> opptyPrvOwnerIdSet,map<Id,Opportunity> opportunityOldMap, list<OpportunityTeamMember> existingOpportunityTeamMembers){

        list<OpportunityTeamMember> lstDeleteTeamMember = new list<OpportunityTeamMember>();
        set<Id> setConvertedOpptyIds = new set<Id>();
        list<Lead>  lstConvertedLeadOpptys = [select Id,ConvertedOpportunityId,IsConverted from Lead where IsConverted=true and ConvertedOpportunityId IN :opportunityOldMap.keySet()];

        for(Lead lObj:lstConvertedLeadOpptys){
            setConvertedOpptyIds.add(lObj.ConvertedOpportunityId);
        }


        /*list<OpportunityTeamMember> lstOpptyTeam = [select Id,OpportunityId,TeamMemberRole,UserId from OpportunityTeamMember
                                                                                                where UserId IN:opptyPrvOwnerIdSet
                                                                                                AND OpportunityId IN:opportunityOldMap.keySet()];*/
        for(OpportunityTeamMember opptyMemObj: existingOpportunityTeamMembers){
            if(opptyPrvOwnerIdSet.contains(opptyMemObj.UserId) && opportunityOldMap.keySet().contains(opptyMemObj.OpportunityId) && opportunityOldMap.containsKey(opptyMemObj.OpportunityId)){
                Opportunity oldOpp = opportunityOldMap.get(opptyMemObj.OpportunityId);
                if(oldOpp.OwnerId == opptyMemObj.UserId){
                    //excluded Lead converter from deletion (creator or opportunity from converted lead is not removed during owner change)
                    if(!(setConvertedOpptyIds.contains(oldOpp.id) && oldOpp.CreatedById ==opptyMemObj.UserId)){
                        //skip ADR and Parnter Manager roles - Opportunity is created by these role
                        if(oldOpp.CreatedById !=opptyMemObj.UserId && opptyMemObj.TeamMemberRole != sTeammeberRole_ADR && opptyMemObj.TeamMemberRole != sTeammeberRole_PartnerManager ){
                            lstDeleteTeamMember.add(opptyMemObj);
                        }
                    }
                }
            }
        }
        return lstDeleteTeamMember;
    }


    /*
    Method:prvOwnerTeamMemberRecords
    Desc: Remove all opportunity pervious owners from team - exclude if the opportunity was created from lead conversion and previous owner is lead converter
                                                                and ADR, parnter manager roles.
  */

    public list<OpportunityTeamMember> prvLeadPassedTeamMemberRecords(set<id> opptyPrvLeadPassedBySet,map<Id,Opportunity> opportunityOldMap,
            List<OpportunityTeamMember> existingOpportunityTeamMembers){

        list<OpportunityTeamMember> lstDeleteTeamMember = new list<OpportunityTeamMember>();


        for(OpportunityTeamMember opptyMemObj: existingOpportunityTeamMembers){
            if(opptyPrvLeadPassedBySet.contains(opptyMemObj.UserId) && opportunityOldMap.keySet().contains(opptyMemObj.OpportunityId) && opportunityOldMap.containsKey(opptyMemObj.OpportunityId)){
                Opportunity oldOpp = opportunityOldMap.get(opptyMemObj.OpportunityId);
                if(oldOpp.Lead_Passed_By__c==opptyMemObj.UserId){
                    lstDeleteTeamMember.add(opptyMemObj);
                }
            }
        }
        return lstDeleteTeamMember;
    }

    /*@Method:getUserObjMap
     *@Desc:  Create Opportunity TeamMemeber
     */
    public list<OpportunityTeamMember> createTeamMemberObj(map<Id,Id> opptyTeamMemberMap, String sRole){
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  createTeamMemberObj method --> opptyTeamMemberMap --> '+opptyTeamMemberMap);
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  createTeamMemberObj method --> sRole --> '+sRole);        
        list<OpportunityTeamMember> opptyMemberObjList = new list<OpportunityTeamMember>();
        for(Id opptyId:opptyTeamMemberMap.keySet()){
            OpportunityTeamMember opptymemObj = new OpportunityTeamMember();
            opptymemObj.OpportunityId = opptyId;
            opptymemObj.UserId = opptyTeamMemberMap.get(opptyId);
            opptymemObj.TeamMemberRole = sRole;
            opptyMemberObjList.add(opptymemObj);
        }
        return opptyMemberObjList;
    }



    /*@Method:createCSMTeamMemberObj
     *@Desc:  Create Opportunity Team with Role CSM which are fetched from the Account Team
     */
    public list<OpportunityTeamMember> createCSMTeamMemberObj(Map<Id,Id> OpptyAccountMap, map<Id,set<Id>> accTeamMap, string sRole,map<Id,Opportunity> opportunityNewMap){
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  createCSMTeamMemberObj method --> OpptyAccountMap --> '+OpptyAccountMap);
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  createCSMTeamMemberObj method --> accTeamMap --> '+accTeamMap);
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  createCSMTeamMemberObj method --> sRole --> '+sRole);
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  createCSMTeamMemberObj method --> opportunityNewMap --> '+opportunityNewMap);

        list<OpportunityTeamMember> opptyMemberObjList = new list<OpportunityTeamMember>();
        for(Id opptyId:OpptyAccountMap.KeySet()){
            if(accTeamMap.containsKey(OpptyAccountMap.get(opptyId)) && opportunityNewMap.get(opptyId).Probability <= Decimal.valueOf(label.CSMOpportunityProbability)){
                set<Id> TeamMemberIdSet = accTeamMap.get(OpptyAccountMap.get(opptyId));
                for(Id TeamMemberId:TeamMemberIdSet){
                    OpportunityTeamMember opptymemObj = new OpportunityTeamMember(
                            OpportunityId = opptyId,
                            UserId = TeamMemberId,
                            TeamMemberRole = sRole
                    );
                    opptyMemberObjList.add(opptymemObj);
                }
            }
        }
        return opptyMemberObjList;
    }

    /*@Method:getCurrentOpptyAccountExe
     *@Desc:  returns Current Opportunity Team Memebers with Role Account Executive
     */

    public list<OpportunityTeamMember> getCurrentOpptyAccountExe(map<Id,Id> opptyAccountMap,String sRole,map<Id,Id> OpptyAccountOwner,
            List<OpportunityTeamMember> existingOpportunityTeamMembers){
        list<OpportunityTeamMember> lstDeleteSalesTeam = new list<OpportunityTeamMember>();
        for(OpportunityTeamMember opptyTeamMemAccExe: existingOpportunityTeamMembers){
            if(sRole.equalsIgnoreCase(opptyTeamMemAccExe.TeamMemberRole) && opptyAccountMap.keySet().contains(opptyTeamMemAccExe.OpportunityId) &&
                    OpptyAccountOwner.containsKey(opptyTeamMemAccExe.OpportunityId) && OpptyAccountOwner.get(opptyTeamMemAccExe.OpportunityId)!=opptyTeamMemAccExe.UserId
                    )
            { //if the current sales Team Account executive is sames as Account owner do not delete

                lstDeleteSalesTeam.add(opptyTeamMemAccExe);
            }
        }

        return lstDeleteSalesTeam;
    }

    /*@Method:getCurrentCSMTeamMember
     *@Desc:  returns all Current Opportunity Team Memebers with Role CSM
     */
    public list<OpportunityTeamMember> getCurrentCSMTeamMember(List<OpportunityTeamMember> opptyPrvTeam,String sRole){
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getCurrentCSMTeamMember method --> opptyPrvTeam --> '+opptyPrvTeam);
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getCurrentCSMTeamMember method --> sRole --> '+sRole);
        
        list<OpportunityTeamMember> lstDeleteSalesTeam = new list<OpportunityTeamMember>();
        for(OpportunityTeamMember opptyTeamMem:opptyPrvTeam){

            //delete ALL CSM
            if(sRole.equalsIgnoreCase(opptyTeamMem.TeamMemberRole)){
                lstDeleteSalesTeam.add(opptyTeamMem);
            }
        }
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getCurrentCSMTeamMember method --> lstDeleteSalesTeam --> '+lstDeleteSalesTeam);        
        return lstDeleteSalesTeam;
    }



    /*@Method:getUserObjMap
     *@Desc:  returns User objects for Opportunity Owners
     */
    public map<Id,User> getUserObjMap(set<Id> UserIdSet){
        return new map<Id,User>([select Id,ManagerId,UserRoleId,UserRole.Name,isActive,manager.isActive from User where Id IN :UserIdSet
        AND isActive =true]);
    }


    /*@Method:getOpptyOwnerMapWithRole
     *@Desc:  returns Opportunity Owner map with specific role
     */

    public map<Id,Id> getOpptyOwnerMapWithRole(map<Id,User> OpptyOwnerObjmap,map<Id,Opportunity> opportunityMap,String sRole){
        map<Id,Id> opptyOwnerRoleMap = new map<Id,Id>();
        for(Opportunity opp:opportunityMap.values()){
            if(OpptyOwnerObjmap.containsKey(opp.OwnerId)){
                User uRec =OpptyOwnerObjmap.get(opp.OwnerId);
                if(uRec.userRole != null && uRec.userRole.Name.containsIgnoreCase(sRole)){
                    opptyOwnerRoleMap.put(opp.Id,uRec.Id);
                }
            }
        }
        return opptyOwnerRoleMap;
    }

    /*@Method:getAccountTeamRoleCSM
     *@Desc:  returns Opportunity Account Team with Role CSM
     */
    public map<Id,set<Id>> getAccountTeamRoleCSM(map<Id,Id> opptyAccountMap, list<AccountTeamMember> accteamMemObjList){
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getAccountTeamRoleCSM method --> opptyAccountMap --> '+opptyAccountMap);        
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getAccountTeamRoleCSM method --> accteamMemObjList --> '+accteamMemObjList);        

        map<Id,set<Id>> accMemberMap = new map<Id,set<Id>>();

        for(AccountTeamMember accTeam:accteamMemObjList){
            //FILTER FOR CSM ROLES ONLY
            if(sTeammeberRole_CSM.equalsIgnoreCase(accTeam.TeamMemberRole)){
                if(!accMemberMap.containskey(accTeam.AccountId)){
                    accMemberMap.put(accTeam.AccountId,new set<Id>());
                }
                accMemberMap.get(accTeam.AccountId).add(accTeam.UserId);
            }
        }
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getAccountTeamRoleCSM method --> accMemberMap --> '+accMemberMap);        

        return accMemberMap;
    }

    /*@Method:getAccountTeamRoleCSM
   *@Desc:  returns Opportunity Account Team with Role CSM
   */
    public map<Id,set<Id>> getAccountTeamRoleCSR(map<Id,Id> opptyAccountMap, list<AccountTeamMember> accteamMemObjList){
        map<Id,set<Id>> accMemberMap = new map<Id,set<Id>>();

        for(AccountTeamMember accTeam:accteamMemObjList){
            //FILTER FOR CSR ROLES ONLY
            if(sTeammeberRole_CSR.equalsIgnoreCase(accTeam.TeamMemberRole)){
                if(!accMemberMap.containskey(accTeam.AccountId)){
                    accMemberMap.put(accTeam.AccountId,new set<Id>());
                }
                accMemberMap.get(accTeam.AccountId).add(accTeam.UserId);
            }
        }

        return accMemberMap;
    }


    /*@Method:getAccountTeamRoleCSD
     *@Desc:  returns Opportunity Account Team with Role CSD
	 * 12/01/2016 Added Tia Xuan
     */
    public map<Id,set<Id>> getAccountTeamRoleCSD(map<Id,Id> opptyAccountMap, list<AccountTeamMember> accteamMemObjList){
        map<Id,set<Id>> accMemberMap = new map<Id,set<Id>>();

        for(AccountTeamMember accTeam:accteamMemObjList){
            //FILTER FOR CSD ROLES ONLY
            if(sTeammeberRole_CSD.equalsIgnoreCase(accTeam.TeamMemberRole)){
                if(!accMemberMap.containskey(accTeam.AccountId)){
                    accMemberMap.put(accTeam.AccountId,new set<Id>());
                }
                accMemberMap.get(accTeam.AccountId).add(accTeam.UserId);
            }
        }

        return accMemberMap;
    }




    /*
    * @Method:  getOpptyAccountOwner
    * @Desc  :  Opportunity Account Owner logic
    * @Param  : opptyAccountMap -  map of Opportuity and opportunityAccoun Id's.
    * @return : return OpportunityId AccountOwnerId Map <OpptyId, AccountOwnerId>
    *
    */
    public map<Id,Id> getOpptyAccountOwner(map<Id,Id> opptyAccountMap){
        map<Id,Id> OpptyOwnerMap = new map<Id,Id>();
        list<Opportunity> OpptyObjList = [select Id,AccountId,Account.OwnerId from Opportunity where Id IN:opptyAccountMap.keySet()];
        for(Opportunity opptyObj:OpptyObjList){
            OpptyOwnerMap.put(opptyObj.Id,opptyObj.Account.OwnerId);
        }
        return OpptyOwnerMap;
    }


    /*
     * @Method: createPartnerDetailsRecords
     * @Desc  : Create PartnerDetails Record upon Opportunity creation and partner contact is not blank
     * @Param : opportunityNewMap  Opprotunity Trigger.new map
     *
     */

    //feature is not yet released
    public void createPartnerDetailsRecords(map<Id,Opportunity> opportunityNewMap){

        list<Partner_Influence__c> partnerDetailsObjList = new list<Partner_Influence__c>();
        list<Opportunity> opptyList = [select Id,Partner_Contact__c,Partner_Contact__r.AccountId from Opportunity
        where Partner_Contact__c!=null
        and Id IN:opportunityNewMap.keySet()];
        for(Opportunity opptyObj:opptyList){
            Partner_Influence__c PartnerDetailsObj = new Partner_Influence__c();
            PartnerDetailsObj.Account__c = opptyObj.Partner_Contact__r.AccountId;
            PartnerDetailsObj.Opportunity__c = opptyObj.Id;
            PartnerDetailsObj.Sourced__c=true;

            partnerDetailsObjList.add(PartnerDetailsObj); //collect objects
        }

        Database.insert(partnerDetailsObjList,false);


    }//end createPartnerDetailsRecords method

    private list<AccountTeamMember> getAccountTeamMembers(Set<Id> accountIds){
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getAccountTeamMembers method --> accountIds --> '+accountIds);        
		//exclude the Accounts with Account Type =Enterprise Partner (OEM)
        List<AccountTeamMember> accTeams = [select Id,AccountId,UserId,TeamMemberRole from AccountTeamMember where AccountId IN:accountIds
        									AND Account.Type != :OpportunitySettings.sAccountTypeEnterprisePartner];
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getAccountTeamMembers method --> accTeams --> '+accTeams);        
        return accTeams;
    }

    private List<OpportunityTeamMember> getOpportunityTeamMembers(Set<Id> opportunityIds){
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getOpportunityTeamMembers method --> opportunityIds --> '+opportunityIds);                
		List<OpportunityTeamMember> oppTeams = [SELECT Id,UserId,OpportunityId,TeamMemberRole FROM OpportunityTeamMember WHERE OpportunityId IN:opportunityIds];
        System.debug(LoggingLevel.ERROR, 'Sid -----> Inside  getAccountTeamMembers method --> oppTeams --> '+oppTeams);        
        return oppTeams;
    }

    public static Map<String,Id> getOpportunitySplitTypesMap(){
        Map<String,Id> opportunitySplitTypesMap = new Map<String,Id>();
        for(OpportunitySplitType splitType: [SELECT DeveloperName,Id,IsActive, MasterLabel FROM OpportunitySplitType where IsActive = true]){
            opportunitySplitTypesMap.put(splitType.MasterLabel.toUpperCase(), splitType.Id);
        }
        return opportunitySplitTypesMap;
    }

    @future
    public static void futureSyncOverlayOpportunitySplits (set<Id> opportunityIds){
        syncOverlayOpportunitySplits(opportunityIds);
    }

    public static void syncOverlayOpportunitySplits (set<Id> opportunityIds){
        System.debug(LoggingLevel.ERROR, 'Inside ###################### syncOverlayOpportunitySplits --> opportunityIds --> '+opportunityIds);
        Map<String,Id> opportunitySplitTypesMap =  getOpportunitySplitTypesMap();
        List<OpportunitySplit> opportunitySplitsToInsert = new List<OpportunitySplit>();
        List<OpportunitySplit> opportunitySplitsToDelete = new List<OpportunitySplit>();
        Set<Id> validSplitIds = new Set<Id>();
        Map<Id,List<OpportunityTeamMember>> teamMembersmap = new Map<Id,List<OpportunityTeamMember>>();
        Map<Id,List<OpportunitySplit>> overlaySplitMap = new Map<Id,List<OpportunitySplit>>();
        Map<Id,List<OpportunitySplit>> renewalForeCastSplitMap = new Map<Id,List<OpportunitySplit>>();

        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([Select Id, Type,OwnerId from Opportunity Where Id in :opportunityIds]);

        //get existing overlay splits for opportunities in context
        for(OpportunitySplit split: [Select Id, OpportunityId, SplitOwnerId,SplitType.MasterLabel from OpportunitySplit
        where OpportunityId in: opportunityIds
        and
        (SplitType.MasterLabel =:ConstantDeclarations.OPPORTUNITY_SPLIT_TYPE_OVERLAY or
        SplitType.MasterLabel =:ConstantDeclarations.OPPORTUNITY_SPLIT_TYPE_RENEWAL_FORECAST)]){
            System.debug(LoggingLevel.ERROR, 'Inside  ###################### syncOverlayOpportunitySplits --> split --> '+split);
            if(ConstantDeclarations.OPPORTUNITY_SPLIT_TYPE_OVERLAY.equalsIgnoreCase(split.SplitType.MasterLabel)){
                if(overlaySplitMap.get(split.OpportunityId) == null){
                    overlaySplitMap.put(split.OpportunityId, new List<OpportunitySplit>());
                }
                overlaySplitMap.get(split.OpportunityId).add(split);
            }
            else{
                if(renewalForeCastSplitMap.get(split.OpportunityId) == null){
                    renewalForeCastSplitMap.put(split.OpportunityId, new List<OpportunitySplit>());
                }
                renewalForeCastSplitMap.get(split.OpportunityId).add(split);
            }
        }

        for(OpportunityTeamMember teamMember: [Select Id,OpportunityId,UserId,Opportunity.OwnerId, OpportunityAccessLevel,TeamMemberRole from OpportunityTeamMember
        where OpportunityId in: opportunityIds and OpportunityAccessLevel != 'All']){
            if(teamMembersmap.get(teamMember.OpportunityId) == null){
                teamMembersmap.put(teamMember.OpportunityId, new List<OpportunityTeamMember>());
            }
            teamMembersmap.get(teamMember.OpportunityId).add(teamMember);
        }
        System.debug('******************************OpportunityTeamMember: '+ teamMembersmap);

        //identify new overlay splits
        if(!teamMembersmap.isEmpty()){
            for(Id OpportunityId: teamMembersmap.keyset()){
                for(OpportunityTeamMember teamMember: teamMembersmap.get(opportunityId)){
                    //team member role is not for opportunity user and matches the candidate team member roles for overlay split
                    if(teammember.userId != teammember.Opportunity.OwnerId
                            && OpportunitySettings.OPPORTUNITY_TEAM_MEMBER_ROLES_REQUIRING_OVERLAY_SPLIT.contains(teammember.TeamMemberRole)){
                        System.debug(LoggingLevel.ERROR, 'syncOverlayOpportunitySplits --> INSIDE --> ');
                        boolean splitFound = false;
                        //check if split already exists
                        if(overlaySplitMap.get(OpportunityId) != null){
                            for(OpportunitySplit split: overlaySplitMap.get(OpportunityId)){
                                if(teamMember.userId == split.SplitOwnerId){
                                    splitFound = true;
                                    validSplitIds.add(split.Id);
                                    break;
                                }
                            }
                        }
                        //create one if one is not found
                        if(splitFound == false){
                            OpportunitySplit split = new OpportunitySplit();
                            split.OpportunityId = OpportunityId;
                            split.SplitTypeId = opportunitySplitTypesMap.get(ConstantDeclarations.OPPORTUNITY_SPLIT_TYPE_OVERLAY.toUpperCase());
                            split.SplitPercentage = 100;
                            split.SplitOwnerId = teamMember.UserId;
                            opportunitySplitsToInsert.add(split);
                        }
                    }
                }
            }
        }
        System.debug('******************************opportunitySplitsToInsert: '+ opportunitySplitsToInsert);

        //identify overlay splits to delete
        if(!overlaySplitMap.isEmpty()){
            for(List<OpportunitySplit> splitList: overlaySplitMap.values()){
                for(OpportunitySplit split: splitList){
                    if(!validSplitIds.contains(split.Id)){
                        opportunitySplitsToDelete.add(split);
                    }
                }
            }
        }
        System.debug('******************************opportunitySplitsToDelete: '+ opportunitySplitsToDelete);

        //identify new Renewal forecast splits
        for(Opportunity opp: opportunityMap.values()){
            if(ConstantDeclarations.OPP_TYPE_RENEWAL.equalsIgnoreCase(opp.Type)){
                Boolean renewalForeCastSplitFound = false;
                if(renewalForeCastSplitMap.get(opp.Id) != null){
                    for(OpportunitySplit split: renewalForeCastSplitMap.get(opp.Id)){
                        if(opp.OwnerId == split.SplitOwnerId){
                            renewalForeCastSplitFound = true;
                            break;
                        }
                    }
                }

                if(renewalForeCastSplitFound == false){
                    OpportunitySplit split = new OpportunitySplit();
                    split.OpportunityId = opp.Id;
                    split.SplitTypeId = opportunitySplitTypesMap.get(ConstantDeclarations.OPPORTUNITY_SPLIT_TYPE_RENEWAL_FORECAST.toUpperCase());
                    split.SplitPercentage = 100;
                    split.SplitOwnerId = opp.OwnerId;
                    opportunitySplitsToInsert.add(split);
                }
            }
        }

        if(!opportunitySplitsToDelete.isEmpty()){
            delete opportunitySplitsToDelete;
        }
        if(!opportunitySplitsToInsert.isEmpty()){
            Database.insert(opportunitySplitsToInsert, false);
        }
    }

    public static void deleteOverlaySplitsForToBeDeletedOpportunityTeamMembers(List<OpportunityTeamMember> teamMembers){
        System.debug(LoggingLevel.ERROR, 'Inside deleteOverlaySplitsForToBeDeletedOpportunityTeamMembers --> teamMembers --> ');
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<String> teamMemberKeys = new Set<string>();
        List<OpportunitySplit> opportunitySplitsToDelete = new List<OpportunitySplit>();

        for(OpportunityTeamMember teamMember: teamMembers){
            opportunityIds.add(teamMember.OpportunityId);
            userIds.add(teammember.UserId);
            teamMemberKeys.add(teamMember.OpportunityId + '-' + teamMember.UserId);
        }
        if(!opportunityIds.isEmpty() && !userIds.isEmpty()){
            for(OpportunitySplit split: [Select Id, OpportunityId, SplitOwnerId from OpportunitySplit
            where OpportunityId in: opportunityIds and SplitOwnerId in: userIds
            and  SplitType.DeveloperName =:ConstantDeclarations.OPPORTUNITY_SPLIT_TYPE_OVERLAY]){
                string key = split.OpportunityId + '-' + split.SplitOwnerId;
                if(teamMemberKeys.contains(key)){
                    opportunitySplitsToDelete.add(split);
                }
            }
        }

        if(!opportunitySplitsToDelete.isEmpty()){
            delete opportunitySplitsToDelete;
        }
    }

    public static Map<Id,Id> getAEEngagementManagerMap(List<Id> aeIds){
        Map<Id,Id> aeEMMap = new Map<Id,Id>();
        for(Engagement_Manager_Mapping__c emm: [Select Account_Executive__c,Engagement_Manager__c
        from Engagement_Manager_Mapping__c
        where Account_Executive__c in: aeIds and Engagement_Manager__r.Isactive = true]){
            aeEMMap.put(emm.Account_Executive__c, emm.Engagement_Manager__c);
        }
        return aeEMMap;
    }

    public static Map<Id,Id> filterLeadPassedByMapToADRRoleUsers(Map<Id,Id> opptyLeadPassedByMap){
        Map<Id,Id> filteredMap = new Map<Id,Id>();
        if(!opptyLeadPassedByMap.isEmpty()){
            Set<Id> usersWithADRRole = Utilities.filterToADRRoleUsers(opptyLeadPassedByMap.values());
            if(!usersWithADRRole.isEmpty()){
                for(Id oppId: opptyLeadPassedByMap.keySet()){
                    if(usersWithADRRole.contains(opptyLeadPassedByMap.get(oppId))){
                        filteredMap.put(oppId, opptyLeadPassedByMap.get(oppId));
                    }
                }
            }
        }
        return filteredMap;
    }

    public static Map<Id,Id> filterLeadPassedByMapToEMRoleUsers(Map<Id,Id> opptyLeadPassedByMap){
        Map<Id,Id> filteredMap = new Map<Id,Id>();
        if(!opptyLeadPassedByMap.isEmpty()){
            Set<Id> usersWithEMRole = Utilities.filterToEMRoleUsers(opptyLeadPassedByMap.values());
            System.debug(LoggingLevel.ERROR, 'usersWithEMRole --> '+usersWithEMRole);
            if(!usersWithEMRole.isEmpty()){
                for(Id oppId: opptyLeadPassedByMap.keySet()){
                    if(usersWithEMRole.contains(opptyLeadPassedByMap.get(oppId))){
                        filteredMap.put(oppId, opptyLeadPassedByMap.get(oppId));
                    }
                }
            }
        }
        System.debug(LoggingLevel.ERROR, 'filteredMap --> '+filteredMap);
        return filteredMap;
    }

    public static Map<Id,Id> filterLeadPassedByMapToPartnerRoleUsers(Map<Id,Id> opptyLeadPassedByMap){
        Map<Id,Id> filteredMap = new Map<Id,Id>();
        if(!opptyLeadPassedByMap.isEmpty()){
            Set<Id> usersWithPartnerRole = Utilities.filterToPartnerRoleUsers(opptyLeadPassedByMap.values());
            System.debug(LoggingLevel.ERROR, 'usersWithPartnerRole --> '+usersWithPartnerRole);
            if(!usersWithPartnerRole.isEmpty()){
                for(Id oppId: opptyLeadPassedByMap.keySet()){
                    if(usersWithPartnerRole.contains(opptyLeadPassedByMap.get(oppId))){
                        filteredMap.put(oppId, opptyLeadPassedByMap.get(oppId));
                    }
                }
            }
        }
        System.debug(LoggingLevel.ERROR, 'filteredMap --> '+filteredMap);
        return filteredMap;
    }
}