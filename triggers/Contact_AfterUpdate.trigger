/*********************************************************************
*
*   File Name: AfterUpdate.trigger
*
*   File Description: Contact Trigger handling all after update events
*
**********************************************************************
*
*   Date            Author                 Change
*   07/29/14        Rob                    Initial Creation                          
*
*********************************************************************/

trigger Contact_AfterUpdate on Contact (after update)
{
    ActivityCountHandler.updateAccountActivity(trigger.new, trigger.oldMap);
}