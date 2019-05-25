trigger OpportunitySplitTrigger on OpportunitySplit (before insert, after insert, before update, after update, before delete) {
	if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
    	
    	String currentUserProfile = Utilities.currentUser.Profile.Name;
        if(OpportunitySettings.SOLUTION_MANAGER_PROFILE_NAME.equalsIgnoreCase(currentUserProfile)){
            if(trigger.isInsert){
                OpportunitySplitTriggerHandler.validateSolutionManagerUpdates(Trigger.new);
            }
            else{
                OpportunitySplitTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
            }
    	}
	}

    if (Trigger.isBefore && Trigger.isInsert) {
        OpportunitySplitTriggerHandler.onBeforeInsert(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunitySplitTriggerHandler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
    }
    if (Trigger.isBefore && Trigger.isDelete) {
        OpportunitySplitTriggerHandler.onBeforeDelete(Trigger.old);
    }
	
}