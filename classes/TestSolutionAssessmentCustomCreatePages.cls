@isTest(seeAllData=true)
private class TestSolutionAssessmentCustomCreatePages{
static testMethod void verify_TestSolutionAssessmentPages() {
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
    o.Opportunity_Source__c ='Direct';    
    o.NextStep='Discovery Call';
    o.Primary_Solution_Interest__c = 'SOA';
    insert o;
    
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;
    insert oli;
    
   
   Profile_Qualification__c techEnvironment = new Profile_Qualification__c();
   techEnvironment.Name = o.Name + '-' + 'Solution Assessment';
   techEnvironment.Opportunity__c = o.Id;
             
    insert techEnvironment;

    ApexPages.StandardController stdController = new ApexPages.StandardController(o);
    String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
    
    PageReference ref = new PageReference(sfdcURL + 'apex/Solution_Assessment_custom_create_Page');
    ref.getParameters().put('id', o.Id);    
    Test.setCurrentPageReference(ref);       
   
    SolutionAssessmentCustomCreate solnAssessmentControllerExt = new SolutionAssessmentCustomCreate(stdController);
    solnAssessmentControllerExt.NewSolutionAssessment();
 
}

}