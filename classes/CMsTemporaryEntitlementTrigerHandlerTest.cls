@isTest
private class CMsTemporaryEntitlementTrigerHandlerTest {
	
	@testSetup
    public static void testSetupInfo()
    {
        
        Account acc = MuleSoftInf_TestDataUtility.buildAccountRecord();
        acc.Status__c = 'Current';
        insert acc;
        
        
        Contact con = MuleSoftInf_TestDataUtility.buildContactRecord(acc.Id, null);
        insert con;

        Opportunity opp = MuleSoftInf_TestDataUtility.buildOpportunityRecord(acc.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 
                            10, Date.today(), null);
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        insert opp;

        Temporary_Entitlements__c te = new Temporary_Entitlements__c();
        te.Opportunity__c = opp.Id;
        te.Customer_Name__c = con.Id;       
        te.Days_Requested__c = 10;
        te.Start_Date__c = Date.today();
        te.Business_Justification__c = 'test';
        te.Anypoint_Username__c = 'test user';
        insert te;

    }
	
	@isTest 
	static void testHistoryRecordCreation() {
		Temporary_Entitlements__c te = [Select id from Temporary_Entitlements__c];

		Test.startTest();
		te.Last_Approved_Days__c = 10;
		update te;
		Test.stopTest();

		System.assert([Select count() from Temporary_Entitlement_History__c] ==1);
	}
	
}