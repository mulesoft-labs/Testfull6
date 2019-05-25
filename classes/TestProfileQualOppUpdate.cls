@isTest(seeAllData=true)
private class TestProfileQualOppUpdate{
  static testMethod void verify_ProfileQualifications() {
    Account a = new Account(Name='TestAccount',BillingCountry='US');
    upsert (a);
    System.debug (a.id);
    //Account newAcct = [select id, name from Account where name =:'TestAccount'];
    //System.debug (newAcct.id);
    Opportunity o = new Opportunity();
    o.Name = 'TestOpportunity';
    o.AccountId = a.id ;
    o.CloseDate = Date.today();
    o.StageName = 'Sales Qualified Lead';
    o.RecordTypeId='01280000000BcQs';
    o.Type = 'New Business';
    o.Amount=1000;
    o.Opportunity_Source__c ='Direct';     
    o.NextStep='Discovery Call';
    Pricebook2 priceBookId = [SELECT Id FROM Pricebook2 WHERE Name=:'Standard Price Book'];
    System.debug('Price Book id = ' + priceBookId.Id);
    o.Pricebook2Id=priceBookId.Id;
    o.Primary_Solution_Interest__c = 'SOA';
    upsert (o);
    System.debug (o.id);
    //For Dev
    //OpportunityLineItem optLI = new OpportunityLineItem(OpportunityId = o.Id, Quantity=1, TotalPrice =5890.00, PricebookEntryId = '01u80000005sUofAAE');
    OpportunityLineItem optLI = new OpportunityLineItem(OpportunityId = o.Id, Quantity=1, TotalPrice =5890.00, PricebookEntryId = '01u80000006IrVaAAK');
    insert optLI;
    Profile_Qualification__c pQ = new Profile_Qualification__c();
    pQ.Name = o.name;
    pQ.Opportunity__c = o.Id;
    System.debug(pQ.Name);
    upsert pQ; // The trigger gets called here.
    Opportunity upOpp= [select id,name, Profile_and_Qualifications__c from Opportunity where id =: o.id];
    //System.assertEquals(upOpp.Profile_and_Qualifications__c,pQ.Id);
}
}