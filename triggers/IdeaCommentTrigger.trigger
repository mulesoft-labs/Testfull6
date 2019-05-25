trigger IdeaCommentTrigger on IdeaComment (after insert) {
    try {
        IdeaCommentTriggerHandler hndlr = new IdeaCommentTriggerHandler();

        if(Trigger.isAfter && Trigger.isInsert) {
            hndlr.sendNotificationsToSubscribers(Trigger.new);
            hndlr.sendNotificationsToAssignedUsers(Trigger.new);
        }
    } catch(Exception ex) {
        System.debug('IdeaCommentTrigger error: ' + ex.getMessage());
    }
}