@isTest
public class getApprovalTableTest {
    static testMethod void testgetApprovalTable(){
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
        //q.SBQQ__Opportunity__c = o.id;
        q.SBQQ__Opportunity2__c = o.id; // required since Winter 16
        q.RecordTypeId = quoteRecTypeId;
        insert q;
        
        Profile p = [select id FROM Profile WHERE Name ='System Administrator'];
        User user1 = new User();
        user1.Username = 'us1xx@test.com'; // may need to modify,must be unique per org
        user1.Email = 'us1@test.com';
        user1.LastName = 'LastName1';
        user1.FirstName = 'FirstName1';
        user1.Alias ='u1';
        user1.CommunityNickname ='use1';
        user1.ProfileId =p.id;
        user1.EmailEncodingKey='UTF-8';
        user1.LanguageLocaleKey='en_US';
        user1.LocaleSidKey='en_US';
        user1.TimeZoneSidKey='America/Los_Angeles';
        user1.Country = 'US';
        user1.Title = 'Territory Manager';
        insert user1;
        
        sbaa__Approver__c aprover = new sbaa__Approver__c();
        aprover.Name = 'Sales Ops';
        aprover.sbaa__User__c = user1.Id;
        insert aprover;
        
        sbaa__Approval__c approval2 = new sbaa__Approval__c();
        approval2.sbaa__Opportunity__c = o.id;
        approval2.Quote__c = q.Id;
        approval2.sbaa__ApprovalStep__c = 2;
        approval2.sbaa__RecordField__c = 'Quote__c';
        approval2.sbaa__Archived__c = false;
        approval2.sbaa__Approver__c = aprover.Id;
        insert approval2;
        
        getApprovalTable ctrl = new getApprovalTable();
        ctrl.quoteId = q.Id;
        ctrl.field_set_name = 'sbaa__RequestFields';
        ctrl.getFields();
        
    }
}