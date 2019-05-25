@isTest
private class CMsPopulatePartnerDetailsOnOppTest{
    static testMethod void createRecords(){
        Account parentAcc = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => parentAcc.Id, 'CloseDate' => Date.today(), 'type' => 'New Business', 'stageName' => '1. ID Business Initiative' })[0];        

        Partner_Influence__c PartnerDetailsObj1 = new Partner_Influence__c();
		PartnerDetailsObj1.Account__c = parentAcc.Id;
		PartnerDetailsObj1.Opportunity__c = opp.Id;
		PartnerDetailsObj1.Sourced__c=true;
		PartnerDetailsObj1.Influence__c=true;
		PartnerDetailsObj1.delivery__c=true;
		PartnerDetailsObj1.reseller__c=true;
        insert PartnerDetailsObj1;
        
        opp.SI_Partner_Account_1__c = null;
        
        update opp;
        
        test.startTest();
        CMsPopulatePartnerDetailsOnOpportunity accsubBatch = new CMsPopulatePartnerDetailsOnOpportunity();
        DataBase.executeBatch(accsubBatch);
        accsubBatch.execute(null);
        test.stopTest();
    }
        
}