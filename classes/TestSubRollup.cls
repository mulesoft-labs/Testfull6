@isTest
private class TestSubRollup {
    @isTest
    private static void testSubRollup (){
        Account a = new Account(Name = 'Acc1',BillingCountry = 'United States');
        insert a;
        
        Product2 p1 = new Product2(Name = 'Prof Product', Product_Tier__c = 'Professional');
        Product2 p2 = new Product2(Name = 'Ent Product', Product_Tier__c = 'Enterprise');
        insert new Product2[] {p1, p2};
        
        SBQQ__Subscription__c s1 = new SBQQ__Subscription__c(SBQQ__Account__c = a.Id, SBQQ__Product__c = p1.Id, Product_Tier__c = 'Professional', SBQQ__Quantity__c = 1);
        SBQQ__Subscription__c s2 = new SBQQ__Subscription__c(SBQQ__Account__c = a.Id, SBQQ__Product__c = p2.Id, Product_Tier__c = 'Enterprise', SBQQ__Quantity__c = 1);
        insert new SBQQ__Subscription__c[] {s1, s2};
        
        Account testAcc1 = [SELECT Enterprise_Tier_Subscriptions__c, Professional_Tier_Subscriptions__c FROM Account WHERE Id = :a.Id];
        //System.assertEquals(1,testAcc1.Enterprise_Tier_Subscriptions__c);
        //System.assertEquals(1,testAcc1.Professional_Tier_Subscriptions__c);
        
        delete new SBQQ__Subscription__c[] {s1,s2};
        
        Account testAcc2 = [SELECT Enterprise_Tier_Subscriptions__c, Professional_Tier_Subscriptions__c FROM Account WHERE Id = :a.Id];
        //System.assertEquals(0,testAcc2.Enterprise_Tier_Subscriptions__c);
        //System.assertEquals(0,testAcc2.Professional_Tier_Subscriptions__c);
    }
}