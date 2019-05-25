public class IdeaCommentTriggerHandler {

    public IdeaCommentTriggerHandler(){
        if (!Trigger.isExecuting) throw new IdeaSecurityException('This code must run in trigger context only');
    }

    public void sendNotificationsToSubscribers(List<IdeaComment> ideaCommentsList){
        Set<String> ideasSet = new Set<String>();
        Set<Id> userIds = new Set<Id>();
        bedrock.EmailNotification notificator = new bedrock.EmailNotification();

        for (IdeaComment ic : ideaCommentsList) {
            ideasSet.add(ic.IdeaId);
            userIds.add(ic.CreatedById);
        }

        Map<Id, User> userIdEmailMap = new Map<Id, User>([SELECT email FROM User WHERE Id IN :userIds]);

        Map<String, List<String>> ideasEmails = IdeaDataSelector.getSubscribersEmailsByIdeas(ideasSet, false);

        List<IdeaComment> comments = [SELECT IdeaId, CreatedById, CommentBody, Idea.Title, Idea.CommunityId
                                      FROM IdeaComment WHERE Id IN :ideaCommentsList];

        for (IdeaComment comment : comments) {
            if (ideasEmails.get(comment.IdeaId) == NULL) continue;

            for (String usrEmail : ideasEmails.get(comment.IdeaId)) {
                if (userIdEmailMap.get(comment.CreatedById) != NULL
                        && usrEmail == userIdEmailMap.get(comment.CreatedById).email) continue;

                notificator.addNewCommentNotification1(usrEmail, comment, 'NewCommentNotificationToSubscriber');
            }
        }

        notificator.sendEmails();
    }


    public void sendNotificationsToAssignedUsers(List<IdeaComment> ideaCommentsList){
        bedrock.EmailNotification notificator = new bedrock.EmailNotification();
        Map<String, List<String>> aMap = IdeaDataSelector.getAssignedUserEmailsByCategory();
        List<String> categories;
        Set<String> emailsList;

        List<IdeaComment> comments = [SELECT CommentBody, Idea.CommunityId, Idea.Title, Idea.Categories
        FROM IdeaComment WHERE Id IN :ideaCommentsList];

        for (IdeaComment comment : comments) {
            categories = comment.Idea.Categories.split(';');
            emailsList = new Set<String>();

            for (String category : categories) {
                if (aMap.get(category) == NULL) continue;

                emailsList.addAll(aMap.get(category));
            }

            for (String em : emailsList) {
                notificator.addNewCommentNotification1(em, comment, 'NewCommentNotificationToCategoryAssignee');
            }
        }

        notificator.sendEmails();
    }
}