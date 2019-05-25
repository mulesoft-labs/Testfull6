/**
 *    Description: Controller class to get list of Quote related Approvals.
 *    Version        Author            Date            Description
 *  
 *    1.0            Team Simplus      07/13/2017      Created test class for uoteApproversController class.
 *    2.0            Team Simplus      08/02/2017      updated test class
 **/
@isTest
private class QuoteApproversControllerTest{
    
    // This method creates records required for functionality
    public static void cretateRecords(Integer approverNo, Integer approvalNo){
        //create account record
        Account acount = new Account(Name='TestAccount',
                                     CurrencyIsoCode='USD',
                                     BillingCountry = 'Test');
        insert acount;
        
        //getting opportunity record type id
        String OppRecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Standard / New Business').getRecordTypeId();

        //create opportunity record
        Opportunity opp = new Opportunity(AccountId = acount.id,
                                          Name='TestOpportunity',
                                          Type = 'New Business',
                                          CurrencyIsoCode = 'USD',
                                          CloseDate = system.today(),
                                          StageName = '0. Sales Qualified Lead');
        insert opp;
        //getting quote record type id
        Id quoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        
        //create quote record
        SBQQ__Quote__c quote = new SBQQ__Quote__c(Legal_Link_or_MSA__c = 'Legal Link',
                                                 SBQQ__Opportunity2__c = opp.id,                                                
                                                 SBQQ__Account__c = acount.id,
                                                 ApprovalStatus__c = 'Draft');
        insert quote;
        
        //create approval rule record
        sbaa__ApprovalRule__c approvalRule = new  sbaa__ApprovalRule__c(Name='TestRule',
                                                                        sbaa__TargetObject__c = 'Opportunity');
        insert approvalRule ;
        
        //create approver record
        list<sbaa__Approver__c> approverList = new list<sbaa__Approver__c>();
        for(Integer i=0;i<approverNo;i++){            
            approverList.add(new sbaa__Approver__c(name='Test-Approver'+i));
        }
        insert approverList;
         
        //create approval record
        list<sbaa__Approval__c> approvalList = new list<sbaa__Approval__c>();
        for(Integer i=0;i<approvalNo;i++){            
            approvalList.add(new sbaa__Approval__c(sbaa__Approver__c = approverList[i].Id,
                                                   Approval_Requested_For__c = 'Product Discounts',
                                                   sbaa__Status__c = 'Requested',
                                                   sbaa__CommentsLong__c = '',
                                                   Comment_History__c = '',
                                                   sbaa__RecordField__c='Quote',
                                                   sbaa__ApprovalStep__c = 1,
                                                   Quote__c = quote.Id));
        }    
        insert approvalList;
        
    }
    
    // This method Verify Quotes with single Approval
    static testMethod void verifyQuoteApprovers(){
        cretateRecords(1,1);       
        SBQQ__Quote__c quote = [Select Id From SBQQ__Quote__c];  
        map<sbaa__Approval__c, list<String>> ApprovalMap = new map<sbaa__Approval__c, list<String>>();
        Test.startTest();   
            QuoteApproverController qacontroller = new QuoteApproverController();
            qacontroller.setQuoteId(quote.Id);
            String quoteRecId = qacontroller.getQuoteId();
            ApprovalMap =  qacontroller.quoteApprovals(quote.Id);
        Test.stopTest();
        system.assertEquals(qacontroller.approverMap.size(), ApprovalMap.size());
    }
    
    // This method Verify Quotes with multiple Approval
    static testMethod void verifyMultipleQuoteApprovers(){
        cretateRecords(5,5);       
        SBQQ__Quote__c quote = [Select Id From SBQQ__Quote__c]; 
        map<sbaa__Approval__c, list<String>> ApprovalMap = new map<sbaa__Approval__c, list<String>>();
        Test.startTest();        
            QuoteApproverController qacontroller = new QuoteApproverController();
            qacontroller.setQuoteId(quote.Id);
            String quoteRecId = qacontroller.getQuoteId();
            ApprovalMap =  qacontroller.quoteApprovals(quote.Id);
        Test.stopTest();
        system.assertEquals(qacontroller.approverMap.size(), ApprovalMap.size());
    }
    
    // This method Verify Quotes with no Approvals
    static testMethod void verifyNullQuoteApprovers(){
        cretateRecords(1,1);       
        SBQQ__Quote__c quote = [Select Id From SBQQ__Quote__c];
        map<sbaa__Approval__c, list<String>> ApprovalMap = new map<sbaa__Approval__c, list<String>>();
        Test.startTest();
            QuoteApproverController qacontroller = new QuoteApproverController();
            qacontroller.setQuoteId(null);
            String quoteRecId = qacontroller.getQuoteId();
            ApprovalMap =  qacontroller.quoteApprovals(quoteRecId);
        Test.stopTest();
        system.assertEquals(0, ApprovalMap.size());
    }    
    
    // This method Verify Quotes with mpst recent updated Approvals
    // [2.0]
    static testMethod void verifyRecentQuoteApprovers(){
        cretateRecords(5,5);       
        map<sbaa__Approval__c, list<String>> ApprovalMap = new map<sbaa__Approval__c, list<String>>();
        SBQQ__Quote__c quote = [Select Id From SBQQ__Quote__c];
        list<sbaa__Approval__c> approvalList = [Select Id,sbaa__Approver__c,Approval_Requested_For__c,
                                                       sbaa__Status__c,sbaa__CommentsLong__c,Comment_History__c,
                                                       sbaa__RecordField__c,sbaa__ApprovalStep__c,
                                                       Quote__c
                                                  From sbaa__Approval__c];            
        for(Integer i=0;i<2;i++){            
            approvalList[i].sbaa__Status__c = 'Rejected';
            approvalList[i].sbaa__CommentsLong__c = 'Rejected-Test'+i;
            approvalList[i].Comment_History__c = 'Rejected-History'+i;
        }
        
        update approvalList;
        
        Test.startTest();
            QuoteApproverController qacontroller = new QuoteApproverController();
            qacontroller.setQuoteId(quote.Id);
            String quoteRecId = qacontroller.getQuoteId();
            ApprovalMap =  qacontroller.quoteApprovals(quote.Id);
        Test.stopTest();
        //system.assertEquals(2,qacontroller.approverMap.size());
    }
}