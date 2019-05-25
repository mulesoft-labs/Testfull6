/*** 
* Class: ConnectorRelatedListTest
* Description: Unit test for ConnectorRelatedListTest
* Author: Elmar Chen
* Create Time: 06/12/2015 14:36:37
*
**********************************************************************
*
*   Date            Author                 Change
*   06/12/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class ConnectorRelatedListTest {
	private static Opportunity opp;
	private static List<Extension__c> es;
	private static List<Extension_Opportunity__c> eos;

	private static void initTestData(){
		opp = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
			'Amount' => 10000
        })[0];
		es = TestDataFactory.createObjects(Extension__c.SObjectType, 10, true, 
			new Map<String, Object>{
				'Name-prefix' => 'Test Connector'
			});
		eos = TestDataFactory.createObjects(Extension_Opportunity__c.SObjectType, 20, false, null);
		for(Integer i=0; i<20; i++){
			eos[i].Extension__c = es[ i<=9 ? i : i - 10].Id;
			eos[i].Critical__c = i<=9;  
			eos[i].Opportunity__c = opp.Id;
		}
		insert eos;
	}
	
	@isTest static void test_Constructor() {
		initTestData();
	Test.startTest();
		ConnectorRelatedList c = new ConnectorRelatedList(new ApexPages.StandardController(opp));
		ConnectorRelatedList c2 = new ConnectorRelatedList(new ApexPages.StandardController(opp));
		c2.oppConnectors = null;
	Test.stopTest(); 
		System.assertEquals(20, c.getChildCount());
		System.assertEquals(0, c2.getChildCount());
		System.assertEquals(20, c.oppConnectors.size());
		for(Integer i=0; i<20; i++){
			System.assertEquals(i>9 ? false : true, c.oppConnectors[i].Critical__c);
		}
		System.assertEquals(10, c.optionsList.size());
		for(Integer idx=0; idx<10; idx++){
			System.debug('#'+idx+': '+ c.optionsList[idx].getLabel());
		}
		for(Integer i=0; i<10; i++){
			System.debug(c.optionsList[i].getLabel());
			System.assertEquals('Test_' + ( String.valueOf(100+i).subString(1) ), c.optionsList[i].getLabel());
			System.assertEquals(es[i].Id, c.optionsList[i].getValue());
		}
	}
	
	@isTest static void test_Delete(){
		initTestData();
		ConnectorRelatedList c = new ConnectorRelatedList(new ApexPages.StandardController(opp));
	Test.startTest();
		c.DeleteConnector();
		c.selectedConnectorId = eos[0].Id;
		c.DeleteConnector();
	Test.stopTest();
		Map<Id, Extension_Opportunity__c> oMap = new Map<Id, Extension_Opportunity__c>(c.oppConnectors);
		System.assertEquals(19, oMap.size());
		System.assert(!oMap.containsKey(eos[0].Id));
	}

	@isTest static void test_Criticalize(){
		initTestData();
		ConnectorRelatedList c = new ConnectorRelatedList(new ApexPages.StandardController(opp));
		c.critical = true;
	Test.startTest();
		c.Criticalize();
		c.selectedConnectorId = eos[19].Id;
		c.Criticalize();
	Test.stopTest();
		Map<Id, Extension_Opportunity__c> oMap = new Map<Id, Extension_Opportunity__c>(c.oppConnectors);
		System.assertEquals(true, oMap.get(eos[19].Id).Critical__c);
	}
	private static ConnectorRelatedList initTestDataForAddConnectors(String stageName){
		initTestData();
		opp.Forecast__c = 'Closed';
		opp.StageName = stageName;
		opp.If_Closed_Lost_Primary_Reason__c = 'reason';
		opp.Multi_Year_Deal__c = 'yes';
		opp.If_yes_Year_X_of_Total_Years__c = '1';
		
		update opp;
		opp = [SELECT ExpectedRevenue, Amount, IsWon, IsClosed FROM Opportunity WHERE Id = :opp.Id ];
		ConnectorRelatedList c = new ConnectorRelatedList(new ApexPages.StandardController(opp));
		c.selectedConnectors = new List<Id>{es[0].Id, es[1].Id};
		return c;

	}

	private static List<Extension_Opportunity__c> getAndVerifyNewEOs(){
		List<Extension_Opportunity__c> neweos = [SELECT Extension__c, Opportunity__c, ExpectedRevenue__c, 
			BookedRevenue__c, LostRevenue__c, Status__c FROM Extension_Opportunity__c
			WHERE id not in :eos];
		System.assertEquals(2, neweos.size());
		for(Extension_Opportunity__c eo : neweos){
			System.assert(eo.Extension__c == es[0].Id || eo.Extension__c == es[1].Id);
			System.assertEquals(opp.Id, eo.Opportunity__c);
			Integer numOfNonZero = 
         		(eo.ExpectedRevenue__c == 0 ? 0 : 1) +
         		(eo.BookedRevenue__c == 0 ? 0 : 1) +
         		(eo.LostRevenue__c == 0 ? 0 : 1);
         	System.assertEquals(1, numOfNonZero);
		}
		return neweos;
	}

	@isTest static void test_AddConnectors_Win(){
		ConnectorRelatedList c = initTestDataForAddConnectors('Closed Won');
	Test.startTest();
		c.AddConnectors();
	Test.stopTest();
		List<Extension_Opportunity__c> neweos = getAndVerifyNewEOs();
		for(Extension_Opportunity__c eo : neweos){
			System.assertEquals('Won', eo.Status__c);
			System.assertEquals(opp.Amount, eo.BookedRevenue__c);
		}
    }

    @isTest static void test_AddConnectors_Lost(){
		ConnectorRelatedList c = initTestDataForAddConnectors('Closed Lost');
	Test.startTest();
		c.AddConnectors();
	Test.stopTest();
		List<Extension_Opportunity__c> neweos = getAndVerifyNewEOs();
		for(Extension_Opportunity__c eo : neweos){
			System.assertEquals('Lost', eo.Status__c);
			System.assertEquals(opp.Amount, eo.LostRevenue__c);
		}
    }

    @isTest static void test_AddConnectors_InProgress(){
		ConnectorRelatedList c = initTestDataForAddConnectors('Negotiation');
	Test.startTest();
		c.AddConnectors();
	Test.stopTest();
		List<Extension_Opportunity__c> neweos = getAndVerifyNewEOs();
		for(Extension_Opportunity__c eo : neweos){
			System.assertEquals('In Progress', eo.Status__c);
			System.assertEquals(opp.ExpectedRevenue, eo.ExpectedRevenue__c);
		}
    }

    @isTest static void test_AddConnectors_NoData(){
		initTestData();
		ConnectorRelatedList c = new ConnectorRelatedList(new ApexPages.StandardController(opp));
	Test.startTest();
		c.AddConnectors();
	Test.stopTest();
		System.assertEquals(20, c.oppConnectors.size());
    }

    @isTest static void test_Popup(){
    	initTestData();
		ConnectorRelatedList c = new ConnectorRelatedList(new ApexPages.StandardController(opp));
	Test.startTest();
		c.closePopup();
		Boolean b1 = c.displayPopup;
		c.showPopup();
		Boolean b2 = c.displayPopup;
	Test.stopTest();
		System.assert(!b1);
		System.assert(b2);
    }
}