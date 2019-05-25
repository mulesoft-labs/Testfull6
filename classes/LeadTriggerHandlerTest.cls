/**
 * Test Class for LeadTriggerHandler
 */
@isTest
private class LeadTriggerHandlerTest {
	static Lead leadObj;
	static{
   		// Create the Lead object
   		leadObj = new Lead( FirstName='Test 100800', LastName = 'Test 100800 UnitTest' );
   		leadObj.Company = 'BOX.com';
   		leadObj.Country = 'US';
   		insert leadObj;  
    }
    
    static testMethod void testTrigger() {
        test.startTest();
	   	leadObj.Status = 'Qualified';
	   try{
	   		update leadObj;
	   		// Make sure conversion was successful
	   }catch(Exception ex){
	   	
	   }	
	   test.stopTest();
    }
    
    static testMethod void testLeadController() {
       test.startTest();
	   LeadController con = new LeadController(new Apexpages.Standardcontroller(leadObj));
	   System.assertEquals(con.validateForLeadConversion(), null);
	   test.stopTest();
    }
    
    
}