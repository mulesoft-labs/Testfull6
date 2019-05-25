/*** 
* Class: OppTeam_ChatterAfterDeleteTest
* Description: 
* Author: Elmar Chen
* Create Time: 06/09/2015 13:13:57
*
**********************************************************************
*
*   Date            Author                 Change
*   06/09/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class OppTeam_ChatterAfterDeleteTest {
	
	@isTest static void test_OppTeam_ChatterAfterDeleteTest() {
		User runUser = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
		User ownerUser = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, true);
		List<FeedItem> exisitingFeedList = null;
		List<Opportunity> opps;
		List<OpportunityTeamMember> otms;
		List<EntitySubscription> ebs;
		System.runAs(runUser){
				opps = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
		        	'Amount'  => 100,
		        	'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
		         	'CloseDate' => date.Today()
		        });
				ebs =  TestDataFactory.createEntitySubscription(4, true, new Map<String, Object>{
						'ParentId' => new List<Id>{opps[0].Id, opps[0].Id, opps[1].Id, opps[1].Id },
						'SubscriberId' => new List<Id>{runUser.Id , ownerUser.Id, runUser.Id , ownerUser.Id}
					});
				otms = TestDataFactory.createOpportunityTeamMember(2, true, new Map<String, Object>{
						'TeamMemberRole' => 'Solutions Consultant - Primary',
						'UserId' => ownerUser.Id,
						'OpportunityId' => opps
					});
				Test.startTest();
					delete otms;
				Test.stopTest();
		}
		
	
		



		List<FeedItem> feedList = [SELECT LinkURL, Title, ParentId, Body FROM FeedItem WHERE ParentId =:ownerUser.Id];
		feedList.addAll([SELECT LinkURL, ParentId, Title, Body FROM FeedItem WHERE ParentId =:runUser.Id]);
		
		Integer numFeedOwnerUser = 0;
		Integer numFeedRunUser = 0;
		for(Integer i=0; i<feedList.size(); i++){
			FeedItem item = feedList[i]; 
			System.debug('#' + i + ' item.Body is'+item.Body);
			if(item.Body.contains('You have been removed as'))
				numFeedOwnerUser++;
			else if(item.Body.contains('removed as'))
				numFeedRunUser++; 
			//System.assert(item.Body.contains(i<=1 ? 'You have been assigned as':'is the' ));	
			System.assert(item.Title.contains( 'Test Opportunity' ));	
		}
		System.assertEquals(2, numFeedOwnerUser);
		System.assertEquals(2, numFeedRunUser);

		ebs = [SELECT Id FROM EntitySubscription];
		System.assertEquals(2, ebs.size());
	}
	
}