/*** 
* Class: OppTeam_ChatterAfterUpdateTest
* Description: Unit test for OppTeam_ChatterAfterUpdateTest
* Author: Elmar Chen
* Create Time: 06/18/2015 19:59:20
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class OppTeam_ChatterAfterUpdateTest {
	
	@isTest static void test_OppTeam_ChatterAfterUpdate() {
		User runUser = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
		User ownerUser = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, true);
		System.runAs(runUser){
				List<Opportunity> opps = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
		        	'Amount'  => 100,
		        	'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
		         	'CloseDate' => date.Today()
		        });
				List<OpportunityTeamMember> otms = TestDataFactory.createOpportunityTeamMember(2, false, new Map<String, Object>{
						//'TeamMemberRole' => 'Solutions Consultant - Primary'
					});
				for(Integer i=0; i<2; i++){
					otms[i].UserId = ownerUser.Id; 
					otms[i].OpportunityId = opps[i].Id;
				}
				insert otms;
			Test.startTest();
				otms[0].TeamMemberRole = otms[1].TeamMemberRole = 'Solutions Consultant - Secondary';
				otms[0].SC_Role_Details__c = otms[1].SC_Role_Details__c = 'Supporting';
				update otms;
			Test.stopTest();
		}
		List<FeedItem> feedList = [SELECT LinkURL, Title, ParentId, Body FROM FeedItem WHERE ParentId =:ownerUser.Id];
		feedList.addAll([SELECT LinkURL, ParentId, Title, Body FROM FeedItem WHERE ParentId =:runUser.Id]);
		
		System.assertEquals(4, feedList.size());
		for(Integer i=0; i<4; i++){
			FeedItem item = feedList[i]; 
			System.debug('#' + i + ' item.Body is'+item.Body+', item.Title is:'+item.Title);
			System.assert(item.Body.contains('Supporting'));	
			System.assert(item.Title.contains( 'Test Opportunity' ));	
		}

	}
	
}