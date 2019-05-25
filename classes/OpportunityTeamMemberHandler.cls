/**
*   Author:-        Narasimha(Perficient)
*   Created:-       01/09/2015
*   Description:-   OpportunityTeamMemberHandler
					handler class for the OpportunityTeamMemberTrigger
*   Revision:-      
*                  
**/ 
public without sharing class OpportunityTeamMemberHandler {
    public static List<Opp_Team_Tracking__c > oppTeamTracking = new List<Opp_Team_Tracking__c >();

	public static void onBeforeInsert(list<OpportunityTeamMember> lstOpptyMember){
		System.debug(LoggingLevel.ERROR, 'Inside OpportunityTeamMemberHandler class --> Method onBeforeInsert');      
		updateTeamUserRole(lstOpptyMember);

		validateUserIsAllowedToUpdateOpportunityInClosing(lstOpptyMember);

	}
	public static void onAfterInsert(list<OpportunityTeamMember> teamMembers){
		System.debug(LoggingLevel.ERROR, 'Inside OpportunityTeamMemberHandler class --> Method onAfterInsert');              
		Set<Id> opportunityIds = new Set<Id>();
		for(OpportunityTeamMember teamMember : teamMembers){
		    opportunityIds.add(teamMember.opportunityId);
		}
		
		//call method to create split for new team member and sync any out of date splits
		if(System.isBatch() || System.isFuture()){
			OpportunityTeamMemberManager.syncOverlayOpportunitySplits (opportunityIds);
		}
		else{
			OpportunityTeamMemberManager.futureSyncOverlayOpportunitySplits (opportunityIds);
		}
        
		/*
        for(OpportunityTeamMember teamMember : teamMembers){
        	Opp_Team_Tracking__c ott = new Opp_Team_Tracking__c();
            ott.Opportunity__c = teamMember.opportunityId;
            ott.Action__c = 'Insert';
			ott.New_Member__c  = teamMember.UserId;
			ott.Team_Member_Role__c = teamMember.TeamMemberRole;            
            oppTeamTracking.add(ott);
        }
        insert oppTeamTracking;
		*/
	}
	
	public static void onBeforeUpdate(map<Id,OpportunityTeamMember> opptyTeamMemberOldMap,map<Id,OpportunityTeamMember> opptyTeamMemberNewMap){
		System.debug(LoggingLevel.ERROR, 'Inside OpportunityTeamMemberHandler class --> Method onBeforeUpdate');      		
        updateTeamUserRole(opptyTeamMemberNewMap.values());

		validateUserIsAllowedToUpdateOpportunityInClosing(opptyTeamMemberNewMap.values());
	}
	
	public static void onAfterUpdate(map<Id,OpportunityTeamMember> opptyTeamMemberOldMap,map<Id,OpportunityTeamMember> opptyTeamMemberNewMap){
		System.debug(LoggingLevel.ERROR, 'Inside OpportunityTeamMemberHandler class --> Method onAfterUpdate');      		
        Set<Id> opportunityIds = new Set<Id>();
		for(OpportunityTeamMember teamMember : opptyTeamMemberNewMap.values()){
		    if(teamMember.teamMemberRole != opptyTeamMemberOldMap.get(teamMember.Id).teamMemberRole){
		        opportunityIds.add(teamMember.opportunityId);
		    }
		}
		
		//call method to create split for new team member and sync any out of date splits
		if(!opportunityIds.isEmpty()){
			if(System.isBatch() || System.isFuture()){
				OpportunityTeamMemberManager.syncOverlayOpportunitySplits (opportunityIds);
			}
			else{
			    OpportunityTeamMemberManager.futureSyncOverlayOpportunitySplits (opportunityIds);
			}
		}
	}
	public static void onBeforeDelete(list<OpportunityTeamMember> lstOpptyTeamMembers){
		System.debug(LoggingLevel.ERROR, 'Inside OpportunityTeamMemberHandler class --> Method onBeforeDelete');              
		validateUserIsAllowedToUpdateOpportunityInClosing(lstOpptyTeamMembers);
        /*
        for(OpportunityTeamMember teamMember : lstOpptyTeamMembers){
        	Opp_Team_Tracking__c ott = new Opp_Team_Tracking__c();
            ott.Opportunity__c = teamMember.opportunityId;
            ott.Action__c = 'Delete';
			ott.Old_Member__c  = teamMember.UserId;            
			ott.Team_Member_Role__c = teamMember.TeamMemberRole;            
            oppTeamTracking.add(ott);
        }
        insert oppTeamTracking;
		*/
    }
	
	
	public static void updateTeamUserRole(list<OpportunityTeamMember> lstOpptyMember){		
		set<Id> setUserId = new set<Id>();
		for(OpportunityTeamMember opptyTeamMemberObj:lstOpptyMember){
			setUserId.add(opptyTeamMemberObj.UserId);
		}
		map<Id,User> UserMap = new map<Id,User>([select Id,UserRoleId,UserRole.Name from User where Id IN:setUserId]);
		for(OpportunityTeamMember opptyTeamMemberObj:lstOpptyMember){
			if(UserMap.containsKey(opptyTeamMemberObj.UserId))
				opptyTeamMemberObj.Team_User_Role__c =UserMap.get(opptyTeamMemberObj.UserId).UserRole.Name;
		}		
	}

	public static void validateUserIsAllowedToUpdateOpportunityInClosing(List<OpportunityTeamMember> OpportunityTeamMembers){
		if(!Utilities.canUpdateOpportuniytyInClosing()){
			Set<Id> parentOpportunityIds = new Set<Id>();

			for(OpportunityTeamMember otm: OpportunityTeamMembers){
				parentOpportunityIds.add(otm.OpportunityId);
			}

			Map<Id,Opportunity> oppMap = new Map<Id,Opportunity> ([Select Id, RecordType.Developername from Opportunity where Id in: parentOpportunityIds]);

			for(OpportunityTeamMember otm: OpportunityTeamMembers){
				if(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(oppMap.get(otm.OpportunityId).RecordType.DeveloperName)
						||ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(oppMap.get(otm.OpportunityId).RecordType.DeveloperName)){
					otm.addError(Label.Opportunity_In_Closing_UnAuthorized_Edit);
				}
			}
		}
	}
}