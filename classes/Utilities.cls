public with sharing class Utilities {
    public static Map<Id,User> additionalUsersMap;
    static{
        additionalUsersMap = new Map<Id,User>();
    }

    public static User currentUser{
        get {
            if (currentUser == null) {
                currentUser = [SELECT Id, Trigger_Override__c, Validation_Override__c, ProfileId, Profile.Name,
                        UserRoleId, UserRole.Name
                FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
            }
            return currentUser;
        }
        private set;
    }

    public static Set<Id> filterToADRRoleUsers(List<Id> userIds){
        Set<Id> adrRoleUsers = new Set<Id>();
        Set<Id> idsNotInMap = new Set<Id>();

        for(Id userId: userIds){
            if(!additionalUsersMap.containsKey(userId)){
                idsNotInMap.add(userId);
            }
        }

        if(!idsNotInMap.isEmpty()){
            for(User u: [Select Id, UserRoleId, UserRole.Name, ProfileId,UserType,Profile.UserLicense.Name from User where id in: idsNotInMap]){
                additionalUsersMap.put(u.Id, u);
            }
        }

        for(Id userId: userIds){
            if(additionalUsersMap.containsKey(userId)){
                User userInContext = additionalUsersMap.get(userId);
                if(userInContext.UserRoleId != null && userInContext.UserRole.Name.toUpperCase().contains('ADR')){
                    adrRoleUsers.add(userId);
                }
            }
        }

        return adrRoleUsers;
    }

    public static Set<Id> filterToEMRoleUsers(List<Id> userIds){
        Set<Id> emRoleUsers = new Set<Id>();
        Set<Id> idsNotInMap = new Set<Id>();

        for(Id userId: userIds){
            if(!additionalUsersMap.containsKey(userId)){
                idsNotInMap.add(userId);
            }
        }

        if(!idsNotInMap.isEmpty()){
            for(User u: [Select Id, UserRoleId, UserRole.Name,ProfileId,UserType,Profile.UserLicense.Name from User where id in: idsNotInMap]){
                additionalUsersMap.put(u.Id, u);
            }
        }

        for(Id userId: userIds){
            if(additionalUsersMap.containsKey(userId)){
                User userInContext = additionalUsersMap.get(userId);
                if(userInContext.UserRoleId != null && userInContext.UserRole.Name.toLowerCase().contains('engagement manager')){
                    emRoleUsers.add(userId);
                }
            }
        }
        return emRoleUsers;
    }

    public static Set<Id> filterToPartnerRoleUsers(List<Id> userIds){
        Set<Id> partnerRoleUsers = new Set<Id>();
        Set<Id> idsNotInMap = new Set<Id>();

        for(Id userId: userIds){
            if(!additionalUsersMap.containsKey(userId)){
                idsNotInMap.add(userId);
            }
        }

        if(!idsNotInMap.isEmpty()){
            for(User u: [SELECT Id, UserRoleId, UserRole.Name,ProfileId,UserType,Profile.UserLicense.Name FROM User WHERE id in: idsNotInMap]){
                additionalUsersMap.put(u.Id, u);
            }
        }
        for(Id userId: userIds){
            if(additionalUsersMap.containsKey(userId)){
                User userInContext = additionalUsersMap.get(userId);
                System.debug(LoggingLevel.ERROR, 'AAAAAAAA ----> userInContext --> '+userInContext);
                System.debug(LoggingLevel.ERROR, 'AAAAAAAA ----> userInContext.UserType --> '+userInContext.UserType);
                System.debug(LoggingLevel.ERROR, 'AAAAAAAA ----> userInContext.Profile.UserLicense.Name --> '+userInContext.Profile.UserLicense.Name);
                if(userInContext.UserRoleId != null && userInContext.UserType != 'Standard' && (userInContext.Profile.UserLicense.Name.toLowerCase().contains('gold partner')
                        || userInContext.Profile.UserLicense.Name.toLowerCase().contains('partner community')
                )
                        ){
                    partnerRoleUsers.add(userId);
                }
            }
        }
        System.debug(LoggingLevel.ERROR, 'AAAAAAAA ----> partnerRoleUsers --> '+partnerRoleUsers);
        return partnerRoleUsers;
    }

    public static boolean canUpdateOpportuniytyInClosing(){
        User userIncontext = currentUser;
        boolean userProfileCanEditOpportunityInClosing = false;

        List<Profiles_With_Closing_Opp_Edit_Access__c> profiles = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();

        for(Profiles_With_Closing_Opp_Edit_Access__c p: profiles) {
            if(p.Profile_Name__c.equalsIgnoreCase(userIncontext.Profile.name)){
                userProfileCanEditOpportunityInClosing = true;
                break;
            }
        }

        if(userInContext.Trigger_Override__c == false && userProfileCanEditOpportunityInClosing == false)
            return false;
        else
                return true;
    }

    public static List<String> getListOfEditableFields(SobjectType s){
        List<string> editableFields = new List<string>();
        Map<String, Schema.SObjectField> fieldMap = s.getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keySet()) {
            if(fieldMap.get(fieldName).getDescribe().isUpdateable()) {
                editableFields.add(fieldName);
            }
        }
        return editableFields;
    }
}