/*** 
* Class: SCAction_SetValuesBeforeInsertTest
* Description: Unit test for SCAction_SetValuesBeforeInsertTest
* Author: Elmar Chen
* Create Time: 06/24/2015 12:38:34
*
**********************************************************************
*
*   Date            Author                 Change
*   06/24/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class SCAction_SetValuesBeforeInsertTest {
	
	@isTest static void test_SCAction_SetValuesBeforeInsertTest() {
		List<Account> acts = TestDataFactory.createAccounts(20, true, null);
		List<Opportunity> opps = TestDataFactory.createOpportunity(20, true, new Map<String, Object>{
				'AccountId' => acts
		}); 
		List<Contact> cs = TestDataFactory.createContacts(20, null, true, new Map<String, Object>{
				'AccountId' => acts
		}); 
		List<OpportunityContactRole> ocrs = TestDataFactory.createObjects(
			OpportunityContactRole.SObjectType, 20, true, new Map<String, Object>{
				'OpportunityId' => opps, 
				'ContactId' => cs, 
				'Role-prefix' => 'Test Role' 
		}); 
		List<Profile_Qualification__c> pqs = TestDataFactory.createObjects(
			Profile_Qualification__c.SObjectType, 20, true, new Map<String, Object>{
				'Account__c' => acts,
				'Opportunity__c' => opps
		});

	Test.startTest();
		List<SC_Action__c> sas = TestDataFactory.createObjects(
			SC_Action__c.SObjectType, 10, true, new Map<String, Object>{
				'Opportunity__c' => opps,
				'Attendees_Roles__c' => new List<String>{'Role', null},
				'Account__c' => acts
		}); 
		sas.addAll( (List<SC_Action__c>)TestDataFactory.createObjects(
			SC_Action__c.SObjectType, 10, true, new Map<String, Object>{
					'Solution_Assessment__c' => pqs
		})); 
	Test.stopTest();
		System.assertEquals(null, sas[0].Solution_Assessment__c);
		System.assertEquals(acts[0].Id, sas[0].Account__c);
		System.assertEquals('Role', sas[0].Attendees_Roles__c);

		System.assertEquals(null, sas[1].Solution_Assessment__c);
		System.assertEquals(acts[1].Id, sas[1].Account__c);
		System.assertEquals(null, sas[1].Attendees_Roles__c);

		System.assertEquals(pqs[0].Id, sas[10].Solution_Assessment__c);
		System.assertEquals(null, sas[10].Account__c);
		System.assertEquals(null, sas[10].Attendees_Roles__c);	
	}
	
}