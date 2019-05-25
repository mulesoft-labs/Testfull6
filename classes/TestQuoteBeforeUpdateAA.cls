@isTest
public class TestQuoteBeforeUpdateAA {
    static testMethod void testQuoteUpdate(){
   
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingCountry = 'US';
        insert a;

        Opportunity o = new Opportunity();
        o.Name = 'TestOpportunity';
        o.AccountId = a.id;
        o.CloseDate = Date.today();
        o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        o.CurrencyIsoCode = 'USD';
        o.Type = 'New Business';
        o.Amount=1000;
        o.NextStep='Discovery Call';
        o.Opportunity_Source__c ='Direct';
        o.Primary_Solution_Interest__c = 'SOA';
        
        insert o;

        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        try {
         insert q;
        } catch(Exception e){
            System.Assert(false,'TestQuoteBeforeUpdateAA: insert e = '+ e);
        }

        q.Special_Terms__c = 'Test Terms';
        try {
           update q;
        }
        catch(Exception e){
            System.Assert(false,'TestQuoteBeforeUpdateAA: update e = '+ e);
        }
    }
}