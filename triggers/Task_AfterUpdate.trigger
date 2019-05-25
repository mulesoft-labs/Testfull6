/*********************************************************************
*
*   File Name: Task_AfterUpdate.trigger
*
*   File Description: Task trigger handling all after update events
*
**********************************************************************
*
*   Date            Author                 Change
*   07/29/14        Rob                    Initial Creation                          
*
*********************************************************************/

trigger Task_AfterUpdate on Task (after update) 
{
    //updates the Activity fields for contact and lead records
    //ActivityCountHandler.updateActivityCount(trigger.new);
}