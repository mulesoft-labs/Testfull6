/*********************************************************************
*
*   File Name: Task_AfterDelete.trigger
*
*   File Description: Task trigger handling all after delete events
*
**********************************************************************
*
*   Date            Author                 Change
*   07/29/14        Rob                    Initial Creation                          
*
*********************************************************************/
trigger Task_AfterDelete on Task (after delete) 

{
    //updates the Activity fields for contact and lead records
    //ActivityCountHandler.updateActivityCount(trigger.old);
}