@isTest
public class CMsApprovalComponentTest {
    
    @isTest
    static void testApprovals(){
        CMsTriggerRunCounter.skipAccountTrigger = true;    
      	CMsTriggerRunCounter.skipSubscriptionTrigger = true;
      	CMsTriggerRunCounter.skipQuoteTrigger = true;
        
        User testUser = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-SC Lead', true);
        System.runAs(testUser){
            Account acct = TestDataFactory.createAccounts(1, true, null)[0];
            Opportunity testOpp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acct.Id })[0];        
            SBQQ__Quote__c testQuote = TestDataFactory.createQuote(1, true, new Map<String, Object>{ 'SBQQ__Opportunity2__c' => testOpp.Id})[0];

            // add approver
            sbaa__Approver__c myApprover = new sbaa__Approver__c(sbaa__User__c=testUser.Id );
            insert myApprover;
    
            // create an approval and attach it to the quote
            sbaa__Approval__c myApproval = new sbaa__Approval__c(Quote__c = testQuote.id,sbaa__Opportunity__c = testOpp .Id, sbaa__Approver__c = myApprover.Id  );
            // required fields sbaa__ApprovalStep__c, sbaa__RecordField__c
            myApproval.sbaa__ApprovalStep__c = 1;
            myApproval.sbaa__RecordField__c = 'Quote__c';
            insert myApproval;                    
        
	        CMsApprovalComponent customApproval = new CMsApprovalComponent();
            customApproval.getAllApprovals();
        }
    }
}