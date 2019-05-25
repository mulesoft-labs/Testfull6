trigger UpdateLeadOwnerRole on Lead (before insert, before update) {
    /*  
    List<Id> ownerIds = new List<Id>();
    
    List<Lead> leads = Trigger.new;
    
    
    for (Lead l:leads) {
        
        
        ownerIds.add(l.ownerId);
        
        
    }
    
    
    Map<Id,User> users = new Map<Id,User>([select id,name,userroleid from User where id in:ownerIds]);
    
    
    
    
    List<Id> userroleids = new List<Id>();
    
    
    
    for (User u:users.values()) {
        
        
        userroleids.add(u.userroleid);
        
        
        
    }
        
        
    Map<Id,UserRole> userroles = new Map<Id,UserRole>([select id,name from UserRole where id in:userroleids]);
    
    
    
    Map<Id,String> userRoleNameMap = new Map<Id,String>();
    
    
    for (User u:users.values()) {
        
        Id userroleid = u.userroleid;
        
        if (userroleid!=null)  {
        
        UserRole role = userRoles.get(userroleid);
        
        String userRoleName = role.name;
        
        userRoleNameMap.put(u.id,userRoleName);
        
        }
        
    }
    
    
    for (Lead l:leads) {
        
        
        Id leadOwnerId = l.ownerid;
        
        if (leadOwnerId!=null&&l.IsConverted==false) {
        
        String userRoleName = userRoleNameMap.get(leadOwnerId);
        
        l.Lead_Owner_Role__c = userRoleName;
        
        }
        
        
    }
    */
}