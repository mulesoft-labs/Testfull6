@isTest(seeAllData=true)
private class TestAccountUpdateOppTriggers{
static testMethod void verify_TestAccountUpdateOppTriggers() {

    Pricebook2 priceBookId = [SELECT Id FROM Pricebook2 WHERE Name=:'Standard Price Book'];
    PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true limit 1];

    Account a = new Account(Name='TestAccount', BillingCountry='US');
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
    o.Opportunity_Source__c ='Direct';  
    
    o.Pricebook2Id=priceBookId.Id;
    o.Primary_Solution_Interest__c = 'SOA';
    insert o;
    System.debug (o.id);
    
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;
    insert oli;

    
    a.Company_Description__c = 'Hello World';
    update(a);
}
}