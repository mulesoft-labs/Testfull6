@isTest
private class QuoteHandler_Test {


    /*
    private static testMethod void test() {
        Account objAccount = new Account(Name = 'Test Account', BillingCity = 'New York', BillingCountry = 'USA', BillingPostalCode='10001');
        insert objAccount;
        List<Product2> lstProduct2 = new List<Product2>{    new Product2(Name = 'TRAINING: Flexible Training Credit Bundle', ProductCode = 'TCFlexBundle', Category__c = 'Training',
                                                                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Premium Platform Support', ProductCode = 'PremPlatSupp', Category__c = 'Subscription',
                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Pre-Production Subscription - Gold (per Core)', ProductCode = 'PremPlatSupp',
                         Category__c = 'Subscription', Family = 'ESB', CurrencyIsoCode = 'USD')
            };
                insert lstProduct2;
        Id bussinessRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard / New Business').getRecordTypeId();
        Opportunity objOpportunity = new Opportunity(Name='New Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                     Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                     RecordTypeId = bussinessRecordTypeId, AccountId = objAccount.Id);
        insert objOpportunity;

        Id MulesoftRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        SBQQ__Quote__c objQuote = new SBQQ__Quote__c(RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = objOpportunity.Id,
                                                     Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert objQuote;

        List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000,
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1,
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000,
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1,
                                       SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLine;

        objOpportunity.SBQQ__Contracted__c = true;
        update objOpportunity;

        test.startTest();
        Id renewRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Opportunity').getRecordTypeId();



        Contract objContract = new Contract(SBQQ__Opportunity__c = objOpportunity.Id,SBQQ__Quote__c = objQuote.Id, AccountId = objAccount.Id,
                                            SBQQ__RenewalOpportunityRecordTypeId__c = renewRecordTypeId, SBQQ__RenewalOpportunityStage__c = '0. Sales Qualified Lead');
        insert objContract;

        Opportunity renewOpportunity = new Opportunity(Name='ReNew Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                       Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                       RecordTypeId = renewRecordTypeId, AccountId = objAccount.Id, SBQQ__RenewedContract__c = objContract.Id);
        insert renewOpportunity;

        SBQQ__Quote__c renweQuote = new SBQQ__Quote__c(RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = renewOpportunity.Id,
                                                       Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert renweQuote;

        List<SBQQ__QuoteLine__c> lstQuoteLineRenew = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000,
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1,
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000,
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1,
                                       SBQQ__Number__c = 100, Training_Net_Total__c= 500,Category__c = 'Subscription')
                };
                    insert lstQuoteLineRenew;

        test.stopTest();

    }
    */

    public static testmethod void testQuoteLineHandler(){
        Profile pf= [Select Id from profile where Name='System Administrator'];
        User u = new User(
                ProfileId = pf.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
        );
        insert u;
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        acc.BillingStreet ='77 Geary Street';
        acc.BillingCity = 'San Francisco';
        acc.BillingState ='CA';
        acc.BillingPostalCode = '94108';

        insert acc;

        Agreement__c agreement = new Agreement__c();
        agreement.Name = 'sample';
        agreement.Account__c = acc.id;
        agreement.Expiration_Date__c = system.Date.today() + 1;
        insert agreement;



        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
                BillingPostalCode = '94108'
        );

        insert testAcc;

        Agreement__c agreement2 = new Agreement__c();
        agreement2.Name = 'sample2';
        agreement2.Account__c = testAcc.id;
        agreement2.RecordTypeId = Schema.SObjectType.Agreement__c.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        agreement.Expiration_Date__c = system.Date.today() + 1;

