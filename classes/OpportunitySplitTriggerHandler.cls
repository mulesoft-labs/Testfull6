public without sharing class OpportunitySplitTriggerHandler {

	public static void onBeforeInsert(list<OpportunitySplit> opportunitySplits){
		validateUserIsAllowedToUpdateOpportunityInClosing(opportunitySplits);
	}

	public static void onBeforeUpdate(map<Id,OpportunitySplit> opportunitySplitNewMap, map<Id,OpportunitySplit> opportunitySplitOldMap){
		validateUserIsAllowedToUpdateOpportunityInClosing(opportunitySplitNewMap.values());
	}
	public static void onAfterUpdate(map<Id,OpportunitySplit> opportunitySplitNewMap, map<Id,OpportunitySplit> opportunitySplitOldMap){
		List<OpportunitySplit> updatedSplits = new List<OpportunitySplit>();
		List<String> splitUpdateableFields = Utilities.getListOfEditableFields(OpportunitySplit.SobjectType);
		for(OpportunitySplit split: opportunitySplitNewMap.values()){
			OpportunitySplit oldSplit = opportunitySplitOldMap.get(split.Id);
			boolean edited = false;
			for(string fieldName: splitUpdateableFields){
				if(split.get(fieldName) != oldSplit.get(fieldName)){
					edited = true;
					break;
				}
			}
			if(edited){
				updatedSplits.add(split);
			}
		}
		
		if(!updatedSplits.isEmpty()){
			validateSolutionManagerUpdates(updatedSplits);
		}
	}

	public static void onBeforeDelete(list<OpportunitySplit> opportunitySplits){
		validateUserIsAllowedToUpdateOpportunityInClosing(opportunitySplits);
	}

	public static void validateUserIsAllowedToUpdateOpportunityInClosing(List<OpportunitySplit> OpportunitySplits){
		if(!Utilities.canUpdateOpportuniytyInClosing()){
			Set<Id> parentOpportunityIds = new Set<Id>();

			for(OpportunitySplit split: OpportunitySplits){
				parentOpportunityIds.add(split.OpportunityId);
			}

			Map<Id,Opportunity> oppMap = new Map<Id,Opportunity> ([Select Id, RecordType.Developername 
																	from Opportunity 
																	where Id in: parentOpportunityIds]);

			for(OpportunitySplit split: OpportunitySplits){
				if(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(oppMap.get(split.OpportunityId).RecordType.DeveloperName)
						|| ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(oppMap.get(split.OpportunityId).RecordType.DeveloperName)){
					split.addError(Label.Opportunity_In_Closing_UnAuthorized_Edit);
				}
			}
		}
	}

	public static void validateSolutionManagerUpdates(List<OpportunitySplit> OpportunitySplits){
		Set<Id> opportunityIds = new Set<Id>();
		Set<Id> userIds = new Set<Id>();
		Map<Id,Map<Id,string>> opportunityTeamMemberRoleMap = new Map<Id,Map<Id,string>>();

		for(OpportunitySplit sp: OpportunitySplits){
			opportunityIds.add(sp.OpportunityId);
			userIds.add(sp.SplitOwnerId);
		}

		//get existing opportunity team members
		for(OpportunityTeamMember otm: [Select Id, OpportunityId,UserId , TeamMemberRole from OpportunityTeamMember
										where OpportunityId in: opportunityIds and UserId in : userIds]){
			if(opportunityTeamMemberRoleMap.get(otm.OpportunityId) == null){
				opportunityTeamMemberRoleMap.put(otm.OpportunityId, new Map<Id,string>());
			}
			opportunityTeamMemberRoleMap.get(otm.OpportunityId).put(otm.UserId, otm.TeamMemberRole);
		}

    
		for(OpportunitySplit sp: OpportunitySplits){
			if(opportunityTeamMemberRoleMap.get(sp.OpportunityId) != null){
				if(opportunityTeamMemberRoleMap.get(sp.OpportunityId).get(sp.SplitOwnerId) != null){
					String teamMemberRole = opportunityTeamMemberRoleMap.get(sp.OpportunityId).get(sp.SplitOwnerId);
					if(!OpportunitySettings.OPPORTUNITY_TEAM_MEMBER_ROLES_WHOSE_SPLITS_CAN_BE_CHANGED_BY_SOLUTION_MANAGER.contains(teamMemberRole)){
						sp.addError('You don\'t have permission to create/update this split.');
					}
				}  
			}			
		}    	
	}

}