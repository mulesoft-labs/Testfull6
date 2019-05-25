/*********************************************************************
*
*   File Name: AccountTeam_BeforeInsert.trigger
*
*   File Description: Handles all before insert events for the
*	Account_Team__c object
*
**********************************************************************
*
*   Date		Author			  Change
*	10/04/14	Rob 			  Commenting out SCTeamMemberRestrictions
*								  as custom Account Team Member object
*								  is no longer being used
*	08/21/14	Rob				  Initial Creation							
*
*********************************************************************/

trigger AccountTeam_BeforeInsert on Account_Team__c(before insert)
{
 	// Restricts adding SC Account Team members to SC Leads     	
 	// SCTeamMemberRestrictions.checkRoleToAddAccountTeamMember(Trigger.New);   
}