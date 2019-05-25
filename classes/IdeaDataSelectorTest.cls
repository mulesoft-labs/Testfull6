@isTest
private class IdeaDataSelectorTest {

    @testSetup
    static void setupData(){
        Test.startTest();

        bedrock__LghtIdeasSettings__c communitySettings = new bedrock__LghtIdeasSettings__c(Name = 'community', bedrock__Value__c = 'TestPublic');
        insert communitySettings;

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        List<User> users = new List<User>();

        users.add(new User(
                Username = 'unittest1@acideas.com',
                Email = 'unittest1@acideas.com',
                Alias = 'test1', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id, TimeZoneSidKey='America/Los_Angeles'
        ));
        users.add(new User(
                Username = 'unittest2@acideas.com',
                Email = 'unittest2@acideas.com',
                Alias = 'test2', EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id, TimeZoneSidKey='America/Los_Angeles'
        ));

        insert users;

        List<IdeasCategoriesAssignment__c> assignments = new List<IdeasCategoriesAssignment__c>();

        assignments.add(new IdeasCategoriesAssignment__c(
                User__c = users[0].Id,
                Categories__c = 'Test1;Test2'
        ));

        assignments.add(new IdeasCategoriesAssignment__c(
                User__c = users[1].Id,
                Categories__c = 'Test1'
        ));

        insert assignments;

        Test.stopTest();

        Integer recordsNumber = [SELECT COUNT() FROM IdeasCategoriesAssignment__c];

        System.assertEquals(2, recordsNumber);
    }

    @isTest
    static void testGetAssignedUserEmailsByCategory(){
        Test.startTest();

        Map<String, List<String>> usersMap = IdeaDataSelector.getAssignedUserEmailsByCategory();

        Test.stopTest();

        System.assertEquals(2, usersMap.size());
        System.assertEquals(2, usersMap.get('Test1').size());
        System.assertEquals(1, usersMap.get('Test2').size());
        System.assertEquals('unittest1@acideas.com', usersMap.get('Test1').get(0));
        System.assertEquals('unittest2@acideas.com', usersMap.get('Test1').get(1));
        System.assertEquals('unittest1@acideas.com', usersMap.get('Test2').get(0));
    }

    @isTest
    static void testGetSubscribersEmailsByIdeas(){
        Test.startTest();

        User usr1 = [SELECT Id FROM User WHERE Username = 'unittest1@acideas.com' LIMIT 1];
        User usr2 = [SELECT Id FROM User WHERE Username = 'unittest2@acideas.com' LIMIT 1];

        //TODO: set LghtIdeasHelper methods with global access
        //String cId = bedrock.LghtIdeasHelper.getCommunityId('');
        Community community = [SELECT Id FROM Community WHERE Name = 'Partners' LIMIT 1];
        String cId = community.Id;

        List<Idea> ideasList = new List<Idea>();
        ideasList.add(new Idea(Title='Test idea_1', Body='Body of test idea_1', Status='New', Categories='test_1', CommunityId=cId));
        ideasList.add(new Idea(Title='Test idea_2', Body='Body of test idea_2', Status='Delivered', Categories='test_2', CommunityId=cId));

        insert ideasList;

        List<bedrock__IdeaSubscription__c> subscr = new List<bedrock__IdeaSubscription__c>();
        subscr.add(new bedrock__IdeaSubscription__c(
                bedrock__Idea__c = ideasList[0].Id,
                bedrock__User__c = usr1.Id
        ));
        subscr.add(new bedrock__IdeaSubscription__c(
                bedrock__Idea__c = ideasList[0].Id,
                bedrock__User__c = usr2.Id
        ));
        subscr.add(new bedrock__IdeaSubscription__c(
                bedrock__Idea__c = ideasList[1].Id,
                bedrock__User__c = usr1.Id
        ));
        insert subscr;

        Set<String> ideasSet = new Set<String>();
        for (Idea idea : ideasList){
            ideasSet.add(idea.Id);
        }

        Map<String, List<String>> ideasEmailsMap = IdeaDataSelector.getSubscribersEmailsByIdeas(ideasSet, false);

        Test.stopTest();

        Integer subscrCount = [SELECT COUNT() FROM bedrock__IdeaSubscription__c];

        System.assertEquals(5, subscrCount);
        System.assertEquals(2, ideasEmailsMap.size());
        System.assertEquals(3, ideasEmailsMap.get(ideasList[0].Id).size());
        System.assertEquals(2, ideasEmailsMap.get(ideasList[1].Id).size());
    }
}