@isTest
public class ApprovalAfterUpdateTest {
    static testMethod void testApprovalAfterUpdate(){
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingCountry = 'US';
        insert a;

        Opportunity o = new Opportunity();
        o.Name = 'TestOpportunity';
        o.AccountId = a.id;
        o.CloseDate = Date.today();
        o.StageName = 'Sales Qualified Lead';
        o.CurrencyIsoCode = 'USD';
        o.Type = 'New Business';
        o.Amount=1000;
        o.NextStep='Discovery Call';
        o.Opportunity_Source__c ='Direct';
        o.Primary_Solution_Interest__c = 'SOA';
        insert o;

        Id quoteRecTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.RecordTypeId = quoteRecTypeId;
        insert q;
        Id pricebookId = Test.getStandardPricebookId();
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;

        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = q.Id;
        qli.SBQQ__Product__c = prod.Id;
        insert qli;

        sbaa__ApprovalRule__c apprule = new sbaa__ApprovalRule__c();
        apprule.Name = 'Test rule';
        apprule.sbaa__TargetObject__c = 'SBQQ__Quote__c';
        apprule.sbaa__ConditionsMet__c = 'Any';
        apprule.sbaa__Active__c = true;
        insert apprule;


        sbaa__Approval__c approval10 = new sbaa__Approval__c();
        approval10.sbaa__Opportunity__c = o.id;
        approval10.Quote__c = q.Id;
        approval10.sbaa__ApprovalStep__c = 1;
        approval10.sbaa__RecordField__c = 'Quote__c';
        approval10.sbaa__CommentsLong__c = 'comments ';
        approval10.sbaa__Archived__c = True;
        approval10.sbaa__Rule__c = apprule.Id;
        insert approval10;
        sbaa__Approval__c approval0 = new sbaa__Approval__c();
        approval0.sbaa__Opportunity__c = o.id;
        approval0.Quote__c = q.Id;
        approval0.sbaa__ApprovalStep__c = 1;
        approval0.sbaa__RecordField__c = 'Quote__c';
        approval0.sbaa__CommentsLong__c = 'comments ';
        approval0.sbaa__Archived__c = True;
        approval0.sbaa__Rule__c = apprule.Id;
        insert approval0;

        sbaa__Approval__c approval00 = new sbaa__Approval__c();
        approval00.sbaa__Opportunity__c = o.id;
        approval00.Quote__c = q.Id;
        approval00.sbaa__ApprovalStep__c = 1;
        approval00.sbaa__RecordField__c = 'Quote__c';
        approval00.sbaa__CommentsLong__c = 'comments ';
        approval00.sbaa__Archived__c = True;
        insert approval00;


        List<sbaa__Approval__c> lstApp = new List<sbaa__Approval__c>();

        sbaa__Approval__c approval = new sbaa__Approval__c();
        approval.sbaa__Opportunity__c = o.id;
        approval.Quote__c = q.Id;
        approval.sbaa__ApprovalStep__c = 1;
        approval.sbaa__RecordField__c = 'Quote__c';

        lstApp.add(approval);
        sbaa__Approval__c approval2 = new sbaa__Approval__c();
        approval2.sbaa__Opportunity__c = o.id;
        approval2.Quote__c = q.Id;
        approval2.sbaa__ApprovalStep__c = 2;
        approval2.sbaa__RecordField__c = 'Quote__c';
        approval2.sbaa__Archived__c = false;
        lstApp.add(approval2);

        insert lstApp;

    }
}