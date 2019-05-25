/*
 * CMsCreateTrainingOrderCtrlTest
 * @description Test class for CMsCreateTrainingOrderCtrl.cls
 * @author Sid Sah
 * @date 06/19/2018
 */

@IsTest
public with sharing class CMsCreateTrainingOrderCtrlTest {

	@IsTest
	public static void testTrainingOrderCreation() {

		User testUser =  TestDataFactory.createUser('System Administrator','APAC-Sales-ASIA-ASIA-RVP',false);
		testUser.Validation_Override__c  = true;
		insert testUser;
		System.RunAs(testUser){

			Account acct = TestDataFactory.createAccounts(1, true, null)[0];
			List<Opportunity> oppList = [Select Id,AccountId FROM Opportunity WHERE AccountId =:acct.Id];
			System.assertEquals(oppList.size(), 0);

			CMsCreateTrainingOrderCtrl ctrl = new CMsCreateTrainingOrderCtrl(new ApexPages.StandardController(acct));
			Test.startTest();
			CMsCreateTrainingOrderCtrl.generateOnlineTrainingOrders(acct.Id);
			Test.stopTest();


			///Validate Online Training Opportunity is created
			List<Opportunity> oppResult = [SELECT Id,AccountId,name,Type,Forecast__c,Sales_Channel__c,closeDate,
					Opportunity_Source__c,SFDC_New_and_Add_On_ACV__c,Multi_Year_Deal__c, stageName
			FROM Opportunity WHERE AccountId =:acct.Id];
			System.assertEquals(oppResult.size(), 1);
			System.assertEquals(oppResult[0].Name, 'Test Vendor 0 - Online Training - [Add Contact Name]');
			System.assertEquals(oppResult[0].Type, 'New Business');
			System.assertEquals(oppResult[0].Forecast__c, 'Likely');
			System.assertEquals(oppResult[0].Sales_Channel__c, 'Self-Service');
			System.assertEquals(oppResult[0].Opportunity_Source__c, 'Direct');
			System.assertEquals(oppResult[0].SFDC_New_and_Add_On_ACV__c, 0.0);
			System.assertEquals(oppResult[0].Multi_Year_Deal__c, 'no');
			System.assertEquals(oppResult[0].stageName, ConstantDeclarations.OPP_STAGE_NEGOTIATE_CLOSE);

			///Validate Online Training Quote is created
			List<SBQQ__Quote__c> quoteResult = [Select Id,SBQQ__Account__c,SBQQ__StartDate__c, SBQQ__Primary__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c =:oppResult[0].Id];
			System.assertEquals(quoteResult.size(), 1);
			System.assertEquals(quoteResult[0].SBQQ__Primary__c, true);
			System.assertEquals(quoteResult[0].SBQQ__Account__c, acct.Id);
			System.assertEquals(quoteResult[0].SBQQ__StartDate__c, oppResult[0].closeDate);

		}

	}
}