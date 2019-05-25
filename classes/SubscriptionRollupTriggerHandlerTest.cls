@isTest
private class SubscriptionRollupTriggerHandlerTest {
    public static Account acc       {get;set;}
    public static Opportunity opp   {get;set;}
    public static Contract cont     {get;set;}
    public static Contract cont2    {get;set;}
    public static Contract cont3    {get;set;}
    public static Product2 prod     {get;set;}


    @testSetup
    public static void testSetupInfo() {
        acc = new Account();
        acc.Name = 'Test acc';
        acc.BillingCountry = 'USA';
        acc.DiscoverOrg_Industry__c = 'Automotive';
        acc.Customer_Success_Manager_new__c = userInfo.getUserId();
        CMsTriggerRunCounter.skipAccountTrigger = true;
        insert acc;

        opp = new Opportunity();
        opp.Type = 'New Business';
        opp.Name='test';
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();
        opp.StageName = '0. Sales Qualified Lead';
        opp.CurrencyIsoCode = 'USD';
        insert opp;

        cont = new Contract();
        cont.AccountId = acc.Id;
        cont.CurrencyIsoCode = 'USD';
        insert cont;

        cont2 = new Contract();
        cont2.AccountId = acc.Id;
        cont2.CurrencyIsoCode = 'EUR';
        insert cont2;

        cont3 = new Contract();
        cont3.AccountId = acc.Id;
        cont3.CurrencyIsoCode = 'GBP';
        insert cont3;

        prod = new Product2();
        prod.Name='Test prod';
        prod.ProductCode='456789';
        prod.Family ='Advertising';
        //prod.Category='Subscription';
        // prod.Active=true;
        insert prod;
    }

    public static TestMethod void subscriptionLifecycle() {
        testSetupInfo();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'USD';

        Test.startTest();
        insert sub;
        sub.SBQQ__NetPrice__c = 150;
        CMsTriggerRunCounter.skipSubscriptionTrigger = false;
        update sub;
        Test.stopTest();
    }

