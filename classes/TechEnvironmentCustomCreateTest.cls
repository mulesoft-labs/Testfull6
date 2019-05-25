/*** 
* Class: TechEnvironmentCustomCreateTest
* Description: Unit test for TechEnvironmentCustomCreateTest
* Author: Elmar Chen
* Create Time: 06/25/2015 11:39:57
*
**********************************************************************
*
*   Date            Author                 Change
*   06/25/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class TechEnvironmentCustomCreateTest {
	
	@isTest static void test_NoTectAs() {
		Opportunity opp = TestDataFactory.createOpportunity(1, true, null)[0];
		TechEnvironmentCustomCreate ctrl = 
			new TechEnvironmentCustomCreate(new ApexPages.StandardController(opp));
	Test.startTest();
		PageReference r = ctrl.NewTechEnvironment();
	Test.stopTest();
		Profile_Qualification__c pq = [SELECT Id FROM Profile_Qualification__c WHERE Opportunity__c =: opp.Id];
		System.assert(r.getUrl().endsWith(pq.Id+''));
	}
	
}