/*** 
* Class: SCAction_ChatterNotificationTest
* Description: Unit test for SCAction_ChatterNotificationTest
* Author: Elmar Chen
* Create Time: 06/18/2015 18:52:06
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class SCAction_ChatterNotificationTest {

	@isTest static void test_Insert() {
		User u1 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
		User u2 = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, false);
		u2.SC_Hierarchy__c = u1.Id;

		System.runAs(u2){
			Opportunity opp = TestDataFactory.createOpportunity(2, true, null)[0];
			SC_Action__c sa = (SC_Action__c)TestDataFactory.createObjects(SC_Action__c.SObjectType, 1, false,
					new Map<String, Object>{
							'Opportunity__c' => opp,
							'Action_Type__c' => 'Action',
							'Not_Available__c' => true,
							'Need_Help__c' => true
					})[0];
			Test.startTest();
			insert sa;
			Test.stopTest();
		}
		List<FeedItem> items = [SELECT Id FROM FeedItem];
		//System.assertEquals(2, items.size());
	}


	//@isTest static void test_Update() {
	//	User u1 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
	//	User u2 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-Sales', false);
	//	u2.SC_Hierarchy__c = u1.Id; 

	//	System.runAs(u2){
	//			Opportunity opp = TestDataFactory.createOpportunity(2, true, null)[0];
	//			SC_Action__c sa = (SC_Action__c)TestDataFactory.createObjects(SC_Action__c.SObjectType, 1, false,
	//				new Map<String, Object>{
	//					'Opportunity__c' => opp,
	//					'Action_Type__c' => 'Action',
	//					'Not_Available__c' => false,
	//					'Need_Help__c' => false
	//			})[0];
	//			insert sa;
	//		Test.startTest();
	//				sa.Need_Help__c = true;
	//				update sa;
	//		Test.stopTest();
	//	}
	//	List<FeedItem> items = [SELECT Id FROM FeedItem];
	//	System.assertEquals(1, items.size());
	//}

}