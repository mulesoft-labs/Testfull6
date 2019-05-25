public class IdeaTriggerHandler {

    public IdeaTriggerHandler() {
        if (!Trigger.isExecuting) throw new IdeaSecurityException('This code must run in trigger context only');
    }

    public void sendNewIdeaNotifications(List<Idea> ideasList) {
        Map<String, List<String>> aMap = IdeaDataSelector.getAssignedUserEmailsByCategory();
        bedrock.EmailNotification notificator = new bedrock.EmailNotification();
        List<String> categories;
        Set<String> emailsList;

        for (Idea idea : ideasList) {
            categories = idea.Categories.split(';');
            emailsList = new Set<String>();

            for (String category : categories) {
                if (aMap.get(category) == NULL) continue;

                emailsList.addAll(aMap.get(category));
            }

            for (String em : emailsList) {
                notificator.addIdeaCreatedNotification(em, idea, 'NewIdeaNotificationToCategoryAssignee');
            }
        }

        notificator.sendEmails();
    }

    public void sendStatusChangeNotifications(List<Idea> ideasList, Map<Id, Idea> oldMap) {

        List<Idea> filteredList = new List<Idea>();

        for (Idea idea : ideasList) {
            if(idea.Status != oldMap.get(idea.Id).Status) {
                filteredList.add(idea);
            }
        }

        if (filteredList.isEmpty()) return;

        this.sendStatusChangeNotificationsToSubscribers(filteredList, oldMap);
        this.sendStatusChangeNotificationsToManagers(filteredList, oldMap);
    }

    private void sendStatusChangeNotificationsToSubscribers(List<Idea> ideasList, Map<Id, Idea> oldMap){
        bedrock.EmailNotification notificator = new bedrock.EmailNotification();
        String oldStatus;
        List<bedrock__IdeaSubscription__c> subscriptions = [
                SELECT bedrock__Idea__c, bedrock__Idea__r.Id, bedrock__Idea__r.Title, bedrock__Idea__r.Status,
                        bedrock__Idea__r.CommunityId, bedrock__Idea__r.Body, bedrock__User__r.Email
                FROM bedrock__IdeaSubscription__c
                WHERE bedrock__Idea__c IN :ideasList LIMIT 10000];

        for (bedrock__IdeaSubscription__c subscr : subscriptions) {
            if (subscr.bedrock__User__r.Email != null) {
                oldStatus = oldMap.get(subscr.bedrock__Idea__c).Status != NULL ? oldMap.get(subscr.bedrock__Idea__c).Status : '';
                notificator.addStatusChangeNotification1(subscr.bedrock__User__r.Email, (Idea)subscr.bedrock__Idea__r,
                        oldStatus, 'ChangeStatusNotificationToSubscriber');
            }
        }

        notificator.sendEmails();
    }

    private void sendStatusChangeNotificationsToManagers(List<Idea> ideasList, Map<Id, Idea> oldMap){
        Map<String, List<String>> aMap = IdeaDataSelector.getAssignedUserEmailsByCategory();
        bedrock.EmailNotification notificator = new bedrock.EmailNotification();
        List<String> categories;
        Set<String> emailsList;
        String oldStatus;

        for (Idea idea : ideasList) {
            categories = idea.Categories.split(';');
            emailsList = new Set<String>();

            for (String category : categories) {
                if (aMap.get(category) == NULL) continue;

                emailsList.addAll(aMap.get(category));
            }

            for (String em : emailsList) {
                oldStatus = oldMap.get(idea.Id).Status != NULL ? oldMap.get(idea.Id).Status : '';
                notificator.addStatusChangeNotification1(em, idea, oldStatus, 'ChangeStatusNotificationToCategoryAssignee');
            }
        }

        notificator.sendEmails();
    }
}