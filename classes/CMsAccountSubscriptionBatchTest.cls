@isTest
private class CMsAccountSubscriptionBatchTest{
    static testMethod void createRecords(){
        Account acct = TestDataFactory.createAccounts(1, true, null)[0];
        //Account acct = TestDataFactory.createAccounts(1, true, new Map<String, Object>{'Control_Plane_Cloud__c' => 1})[0];
        List<Contract> Contracts = TestDataFactory.createContracts(1, true, new Map<String, Object>{'Status' => 'Draft', 'StartDate' => date.today(), 'EndDate' => date.today().addyears(1), 'AccountId' => acct.id});
        Contracts.add(TestDataFactory.createContracts(1, true, new Map<String, Object>{'Status' => 'Draft', 'StartDate' => date.today(), 'EndDate' => date.today().addyears(1), 'AccountId' => acct.id})[0]);

        System.debug('contracts **** ' + Contracts);
        Contracts[0].Status = 'Activated';
        update Contracts;
        List<Product2> Productlist = new List<Product2>();
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'Additional Pre-Production Core', 'ProductCode' => 'ADDTNLPREPRODCORE', 'Product_Tier__c' => 'Professional', 'Control_Plane__c' => 'Cloud'})[0]);
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'FTPS Connector - Pre-Production', 'ProductCode' => 'FTPSPreProdConnect', 'Product_Tier__c' => 'Professional', 'Control_Plane__c' => 'On-Premise'})[0]);
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'Additional Pre-Production Core', 'ProductCode' => 'ADDTNLPREPRODCORE', 'Product_Tier__c' => 'Professional', 'Runtime_Plane__c' => 'Cloud'})[0]);
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'FTPS Connector - Pre-Production', 'ProductCode' => 'FTPSPreProdConnect', 'Product_Tier__c' => 'Professional', 'Runtime_Plane__c' => 'On-Premise'})[0]);
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'FTPS Connector - Pre-Production', 'ProductCode' => 'FTPSPreProdConnect', 'Product_Tier__c' => 'Professional', 'Packaging__c' => 'Current'})[0]);
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'FTPS Connector - Pre-Production', 'ProductCode' => 'FTPSPreProdConnect', 'Product_Tier__c' => 'Professional', 'Packaging__c' => 'Legacy'})[0]);
        Insert Productlist;

        List<SBQQ__Subscription__c> Subscriptions = new List<SBQQ__Subscription__c>();
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[0].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1, 'SBQQ__Contract__c'=>Contracts[0].id})[0]);
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[1].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1, 'SBQQ__Contract__c'=>Contracts[0].id})[0]);
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[2].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1, 'SBQQ__Contract__c'=>Contracts[0].id})[0]);
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[3].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1, 'SBQQ__Contract__c'=>Contracts[0].id})[0]);
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[4].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1, 'SBQQ__Contract__c'=>Contracts[0].id})[0]);
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[5].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1, 'SBQQ__Contract__c'=>Contracts[0].id})[0]);
        Insert Subscriptions;
        
        test.startTest();
        CMsAccountSubscriptionBatch accsubBatch = new CMsAccountSubscriptionBatch();
        DataBase.executeBatch(accsubBatch);
        accsubBatch.execute(null);
        test.stopTest();
    }
    
    static testMethod void createRecords1(){
        Account acct = TestDataFactory.createAccounts(1, true, null)[0];
        //Account acct = TestDataFactory.createAccounts(1, true, new Map<String, Object>{'Control_Plane_Cloud__c' => 1})[0];
        List<Contract> Contracts = TestDataFactory.createContracts(1, true, new Map<String, Object>{'Status' => 'Draft', 'StartDate' => date.today(), 'EndDate' => date.today().addyears(1), 'AccountId' => acct.id});
        Contracts.add(TestDataFactory.createContracts(1, true, new Map<String, Object>{'Status' => 'Draft', 'StartDate' => date.today(), 'EndDate' => date.today().addyears(1), 'AccountId' => acct.id})[0]);
        for(Contract c : Contracts){
            c.Status= 'Activated';
        }
        update Contracts;
        List<Product2> Productlist = new List<Product2>();
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'Additional Pre-Production Core', 'ProductCode' => 'ADDTNLPREPRODCORE', 'Product_Tier__c' => 'Professional', 'Control_Plane__c' => 'Cloud'})[0]);
        Productlist.add(TestDataFactory.createProducts(1, false, new Map<String, Object>{'Name' => 'FTPS Connector - Pre-Production', 'ProductCode' => 'FTPSPreProdConnect', 'Product_Tier__c' => 'Professional', 'Control_Plane__c' => 'On-Premise'})[0]);
        Insert Productlist;

        List<SBQQ__Subscription__c> Subscriptions = new List<SBQQ__Subscription__c>();
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[0].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1})[0]);
        Subscriptions.add(TestDataFactory.createSBQQSubscription(1, false, new Map<String, Object>{'SBQQ__Account__c' => acct.Id, 'SBQQ__Product__c' => Productlist[0].Id, 'Product_Tier__c' => 'Professional', 'SBQQ__Quantity__c' => 1})[0]);
        Insert Subscriptions;
        
        test.startTest();
        CMsAccountSubscriptionBatch accsubBatch = new CMsAccountSubscriptionBatch();
        DataBase.executeBatch(accsubBatch);
        test.stopTest();
    }
    
}