/*** 
* Class: Opp_SCChatterNotificationsTest
* Description: Unit test for Opp_SCChatterNotificationsTest
* Author: Elmar Chen
* Create Time: 06/30/2015 13:01:44
*
**********************************************************************
*
*   Date            Author                 Change
*   06/30/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class Opp_SCChatterNotificationsTest {
	
	@isTest static void test_Opp_SCChatterNotificationsTest() {
		User runUser = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', false);
		runUser.Validation_Override__c=true;
		insert runUser;
		User ownerUser = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, true);
		System.runAs(runUser){
			Account acct = TestDataFactory.createAccounts(1, true, null)[0];
			List<Opportunity> opps = TestDataFactory.createOpportunity(20, true, new Map<String, Object>{
				  'AccountId' => acct,     
				  'StageName' => ConstantDeclarations.OPP_STAGE_EDUCATE_ON_MULESOFT_VISION
            });
            
    
        Test.startTest();
        	for(Opportunity opp : opps){
        		opp.StageName = 'Sales Qualified Lead - Stale';
        		opp.Type = 'New Business';
        	}
        	update opps;
        Test.stopTest();
		}
	}
	
}