/*** 
* Class: OppTeam_ChatterAfterInsertTest
* Description: Test case for trigger OppTeam_ChatterAfterInsert
* Author: Elmar Chen
* Create Time: 06/08/2015 14:25:10
*
**********************************************************************
*
*   Date            Author                 Change
*   06/08/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class OppTeam_ChatterAfterInsertTest {
	
	@isTest static void test_OppTeam_ChatterAfterInsert() {
		User runUser = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
		User ownerUser = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, true);
		System.runAs(runUser){
				List<Opportunity> opps = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
		        	'Amount'  => 100,
		        	'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
		         	'CloseDate' => date.Today()
		        });
				List<OpportunityTeamMember> otms = TestDataFactory.createOpportunityTeamMember(2, false, new Map<String, Object>{
						'TeamMemberRole' => 'Solutions Consultant - Primary'
					});
				for(Integer i=0; i<2; i++){
					otms[i].UserId = ownerUser.Id; 
					otms[i].OpportunityId = opps[i].Id;
				}

			Test.startTest();
				insert otms;
			Test.stopTest();
		}
		List<FeedItem> feedList = [SELECT LinkURL, Title, ParentId, Body FROM FeedItem WHERE ParentId =:ownerUser.Id];
		feedList.addAll([SELECT LinkURL, ParentId, Title, Body FROM FeedItem WHERE ParentId =:runUser.Id]);
		
		System.assertEquals(4, feedList.size());
		for(Integer i=0; i<4; i++){
			FeedItem item = feedList[i]; 
			System.debug('#' + i + ' item.Body is'+item.Body);
			System.assert(item.Body.contains(i<=1 ? 'You have been assigned as':'is the' ));	
			System.assert(item.Title.contains( 'Test Opportunity' ));	
		}

	}
}