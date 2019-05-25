@isTest(seeAllData=true)
private class TestMutualClosePlanTriggers{
static testMethod void verify_TestMutualClosePlanTriggers() {
    Account a = new Account(Name='TestAccount',BillingCountry='US'); 
    insert (a);    
    PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true limit 1];
     
    Opportunity o = new Opportunity();
    o.Name = 'TestOpportunity';
    OpportunityLineItem ol = new OpportunityLineItem();
    
    o.CurrencyIsoCode = pbID.CurrencyIsoCode;
    o.Name = 'TestOpportunity';
    o.AccountId = a.id ;
    o.CloseDate = Date.today();
    o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
    o.Type = 'New Business';
    o.Amount=1000;
    o.Opportunity_Source__c ='Direct';     
    o.NextStep='Discovery Call';
    o.Primary_Solution_Interest__c = 'SOA';
    insert o;
    
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;
    insert oli;
    
  
    
    Mutual_Close_Plan__c mcp = new Mutual_Close_Plan__c();
    mcp.Action_Owner__c='Test MC Owner';
    mcp.Mutual_Close_Action_Name__c='Test MC action';
    mcp.Due_Date__c = Date.today();
    mcp.Opportunity__c = o.Id;
    insert mcp;
    
    mcp =  [SELECT Opportunity__c,  Is_Completed__c, Id from Mutual_Close_Plan__c where Id =:mcp.Id];
    mcp.Is_Completed__c = true;
    update mcp;
    
    delete mcp;
     
}
}