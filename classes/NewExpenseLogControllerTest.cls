/*** 
* Class: NewExpenseLogControllerTest
* Description: Unit test for NewExpenseLogControllerTest
* Author: Elmar Chen
* Create Time: 06/25/2015 11:27:07
*
**********************************************************************
*
*   Date            Author                 Change
*   06/25/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class NewExpenseLogControllerTest {
	
	@isTest static void test_NewExpenseLogControllerTest() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		System.currentPageReference().getParameters().put('retURL', '/'+prj.Id);
		List<Vendor__c> vs = TestDataFactory.createVendors(20, true, null);
	Test.startTest();
		NewExpenseLogController ctrl = new NewExpenseLogController(new ApexPages.StandardController(prj));
	Test.stopTest();
		System.assertEquals(prj.Id, ctrl.getLog().Project__c);
		System.assertEquals(20, ctrl.VendorList.size());
	}
	
}