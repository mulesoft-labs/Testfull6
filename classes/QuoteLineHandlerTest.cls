@isTest
public class QuoteLineHandlerTest{
    public static testmethod void testQuoteLineHandler(){
        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
                BillingPostalCode = '94108');
        insert testAcc;
        Contract testContract = new Contract(accountId  = testAcc.Id,
                Status = 'Draft');
        insert testContract;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Amount = 123,
                SBQQ__RenewedContract__c = testContract.Id);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link',
                RenewalRecalculated__c = False);
        insert testQuote;

        Product2 subProduct = new Product2(Name = 'ActiveMQ - Gold',
                ProductCode = 'PLATINUMSUB',
                CurrencyIsoCode = 'USD',
                Family = 'ESB',
                Category__c = 'Subscription');
        insert subProduct;

        Product2 platSubProduct = new Product2(Name = 'Platinum Subscription',
                ProductCode = 'PLATINUMSUB',
                CurrencyIsoCode = 'USD',
                Family = 'ESB',
                Category__c = 'Subscription');
        insert platSubProduct;

        SBQQ__QuoteLine__c subQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = subProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));
        insert subQL;

        SBQQ__QuoteLine__c platSubQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = platSubProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));

        test.startTest();
        insert platSubQL;
        test.stopTest();
    }
    public static testmethod void testDeleteQuoteLineHandler(){
        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
                BillingPostalCode = '94108');
        insert testAcc;
        Contract testContract = new Contract(accountId  = testAcc.Id,
                Status = 'Draft');
        insert testContract;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Amount = 123,
                SBQQ__RenewedContract__c = testContract.Id);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link',
                RenewalRecalculated__c = False);
        insert testQuote;

        Product2 subProduct = new Product2(Name = 'ActiveMQ - Gold',
                ProductCode = 'ActiveMQ',
                CurrencyIsoCode = 'USD',
                Family = 'ESB',
                Category__c = 'Subscription');
        insert subProduct;

        Product2 platSubProduct = new Product2(Name = 'Platinum Subscription',
                ProductCode = 'PLATINUMSUB',
                CurrencyIsoCode = 'USD',
                Family = 'ESB',
                Category__c = 'Subscription');
        insert platSubProduct;

        SBQQ__QuoteLine__c subQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = subProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));
        insert subQL;


        test.startTest();
        delete subQL;
        test.stopTest();
    }
}