trigger CaseTrigger on Case (after insert, before insert, before update, after update) {
    if (Trigger.isUpdate) {
        if (trigger.isBefore) {
            CaseTriggerHandler.beforeUpdate(trigger.new, trigger.old);
        } else if(trigger.isAfter) {
            CaseTriggerHandler.afterUpdate(trigger.new, trigger.old);
        }
    } else if (Trigger.isInsert) {
        if(trigger.isBefore) {
            CaseTriggerHandler.beforeinsert(trigger.new);
        } else if(trigger.isAfter) {
            CaseTeamManager.addCreator(trigger.new);
            CaseTriggerHandler.afterInsert(trigger.new);
        }
    }
}