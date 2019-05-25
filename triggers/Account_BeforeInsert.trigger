/*********************************************************************
*
*   File Name: Account_BeforeInsert 
*
*   File Description: Trigger that will run on before update Event
*
**********************************************************************
*
*   Date        Author                      Change
*   10/12/14    Rob                         Initial Creation                        
*
*********************************************************************/
trigger Account_BeforeInsert on Account (before insert) {
    //TODO: Move this to handler
    // call to update Region and Sub Region of Account
    //AccountRegionHandler.AccountBeforeInsert(trigger.new);
}