        insert agreement2;
        testAcc.MSA_Lookup__c = agreement2.id;
        testAcc.MPA_Lookup__c = agreement2.id;
        testAcc.PSA_Lookup__c = agreement2.id;
        update testAcc;
        Contract testContract = new Contract(accountId  = testAcc.Id,
                Status = 'Draft');
        insert testContract;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Enterprise Direct',
                Amount = 123,
                SBQQ__RenewedContract__c = testContract.Id);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link',
                SBQQ__Account__c = testAcc.id,
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

        SBQQ__QuoteLine__c platSubQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = platSubProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));

        test.startTest();
        insert platSubQL;
        test.stopTest();
    }

    public static testmethod void testQuoteLineHandler2(){
        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',
                BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
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
                SBQQ__Account__c = testAcc.id,
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

        SBQQ__QuoteLine__c platSubQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = platSubProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));

        test.startTest();
        insert platSubQL;
        test.stopTest();
    }

    public static testmethod void testQuoteLineHandler3(){
        Profile pf= [Select Id from profile where Name='System Administrator'];
        User u = new User(
                ProfileId = pf.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
        );
        insert u;
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        acc.BillingStreet ='77 Geary Street';
        acc.BillingCity = 'San Francisco';
        acc.BillingState ='CA';
        acc.BillingPostalCode = '94108';
        insert acc;

        Agreement__c agreement = new Agreement__c();
        agreement.Name = 'sample';
        agreement.Account__c = acc.id;
        agreement.Expiration_Date__c = system.Date.today() + 1;
        insert agreement;



        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
                BillingPostalCode = '94108'
        );

        insert testAcc;

        Agreement__c agreement2 = new Agreement__c();
        agreement2.Name = 'sample2';
        agreement2.Account__c = testAcc.id;
        agreement2.Pass_Through_Terms__c = 'MSA';
        agreement2.RecordTypeId = Schema.SObjectType.Agreement__c.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        agreement.Expiration_Date__c = system.Date.today() + 1;

        insert agreement2;
        testAcc.MSA_Lookup__c = agreement2.id;
        testAcc.MPA_Lookup__c = agreement2.id;
        testAcc.PSA_Lookup__c = agreement2.id;
        update testAcc;
        Contract testContract = new Contract(accountId  = testAcc.Id,
                Status = 'Draft');
        insert testContract;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Enterprise Partner (VAR)',
                Amount = 123,
                SBQQ__RenewedContract__c = testContract.Id);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link',
                Partner_Account__c = testAcc.id,
                SBQQ__Account__c = testAcc.id,
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

        SBQQ__QuoteLine__c platSubQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = platSubProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));

        test.startTest();
        insert platSubQL;
        test.stopTest();
    }

    public static testmethod void testQuoteLineHandler4(){
        Profile pf= [Select Id from profile where Name='System Administrator'];
        User u = new User(
                ProfileId = pf.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
        );
        insert u;
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        acc.BillingStreet ='77 Geary Street';
        acc.BillingCity = 'San Francisco';
        acc.BillingState ='CA';
        acc.BillingPostalCode = '94108';
        insert acc;

        Agreement__c agreement = new Agreement__c();
        agreement.Name = 'sample';
        agreement.Account__c = acc.id;
        agreement.Expiration_Date__c = system.Date.today() + 1;
        insert agreement;



        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
                BillingPostalCode = '94108'
        );

        insert testAcc;

        Agreement__c agreement2 = new Agreement__c();
        agreement2.Name = 'sample2';
        agreement2.Account__c = testAcc.id;
        agreement2.Pass_Through_Terms__c = 'EULA';
        agreement2.RecordTypeId = Schema.SObjectType.Agreement__c.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        agreement.Expiration_Date__c = system.Date.today() + 1;

        insert agreement2;
        testAcc.MSA_Lookup__c = agreement2.id;
        testAcc.MPA_Lookup__c = agreement2.id;
        testAcc.PSA_Lookup__c = agreement2.id;
        update testAcc;
        Contract testContract = new Contract(accountId  = testAcc.Id,
                Status = 'Draft');
        insert testContract;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Enterprise Partner (VAR)',
                Amount = 123,
                SBQQ__RenewedContract__c = testContract.Id);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link',
                Partner_Account__c = testAcc.id,
                SBQQ__Account__c = testAcc.id,
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

        SBQQ__QuoteLine__c platSubQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = platSubProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));

        test.startTest();
        insert platSubQL;
        test.stopTest();
    }

    public static testmethod void testQuoteLineHandler5(){
        Profile pf= [Select Id from profile where Name='System Administrator'];
        User u = new User(
                ProfileId = pf.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
        );
        insert u;
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        acc.BillingStreet ='77 Geary Street';
        acc.BillingCity = 'San Francisco';
        acc.BillingState ='CA';
        acc.BillingPostalCode = '94108';
        insert acc;

        Agreement__c agreement = new Agreement__c();
        agreement.Name = 'sample';
        agreement.Account__c = acc.id;
        agreement.Expiration_Date__c = system.Date.today() + 1;
        insert agreement;



        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
                BillingPostalCode = '94108'
        );

        insert testAcc;

        Agreement__c agreement2 = new Agreement__c();
        agreement2.Name = 'sample2';
        agreement2.Account__c = testAcc.id;
        agreement2.Pass_Through_Terms__c = 'MSA';
        agreement2.RecordTypeId = Schema.SObjectType.Agreement__c.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        agreement.Expiration_Date__c = system.Date.today() + 1;

        insert agreement2;
        testAcc.MSA_Lookup__c = agreement2.id;
        testAcc.MPA_Lookup__c = agreement2.id;
        testAcc.PSA_Lookup__c = agreement2.id;
        update testAcc;
        Contract testContract = new Contract(accountId  = testAcc.Id,
                Status = 'Draft');
        insert testContract;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Distributor',
                Amount = 123,
                SBQQ__RenewedContract__c = testContract.Id);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link',
                Partner_Account__c = testAcc.id,
                SBQQ__Account__c = testAcc.id,
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

        SBQQ__QuoteLine__c platSubQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = platSubProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));

        test.startTest();
        insert platSubQL;
        test.stopTest();
    }

    public static testmethod void testQuoteLineHandler7(){
        Profile pf= [Select Id from profile where Name='System Administrator'];
        User u = new User(
                ProfileId = pf.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
        );
        insert u;
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        acc.BillingStreet ='77 Geary Street';
        acc.BillingCity = 'San Francisco';
        acc.BillingState ='CA';
        acc.BillingPostalCode = '94108';
        insert acc;

        Agreement__c agreement = new Agreement__c();
        agreement.Name = 'sample';
        agreement.Account__c = acc.id;
        agreement.Expiration_Date__c = system.Date.today() + 1;
        insert agreement;



        Account testAcc =  new Account(Name = 'testAcc',
                BillingCountry = 'America',
                CurrencyIsoCode = 'USD',BillingStreet ='77 Geary Street', BillingCity = 'San Francisco',BillingState ='CA',
                BillingPostalCode = '94108'
        );

        insert testAcc;

        Agreement__c agreement2 = new Agreement__c();
        agreement2.Name = 'sample2';
        agreement2.Account__c = testAcc.id;
        agreement2.Pass_Through_Terms__c = 'EULA';
        agreement2.RecordTypeId = Schema.SObjectType.Agreement__c.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        agreement.Expiration_Date__c = system.Date.today() + 1;

        insert agreement2;
        testAcc.MSA_Lookup__c = agreement2.id;
        testAcc.MPA_Lookup__c = agreement2.id;
        testAcc.PSA_Lookup__c = agreement2.id;
        update testAcc;
        Contract testContract = new Contract(accountId  = testAcc.Id,
                Status = 'Draft');
        insert testContract;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Distributor',
                Amount = 123,
                SBQQ__RenewedContract__c = testContract.Id);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link',
                Partner_Account__c = testAcc.id,
                SBQQ__Account__c = testAcc.id,
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

        SBQQ__QuoteLine__c platSubQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = platSubProduct.Id,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = Date.newInstance(2016, 6, 30),
                SBQQ__EndDate__c = Date.newInstance(2017, 6, 29));

        test.startTest();
        insert platSubQL;
        test.stopTest();
    }
    public static testmethod void testQuotePushToNetsuite(){
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        insert acc;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Enterprise Direct',
                Amount = 123);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                SBQQ__Account__c = acc.id,
                RenewalRecalculated__c = False,
                Push_to_NetSuite__c = false,
                SBQQ__Status__c = 'Approved ');
        insert testQuote;

        testQuote.Push_to_NetSuite__c = true;

        test.startTest();
        update testQuote;
        test.stopTest();

        List<Opportunity> opps =  [SELECT Quote_Pushed_to_Netsuite__c FROM Opportunity WHERE Id = :testOpp.Id];
        System.assertEquals(1, opps.size());
        System.assertEquals(testQuote.Id, opps[0].Quote_Pushed_to_Netsuite__c);

    }
    /*@TestSetup
    public static void testSetup(){
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
    }    */    
    
    public static testmethod void testCheckCreditAutomation(){      
        
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        insert acc;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Enterprise Direct',
                Amount = 123);
        insert testOpp;
        
        /*
        Account acc = [SELECT Id,Name FROM Account limit 1];
        Opportunity testOpp = [SELECT Id,Name FROM Opportunity Limit 1];
        */
        
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                SBQQ__Account__c = acc.id,
                RenewalRecalculated__c = False,
                Push_to_NetSuite__c = false,
                SBQQ__Status__c = 'Approved ',
                Credit_Added__c = false,
                Upgrade_Credit_Terms_v2__c = false);
                    
        Test.startTest();        
        try{
            insert testQuote;
        }
        catch(Exception ex) {

        }

        try{
            testQuote.Upgrade_Credit_Terms_v2__c = true;
            testQuote.Credit_Amount__c = 5000;
            update testQuote;
        }
        catch(Exception ex) {

        }
        
        
        Test.stopTest();
        
        /*
        Account acc1 = [select Id, Name from Account limit 1];
        Opportunity testOpp = [SELECT Id, Sales_Channel__c FROM Opportunity Limit 1];
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                SBQQ__Account__c = acc1.id,
                RenewalRecalculated__c = False,
                Push_to_NetSuite__c = false,
                SBQQ__Status__c = 'Approved ',
                Credit_Added__c = false,
                Credit_Amount__c = 100,
                Upgrade_Credit_Terms_v2__c = true);       
        insert testQuote;


        testQuote.Credit_Added__c = true;
        testQuote.Credit_Amount__c = 200;
        try{
            test.startTest();
            update testQuote;
            test.stopTest();
        }
        catch(Exception ex) {

        }
        */
    }
    
    public static testmethod void testUpdateCreditAutomation(){      
        
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        insert acc;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Enterprise Direct',
                Amount = 123);
        insert testOpp;
        
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                SBQQ__Account__c = acc.id,
                RenewalRecalculated__c = False,
                Push_to_NetSuite__c = false,
                SBQQ__Status__c = 'Approved ',
                Credit_Added__c = true,
                Upgrade_Credit_Terms_v2__c = true,
                Credit_Amount__c = 5000);
                
        
                    
        Test.startTest();        
        try{
            insert testQuote;
            
            SBQQ__QuoteLine__c subQL = new SBQQ__QuoteLine__c(SBQQ__Product__c = System.Label.Credit,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__StartDate__c = System.Today().addDays(-2),
                SBQQ__EndDate__c = System.Today().addDays(200));
                
            insert subQL;   
        }
        catch(Exception ex) {

        }
        try{
            testQuote.Credit_Amount__c = 8000;
            update testQuote;
        }
        catch(Exception ex) {

        }
        
        
        Test.stopTest();
    }

    public static testmethod void testDeleteQuote(){
        Account acc = new Account();
        acc.Name ='Name';
        acc.BillingCountry = 'US';
        insert acc;
        Opportunity testOpp = new Opportunity(Name = 'testOpp',
                Type = 'New Business',
                CurrencyIsoCode = 'USD',
                CloseDate = Date.newInstance(2017, 6, 30),
                StageName = 'Sales Qualified Lead',
                Sales_Channel__c = 'Enterprise Direct',
                Amount = 123);
        insert testOpp;
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.Id,
                SBQQ__Account__c = acc.id,
                RenewalRecalculated__c = False,
                Push_to_NetSuite__c = false,
                SBQQ__Status__c = 'Approved ');
        insert testQuote;

        test.startTest();
        delete testQuote;
        test.stopTest();
    }
}