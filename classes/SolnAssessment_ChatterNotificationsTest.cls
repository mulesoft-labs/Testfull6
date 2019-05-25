/*** 
* Class: SolnAssessment_ChatterNotificationsTest
* Description: Unit test for SolnAssessment_ChatterNotificationsTest
* Author: Elmar Chen
* Create Time: 06/18/2015 19:45:12
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class SolnAssessment_ChatterNotificationsTest {
	@isTest static void test_Insert() {
		User u1 = TestDataFactory.createUser('System Administrator', 'NA-SC Lead', true);
		User u2 = TestDataFactory.createUser('System Administrator', Label.TestClassRoleName, false);
		u2.SC_Hierarchy__c = u1.Id; 

		System.runAs(u2){
				Opportunity opp = TestDataFactory.createOpportunity(2, true, null)[0];
				Profile_Qualification__c sa = (Profile_Qualification__c)TestDataFactory.createObjects(Profile_Qualification__c.SObjectType, 1, false,
					new Map<String, Object>{
						'Opportunity__c' => opp,
						'Is_MuleSoft_Technical_Fit__c' => 'No'
				})[0];
			Test.startTest();
					insert sa;
			Test.stopTest();
		}
		List<FeedItem> items = [SELECT Id FROM FeedItem];
		System.assertEquals(1, items.size());
	}


	@isTest static void test_Update() {
		User u1 = TestDataFactory.createUser('System Administrator', 'NA-SC Lead', true);
		User u2 = TestDataFactory.createUser('System Administrator', Label.TestClassRoleName, false);
		u2.SC_Hierarchy__c = u1.Id; 

		System.runAs(u2){
				Opportunity opp = TestDataFactory.createOpportunity(2, true, null)[0];
				Profile_Qualification__c sa = (Profile_Qualification__c)TestDataFactory.createObjects(Profile_Qualification__c.SObjectType, 1, false,
					new Map<String, Object>{
						'Opportunity__c' => opp,
						'Is_MuleSoft_Technical_Fit__c' => 'Yes'
				})[0];
				insert sa;
			Test.startTest();
					sa.Is_MuleSoft_Technical_Fit__c = 'No';
					update sa;
			Test.stopTest();
		}
		List<FeedItem> items = [SELECT Id FROM FeedItem];
		System.assertEquals(1, items.size());
	}
}