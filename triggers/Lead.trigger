/*
* Name : Lead
* Author : Rohit Mehta (Apprivo)
* Date : 05/02/2010
* Usage : Called on Lead Convert. Checks if lead got converted and if lead RT is in the configured RT.
* If yes calls a future method to add user to sales team.
*/
trigger Lead on Lead (after update) {
/*
    Map <Id, Lead> leads = new Map <Id, Lead> ();
    Map<Id, Id> oppId_Partner_Map = new Map<Id, Id>(); 
    Map<Id,Id> OppId_Userid_Map = new map<id,id>();
    map<id,String> TeamMemberRoleMap = new map<id,String>();
    
    ATST_Settings__c defaultApplicationSettings = AddToSalesTeam.getDefaultApplicationSettings();

    //no record types configured..nothing to do.
    if(defaultApplicationSettings.Lead_Record_Types__c == null) {
        return;
    }

    Set<Id> leadRecordTypes = new Set<Id>();
    for (String rt : defaultApplicationSettings.Lead_Record_Types__c.split(';')) {
        leadRecordTypes.add(rt);
    }
    for (Lead l: trigger.new){
        String leadRT = l.recordTypeId;
        if(leadRT == null){
            continue;
        }
        leadRT = leadRT.substring(0,15);         
        
        if (trigger.oldMap.get(l.Id).IsConverted || (!l.IsConverted) || (! leadRecordTypes.contains(leadRT))) {
            continue;   
        }
        
        if (l.ConvertedOpportunityId != null)
            oppId_Partner_Map.put(l.ConvertedOpportunityId, trigger.OldMap.get(l.Id).OwnerId);


    }

    if (! oppId_Partner_Map.isEmpty())
        AddToSalesTeam.addPartnerToSalesTeamFuture(oppId_Partner_Map);
    
    
    //add current User to the Opportunity Team if the role contains ADR or sales for the converted oppty
    map<string,string> USRROLE_TEAMRROLE_MAP=AddToSalesTeam.USRROLE_TEAMRROLE_MAP;
    list<UserRole> uroleObj = [select Id,Name from UserRole where Id=:userInfo.getUserRoleId() limit 1];
    for(string sRole:USRROLE_TEAMRROLE_MAP.keySet()){
        if(!uroleObj.isEmpty() && uroleObj[0].Name.containsIgnoreCase(sRole)){
            for(Lead l: trigger.new){
                if (l.ConvertedOpportunityId != null && (trigger.oldMap.get(l.Id).IsConverted !=l.IsConverted))
                 {  
                    OppId_Userid_Map.put(l.ConvertedOpportunityId, userInfo.getUserid());
                    TeamMemberRoleMap.put(userInfo.getUserid(),USRROLE_TEAMRROLE_MAP.get(sRole));
                 }
            }
    }}
    
    if(!OppId_Userid_Map.isEmpty()){
         AddToSalesTeam.addStandarduserToSalesTeamFuture(OppId_Userid_Map,TeamMemberRoleMap);
    }
    */
}