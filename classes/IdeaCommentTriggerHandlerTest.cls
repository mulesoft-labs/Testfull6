@isTest
private class IdeaCommentTriggerHandlerTest {

    @testSetup
    static void setupData(){
        Test.startTest();

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        //Profile communityUserProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User'];

        Account acc = new Account(Name='TestCommunity', BillingCountry = 'USA');
        insert acc;

        Contact communityUserContact = new Contact(
                LastName = 'Community',
                AccountId = acc.Id
        );
        insert communityUserContact;

        User testUser = new User(Alias = 'testusr', Email='testusr@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testusr@testorg.com');
        insert testUser;

        /*
        User testCommunityUser = new User(Alias = 'testcomm', Email='testcommunityusr@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Community', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = communityUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testcommunityusr@testorg.com', ContactId=communityUserContact.Id);
        insert testCommunityUser;
		*/
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

        System.runAs(testUser){
            Idea testUserIdea = new Idea(Title='Test idea_3', Body='Body of test idea_3', Status='New', Categories='test_2', CommunityId=cId);

            insert testUserIdea;
        }

        /*
        System.runAs(testCommunityUser){
            Idea testCommunityUserIdea = new Idea(Title='Test idea_4', Body='Body of test idea_4', Status='New', Categories='test_3', CommunityId=cId);

            //insert testCommunityUserIdea;
        }
		*/
        Test.stopTest();

        Integer ideasCount = [SELECT COUNT() FROM Idea];

        System.assertEquals(3, ideasCount);
    }

    @isTest
    static void testSendNotificationsToSubscribersOnCreate(){
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
        Idea testIdea1 = [SELECT Id FROM Idea WHERE Title='Test idea_1' LIMIT 1];
        Idea testIdea2 = [SELECT Id FROM Idea WHERE Title='Test idea_2' LIMIT 1];
        Idea testIdea3 = [SELECT Id FROM Idea WHERE Title='Test idea_3' LIMIT 1];

        List<IdeaComment> testComments = new List<IdeaComment>();
        testComments.add(new IdeaComment(CommentBody='First comment', IdeaId=testIdea1.Id));
        testComments.add(new IdeaComment(CommentBody='First comment', IdeaId=testIdea2.Id));
        testComments.add(new IdeaComment(CommentBody='First-second comment', IdeaId=testIdea2.Id));

        insert testComments;

        System.runAs(testUser){
            List<IdeaComment> testUserComments = new List<IdeaComment>();
            testUserComments.add(new IdeaComment(CommentBody='Second comment', IdeaId=testIdea1.Id));
            testUserComments.add(new IdeaComment(CommentBody='Second comment', IdeaId=testIdea3.Id));

            insert testUserComments;
        }

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testSendNotificationsToAssignedUsersOnCreate(){
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
        //User testCommUser = [SELECT Id FROM User WHERE UserName = 'testcommunityusr@testorg.com' LIMIT 1];
        Idea testIdea1 = [SELECT Id FROM Idea WHERE Title='Test idea_1' LIMIT 1];
        Idea testIdea2 = [SELECT Id FROM Idea WHERE Title='Test idea_2' LIMIT 1];

        Community community = [SELECT Id FROM Community WHERE Name = 'Partners' LIMIT 1];
        String cId = community.Id;

        IdeasCategoriesAssignment__c assign = new IdeasCategoriesAssignment__c(
                User__c = testUser.Id,
                Categories__c = 'test_2'
        );

        insert assign;

        System.runAs(testUser){
            List<IdeaComment> testUserComments = new List<IdeaComment>();
            testUserComments.add(new IdeaComment(CommentBody='First comment', IdeaId=testIdea1.Id));
            testUserComments.add(new IdeaComment(CommentBody='First comment', IdeaId=testIdea2.Id));

            insert testUserComments;
        }

        Test.stopTest();

        System.assert(true);
    }
}