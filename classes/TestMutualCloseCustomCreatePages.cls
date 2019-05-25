@isTest(seeAllData=true)
private class TestMutualCloseCustomCreatePages{
static testMethod void verify_TestMutualCloseCustomCreatePages() {
    Pricebook2 priceBookId = [SELECT Id FROM Pricebook2 WHERE Name=:'Standard Price Book'];
    PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true limit 1];

    Account a = new Account(Name='TestAccount',BillingCountry='US');
    insert a;
    System.debug ('Account = ' + a.id);

    Opportunity o = new Opportunity();
    o.Name = 'TestOpportunity';
    o.AccountId = a.id ;
    o.CloseDate = Date.today();
    o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
    o.CurrencyIsoCode = pbID.CurrencyIsoCode;
    ID opprtId = [SELECT Id FROM RecordType WHERE Name = 'Standard / New Business'].Id;
    o.RecordTypeId=opprtId;
    o.Type = 'New Business';
    o.Amount=1000;
    o.NextStep='Discovery Call';
    o.Pricebook2Id=priceBookId.Id;
    o.Opportunity_Source__c = 'Direct'; 
    o.Primary_Solution_Interest__c = 'SOA';
    insert o;
    System.debug (o.id);
  Test.StartTest();  
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;
    insert oli;
    
    
        
    Mutual_Close_Plan__c mcp = new Mutual_Close_Plan__c();
    mcp.Action_Owner__c='Test MC Owner1';
    mcp.Mutual_Close_Action_Name__c='Test MC action-MCPlan-CustomCreate1';
    mcp.Due_Date__c = Date.today();
    mcp.Opportunity__c = o.Id;
    insert mcp;

    List<Mutual_Close_Plan__c> mcPlans = new List<Mutual_Close_Plan__c>();
    mcPlans.add(mcp);
    
    String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';    
    PageReference ref = new PageReference(sfdcURL + 'apex/Mutual_Close_Plan_custom_create_page');
    ref.getParameters().put('id', o.Id);
    System.debug('In Test Class Custom Create = ' + ref.getURL());
    Test.setCurrentPageReference(ref);       
    
    ApexPages.StandardSetController setController = new ApexPages.StandardSetController(mcPlans);
    MutualClosePlanCustomCreate mcPlansCustomController = new MutualClosePlanCustomCreate(setController);   
    mcPlansCustomController.NewMutualClosePlan();
   Test.StopTest();

}

}