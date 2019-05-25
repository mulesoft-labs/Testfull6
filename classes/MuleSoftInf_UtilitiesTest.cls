/*********************************************************************
*
*   File Name: MuleSoftInf_UtilitiesTest.cls
*
*   File Description: Test class for the MuleSoftInf_Utilities
*	class
*
**********************************************************************
*
*   Date		Author			  Change
*	07/21/14	Robert			  Initial Creation							
*
*********************************************************************/

@isTest
private with sharing class MuleSoftInf_UtilitiesTest
{
	
	/**
	 * Test method to test the getRecordTypeMap method
	 */
	private static testMethod void testGetRecordTypeMap()
	{		
		Test.startTest();
		Map<String, Id> leadRecordTypeMap = MuleSoftInf_Utilities.getRecordTypeMap('Lead');
		Test.stopTest();

		// Validate that the map isn't empty.  The lead object currently
		// has 4 record types
		System.assert(!leadRecordTypeMap.keySet().isEmpty());
	}	
	
}