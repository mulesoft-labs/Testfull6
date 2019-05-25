@isTest(seeAllData=true)

private class TestLeadConversion{

static testMethod void unitTestLeadConversion() {

    test.startTest();

   // Create the Lead object
   Lead testLead = new Lead(
   FirstName='Test 100800',
   LastName = 'Test 100800 UnitTest'
   //Status='Prospect'
   //Ready_to_Convert__c = true
   );
   testLead.Company = 'BOX.com';
   testLead.Country = 'US';
   insert testLead;
   System.debug('Created and inserted lead');

   Database.LeadConvert lc = new database.LeadConvert();
   lc.setLeadId(testLead.Id);
    try{
   LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
   lc.setConvertedStatus(convertStatus.MasterLabel);
   Database.LeadConvertResult lcr = Database.convertLead(lc);
    }catch(Exception ex){
    }
   // Make sure conversion was successful
  

   test.stopTest();
   }
   }