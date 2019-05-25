/*********************************************************************
*
*   File Name: AccountTeam_BeforeUpdate.trigger
*
*   File Description: Handles all before update events for the
*   Account_Team__c object
*
**********************************************************************
*
*   Date        Author            Change
*   10/04/14    Rob               Commenting out SCTeamMemberRestrictions
*                                 as custom Account Team Member object
*                                 is no longer being used
*   08/21/14    Rob               Initial Creation                          
*
*********************************************************************/

trigger AccountTeam_BeforeUpdate on Account_Team__c(before update)
{
    // Restricts updating SC Account Team members to SC Leads       
    // SCTeamMemberRestrictions.checkRoleToAddAccountTeamMember(Trigger.New);   
}