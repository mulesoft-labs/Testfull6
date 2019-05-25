@isTest(seeAllData=true)
private class TestMutualCloseCancelPages{
static testMethod void verify_TestMutualCloseCancelPages() {
    Account a = new Account(Name='TestAccount-MCPlan-CustomCreate',BillingCountry='US'); 
    insert (a);    
    PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true limit 1];
     
    Opportunity o = new Opportunity();
    OpportunityLineItem ol = new OpportunityLineItem();
    
    o.CurrencyIsoCode = pbID.CurrencyIsoCode;
    o.Name = 'TestOpportunity-MCPlan-CustomCreate';
    o.AccountId = a.id ;
    o.CloseDate = Date.today();
    o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
    o.Type = 'New Business';
    o.Amount=1000;
    o.NextStep='Discovery Call';
    o.Opportunity_Source__c='Direct'; 
    o.Primary_Solution_Interest__c = 'SOA';
    insert o;
    
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;
    insert oli;
    
 
        
    Mutual_Close_Plan__c mcp = new Mutual_Close_Plan__c();
    mcp.Action_Owner__c='Test MC Owner';
    mcp.Mutual_Close_Action_Name__c='Test MC action-MCPlan-CustomCreate';
    mcp.Due_Date__c = Date.today();
    mcp.Opportunity__c = o.Id;
    insert mcp;

    ApexPages.StandardController stdController = new ApexPages.StandardController(mcp);
    String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
    
    PageReference ref = new PageReference(sfdcURL + mcp.Id + '/e?retURL=%2F' + mcp.Id);
    ref.getParameters().put('Id', mcp.Id);
    ref.getParameters().put('isParentOpp', String.ValueOf(false));  
    
    Test.setCurrentPageReference(ref);       
   
    MutualClosePlanCustomCancel mcPlansCancelController = new MutualClosePlanCustomCancel(stdController);
    mcPlansCancelController.CancelMutualClosePlan();
 
}

}