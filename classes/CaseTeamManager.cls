public class CaseTeamManager{
    public static void addCreator(List<Case> cases){
        Map<String,Case> emailCaseMap = getEmailCaseMap(cases);
        if(!emailCaseMap.isEmpty()){
            Id creatorRoleId = getCreatorRoleId();
            Map<Id,CaseTeamMember> caseTeamMembersMap = getCaseTeamMembers(creatorRoleId,emailCaseMap);
            caseTeamMembersMap = filter(creatorRoleId,caseTeamMembersMap);
            insert caseTeamMembersMap.values();
        }
    }

    private static Map<Id,CaseTeamMember> filter(Id creatorRoleId,Map<Id,CaseTeamMember> caseTeamMembersMap){
        for (CaseTeamMember ctm : [
            SELECT Id, MemberId, ParentId
            FROM CaseTeamMember
            WHERE ParentId IN :caseTeamMembersMap.keySet() AND TeamRoleId=:creatorRoleId
            ORDER BY ParentId]) {
            CaseTeamMember ctmD = caseTeamMembersMap.get(ctm.ParentId);
            if(ctmD != NULL && ctmD.MemberId == ctmD.MemberId){
                caseTeamMembersMap.remove(ctm.ParentId);
            }
        }
        return caseTeamMembersMap;
    }

    private static Map<Id,CaseTeamMember> getCaseTeamMembers(Id creatorRoleId,Map<String,Case> emailCaseMap){
        Map<Id,CaseTeamMember> membersToAdd = new Map<Id,CaseTeamMember>();
        for(User u : [
            SELECT Id,Email 
            FROM User 
            WHERE Email IN:emailCaseMap.keySet() and IsActive=true]){
            membersToAdd.put(emailCaseMap.get(u.Email).Id,new CaseTeamMember(                   
                ParentId = emailCaseMap.get(u.Email).Id,                           
                MemberId = u.Id,
                TeamRoleId = creatorRoleId
              )
            );
        }
        return membersToAdd;
    }
    
    private static Map<String,Case> getEmailCaseMap(List<Case> cases){
        Map<String,Case> emailCaseMap = new Map<String,Case>();
        for (Case c : cases) {
            if(String.isNotBlank(String.valueof(c.SuppliedEmail))){
                emailCaseMap.put(string.valueOf(c.SuppliedEmail),c);
            }   
        }  
        return emailCaseMap;
    }

    private static Id getCreatorRoleId(){
        Id rid;
        for(CaseTeamRole ct : [
                SELECT Id 
                FROM CaseTeamRole 
                WHERE Name = 'Creator' LIMIT 1]){
            rid = ct.Id;
        }
        return rid;
    }
}