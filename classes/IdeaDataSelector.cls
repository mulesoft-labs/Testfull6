public without sharing class IdeaDataSelector {

    public static Map<String, List<String>> getAssignedUserEmailsByCategory(){
        Map<String, List<String>> aMap = new Map<String, List<String>>();
        List<String> categoriesList;

        List<IdeasCategoriesAssignment__c> assignments = [SELECT User__r.Email, Categories__c
        FROM IdeasCategoriesAssignment__c
        LIMIT 10000];

        for (IdeasCategoriesAssignment__c assign : assignments) {
            if (assign.User__r.Email == NULL) continue;

            categoriesList = assign.Categories__c.split(';');

            for (String category : categoriesList) {
                if (!aMap.containsKey(category)) {
                    aMap.put(category, new List<String>{assign.User__r.Email});
                } else {
                    aMap.get(category).add(assign.User__r.Email);
                }
            }
        }

        return aMap;
    }


    public static Map<String, List<String>> getSubscribersEmailsByIdeas(Set<String> ideasIds, Boolean ignoreEmailSettings){
        Map<String, List<String>> emailsMap = new Map<String, List<String>>();
        Set<String> allUsers = new Set<String>();
        Set<String> allZones = new Set<String>();

        List<bedrock__IdeaSubscription__c> subscrs = [
                SELECT bedrock__Idea__c, bedrock__Idea__r.CommunityId, bedrock__User__c, bedrock__User__r.Email
                FROM bedrock__IdeaSubscription__c
                WHERE bedrock__Idea__c IN :ideasIds
                LIMIT 10000];

        for (bedrock__IdeaSubscription__c subscr : subscrs) {
            allUsers.add(subscr.bedrock__User__c);
            allZones.add(subscr.bedrock__Idea__r.CommunityId);
        }

        Map<String, Set<String>> networkUsers = new Map<String, Set<String>>();

        for (NetworkMember membr : [SELECT MemberId, NetworkId, PreferencesDisableAllFeedsEmail
                                    FROM NetworkMember WHERE MemberId IN :allUsers]) {
            if (ignoreEmailSettings == FALSE && membr.PreferencesDisableAllFeedsEmail == TRUE) continue;

            if (networkUsers.get(membr.NetworkId) != NULL) {
                networkUsers.get(membr.NetworkId).add(membr.MemberId);
            } else {
                networkUsers.put(membr.NetworkId, new Set<String>{membr.MemberId});
            }
        }

        Map<String, Set<String>> communityUsers = new Map<String, Set<String>>();

        for (Community zone : [SELECT NetworkId FROM Community WHERE Id IN :allZones]) {
            if (networkUsers.get(zone.NetworkId) == NULL) continue;

            communityUsers.put(zone.Id, networkUsers.get(zone.NetworkId));
        }

        for (bedrock__IdeaSubscription__c subscr : subscrs) {
            if (emailsMap.get(subscr.bedrock__Idea__c) != NULL) {
                emailsMap.get(subscr.bedrock__Idea__c).add(subscr.bedrock__User__r.Email);
            } else {
                emailsMap.put(subscr.bedrock__Idea__c, new List<String>{subscr.bedrock__User__r.Email});
            }
        }

        return emailsMap;
    }
}