/*********************************************************************
*
*   File Name: OpportunityTeamMember_BeforeDelete.trigger
*
*   File Description: Handles all before delete events for the
*   OpportunityTeam object
*
**********************************************************************
*
*   Date        Author            Change
*   08/21/14    Rob               Initial Creation                          
*
*********************************************************************/

trigger OpportunityTeamMember_BeforeDelete on OpportunityTeamMember(before delete)
{
    if(!Utilities.currentUser.Trigger_Override__c){ 
    	// Restricts deleting SC Opportunity Team members to SC Leads        
    	SCTeamMemberRestrictions.checkRoleToAddOpportunityTeamMember(Trigger.old);
    }
}