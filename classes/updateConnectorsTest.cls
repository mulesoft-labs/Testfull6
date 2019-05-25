/*** 
* Class: updateConnectorsTest
* Description: Unit test for updateConnectorsTest
* Author: Elmar Chen
* Create Time: 06/23/2015 16:01:29
*
**********************************************************************
*
*   Date            Author                 Change
*   06/23/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class updateConnectorsTest {
	
	@isTest static void test_updateConnectorsTest() {
		List<Opportunity> opps = TestDataFactory.createOpportunity(6, true, new Map<String, Object>{
			'Amount' => 10000,
			'StageName' => new List<String>{'Negotiation', 'Closed Won', 'Closed Lost', 
				'Closed Lost', 'Negotiation', 'Negotiation'},
			'forecast__c' => 'forecast__c',
			'If_Closed_Lost_Primary_Reason__c' =>'If_Closed_Lost_Primary_Reason__c',
			'Multi_Year_Deal__c' => 'yes',
			'If_yes_Year_X_of_Total_Years__c' => '1'
		});
		
		List<Extension__c> es = TestDataFactory.createObjects(Extension__c.SObjectType, 6, true, 
			new Map<String, Object>{
				'Name' => 'Test Connector'
			});
		List<Extension_Opportunity__c> eos = TestDataFactory.createObjects(Extension_Opportunity__c.SObjectType, 
			6, true, new Map<String, Object>{
				'Extension__c' => es,
				'Critical__c' => true,  
				'Opportunity__c' => opps,
				'Status__c' => 'In Progress',
				'ExpectedRevenue__c' => 2500
			});

	Test.startTest();
	
		opps[0].StageName = 'Present Value';
		opps[1].Amount = 20000;
		opps[2].Amount = 20000;
		opps[3].StageName = 'Present Value';
		opps[4].StageName = 'Closed Won';
		opps[5].StageName = 'Closed Lost';

		update opps;
		
	Test.stopTest();
		 eos = [Select id, ExpectedRevenue__c, BookedRevenue__c, LostRevenue__c, Status__c 
		 	from Extension_Opportunity__c where Opportunity__c in :opps ORDER BY Opportunity__r.Name];
		
		System.assertEquals('In Progress', eos[0].Status__c);	
		System.assertEquals(2500.0, eos[0].ExpectedRevenue__c);	

		System.assertEquals('In Progress', eos[0].Status__c);	
		System.assertEquals(2500.0, eos[0].ExpectedRevenue__c);	

		System.assertEquals('Won', eos[1].Status__c);	
		System.assertEquals(20000.0, eos[1].BookedRevenue__c);	

		System.assertEquals('Lost', eos[2].Status__c);	
		System.assertEquals(20000.0, eos[2].LostRevenue__c);	

		System.assertEquals('In Progress', eos[3].Status__c);	
		System.assertEquals(2500.0, eos[3].ExpectedRevenue__c);	

		System.assertEquals('Won', eos[4].Status__c);	
		System.assertEquals(10000.0, eos[4].BookedRevenue__c);	

		System.assertEquals('Lost', eos[5].Status__c);	
		System.assertEquals(10000.0, eos[5].LostRevenue__c);	

		for(Extension_Opportunity__c eo : eos){
			Integer numOfNonZero = (eo.ExpectedRevenue__c == 0 ? 0 : 1) + (eo.BookedRevenue__c == 0 ? 0 : 1) + 	(eo.LostRevenue__c == 0 ? 0 : 1);
         	System.assertEquals(1, numOfNonZero);
		}
		
	}
	
}