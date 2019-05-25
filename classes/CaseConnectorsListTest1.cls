/*** 
* Class: CaseConnectorsListTest1
* Description: Unit test for CaseConnectorsList
* Author: Elmar Chen
* Create Time: 06/25/2015 11:59:50
*
**********************************************************************
*
*   Date            Author                 Change
*   06/25/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class CaseConnectorsListTest1 {
	
	private static Opportunity opp;
	private static Case c;
	private static List<Extension__c> es;
	private static List<Extension_Version__c> evs;
	private static List<Case_Connector__c> eos;

	private static void initTestData(){
		opp = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
			'Amount' => 10000
        })[0];
       
        es = TestDataFactory.createObjects(Extension__c.SObjectType, 10, true, 
			new Map<String, Object>{
				'Name-prefix' => 'Test Connector'
		});
        
        Account testAccount = TestDataFactory.createAccounts(1, true, 
            new Map<String,Object>{
        })[0];

		c = (Case)TestDataFactory.createObjects(Case.SObjectType, 1, true, 
        	new Map<String, Object>{
                'AccountId' =>  testAccount
        })[0];


		evs = TestDataFactory.createObjects(Extension_Version__c.SObjectType, 10, true, 
			new Map<String, Object>{
				'Name-prefix' => 'Test Connector',
				'Extension__c' => es,
                'Encryption__c' => 'Test Encryption',
                'Export_Compliance__c' => 'Test Export Compliance'
		});
		eos = TestDataFactory.createObjects(Case_Connector__c.SObjectType, 20, true, 
			new Map<String, Object>{
			'Extension_Version__c' => evs,
			'Case__c' =>c
		});
	}
	
	@isTest static void test_Constructor() {
		initTestData();
	Test.startTest();
		CaseConnectorsList ctrl = new CaseConnectorsList(new ApexPages.StandardController(c));
		
	Test.stopTest(); 
		System.assertEquals(20, ctrl.getChildCount());
	}

	@isTest static void test_Delete() {
		initTestData();
		CaseConnectorsList ctrl1 = new CaseConnectorsList(new ApexPages.StandardController(c));
		CaseConnectorsList ctrl2 = new CaseConnectorsList(new ApexPages.StandardController(c));
		ctrl1.selectedConnectorId = eos[0].Id;
	Test.startTest();
		ctrl1.DeleteConnector();
		ctrl2.DeleteConnector();
	Test.stopTest(); 
		System.assertEquals(19, ctrl1.getChildCount());
	}

	@isTest
	static void test_close_openPopup(){
		initTestData();
		CaseConnectorsList ctrl1 = new CaseConnectorsList(new ApexPages.StandardController(c));
	Test.startTest();
		ctrl1.closePopup();
		Boolean b1 = ctrl1.displayPopup;
		ctrl1.showPopup();
		Boolean b2 = ctrl1.displayPopup;
	Test.stopTest();
		System.assertEquals(false, b1);
		System.assertEquals(true, b2);
	}
}