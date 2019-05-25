/**
 * Default implementation of IMsTriggerHandler.
 *
 * This handler performs no actions on trigger events but can be extended to
 * add logic for handling specific events.
 */
global virtual class CMsBaseTriggerHandler implements IMsTriggerHandler {

    private static Set<String> isRunning = new Set<String>();
    private static Map<String, Object> triggerContext = new Map<String, Object>();
    private boolean isBeforeInsertEnabled {get;set;}
    private boolean isBeforeUpdateEnabled {get;set;}
    private boolean isBeforeDeleteEnabled {get;set;}
    private boolean isAfterInsertEnabled {get;set;}
    private boolean isAfterUpdateEnabled {get;set;}
    private boolean isAfterDeleteEnabled {get;set;}
    private boolean isAfterUndeleteEnabled {get;set;}

    global boolean isReentrant {
        get {
            return isReentrant != null ? isReentrant : false;
        }
        set;
    }

    // TODO: The values can come from the Custom Setting.
    // This way if we want to bypass the trigger we can do it easily
    global CMsBaseTriggerHandler() {
        this.isBeforeInsertEnabled = true;
        this.isBeforeUpdateEnabled = true;
        this.isBeforeDeleteEnabled = true;
        this.isAfterInsertEnabled = true;
        this.isAfterUpdateEnabled = true;
        this.isAfterDeleteEnabled = true;
        this.isAfterUndeleteEnabled = true;
    }

    global virtual Object getTriggerContext(String name) {
        return triggerContext.get(name);
    }

    global virtual void setTriggerContext(String name, Object value) {
        triggerContext.put(name, value);
    }

    private void doBeforeInsert(boolean isReentry) {
        beforeInsert(isReentry);
    }

    global virtual void beforeInsert() {
    }

    global virtual void beforeInsert(boolean isReentry) {
        beforeInsert();
    }

    private void doAfterInsert(boolean isReentry) {
        afterInsert(isReentry);
    }

    global virtual void afterInsert() {
    }

    global virtual void afterInsert(boolean isReentry) {
        afterInsert();
    }

    private void doBeforeUpdate(boolean isReentry) {
        beforeUpdate(isReentry);
    }

    global virtual void beforeUpdate() {
    }

    global virtual void beforeUpdate(boolean isReentry) {
        beforeUpdate();
    }

    private void doAfterUpdate(boolean isReentry) {
        afterUpdate(isReentry);
    }

    global virtual void afterUpdate() {
    }

    global virtual void afterUpdate(boolean isReentry) {
        afterUpdate();
    }

    private void doBeforeDelete(boolean isReentry) {
        beforeDelete(isReentry);
    }

    global virtual void beforeDelete() {
    }

    global virtual void beforeDelete(boolean isReentry) {
        beforeDelete();
    }

    private void doAfterDelete(boolean isReentry) {
        afterDelete(isReentry);
    }

    global virtual void afterDelete() {
    }

    global virtual void afterDelete(boolean isReentry) {
        afterDelete();
    }

    private virtual void doAfterUndelete(boolean isReentry) {
        afterUndelete(isReentry);
    }

    global virtual void afterUndelete() {
    }

    global virtual void afterUndelete(boolean isReentry) {
        afterUndelete();
    }

    global virtual void handle() {
        String triggerKey = getTriggerKey();
        if (isReentrant || !isRunning.contains(triggerKey)) {
            boolean isReentry = isRunning.contains(triggerKey);
            isRunning.add(triggerKey);
            handleTrigger(isReentry);
            isRunning.remove(triggerKey);
        }
    }

    global virtual void handleTrigger(boolean isReentry) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                if (isBeforeInsertEnabled) doBeforeInsert(isReentry);
            } else if (Trigger.isUpdate) {
                if (isBeforeUpdateEnabled) doBeforeUpdate(isReentry);
            } else if (Trigger.isDelete) {
                if (isBeforeDeleteEnabled) doBeforeDelete(isReentry);
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                if (isAfterInsertEnabled) doAfterInsert(isReentry);
            } else if (Trigger.isUpdate) {
                if (isAfterUpdateEnabled) doAfterUpdate(isReentry);
            } else if (Trigger.isDelete) {
                if (isAfterDeleteEnabled) doAfterDelete(isReentry);
            } else if (Trigger.isUndelete) {
                if (isAfterUndeleteEnabled) doAfterUndelete(isReentry);
            }
        }
    }

    private String getClassName() {
        //there is no way programatically find the class name of this instance
        //we will parse the result of the toString method
        return String.valueOf(this).substringBefore(':');
    }

    private String getTriggerKey() {
        String className = getClassName();
        String triggerType = 'is'
                + (Trigger.isBefore ? 'Before' : (Trigger.isAfter ? 'After' : ''))
                + (Trigger.isInsert ? 'Insert' : (Trigger.isUpdate ? 'Update' : (Trigger.isDelete ? 'Delete' : (Trigger.isUndelete ? 'Undelete' : ''))));
        return className + '.' + triggerType;
    }


}