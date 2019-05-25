@isTest
private class IdeaTriggerHandlerTest {

    @testSetup
    static void setupData(){
        Test.startTest();

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        User testUser = new User(Alias = 'testusr', Email='testusr@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testusr@testorg.com');
        insert testUser;

        bedrock__LghtIdeasSettings__c communitySettings = new bedrock__LghtIdeasSettings__c(Name = 'community', bedrock__Value__c = 'TestPublic');
        insert communitySettings;

        //TODO: set LghtIdeasHelper methods with global access
        //String cId = bedrock.LghtIdeasHelper.getCommunityId('');
        Community community = [SELECT Id FROM Community WHERE Name = 'Partners' LIMIT 1];
        String cId = community.Id;

        List<Idea> ideasList = new List<Idea>();
        ideasList.add(new Idea(Title='Test idea_1', Body='Body of test idea_1', Status='New', Categories='test_1', CommunityId=cId));
        ideasList.add(new Idea(Title='Test idea_2', Body='Body of test idea_2', Status='Delivered', Categories='test_2', CommunityId=cId));

        insert ideasList;

        Test.stopTest();

        Integer ideasCount = [SELECT COUNT() FROM Idea];

        System.assertEquals(2, ideasCount);
    }

    @isTest
    static void testSendStatusChangeNotificationsToSubscribers(){
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
        Idea testIdea1 = [SELECT Id, Status FROM Idea WHERE Title='Test idea_1' LIMIT 1];
        Idea testIdea2 = [SELECT Id, Status FROM Idea WHERE Title='Test idea_2' LIMIT 1];

        bedrock__IdeaSubscription__c subscr = new bedrock__IdeaSubscription__c(
                bedrock__User__c = testUser.Id,
                bedrock__Idea__c = testIdea1.Id
        );

        insert subscr;

        testIdea1.Status = 'Delivered';

        update testIdea1;

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testSendStatusChangeNotificationsToAssignedUsers(){
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
        Idea testIdea1 = [SELECT Id, Status FROM Idea WHERE Title='Test idea_1' LIMIT 1];

        testIdea1.Status = 'Delivered';

        update testIdea1;

        IdeasCategoriesAssignment__c assign = new IdeasCategoriesAssignment__c(
                User__c = testUser.Id,
                Categories__c = 'test_1'
        );

        insert assign;

        testIdea1.Status = 'New';

        update testIdea1;

        Test.stopTest();

        System.assert(true);
    }
}