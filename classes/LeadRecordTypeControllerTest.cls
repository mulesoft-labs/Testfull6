@isTest
private class LeadRecordTypeControllerTest {
	
	@isTest static void getLeadRecordType() {
		// Implement test code
		// 
		Lead leadObj = new Lead( FirstName='Test 100800', LastName = 'Test 100800 UnitTest' );
   		leadObj.Company = 'BOX.com';
   		leadObj.Country = 'US';
   		insert leadObj;
		LeadRecordTypeController controller = new LeadRecordTypeController(new ApexPages.StandardController(leadObj));
		controller.getLeadRecordType();

	}
	
	
}