/*********************************************************************
*
*   File Name: SCActionTriggerHandlerTest.cls
*
*   File Description: Test class for the SCActionTriggerHandler class
*
**********************************************************************
*
*   Date        Author              Change
*   07/01/14    Robert              Modified to run as a test user with
*                                   the SC_Hierarchy__c field set to
*                                   resolve deploy issues when deploying
*                                   user doesn't have this field set
*   02/24/14    Andrew              Initial Creation                             
*
*********************************************************************/
        
@isTest
private class SCActionTriggerHandlerTest
{

    public static testMethod void testAfterInsert()
    {
        User testUser = createTestUser();

        System.runAs(testUser)
        {
	        SC_Action__c sca = new SC_Action__c ();
		    sca.RecordTypeId = SCActionTriggerHandler.getRecordTypeId('PoC/PoV/custom demo').id;
		    sca.On_site1__c = 'No';
		    insert sca;
	    }
    }

    public static User createTestUser()
    {
    	Profile p = [select Id from Profile where Name = 'System Administrator'];
    	User newUser = new User();
    	newUser.Alias 				= 'test1';
    	newUser.Email 				= 'testuser@fakeemailaccount.com';
    	newUser.EmailEncodingKey 	= 'UTF-8';
    	newUser.LastName 			= 'Test User';
    	newUser.LanguageLocaleKey 	= 'en_US';
    	newUser.LocaleSidKey 		= 'en_US';
    	newUser.ProfileId 			= p.Id;
    	newUser.TimeZoneSidKey 		= 'America/Los_Angeles';
    	newUser.UserName 			= 'testuser@fakeemailaccount.com';
    	newUser.SC_Hierarchy__c		= UserInfo.getUserId();
    	insert newUser;

    	return newUser;
    }

}