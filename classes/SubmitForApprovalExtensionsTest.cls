@isTest
private class SubmitForApprovalExtensionsTest {

    static testMethod void testSubmitForApproval(){
        Account acc = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acc.Id })[0];
		//opp.StageName = ConstantDeclarations.OPP_STAGE_5_PERCENT;
		opp.StageName = ConstantDeclarations.OPP_STAGE_10_PERCENT;
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        //opp.What_is_the_business_need_initiative__c = 'test';
        opp.Follow_on_meeting_scheduled__c = true;
        update opp;
		Test.startTest();
        	Test.setCurrentPage( Page.SubmitForApproval );
        	Apexpages.StandardController controller = new Apexpages.StandardController( opp );
        	SubmitForApprovalExtensions extController = new SubmitForApprovalExtensions( controller );
        	extController.getFieldSetNameToFieldsMap();
        	extController.saveOpportunity();
        	extController.submitForApproval();
        	extController.submitPage();
        	extController.backToOpportunity();
        Test.stopTest();
    }
}