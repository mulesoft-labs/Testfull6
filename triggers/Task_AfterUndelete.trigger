/*********************************************************************
*
*   File Name: Task_AfterUndelete.trigger
*
*   File Description: Task trigger handling all after undelete events
*
**********************************************************************
*
*   Date            Author                 Change
*   07/29/14        Rob                    Initial Creation                          
*
*********************************************************************/

trigger Task_AfterUndelete on Task (after undelete) 
{
    //updates the Activity fields for contact and lead records
    //ActivityCountHandler.updateActivityCount(trigger.new); 
}