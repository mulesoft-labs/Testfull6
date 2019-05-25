@isTest(seeAllData=true)
private class TestSCActions{
static testMethod void verify_SCActions() {
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
    //For Dev
    //o.RecordTypeId='01280000000BcQs';
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
    SC_Action__c sca = new SC_Action__c ();
    sca.Opportunity__c = o.Id;
    //For Sandbox
    sca.RecordTypeId = SCActionTriggerHandler.getRecordTypeId('PoC/PoV/custom demo').id;
    sca.On_site1__c = 'No';
    insert sca;
   
    //For dev
   // User newUser = [SELECT Id FROM User WHERE Alias='jdo.dev'];
    //User newUser = [SELECT Id FROM User WHERE Alias='jdo'];
    //System.RunAs(newUser){
    
       sca.Status__c='Completed';
       update sca;
    //}
    
    
    //Presales_Request__c newPR= [select OwnerId, Opportunity_Owner_Name__c, Opportunity_Owner_Email__c, Profile_and_Qualifications__c from  Presales_Request__c where id =: pR.id];
    //System.debug('Pre-sales owner = ' + newPR.OwnerId);
    //System.assertEquals(newPR.OwnerId, newUser.Id);
}
}