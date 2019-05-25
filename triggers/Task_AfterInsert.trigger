/*********************************************************************
*
*   File Name: Task_AfterInsert.trigger
*
*   File Description: Task trigger handling all after insert events
*
**********************************************************************
*
*   Date            Author                 Change
*   07/29/14        Rob                    Initial Creation                          
*
*********************************************************************/

trigger Task_AfterInsert on Task (after insert) 
{
    //updates the Activity fields for contact and lead records
    //ActivityCountHandler.updateActivityCount(trigger.new);
}