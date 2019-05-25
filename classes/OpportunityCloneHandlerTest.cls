/*********************************************************************
*
*   File Name: OpportunityCloneHandlerTest.cls
*
*   File Description: This class is to test Opportunity Cloning functionality
*
**********************************************************************
*
*   Date    Author        Change
*  10/31/14  Rob          Initial Creation              
*
*********************************************************************/   
@isTest(seeAlldata = true)
private class OpportunityCloneHandlerTest
{
    
    /**
   * Testing Opportunity Cloning Functionality
   */    
    private static testmethod void testOppCloning()
    {
    Account a = new Account();
    a.Name = 'Test Account';
    a.BillingCountry = 'India';
        insert a;
    
    Opportunity opp = new Opportunity();
    opp.Name = 'Test opp';
    opp.AccountId = a.Id;
    opp.Closedate = Date.Today();
    opp.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
    opp.Type = 'New Business';
    opp.Opportunity_Source__c = 'Partner Outbound';
    opp.Primary_Solution_Interest__c = 'SOA';
    opp.Contract_End_Date__c = Date.Today();
    insert opp;
    

    List<OpportunityCloning__c> oppClone2 = [Select Id From OpportunityCloning__c];
    delete oppClone2;
    
    OpportunityCloning__c oppClone = new OpportunityCloning__c();
    oppClone.Name = 'Opportunity_Plan__c';
    oppClone.OpportunityLookUpAPI_Name__c = 'Opportunity__c';
    insert oppClone;
    
    
    List<Pricebook2> standardPB = [select id from Pricebook2 where isStandard=true];
    
    Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
    insert pb;
    Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', IsActive = true);
    insert prod;
    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB[0].Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert standardPrice;

    PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert pbe;

    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 7500, Description = '2007 CMR #4 - Anti-Infectives');
    insert oli;

        Test.startTest();
    opp.StageName = 'Closed Won';
    opp.ForecastCategoryName = 'Closed';
    opp.forecast__c = 'Closed';
    opp.Probability = 100;
    opp.Multi_Year_Deal__c = 'yes';
    opp.If_yes_Year_X_of_Total_Years__c = '1';
        
    update opp;
    System.debug('???? Stage Name'+ opp.StageName);
    Test.stopTest();
    }
}