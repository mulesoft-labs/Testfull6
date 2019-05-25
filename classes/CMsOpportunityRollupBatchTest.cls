@isTest
private class CMsOpportunityRollupBatchTest {

    static testMethod void testValidateTrainingAmount(){        
        
       	Id pricebookId = Test.getStandardPricebookId();
        List<Product2> prodsToInsert = new List<Product2>();
        Product2 prodTraining1 = new Product2(Name = 'Training 1', Family = 'Training', Category__c = 'Training',IsActive = true, ProductCode='Test Training 1');
		prodsToInsert.add(prodTraining1);
        Product2 prodTraining2 = new Product2(Name = 'Training 2', Family = 'Training', Category__c = 'Training',IsActive = true, ProductCode='Test Training 2');
		prodsToInsert.add(prodTraining2);        
        Product2 prodConsulting1 = new Product2(Name = 'Consulting 1', Family = 'Consulting', Category__c = 'Consulting',IsActive = true, ProductCode='Test Consulting 1');
		prodsToInsert.add(prodConsulting1);        
        Product2 prodConsulting2 = new Product2(Name = 'Consulting 2', Family = 'Consulting', Category__c = 'Consulting',IsActive = true, ProductCode='Test Consulting 2');
		prodsToInsert.add(prodConsulting2);
        insert prodsToInsert;        
        
        List<PricebookEntry> pbeToInsert = new List<PricebookEntry>();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prodTraining1.Id, UnitPrice = 5000, IsActive = true, UseStandardPrice = false);
		pbeToInsert.add(pbe1);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prodTraining2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
		pbeToInsert.add(pbe2);
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prodConsulting1.Id, UnitPrice = 2000, IsActive = true, UseStandardPrice = false);
		pbeToInsert.add(pbe3);
        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prodConsulting2.Id, UnitPrice = 20000, IsActive = true, UseStandardPrice = false);
		pbeToInsert.add(pbe4);        
        insert pbeToInsert;
     
        Account acct = TestDataFactory.createAccounts(1, true, null)[0];
		List<Opportunity> opps;        
		opps = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
                                                'StageName' => ConstantDeclarations.OPP_STAGE_CLOSED_WON,
                                                'CloseDate' => date.Today().addDays(-10),
                                                'AccountId' => acct.Id
		        								});
        System.debug(LoggingLevel.ERROR, '---------------------->>>>>'+opps);
        List<OpportunityLineItem> olis1 = TestDataFactory.createOpportunityLineItem(1,true,new Map<String, Object>{
            																		'UnitPrice' => 5000,
                                                                                    'OpportunityId' => opps[0].Id,
                                                                                    'Quantity' => 1,
																					'pricebookentryId' => pbe1.Id                                                                                        
                                                                                    });
        

		List<OpportunityLineItem> olis2 = TestDataFactory.createOpportunityLineItem(1,true,new Map<String, Object>{
            																		'UnitPrice' => 10000,            
                                                                                    'OpportunityId' => opps[0].Id,
                                                                                    'Quantity' => 1,
																					'pricebookentryId' => pbe2.Id                                                                                          
                                                                                    });
        
		List<OpportunityLineItem> olis3 = TestDataFactory.createOpportunityLineItem(1,true,new Map<String, Object>{
            																		'UnitPrice' => 2000,
                                                                                    'OpportunityId' => opps[1].Id,
                                                                                    'Quantity' => 1,
																					'pricebookentryId' => pbe3.Id  
                                                                                    });
        
		List<OpportunityLineItem> olis4 = TestDataFactory.createOpportunityLineItem(1,true,new Map<String, Object>{
            																		'UnitPrice' => 20000,            
                                                                                    'OpportunityId' => opps[1].Id,
                                                                                    'Quantity' => 1,
																					'pricebookentryId' => pbe4.Id                                                                                          
                                                                                    });        
               
        test.startTest();
        CMsOpportunityRollupBatch opptyRollUpBatch = new CMsOpportunityRollupBatch();
        DataBase.executeBatch(opptyRollUpBatch);
        opptyRollUpBatch.execute(null);
        test.stopTest();
        

		List<Account> accounts = [SELECT Id, Training_Sold_Last_1_year__c, Consulting_Sold_Last_1_Year__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals(15000, accounts[0].Training_Sold_Last_1_year__c);
		System.assertEquals(22000, accounts[0].Consulting_Sold_Last_1_Year__c);

    } 
    
}