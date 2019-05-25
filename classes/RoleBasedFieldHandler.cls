/**
Last modified by Andreas Slovacek
Last modified date 11 July 2016

Changelog:

11 July 2016 - Andreas: 1) Constructor for RoleBasedFieldHandler.process(trigger.new, trigger.old).  Only
						call the process function if the Role field is updated.
						2) Process now updates Function as AD if they are an ADR

16 June 2016 - Andreas: Added comments. Added "else" in process(List<User> userlist) to check the Sales
						management checkbox if the user has less fields. Second thought need more 
						specifiers.
						Manangers by Role X Profile: ADR, CSM, Sales are all different

20 May 2016 - Andreas:  change """us.Sales_Region__c = DIRECTION_DICT.get(parts[2].toUpperCase());""" 
						to """us.Sales_Region__c = parts[2].toUpperCase();""" because the dictionary
						only contains values pertinent to NA. Instead we should handle the roles
						generally. This avoids updating this class even if role names change.
*/

public with sharing class RoleBasedFieldHandler{
    private final static Map<String,String> DIRECTION_DICT = new Map<String,String> {
        'n' => 'North',
        'w' =>'West',
        'e' => 'East',
        's'=>'South'
    } ;
    private final static Map<String,String> FUNCTTYPE_DICT= new Map<String,String> {
        'e' => 'Enterprise',
        'm' =>'Market Response',
        's' => 'Strategic',
        'c'=>'Commercial'
    } ;

        
     /**
     * Function: Public static void process(List<User> userListNew, List<User> userListOld)
     * Purpose: If User Role has changed then call process()
     * Method: 	Create a map of the old Role values; check that the new value doesn't match the
     * 			old value; add the user to usersNeedingUpdate and call process() on 
     * 			usersNeedingUpdate.
     */     
        public static void process(List<User> userListUpdated, List<User> userListOld){
            
            List<User> usersNeedingUpdate = new List<User>(); // List to call process on
            Map<Id, User> oldUser = new Map<Id, User>(userListOld);// Map of Ids with previous values

            
            // Add users and their new roles to updatedUser map
            for(User u : userListUpdated){
                
                // Compare new value to old map value and add to list if changed
                if( oldUser.get( u.Id ).UserRoleId != u.UserRoleId  ){
                    usersNeedingUpdate.add(u);
                }// end if( oldUser.get( u.Id ) != u.UserRoleId  )
                
            }// end for(User u : userListUpdated)
            
            
            // process the list of Users needing updates
            if( !usersNeedingUpdate.isEmpty() ){
                process(usersNeedingUpdate);
            }// if( !usersNeedingUpdate.isEmpty() )
        }// end public static void process(List<User> userListNew, List<User> userListOld)
        
        
        
        
        
    public static void process(List<User> userlist){
        Map<Id,String> mapOfRoleIDandRole= new Map<Id,String>();
        mapOfRoleIDandRole= getUserRoleName(userlist);
        for(User us : userlist){
            us.Function__c = us.Territory__c = us.Sales_Region__c = us.Function_type__c ='';
            if(us.userRoleId!=NULL && mapOfRoleIDandRole.get(us.userRoleId).contains('-')){
                List<String> parts = mapOfRoleIDandRole.get(us.userRoleId).split('-');
                if(parts.size() > 0 && !parts.isEmpty()){
                    us.Function__c = us.Territory__c = us.Sales_Region__c = us.Function_type__c ='';
                    us.Territory__c = parts[0];
                    if(parts.size() > 1){// Fill Function
                        // If ADR label function as AD, otherwise use parts[1]
                        if( parts[1] == 'ADR'){
                            us.Function__c = 'AD';
                        }// end if( parts[1] == 'ADR')
                        else{
                        	us.Function__c = parts[1];
                        }// end else
                    }// end if(parts.size() > 1)
                    if(parts.size() > 2){// Fill "Sales Region"
                        us.Sales_Region__c = parts[2].toUpperCase(); 
                    }// end if(parts.size() > 2)
                    if(parts.size() > 3){ // If Commercial, Enterprise or Strategic is delimited then note it in "Segment"
                        us.Function_type__c =FUNCTTYPE_DICT.get(parts[3].toLowerCase());
                    }// end if(parts.size() > 3)
/*                    else{
                        // if parts.size() <= 3 then the user is at a manager level
						us.Sales_Manager__c = TRUE;                        
                    }// end else
  */                  
                    
                    
                }// end if(parts.size() > 0 && !parts.isEmpty()){
            }// end if(us.userRoleId!=NULL && mapOfRoleIDandRole.get(us.userRoleId).contains('-'))
        }// end  for(User us : userlist)
    }// end public static void process(List<User> userlist)

    
    
    
    
    private static Map<Id,String> getUserRoleName(List<User> users){
        Set<Id> userIds = new Set<Id>();
        
        for(User usr : users){
            if(usr.UserRoleId !=Null){
                userIds.add(usr.UserRoleId);
            } 
               
        }// end for(User usr : users)
        
        Map<Id,String> mapOfUserIDAndRoleName = new Map<Id,String>();
        
        
        for(UserRole role :[SELECT Id,Name FROM userRole WHERE id in:userIds]){
            mapOfUserIDAndRoleName.put(role.Id,role.Name);     
        }// end for(UserRole role :[SELECT Id,Name FROM userRole WHERE id in:userIds])
        return mapOfUserIDAndRoleName;
    }// end private static Map<Id,String> getUserRoleName(List<User> users)
    
    

    
    
    
}// end public with sharing class RoleBasedFieldHandler