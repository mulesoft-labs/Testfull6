@isTest(seeAllData=true)
private class TestPRInsert{
static testMethod void verify_PreSalesRequest() {
    Account a = new Account(Name='TestAccount',BillingCountry='US');
    upsert (a);
    System.debug (a.id);
    //Account newAcct = [select id, name from Account where name =:'TestAccount'];
    //System.debug (newAcct.id);
    Opportunity o = new Opportunity();
    o.Name = 'TestOpportunity';
    o.AccountId = a.id ;
    o.CloseDate = Date.today();
    o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
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
    //For dev
    //OpportunityLineItem optLI = new OpportunityLineItem(OpportunityId = o.Id, Quantity=1, TotalPrice =5890.00, PricebookEntryId = '01u80000005sUofAAE');
    OpportunityLineItem optLI = new OpportunityLineItem(OpportunityId = o.Id, Quantity=1, TotalPrice =5890.00, PricebookEntryId = '01u80000006IrVaAAK');
   
    insert optLI;
    Presales_Request__c pR = new Presales_Request__c();
    pR.Opportunity__c = o.Id;
    //For dev
    //pR.RecordTypeId = '012Q00000008qKw';
    pR.RecordTypeId = '01280000000BfTg';
    pR.Discovery_Call_Date__c = Date.today();
    pR.Attendee_List_Roles__c = 'John Thompson';
   // System.debug(pQ.Name);
   upsert pR; // The trigger gets called here.
   Opportunity upOpp= [select id,name, OwnerId, Profile_and_Qualifications__c from Opportunity where id =: o.id];
   Presales_Request__c newPR= [select Opportunity_Owner_Name__c, Opportunity_Owner_Email__c, Profile_and_Qualifications__c from  Presales_Request__c where id =: pR.id];
   
   User ou = [SELECT Name, Email from User WHERE id=:upOpp.OwnerId];
   
   
   System.assertEquals(ou.Name, newPR.Opportunity_Owner_Name__c);
   System.assertEquals(ou.Email, newPR.Opportunity_Owner_Email__c );
   System.assertEquals(upOpp.Profile_and_Qualifications__c, newPR.Profile_and_Qualifications__c);
}
}