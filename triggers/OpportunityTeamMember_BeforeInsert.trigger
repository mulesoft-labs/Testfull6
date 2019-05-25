/*********************************************************************
*
*   File Name: OpportunityTeamMember_BeforeInsert.trigger
*
*   File Description: Handles all before insert events for the
*	OpportunityTeam object
*
**********************************************************************
*
*   Date		Author			  Change
*	08/21/14	Rob				  Initial Creation							
*
*********************************************************************/

trigger OpportunityTeamMember_BeforeInsert on OpportunityTeamMember(before insert)
{
	// Restricts adding SC Opportunity Team members to SC Leads          
    SCTeamMemberRestrictions.checkRoleToAddOpportunityTeamMember(Trigger.New);    
}