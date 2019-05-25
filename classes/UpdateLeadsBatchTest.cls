/*** 
* Class: UpdateLeadsBatchTest
* Description: Unit test for UpdateLeadsBatch
* Author: Elmar Chen
* Create Time: 06/10/2015 19:08:43
*
**********************************************************************
*
*   Date            Author                 Change
*   06/10/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class UpdateLeadsBatchTest {
	
	@isTest static void test_Constructor() {
		UpdateLeadsBatch b = new UpdateLeadsBatch('A', 'B', 'C', 'D');
		System.assertEquals(b.Query, 'A');
		System.assertEquals(b.Entity, 'B');
		System.assertEquals(b.Field, 'C');
		System.assertEquals(b.Value, 'D');

	}
	
	//trial test. No meaningful assert is made since the original code has no side affect nor return values.
	@isTest static void test_execute() {
		UpdateLeadsBatch b = new UpdateLeadsBatch();
		List<Lead> leads = Database.Query(b.Query);
		b.start(null);
		b.execute(null, leads);
		b.finish(null);
	}
	
}