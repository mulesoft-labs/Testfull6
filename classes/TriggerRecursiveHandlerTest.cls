/*********************************************************************
*
*   File Name: TriggerRecursiveHandlerTest
*
*   File Description: Test class to test the TriggerRecursiveHandler
*	class.
*
**********************************************************************
*
*   Date        Author                      Change
*   10/08/14    Rob                         Initial Creation                        
*
*********************************************************************/

@isTest
private with sharing class TriggerRecursiveHandlerTest
{
	/**
     * Test Method to test NotifyAt10Percent function
     */    
    private testmethod static void hasRunTest()
    {
    	System.assert(TriggerRecursiveHandler.hasRun() == false);    	
    	System.assert(TriggerRecursiveHandler.hasRun() == false);    	
    }
}