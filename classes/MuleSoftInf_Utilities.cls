/*********************************************************************
*
*   File Name: MuleSoftInf_Utilities.cls
*
*   File Description: Contains common utility methods needed in the org
*
**********************************************************************
*
*   Date		Author			  Change
*	07/15/14	Robert			  Initial Creation							
*
*********************************************************************/

global with sharing class MuleSoftInf_Utilities
{

	/**
	 * Returns a map of record type name and Id for a given object
	 */
	global static Map<String, Id> getRecordTypeMap(String objectName)
	{
    	// Generate map of tokens for the sObjects in the org
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

		// Retrieve the describe results for the object passed in the method argument
		DescribeSObjectResult result = globalDescribe.get(objectName).getDescribe();

		// Generate map of all records types for the object passed
		Map<String,Schema.RecordTypeInfo> recordTypeInfoMap = result.getRecordTypeInfosByName();

		Map<String, Id> recordTypeMap = new Map<String, Id>();
		for(Schema.RecordTypeInfo r : recordTypeInfoMap.values())
		{
			recordTypeMap.put(r.getName(), r.getRecordTypeId());
		}

		return recordTypeMap;
	}

}