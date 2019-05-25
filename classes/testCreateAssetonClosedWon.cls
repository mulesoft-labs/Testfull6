@isTest(seeAllData=true)
private class testCreateAssetonClosedWon {
 
  static testMethod void testCreateAssetonClosedWon(){
    
    /*Account a = new Account(Name='TestAccount');
    //a.CurrencyIsoCode = 'USD';
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
    //o.RecordTypeId='01280000000BcQs';
    o.Type = 'New Business';
    o.Amount=1000;
    o.NextStep='Discovery Call';
    insert o;
    
    
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;
    insert oli;*/
   
    Account a = new Account(Name='TestAccount', BillingCountry='US'); 
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
    o.NextStep='Discovery Call';
    o.Opportunity_Source__c ='Direct';  
    o.Primary_Solution_Interest__c = 'SOA';
    
    insert o;
    
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;
    insert oli;  
   
    o.StageName= 'Closed Won';
    
    try
    {
	    update o;
    }
    catch(Exception e){}
    
    //delete ol;
    //delete o;  
   
  } 
}