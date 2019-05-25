@isTest
public with sharing class CMsBookingControllerTest {
 
    static testMethod void testCreationAndUpdateOfChildOpps() {
        Account acct = TestDataFactory.createAccounts(1, true, null)[0];
        Contact c = TestDataFactory.createContacts(1, acct.Id, true, null)[0];
        Opportunity parentOpp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acct.Id })[0];
        TestDataFactory.createQuote(1, true, new Map<String, Object>{ 'SBQQ__Opportunity2__c' => parentOpp.Id });
        //TestDataFactory.createPartner(1, true, new Map<String, Object>{ 'Account__c' => acct.Id , 'Opportunity__c' => parentOpp.Id});        
        //TestDataFactory.createOpportunityContactRole(1, true, new Map<String, Object>{'OpportunityId' => parentOpp.Id, 'ContactId' => c.Id});
        PageReference pageref = Page.PMsBookingStep1;
        pageRef.getParameters().putAll(new Map<String,String>{'parentOppId'=>parentOpp.Id});

        Test.setCurrentPage(pageRef);

        CMsBookingController ctrl = new CMsBookingController(new ApexPages.StandardController(parentOpp));
        Test.startTest();
        ctrl.createChildOpportunities(parentOpp,2);//Creating 2 child Opportunities
        Test.stopTest();
        
        //Validate that 2 child opportunities got created
        List<Opportunity> childOpps = [SELECT Id FROM Opportunity WHERE Parent_Opportunity__c =:parentOpp.Id];
        System.assertEquals(2,childOpps.size());
        
        //Validate that quote got Cloned
        List<SBQQ__Quote__c> childQuotes = [SELECT Id FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c IN :childOpps];
        System.assertEquals(2,childQuotes.size());

        //Validate that the primary contact role got cloned
        List<OpportunityContactRole> opptyContactRole = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId IN :childOpps AND ContactId =:c.Id];
        //System.assertEquals(2,opptyContactRole.size());
                 
        //Validate that the Partner Details got cloned
        List<Partner_Influence__c> partners = [SELECT Id FROM Partner_Influence__c WHERE Opportunity__c IN :childOpps AND Account__c =:acct.Id];
        //System.assertEquals(2,partners.size());
    }
	
    static testMethod void testUpdateOfChildOpps() {
        Account acct = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity parentOpp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acct.Id })[0];
        Opportunity child1 = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acct.Id,'Parent_Opportunity__c' => parentOpp.Id })[0];
       
        PageReference pageref = Page.PMsBookingStep1;
        pageRef.getParameters().putAll(new Map<String,String>{'parentOppId'=>parentOpp.Id});

        Test.setCurrentPage(pageRef);
        CMsBookingController ctrl = new CMsBookingController(new ApexPages.StandardController(parentOpp));
        ctrl.parentOppId = parentOpp.Id;        
        
        Test.startTest();
        ctrl.updateChildOpportunities();
        Test.stopTest();
        
    }
    
    
    static testMethod void testAllNavigationLink() {
        Account acct = TestDataFactory.createAccounts(1, true, null)[0];
        Contact c = TestDataFactory.createContacts(1, acct.Id, true, null)[0];
        Opportunity parentOpp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acct.Id })[0];
        TestDataFactory.createQuote(1, true, new Map<String, Object>{ 'SBQQ__Opportunity2__c' => parentOpp.Id });
        TestDataFactory.createPartner(1, true, new Map<String, Object>{ 'Account__c' => acct.Id , 'Opportunity__c' => parentOpp.Id});        
        TestDataFactory.createOpportunityContactRole(1, true, new Map<String, Object>{'OpportunityId' => parentOpp.Id, 'ContactId' => c.Id});
        
        PageReference pageRef = Page.PMsBookingStep1; //replace with your VF page name
        pageRef.getParameters().putAll(new Map<String,String>{'parentOppId'=>parentOpp.Id});

        Test.setCurrentPage(pageRef);
        
        CMsBookingController ctrl = new CMsBookingController(new ApexPages.StandardController(parentOpp));

        PageReference page1 = ctrl.goToStep3();
        ctrl.step1();
        System.assertNotEquals(null,pageRef);
        System.assertEquals('/apex/pmsbookingstep1?parentOppId='+parentOpp.Id ,pageRef.getUrl());        
        ctrl.step2();
        System.assertNotEquals(null,pageRef);
        ctrl.backToStep2();
        System.assertNotEquals(null,pageRef);
        ctrl.backToStep3();
        System.assertNotEquals(null,pageRef);
        ctrl.step3();//Update child Opportunities
        System.assertNotEquals(null,pageRef);
        ctrl.step4();//Copy Opp Team member    
        System.assertNotEquals(null,pageRef);
        ctrl.cancel();
        System.assertNotEquals(null,pageRef);
    }

    


}