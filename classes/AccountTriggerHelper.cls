/**
 * Author :- Santoshi(Perficient)
 * The class to handle Account trigger operations for Account team related processing.
 */
public without sharing class AccountTriggerHelper {
    //these are Account Team Member Roles that will be reflected on Opportunity Team Members
    /*public static final Set<String> OPPORTUNITY_TEAM_MEMBER_ROLES = new Set<String>{
            OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_CSM,
            OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_CSR,
            OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_CSD
    };
	*/
    public static final Map<String, Set<String>> OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP = new Map<String, Set<String>>();
    static{
        OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP.put(ConstantDeclarations.OPP_TYPE_NEW_BUSINESS, new Set<String>{
                ConstantDeclarations.OPP_STAGE_CLOSED_WON,
                ConstantDeclarations.OPP_STAGE_CLOSED_LOST,
                ConstantDeclarations.OPP_STAGE_NEGOTIATE_CLOSE,
                ConstantDeclarations.OPP_STAGE_SUBMIT_CLOSING,
                ConstantDeclarations.OPP_STAGE_BOOKING
        });


        OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP.put(ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS, new Set<String>{
                ConstantDeclarations.OPP_STAGE_CLOSED_WON,
                ConstantDeclarations.OPP_STAGE_CLOSED_LOST,
                ConstantDeclarations.OPP_STAGE_NEGOTIATE_CLOSE,
                ConstantDeclarations.OPP_STAGE_SUBMIT_CLOSING,
                ConstantDeclarations.OPP_STAGE_BOOKING
        });
        OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP.put(ConstantDeclarations.OPP_TYPE_RENEWAL, new Set<String>{
                ConstantDeclarations.OPP_STAGE_CLOSED_WON,
                ConstantDeclarations.OPP_STAGE_CLOSED_LOST,
                ConstantDeclarations.OPP_STAGE_VERBAL_WIN,
                ConstantDeclarations.OPP_STAGE_SUBMIT_CLOSING,
                ConstantDeclarations.OPP_STAGE_BOOKING
        });
    }

    //Acount Team Member role
    public static final String ACCOUNT_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER= 'Engagement Manager';
    public static final String ACCOUNT_TEAM_MEMBER_ROLE_CSM ='Customer Success Manager (CSM)';
	public static final String ACCOUNT_TEAM_MEMBER_ROLE_CS_ARCHITECT ='Customer Success Architect';
	public static final String ACCOUNT_TEAM_MEMBER_ROLE_CS_ENGINEER ='Customer Success Engineer';

    public static void updateAccountTeamMember(List<Account> triggerNewList, Map<Id,Account> triggerOldMap){
        System.debug(LoggingLevel.ERROR,'-----> Inside AccountTriggerHelper class --> Method: updateAccountTeamMember');        
        Map<ID,Set<ID>> addAccountTeams = new Map<ID,Set<ID>>();       //Map: userId --> Set[accId1, accId2, ...]
        Map<ID,ID> deleteAccountTeamsUserIdToAccId = new Map<ID,ID>(); //Map: userId --> accId
        Set<ID> deleteAccountTeamSet = new Set<ID>();                  //Set: [accId1, accId2, ...]
        Set<ID> deleteAccountTeamSetEngagementMgr = new Set<ID>();     //Set: [accId1, accId2, ...] for Engagement Manager
        for(Account acc : triggerNewList){
            //Sid --> Insert New account
            if(triggerOldMap == null){
                //INSERT: Customer Success Manager                
                if(!String.isblank(acc.Customer_Success_Manager_new__c)){
                    if(!addAccountTeams.containsKey(acc.Customer_Success_Manager_new__c)){
                        addAccountTeams.put(acc.Customer_Success_Manager_new__c,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Customer_Success_Manager_new__c).add(acc.Id);
                }
                
                //INSERT: Engagement Manager              
                if(!String.isblank(acc.Engagement_Manager__c)){
                    if(!addAccountTeams.containsKey(acc.Engagement_Manager__c)){
                        addAccountTeams.put(acc.Engagement_Manager__c,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Engagement_Manager__c).add(acc.Id);
                }

                //INSERT: Customer Success Architect
                if(!String.isblank(acc.Customer_Success_Architect__c)){
                    if(!addAccountTeams.containsKey(acc.Customer_Success_Architect__c)){
                        addAccountTeams.put(acc.Customer_Success_Architect__c,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Customer_Success_Architect__c).add(acc.Id);
                }        
				
                //INSERT: Customer Success Engineer
                if(!String.isblank(acc.Customer_Success_Engineer__c)){
                    if(!addAccountTeams.containsKey(acc.Customer_Success_Engineer__c)){
                        addAccountTeams.put(acc.Customer_Success_Engineer__c,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Customer_Success_Engineer__c).add(acc.Id);
                }                
            }
            //updated account
            else{
                
                //UPDATE: Customer Success Manager 
                //When CSM is changed to another CSM 
                if(!String.isblank(acc.Customer_Success_Manager_new__c) &&(acc.Customer_Success_Manager_new__c != triggerOldMap.get(acc.Id).Customer_Success_Manager_new__c || System.Label.Account_TeamMassUpdate == 'true') ){
                    if(!addAccountTeams.containsKey(acc.Customer_Success_Manager_new__c)){
                        addAccountTeams.put(acc.Customer_Success_Manager_new__c,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Customer_Success_Manager_new__c).add(acc.Id);
                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Customer_Success_Manager_new__c,acc.Id);
                    deleteAccountTeamSet.add(acc.Id);
                }
                //When CSM is removed from the Account                 
                if(String.isblank(acc.Customer_Success_Manager_new__c) && (acc.Customer_Success_Manager_new__c != triggerOldMap.get(acc.Id).Customer_Success_Manager_new__c || System.Label.Account_TeamMassUpdate == 'true')){
                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Customer_Success_Manager_new__c,acc.Id);
                    deleteAccountTeamSet.add(acc.Id);
                }
                
                //UPDATE: Engagement Manager
                //When EM is changed to another EM 
                if(!String.isblank(acc.Engagement_Manager__c) &&(acc.Engagement_Manager__c != triggerOldMap.get(acc.Id).Engagement_Manager__c || System.Label.Account_TeamMassUpdate == 'true') ){
                    if(!addAccountTeams.containsKey(acc.Engagement_Manager__c)){
                        addAccountTeams.put(acc.Engagement_Manager__c,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Engagement_Manager__c).add(acc.Id);
                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Engagement_Manager__c,acc.Id);
                    deleteAccountTeamSetEngagementMgr.add(acc.Id);
                }
                //When EM is removed from the Account 
                if(String.isblank(acc.Engagement_Manager__c) && (acc.Engagement_Manager__c != triggerOldMap.get(acc.Id).Engagement_Manager__c || System.Label.Account_TeamMassUpdate == 'true')){
                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Engagement_Manager__c,acc.Id);
                    deleteAccountTeamSetEngagementMgr.add(acc.Id);
                }
                
                //UPDATE: Customer Success Architect
                if(!String.isblank(acc.Customer_Success_Architect__c) &&(acc.Customer_Success_Architect__c != triggerOldMap.get(acc.Id).Customer_Success_Architect__c || System.Label.Account_TeamMassUpdate == 'true') ){
                    if(!addAccountTeams.containsKey(acc.Customer_Success_Architect__c)){
                        addAccountTeams.put(acc.Customer_Success_Architect__c,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Customer_Success_Architect__c).add(acc.Id);
                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Customer_Success_Architect__c,acc.Id);
                    deleteAccountTeamSet.add(acc.Id);
                }
                
                if(String.isblank(acc.Customer_Success_Architect__c) && (acc.Customer_Success_Architect__c != triggerOldMap.get(acc.Id).Customer_Success_Architect__c || System.Label.Account_TeamMassUpdate == 'true')){
                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Customer_Success_Architect__c,acc.Id);
                    deleteAccountTeamSet.add(acc.Id);
                }
                
                //UPDATE: Customer Success Engineer                
                if(!String.isblank(acc.Customer_Success_Engineer__c ) &&(acc.Customer_Success_Engineer__c  != triggerOldMap.get(acc.Id).Customer_Success_Engineer__c  || System.Label.Account_TeamMassUpdate == 'true') ){
                    if(!addAccountTeams.containsKey(acc.Customer_Success_Engineer__c )){
                        addAccountTeams.put(acc.Customer_Success_Engineer__c ,new Set<Id>());
                    }
                    addAccountTeams.get(acc.Customer_Success_Engineer__c ).add(acc.Id);

                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Customer_Success_Engineer__c ,acc.Id);
                    deleteAccountTeamSet.add(acc.Id);
                }
                
                if(String.isblank(acc.Customer_Success_Engineer__c ) && (acc.Customer_Success_Engineer__c  != triggerOldMap.get(acc.Id).Customer_Success_Engineer__c  || System.Label.Account_TeamMassUpdate == 'true')){
                    deleteAccountTeamsUserIdToAccId.put(triggerOldMap.get(acc.Id).Customer_Success_Engineer__c ,acc.Id);
                    deleteAccountTeamSet.add(acc.Id);
                }    
                ///*
                //If Account Owner is Changed adding CSM, CSA, CSE and EM back to 
                if(acc.OwnerId != triggerOldMap.get(acc.Id).OwnerId){
                    System.debug(LoggingLevel.ERROR, '1 ----------> SID ----> Inside Account Owner Change --> addAccountTeams --> '+addAccountTeams);                    
                    if(!String.isblank(acc.Customer_Success_Manager_new__c)){
                    	if(!addAccountTeams.containsKey(acc.Customer_Success_Manager_new__c)){
                        	addAccountTeams.put(acc.Customer_Success_Manager_new__c,new Set<Id>());
                    	}
                    	addAccountTeams.get(acc.Customer_Success_Manager_new__c).add(acc.Id);
                    }
                    System.debug(LoggingLevel.ERROR, '2 ----------> SID ----> addAccountTeams --> '+addAccountTeams);                    
                    if(!String.isblank(acc.Engagement_Manager__c)){
	                    if(!addAccountTeams.containsKey(acc.Engagement_Manager__c)){
    	                    addAccountTeams.put(acc.Engagement_Manager__c,new Set<Id>());
        	            }
            	        addAccountTeams.get(acc.Engagement_Manager__c).add(acc.Id);
                    }
                    
                    System.debug(LoggingLevel.ERROR, '3 ----------> SID ----> addAccountTeams --> '+addAccountTeams);                    
                    if(!String.isblank(acc.Customer_Success_Architect__c)){
                    	if(!addAccountTeams.containsKey(acc.Customer_Success_Architect__c)){
                        	addAccountTeams.put(acc.Customer_Success_Architect__c,new Set<Id>());
                    	}
                    	addAccountTeams.get(acc.Customer_Success_Architect__c).add(acc.Id);
                    }
                    
                    System.debug(LoggingLevel.ERROR, '4 ----------> SID ----> addAccountTeams --> '+addAccountTeams);                    
                    
                    if(!String.isblank(acc.Customer_Success_Engineer__c)){
                    	if(!addAccountTeams.containsKey(acc.Customer_Success_Engineer__c )){
                        	addAccountTeams.put(acc.Customer_Success_Engineer__c ,new Set<Id>());
                    	}
                    	addAccountTeams.get(acc.Customer_Success_Engineer__c ).add(acc.Id);
                    }
                    System.debug(LoggingLevel.ERROR, '5 ----------> SID ----> addAccountTeams --> '+addAccountTeams);                    
                }     
				//*/
            }
        }
        System.debug(LoggingLevel.ERROR,'-----> Inside AccountTriggerHelper class --> Method: updateAccountTeamMember --> addAccountTeams --> '+addAccountTeams);        
        System.debug(LoggingLevel.ERROR,'-----> Inside AccountTriggerHelper class --> Method: updateAccountTeamMember --> deleteAccountTeamsUserIdToAccId --> '+deleteAccountTeamsUserIdToAccId);        
        System.debug(LoggingLevel.ERROR,'-----> Inside AccountTriggerHelper class --> Method: updateAccountTeamMember --> deleteAccountTeamSet --> '+deleteAccountTeamSet);        
        System.debug(LoggingLevel.ERROR,'-----> Inside AccountTriggerHelper class --> Method: updateAccountTeamMember --> deleteAccountTeamSetEngagementMgr --> '+deleteAccountTeamSetEngagementMgr);        
        //Check if any team member needs to be DELETED from both Account Team and Opportunity Team?
        if(!deleteAccountTeamsUserIdToAccId.isempty()){
            deleteAccountTeamSetEngagementMgr.addAll(deleteAccountTeamSet);
            System.debug(LoggingLevel.ERROR,'-----> deleteAccountTeamSetEngagementMgr '+ deleteAccountTeamSetEngagementMgr);
            
            deleteAccountTeamMembers(deleteAccountTeamsUserIdToAccId,deleteAccountTeamSetEngagementMgr);
            deleteOpportunityTeamMembers(deleteAccountTeamSet, deleteAccountTeamsUserIdToAccId);
        }
        //See if any team member needs to be ADDED in both Account Team and Opportunity Team?
        if(!addAccountTeams.isempty()){
            List<AccountTeamMember> oppteamMembers = new List<AccountTeamMember>();
            List<AccountTeamMember> teamMembersCreated = addAccountTeamMembers(addAccountTeams);
            System.debug(LoggingLevel.ERROR,'-----> teamMembersCreated '+ teamMembersCreated);
            for(AccountTeamMember atm : teamMembersCreated){
                if(!atm.TeamMemberRole.tolowerCase().contains('engagement manager')){
                    oppteamMembers.add(atm);
                }
            }
            System.debug(LoggingLevel.ERROR,'-----> oppteamMembers '+ oppteamMembers);
            //if account is updated, sync Opportunity Team Members to Account Team Members
            if(triggerOldMap != null && !oppteamMembers.isEmpty()){
                addOpportunityTeamMembes(oppteamMembers);
            }
        }
    }


    private static void deleteAccountTeamMembers(Map<Id,Id> deleteAccountTeamsUserIdToAccId,Set<Id> deleteAccountTeamSet){
        System.debug('1 --> Sid --> deleteAccountTeamsUserIdToAccId--'+deleteAccountTeamsUserIdToAccId);
        System.debug('2 --> Sid --> deleteAccountTeamSet--'+deleteAccountTeamSet);
        Set<Id> deletedAccountTeamIds = new Set<Id>();
        List<AccountTeamMember> deleteAccountTeamsList = new List<AccountTeamMember>();
        Map<Id,AccountTeamMember> accountTeamMap = new Map<Id,AccountTeamMember>(
        [ Select a.UserId, a.TeamMemberRole, a.SystemModstamp, a.LastModifiedDate,
                a.LastModifiedById, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.AccountId,
                a.AccountAccessLevel,a.Account.Customer_Success_Manager_new__c,a.Account.Customer_Success_Manager_new__r.Title
        From AccountTeamMember a
        WHERE (a.AccountId in :deleteAccountTeamSet)]);
        System.debug('3 --> Sid --> accountTeamMap--'+accountTeamMap);
        if(!accountTeamMap.isEmpty()){
            for(AccountTeamMember accTeam : accountTeamMap.values()){
                System.debug('4 --> Sid --> accTeam--'+accTeam);
                System.debug('4 --> Sid --> accTeam.TeamMemberRole--'+accTeam.TeamMemberRole);
                System.debug('4 --> Sid --> accTeam--'+accTeam);
                if(deleteAccountTeamsUserIdToAccId.keyset().contains(accTeam.UserId) && !String.isblank(accTeam.TeamMemberRole) &&
                        (accTeam.TeamMemberRole.tolowerCase().contains(ACCOUNT_TEAM_MEMBER_ROLE_CSM.toLowerCase())
                                || accTeam.TeamMemberRole.tolowerCase().contains(ACCOUNT_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER.toLowerCase())
                        		|| accTeam.TeamMemberRole.tolowerCase().contains(ACCOUNT_TEAM_MEMBER_ROLE_CS_ARCHITECT.toLowerCase())
                        		|| accTeam.TeamMemberRole.tolowerCase().contains(ACCOUNT_TEAM_MEMBER_ROLE_CS_ENGINEER.toLowerCase()))){
                    deleteAccountTeamsList.add(accTeam);
                }
            }
            System.debug('5 --> Sid --> deleteAccountTeamsList--'+deleteAccountTeamsList);
            if(deleteAccountTeamsList.size() > 0){
                delete (deleteAccountTeamsList);
            }
        }
    }

    private static List<AccountTeamMember> addAccountTeamMembers(Map<ID,Set<ID>> addAccountTeams){
        Set<Id> userRoleIds = new Set<Id>();
        Map<Id,String> mapOfRoleIdAndRoleName = new Map<Id,String>();
        Map<Id,User> userMap = new Map<Id,User>([Select Id, UserRoleId From User WHERE id in :addAccountTeams.keySet() AND isActive= true]);
        System.debug(LoggingLevel.ERROR,' Sid --> 1 -----> userMap ----> '+ userMap);
        for(User u : userMap.values()){
            if(u.UserRoleId !=null){
                userRoleIds.add(u.UserRoleId);
            }
        }

        for(UserRole role :[SELECT Id,DeveloperName FROM userRole WHERE Id IN:userRoleIds]){
            mapOfRoleIdAndRoleName.put(role.Id,role.DeveloperName);
        }
        System.debug(LoggingLevel.ERROR,' Sid --> 1 -----> mapOfRoleIdAndRoleName ----> '+ mapOfRoleIdAndRoleName);
        List<AccountTeamMember> addAccountTeamsList = new List<AccountTeamMember>();

        for(String teamId : addAccountTeams.keySet()){
            User usr = userMap.get(teamId);
            System.debug('checking team ids---> '+usr);
            System.debug('checking userMap ids---> '+userMap);
            System.debug('checking teamId ids---> '+teamId);
            Set<Id> accSet = addAccountTeams.get(teamId);
            for(String accStr : accSet){
                System.debug(LoggingLevel.ERROR,' Sid --> 1 -----> accStr ----> '+ accStr);
                AccountTeamMember teamMember = new AccountTeamMember();
                if(usr != null){
                    if(mapOfRoleIdAndRoleName.get(usr.UserRoleId) !=null && ((mapOfRoleIdAndRoleName.get(usr.UserRoleId)).contains('_CS_')) 
                       && !((mapOfRoleIdAndRoleName.get(usr.UserRoleId)).contains('_CSA')) && !((mapOfRoleIdAndRoleName.get(usr.UserRoleId)).contains('_CSE'))){
                        teamMember.AccountId = accStr;
                        teamMember.UserId = teamId;
                        teamMember.TeamMemberRole = ACCOUNT_TEAM_MEMBER_ROLE_CSM;
                        addAccountTeamsList.add(teamMember);
                    } else if(mapOfRoleIdAndRoleName.get(usr.UserRoleId) !=null && ((mapOfRoleIdAndRoleName.get(usr.UserRoleId)).contains('_Engagement_Manager'))){
                        teamMember.AccountId = accStr;
                        teamMember.UserId = teamId;
                        teamMember.TeamMemberRole = ACCOUNT_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER;
                        addAccountTeamsList.add(teamMember);
                    } else if(mapOfRoleIdAndRoleName.get(usr.UserRoleId) !=null && ((mapOfRoleIdAndRoleName.get(usr.UserRoleId)).contains('_CSA'))){
                        teamMember.AccountId = accStr;
                        teamMember.UserId = teamId;
                        teamMember.TeamMemberRole = ACCOUNT_TEAM_MEMBER_ROLE_CS_ARCHITECT;
                        addAccountTeamsList.add(teamMember);
                    } else if(mapOfRoleIdAndRoleName.get(usr.UserRoleId) !=null && ((mapOfRoleIdAndRoleName.get(usr.UserRoleId)).contains('_CSE'))){
                        teamMember.AccountId = accStr;
                        teamMember.UserId = teamId;
                        teamMember.TeamMemberRole = ACCOUNT_TEAM_MEMBER_ROLE_CS_ENGINEER;
                        addAccountTeamsList.add(teamMember);
                    }
                    
                }
            }
        }
        System.debug(LoggingLevel.ERROR,' Sid --> 1 -----> addAccountTeamsList '+ addAccountTeamsList);
        if(!addAccountTeamsList.isEmpty()){
            insert addAccountTeamsList;
        }
        return addAccountTeamsList;
    }

    private static void deleteOpportunityTeamMembers(Set<Id> accountIds, Map<Id,Id> deleteAccountTeamsUserIdToAccId){

        //get all opportunities associated that have close dates Today and the future and Types considered for Account Team Sync
        List<Opportunity> opportunityList = [Select Id, Type, StageName
        from Opportunity
        where AccountId in : accountIds
        and CloseDate >=: Date.today()
        and Type in: OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP.keySet()];
        opportunityList = filterExcludedStageOpportunities(opportunityList);
        System.debug(LoggingLevel.ERROR,'1-----> Inside deleteOpportunityTeamMembers --> opportunityList  --> '+ opportunityList);       
        Set<Id> teamMemberIds = deleteAccountTeamsUserIdToAccId.keyset();
        System.debug(LoggingLevel.ERROR,'1-----> Inside deleteOpportunityTeamMembers --> teamMemberIds  --> '+ teamMemberIds);       
        
        if(!opportunityList.isEmpty()){
            List<OpportunityTeamMember> oppTeamMembersToDelete = [Select Id, OpportunityId, UserId, TeamMemberRole
            from OpportunityTeamMember
            Where OpportunityId in: opportunityList
            and userId IN :teamMemberIds];
        	System.debug(LoggingLevel.ERROR,'1 -----> Inside deleteOpportunityTeamMembers --> oppTeamMembersToDelete  --> '+ oppTeamMembersToDelete);                            
            if(!oppTeamMembersToDelete.isEmpty()){
                //associated splits need to be deleted before deleting Team members
                OpportunityTeamMemberManager.deleteOverlaySplitsForToBeDeletedOpportunityTeamMembers(oppTeamMembersToDelete);
        		System.debug(LoggingLevel.ERROR,'2 -----> Inside deleteOpportunityTeamMembers --> oppTeamMembersToDelete  --> '+ oppTeamMembersToDelete);                
                delete oppTeamMembersToDelete;
            }
        }
    }

    private static void addOpportunityTeamMembes(List<AccountTeamMember> teamMembersCreated){
        Map<Id, List<AccountTeamMember>> accountTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
        for(AccountTeamMember atm: teamMembersCreated){
            System.debug(LoggingLevel.ERROR,'1-----> atm '+ atm);
            if(!accountTeamMembersMap.containsKey(atm.AccountId)){
                accountTeamMembersMap.put(atm.AccountId, new List<AccountTeamMember>());
            }
            accountTeamMembersMap.get(atm.AccountId).add(atm);
        }

        //get all opportunities associated that have close dates Today and the future and Types considered for Account Team Sync
        List<Opportunity> opportunityList = [Select Id, Type, StageName, AccountId
        from Opportunity
        where AccountId in : accountTeamMembersMap.keySet()
        and CloseDate >=: Date.today()
        and Type in: OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP.keySet()];
        System.debug(LoggingLevel.ERROR,'1-----> opportunityList '+ opportunityList);
        opportunityList = filterExcludedStageOpportunities(opportunityList);
        System.debug(LoggingLevel.ERROR,'2-----> opportunityList '+ opportunityList);
        if(!opportunityList.isEmpty()){
            Set<Id> oppIdsForSplitSync = new Set<Id>();
            //create Opportunity Teams
            List<OpportunityTeamMember> oppTeamMembersToCreate = new List<OpportunityTeamMember>();
            for(Opportunity opp: opportunityList){
                oppIdsForSplitSync.add(opp.Id);
                for(AccountTeamMember atm: accountTeamMembersMap.get(opp.AccountId)){
                    OpportunityTeamMember otm = new OpportunityTeamMember();
                    otm.OpportunityId = opp.Id;
                    otm.UserId = atm.UserId;
                    otm.TeamMemberRole = atm.TeamMemberRole;
                    oppTeamMembersToCreate.add(otm);
                }
            }

            if(!oppTeamMembersToCreate.isEmpty()){
                insert oppTeamMembersToCreate;
                //sync splits to reflect new opportunity team members
                OpportunityTeamMemberManager.futureSyncOverlayOpportunitySplits (oppIdsForSplitSync);
            }
        }
    }

    private static List<Opportunity> filterExcludedStageOpportunities(List<Opportunity> oppList){
        List<Opportunity> filteredList = new List<Opportunity>();
        for(Opportunity opp: oppList){
            boolean excludeOpportunity = false;
            for(String oppTYpe: OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP.keySet()){
                if(oppTYpe.equalsIgnoreCase(opp.Type)){
                    for(String excludedStage: OPPORTUNITY_TYPE_TO_EXCLUDED_STAGE_MAP.get(oppTYpe)){
                        if(excludedStage.equalsIgnoreCase(opp.StageName)){
                            excludeOpportunity = true;
                        }
                    }
                    break;
                }
            }
            if(!excludeOpportunity){
                filteredList.add(opp);
            }
        }
        return filteredList;
    }
}