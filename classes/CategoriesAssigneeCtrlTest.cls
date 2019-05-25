@isTest
private class CategoriesAssigneeCtrlTest {
    @testSetup
    private static void setup(){
        Test.startTest();

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        List<User> users = new List<User>();

        users.add(new User(
                Username = 'unittest1@UserCategoriesAssignmentControllerTest.com',
                Email = 'unittest1@UserCategoriesAssignmentControllerTest.com',
                Alias = 'test1', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id, TimeZoneSidKey='America/Los_Angeles'
        ));
        users.add(new User(
                Username = 'unittest2@UserCategoriesAssignmentControllerTest.com',
                Email = 'unittest2@UserCategoriesAssignmentControllerTest.com',
                Alias = 'test2', EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id, TimeZoneSidKey='America/Los_Angeles'
        ));

        insert users;

        IdeasCategoriesAssignment__c assignment = new IdeasCategoriesAssignment__c(
                User__c = users[0].Id,
                Categories__c = 'Category 1'
        );

        insert assignment;

        Test.stopTest();

        Integer recordsNumber = [SELECT COUNT() FROM IdeasCategoriesAssignment__c];

        System.assertEquals(1, recordsNumber);
    }

    @isTest
    private static void testConstructorMethod(){
        Test.startTest();
        CategoriesAssigneeCtrl controller = new CategoriesAssigneeCtrl();
        Test.stopTest();

        System.assertEquals(1, controller.records.size());
    }

    @isTest
    private static void testEdit(){
        Test.startTest();
        CategoriesAssigneeCtrl controller = new CategoriesAssigneeCtrl();
        controller.createCategoriesString = 'First;Second';

        controller.edit();

        Test.stopTest();

        System.assertEquals(2, controller.createCategories.size());
        System.assertEquals('First', controller.createCategories[0]);
        System.assertEquals('Second', controller.createCategories[1]);
    }

    @isTest
    private static void testSave(){
        Test.startTest();
        CategoriesAssigneeCtrl controller = new CategoriesAssigneeCtrl();
        IdeasCategoriesAssignment__c initialRecord = [SELECT User__r.Username, Categories__c
        FROM IdeasCategoriesAssignment__c LIMIT 1];

        controller.createUsername = 'notexisting@user.com';
        controller.createCategories = new List<String>{'Somecat'};
        controller.save();

        Integer numberAfterFailInsert = [SELECT COUNT() FROM IdeasCategoriesAssignment__c];

        controller.createUsername = initialRecord.User__r.Username;
        controller.createCategories = new List<String>{'Updated category'};
        controller.save();

        Integer numberAfterUpdate = [SELECT COUNT() FROM IdeasCategoriesAssignment__c];
        IdeasCategoriesAssignment__c updatedRecord = [SELECT Categories__c
        FROM IdeasCategoriesAssignment__c
        LIMIT 1];

        controller.createUsername = 'unittest2@UserCategoriesAssignmentControllerTest.com';
        controller.createCategories = new List<String>{'Inserted category'};
        controller.save();

        Integer numberSuccessInsert = [SELECT COUNT() FROM IdeasCategoriesAssignment__c];

        Test.stopTest();

        System.assertEquals(1, numberAfterFailInsert);
        System.assertEquals(1, numberAfterUpdate);
        System.assertEquals('Updated category', updatedRecord.Categories__c);
        System.assertEquals(2, numberSuccessInsert);
    }

    @isTest
    private static void testRemove(){
        Test.startTest();
        CategoriesAssigneeCtrl controller = new CategoriesAssigneeCtrl();

        List<IdeasCategoriesAssignment__c> initialRecords = [SELECT Id FROM IdeasCategoriesAssignment__c];

        controller.rId = initialRecords[0].Id;
        controller.remove();

        Integer numberAfterDelete = [SELECT COUNT() FROM IdeasCategoriesAssignment__c];

        controller.remove();

        Test.stopTest();

        System.assertEquals(1, initialRecords.size());
        System.assertEquals(0, numberAfterDelete);
    }
}