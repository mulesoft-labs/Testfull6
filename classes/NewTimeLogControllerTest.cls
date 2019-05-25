/*** 
* Class: NewTimeLogControllerTest
* Description: Test case for NewTimeLogController
* Author: Elmar Chen
* Create Time: 06/15/2015 14:23:18
*
**********************************************************************
*
*   Date            Author                 Change
*   06/15/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class NewTimeLogControllerTest {
	private static Project__c prj;
	private static Work_Task__c wt;
	private static Milestone__c m; 
	private static void initTestData(){
		List<RecordType> rts = [Select Id, Name From RecordType 
			Where SObjectType = 'Project__c' and Name='iApp' limit 1];
		Id rtId = rts.size() >0 ? rts[0].Id : null;
 		prj = TestDataFactory.createProject(1, true, new Map<String, Object>{
			'project_manager__c' => UserInfo.getUserId(),
			'RecordTypeId' => rtId
		})[0];
		
		wt = TestDataFactory.createWorkTask(1, true, new Map<String, Object>{
			'Project__c' => prj.Id
		})[0];

		m = TestDataFactory.createMilestone(1, true, new Map<String, Object>{
			'Project__c' => prj.Id
		})[0];
		List<Employee__c> es = TestDataFactory.createObjects(Employee__c.SObjectType, 20, true, null);
		List<Resource_Allocation__c> ras = TestDataFactory.createObjects(Resource_Allocation__c.SObjectType,
			20, true, new Map<String, Object>{
				'Project__c' => prj.Id,
				'Employee__c' => es

		});
		Customer_Deliverable__c cd = (Customer_Deliverable__c) TestDataFactory.createObjects(Customer_Deliverable__c.SObjectType, 
			1, true, new Map<String, Object>{
				'Project__c' => prj.Id
		})[0];
	}	

	@isTest 
	static void test_Construtor_allParams() { 
		initTestData();

		System.currentPageReference().getParameters().put('projectID', prj.Id);
		System.currentPageReference().getParameters().put('retURL', '/'+prj.Id);
		System.currentPageReference().getParameters().put('work_taskID', wt.Id);
		System.currentPageReference().getParameters().put('phaseID', m.Id);
	Test.startTest();
		NewTimeLogController c = new NewTimeLogController(new ApexPages.StandardController(prj));
	Test.stopTest();
		Time_log__c log = c.getLog();
		System.assertEquals(wt.Id, log.Work_Task__c);
		System.assertEquals(m.Id, log.Milestone__c);
		System.assertEquals(prj.Id, c.selectedProjectId);

		System.assertEquals(false, c.getIsSelectedProjectNull());

		System.assertEquals(21, c.getProjectEmployees().size());

		System.assertEquals(true, c.getHasDeliverables());
		System.assertEquals(true, c.getisProjectManager());
		System.assertEquals(true, c.getIsiAppProject());
		System.assertEquals(true, c.getHasWorkItems());
		System.assertEquals(true, c.getIsProjectExternal());
		System.assertEquals(null, c.getNewCase().Id);
		System.assertEquals(null, c.billAs);
		System.assertEquals(1, c.getBillAsList().size());
	} 
	@isTest 
	static void test_Construtor_NoPhaseID() { 
	/*
	* Test case can not be written due to an apparent error in tested code, line 738
	*  		if((phaseIDParam!=null||phaseIDParam.length()>0)&&wttmp!=null) {
	* shall be 
	*       if((phaseIDParam!=null&&phaseIDParam.length()>0)&&wttmp!=null) {
	*                             ^^
	*/
	//	initTestData();
	//	System.currentPageReference().getParameters().put('projectID', prj.Id);
	//	System.currentPageReference().getParameters().put('retURL', '/'+prj.Id);
	//	System.currentPageReference().getParameters().put('work_taskID', wt.Id);
	//	//System.currentPageReference().getParameters().put('phaseID', m.Id);
	//Test.startTest();
	//	NewTimeLogController c = new NewTimeLogController(new ApexPages.StandardController(prj));
	//Test.stopTest();
	//	Time_log__c log = c.getLog();
	//	System.assertEquals(wt.Id, log.Work_Task__c);
	//	System.assertEquals(m.Id, log.Milestone__c);
	//	System.assertEquals(prj.Id, c.selectedProjectId);
	} 

	//@isTest
	//static void test_getIsPortalUser(){

	//	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	//	Profile profile1 = [Select Id from Profile where name = 'System Administrator'];

	//	//Create account
	//	Account portalAccount1 = new Account(
	//	    Name = 'TestAccount',
	//	    OwnerId = UserInfo.getUserId(),
	//	    BillingCountry = 'US'
	//	);
	//	Database.insert(portalAccount1);
	//	//Create contact
	//	Contact contact1 = new Contact(
	//	    FirstName = 'Test',
	//	        Lastname = 'McTesty',
	//	    AccountId = portalAccount1.Id,
	//	        Email = System.now().millisecond() + 'test@test.com'
	//	);
	//	Database.insert(contact1);
	//	//Create user
	//	Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
	//	User u1 = new User(
	//	    Username = System.now().millisecond() + 'test12345@test.com',
	//	    ContactId = contact1.Id,
	//	    ProfileId = portalProfile.Id,
	//	    Alias = 'test123',
	//	    Email = 'test12345@test.com',
	//	    EmailEncodingKey = 'UTF-8',
	//	    LastName = 'McTesty',
	//	    CommunityNickname = 'test12345',
	//	    TimeZoneSidKey = 'America/Los_Angeles',
	//	    LocaleSidKey = 'en_US',
	//	    LanguageLocaleKey = 'en_US'
	//	);
	//	Database.insert(u1);

	//	//Profile portalProfile = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
	//	//User u1 = TestDataFactory.createUser(portalProfile.Name, 'NA-SC Lead', false);
	//	//u1.ContactId = co.Id;
	//	User u2 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-Sales', false);

	//	initTestData();
		
	//	NewTimeLogController c = new NewTimeLogController(new ApexPages.StandardController(prj));
	//Test.startTest();
	//	boolean b1,b2;
	//	System.runAs(u1){
	//		b1 = c.getIsPortalUser();
	//	}
	//	System.runAs(u2){
	//		b2 = c.getIsPortalUser();
	//	}
	//Test.stopTest();
	//	System.assertEquals(true, b1);
	//	System.assertEquals(false, b2);
	//}
}