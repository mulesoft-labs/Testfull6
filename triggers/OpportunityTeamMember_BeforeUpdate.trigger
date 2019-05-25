/*********************************************************************
*
*   File Name: OpportunityTeamMember_BeforeUpdate.trigger
*
*   File Description: Handles all before update events for the
*   OpportunityTeam object
*
**********************************************************************
*
*   Date        Author            Change
*   08/21/14    Rob               Initial Creation                          
*
*********************************************************************/

trigger OpportunityTeamMember_BeforeUpdate on OpportunityTeamMember(before update)
{
    // Restricts updating SC Opportunity Team members to SC Leads
    if(!Utilities.currentUser.Trigger_Override__c){            
    	SCTeamMemberRestrictions.checkRoleToAddOpportunityTeamMember(Trigger.New);
    }
}