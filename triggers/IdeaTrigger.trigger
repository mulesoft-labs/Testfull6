trigger IdeaTrigger on Idea (after insert, after update) {
    try {
        IdeaTriggerHandler hndlr = new IdeaTriggerHandler();

        if (Trigger.isAfter && Trigger.isInsert) {
            hndlr.sendNewIdeaNotifications(Trigger.new);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            hndlr.sendStatusChangeNotifications(Trigger.new, Trigger.oldMap);
        }
    } catch(Exception ex) {
        System.debug('IdeaTrigger error: ' + ex.getMessage());
    }
}