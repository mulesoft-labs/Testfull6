/*********************************************************************
*
*   File Name: AccountTeam_BeforeDelete.trigger
*
*   File Description: Handles all before delete events for the
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

trigger AccountTeam_BeforeDelete on Account_Team__c(before delete)
{
    // Restricts deleting SC Account Team members to SC Leads    
    // SCTeamMemberRestrictions.checkRoleToAddAccountTeamMember(Trigger.old);    
}