    public static TestMethod void changeContract() {
        testSetupInfo();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'USD';
        CMsTriggerRunCounter.skipSubscriptionTrigger = true;
        insert sub;
        sub.SBQQ__Contract__c=cont2.Id;//change the contract
        Test.startTest();
        CMsTriggerRunCounter.skipSubscriptionTrigger = false;
        update sub;

        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    System.assertNotEquals(sub.CurrencyIsoCode, contrct.CurrencyISOCode);
                    System.assertEquals(77, contrct.Total_of_Subscriptions__c);
                }
            }
        }

        Test.stopTest();
    }

    public static TestMethod void changeSubscriptionPrice() {
        testSetupInfo();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.CurrencyIsoCode = 'USD';
        sub.SBQQ__Quantity__c = 1;
        CMsTriggerRunCounter.skipSubscriptionTrigger = true;
        insert sub;
        sub.SBQQ__Quantity__c = 2;
        Test.startTest();
        CMsTriggerRunCounter.skipSubscriptionTrigger = false;
        update sub;

        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    System.assertEquals(sub.CurrencyIsoCode, contrct.CurrencyISOCode);
                    System.assertEquals(sub.SBQQ__NetPrice__c * sub.SBQQ__Quantity__c, contrct.Total_of_Subscriptions__c  );
                }
            }
        }
        Test.stopTest();
    }

    public static TestMethod void updateWithMajorChanges() {
        testSetupInfo();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'USD';
        CMsTriggerRunCounter.skipSubscriptionTrigger = true;
        insert sub;
        sub.SBQQ__SubscriptionStartDate__c=Date.today();
        sub.SBQQ__NetPrice__c = 200;
        sub.SBQQ__Quantity__c = 2;
        Test.startTest();
        CMsTriggerRunCounter.skipSubscriptionTrigger = false;
        update sub;

        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    System.assertEquals(sub.CurrencyIsoCode, contrct.CurrencyISOCode);
                    System.assertEquals(sub.SBQQ__NetPrice__c * sub.SBQQ__Quantity__c, contrct.Total_of_Subscriptions__c  );
                }
            }
        }
        Test.stopTest();
    }

    public static TestMethod void addToPreExisting() {
        testSetupInfo();
        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'USD';
        subs.add(sub);
        SBQQ__Subscription__c sub2 = new SBQQ__Subscription__c();
        sub2.SBQQ__Account__c =acc.Id;
        sub2.SBQQ__Contract__c=cont.Id;
        sub2.SBQQ__Product__c=prod.Id;
        sub2.SBQQ__NetPrice__c = 125;
        sub2.SBQQ__Quantity__c = 1;
        sub2.CurrencyIsoCode = 'USD';
        subs.add(sub2);
        SBQQ__Subscription__c sub3 = new SBQQ__Subscription__c();
        sub3.SBQQ__Account__c =acc.Id;
        sub3.SBQQ__Contract__c=cont.Id;
        sub3.SBQQ__Product__c=prod.Id;
        sub3.SBQQ__NetPrice__c = 150;
        sub3.SBQQ__Quantity__c = 1;
        sub3.CurrencyIsoCode = 'USD';
        subs.add(sub3);
        Test.startTest();
        insert subs;

        Decimal total = (sub3.SBQQ__NetPrice__c *sub3.SBQQ__Quantity__c )+(sub2.SBQQ__NetPrice__c *sub2.SBQQ__Quantity__c )+(sub.SBQQ__NetPrice__c *sub.SBQQ__Quantity__c );
        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        Integer count = 0;
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    count++;
                    System.assertEquals(sub.CurrencyIsoCode, contrct.CurrencyISOCode);
                    System.assertEquals(total, contrct.Total_of_Subscriptions__c  );
                }
            }
        }
        system.assertEquals(3, count);
        Test.stopTest();
    }

    public static TestMethod void addSameCurrencyAsPArent() {
        testSetupInfo();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'USD';
        Test.startTest();
        insert sub;

        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    System.assertEquals(sub.CurrencyIsoCode, contrct.CurrencyISOCode);
                    System.assertEquals(sub.SBQQ__NetPrice__c * sub.SBQQ__Quantity__c, contrct.Total_of_Subscriptions__c  );
                }
            }
        }
        Test.stopTest();
    }

    public static TestMethod void addZeroDollarSubscription() {
        testSetupInfo();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 0;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'USD';
        Test.startTest();
        insert sub;

        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    System.assertEquals(sub.CurrencyIsoCode, contrct.CurrencyISOCode);
                    //System.assertEquals(sub.SBQQ__NetPrice__c * sub.SBQQ__Quantity__c, contrct.Total_of_Subscriptions__c  );
                }
            }
        }
        Test.stopTest();
    }

    public static TestMethod void addDifferentCurrencyThanParent() {
        testSetupInfo();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont3.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'USD';
        Test.startTest();
        insert sub;

        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    System.assertNotEquals(sub.CurrencyIsoCode, contrct.CurrencyISOCode);
                    System.assertEquals(65, contrct.Total_of_Subscriptions__c  );
                }
            }
        }
        Test.stopTest();
    }

    public static TestMethod void addToExistingDifferentCurrencies() {
        testSetupInfo();
        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c =acc.Id;
        sub.SBQQ__Contract__c=cont.Id;
        sub.SBQQ__Product__c=prod.Id;
        sub.SBQQ__NetPrice__c = 100;
        sub.SBQQ__Quantity__c = 1;
        sub.CurrencyIsoCode = 'GBP';
        subs.add(sub);
        SBQQ__Subscription__c sub2 = new SBQQ__Subscription__c();
        sub2.SBQQ__Account__c =acc.Id;
        sub2.SBQQ__Contract__c=cont2.Id;
        sub2.SBQQ__Product__c=prod.Id;
        sub2.SBQQ__NetPrice__c = 125;
        sub2.SBQQ__Quantity__c = 1;
        sub2.CurrencyIsoCode = 'USD';
        subs.add(sub2);
        SBQQ__Subscription__c sub3 = new SBQQ__Subscription__c();
        sub3.SBQQ__Account__c =acc.Id;
        sub3.SBQQ__Contract__c=cont3.Id;
        sub3.SBQQ__Product__c=prod.Id;
        sub3.SBQQ__NetPrice__c = 150;
        sub3.SBQQ__Quantity__c = 1;
        sub3.CurrencyIsoCode = 'EUR';
        subs.add(sub3);

        Test.startTest();
        insert subs;

        List<SBQQ__Subscription__c> subsList = [Select SBQQ__Account__c,SBQQ__Contract__c,SBQQ__Product__c,
                SBQQ__NetPrice__c,SBQQ__Quantity__c,CurrencyIsoCode
        From SBQQ__Subscription__c Where SBQQ__Account__c =: acc.Id];
        System.Debug('subsList: '+subsList);
        List<Contract> contracts = [Select Id, Total_of_Subscriptions__c, CurrencyISOCode From Contract];
        System.Debug('contracts: '+contracts);
        for(SBQQ__Subscription__c subscription:subsList)
        {
            for(Contract contrct:contracts)
            {
                if(subscription.SBQQ__Contract__c == contrct.id)
                {
                    System.Debug('sub.CurrencyIsoCode, contrct.CurrencyISOCode:'+sub.CurrencyIsoCode+', '+contrct.CurrencyISOCode);
                    if(contrct.CurrencyISOCode == 'USD')System.assertEquals(100, contrct.Total_of_Subscriptions__c);
                    if(contrct.CurrencyISOCode == 'EUR')System.assertEquals(96.25, contrct.Total_of_Subscriptions__c);
                    if(contrct.CurrencyISOCode == 'GBP')System.assertEquals(97.5, contrct.Total_of_Subscriptions__c);
                }
            }
        }
        Test.stopTest();
    }
}