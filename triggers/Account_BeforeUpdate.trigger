/*********************************************************************
*
*   File Name: Account_BeforeUpdate 
*
*   File Description: Trigger that will run on before update Event
*
**********************************************************************
*
*   Date        Author                      Change
*   10/12/14    Rob                         Initial Creation                        
*   11/11/16    Santoshi                    Added acount team member logic and activated the trigger as there was no other trigger for before update
*********************************************************************/
trigger Account_BeforeUpdate on Account (before update) {
    
    // call to update Region and Sub Region of Account
   // AccountRegionHandler.AccountBeforeUpdate(trigger.new, trigger.oldMap); 
   //SM 12/1 - The above method was already commented as the trigger was inactive.
      
   //SM - Added below code to call the update Account Team Member

    // AccountTriggerHelper.updateAccountTeamMember(trigger.new,trigger.oldMap);
    
}