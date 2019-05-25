/*********************************************************************
*
*   File Name: TriggerRecursiveHandler.cls
*
*   File Description: Utility class to control recursive firing of
*	triggers
*
**********************************************************************
*
*   Date		Author			  Change
*	10/08/14	Rob				  Initial Creation							
*
*********************************************************************/

public with sharing class TriggerRecursiveHandler
{
	private static Boolean run = false;

	public static Boolean hasRun()
	{
		if(run)
		{
			return (Test.isRunningTest() ? false : true);
		}
		else
		{
			run = true;
			return false;
		}
	}
}