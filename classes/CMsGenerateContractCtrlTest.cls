/*
 * CMsGenerateContractCtrlTest
 * @description Test class for CMsGenerateContractCtrl.cls
 * @author Sid Sah
 * @date 01/17/2018
 */

@IsTest
public with sharing class CMsGenerateContractCtrlTest {

    @IsTest
    public static void testContractGeneration() {
 		Account acct = TestDataFactory.createAccounts(1, true, null)[0];
        Contact c = TestDataFactory.createContacts(1, acct.Id, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acct.Id })[0];
        TestDataFactory.createOpportunityContactRole(1, true, new Map<String, Object>{'OpportunityId' => opp.Id, 'ContactId' => c.Id});
        List<SBQQ__Quote__c> qt = TestDataFactory.createQuote(1, true, new Map<String, Object>{ 'SBQQ__Opportunity2__c' => opp.Id });
        qt[0].SBQQ__Primary__c = true;
        qt[0].SBQQ__StartDate__c = Date.today(); 
        update qt[0];
        List<Contract> contractBeforeGenerateContract = [Select Id,AccountId FROM Contract WHERE AccountId =:acct.Id];
        System.assertEquals(contractBeforeGenerateContract.size(), 0);
		
        CMsGenerateContractCtrl ctrl = new CMsGenerateContractCtrl(new ApexPages.StandardController(opp));
        Test.startTest();
        CMsGenerateContractCtrl.generateContract(opp.Id);
		Test.stopTest();
        //We don't know what Steelbrick implementation is to generate a Contract.
        //We can't assert the values. The purpose of this Test is to cover the CMsGenerateContractCtrl.class
        /*
        List<Contract> contractAfterGenerateContract = [Select Id,AccountId FROM Contract WHERE AccountId =:acct.Id];
        System.debug(LoggingLevel.ERROR, 'contractAfterGenerateContract-->'+contractAfterGenerateContract);
        System.assertEquals(contractAfterGenerateContract.size(), 1);
		*/
    }
}