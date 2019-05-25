/*** 
* Class: AddToSalesTeamHelperTest
* Description: Unit test for AddToSalesTeamHelperTest
* Author: Elmar Chen
* Create Time: 06/18/2015 21:15:16
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class AddToSalesTeamHelperTest {
	
	@isTest static void test_InsertMember() {
		User runUser = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
		User ownerUser = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, true);
		List<Opportunity> opps;
		List<OpportunityTeamMember> otms;
		System.runAs(runUser){
				opps = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
		        	'Amount'  => 100,
		        	'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
		         	'CloseDate' => date.Today()
		        });
				
				otms = TestDataFactory.createOpportunityTeamMember(2, false, new Map<String, Object>{
						'TeamMemberRole' => 'Solutions Consultant - Primary',
						'UserId' => ownerUser.Id,
						'OpportunityId' => opps
					});
				Test.startTest();
					AddToSalesTeamHelper.insertTeamMember(otms);
				Test.stopTest();
		}
		
		otms = [SELECT Id,UserId,TeamMemberRole FROM OpportunityTeamMember WHERE OpportunityId in :opps AND TeamMemberRole != 'Opportunity Owner'];
		System.assertEquals(2, otms.size());
	}

	@isTest static void test_InsertShare() {
		User runUser = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
		User ownerUser = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, true);
		List<Opportunity> opps;
		List<OpportunityShare> oss;
		System.runAs(runUser){
				opps = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
		        	'Amount'  => 100,
		        	'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
		         	'CloseDate' => date.Today()
		        });
				
				oss = TestDataFactory.createObjects(OpportunityShare.SObjectType, 2, false, 
					new Map<String, Object>{
						'OpportunityId' => opps,
						'UserOrGroupId' => ownerUser.Id,
						'OpportunityAccessLevel' => 'Edit'
					});
				Test.startTest();
					AddToSalesTeamHelper.insertShare(oss);
				Test.stopTest();
		}
		
		oss = [SELECT Id FROM OpportunityShare WHERE OpportunityId in :opps AND OpportunityAccessLevel='Edit' 
			AND UserOrGroupId =:ownerUser.Id];
		System.assertEquals(2, oss.size());
	}
}