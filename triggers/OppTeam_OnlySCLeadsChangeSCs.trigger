trigger OppTeam_OnlySCLeadsChangeSCs on OpportunityTeamMember (before insert, before update, before delete) {
     Set<String> userIds = new Set<String>();
     String errorMsgUser = 'Please contact your SC lead in your region to add or change SC\n';
     String errorMsgSCLead = 'SC Leads can add or change SCs only in their region\n';
     String errorMsgBlankSCRole = 'Please enter a role details for the SC\n';
     
     
     List<OpportunityTeamMember> oppTeamMemberList = new List<OpportunityTeamMember>();
     Set<String> oppIds = new Set<String>();
     Map<String, User> oppOwnerMap = new Map<String,User>();
     Map<String, User> memberOtmMap = new Map<String,User>();
     Map<String, User> userOtmMap = new Map<String,User>();
     
     if(trigger.isdelete)
     {     
         for (OpportunityTeamMember otm : Trigger.old){
            userIds.add(UserInfo.getUserId());
            userIds.add(otm.UserId);
            oppIds.add(otm.OpportunityId);
            oppTeamMemberList.add(otm);  
         }
     }else if (trigger.isInsert || trigger.isUpdate){
         for (OpportunityTeamMember otm : Trigger.new){
             userIds.add(UserInfo.getUserId());
             userIds.add(otm.UserId);
             oppIds.add(otm.OpportunityId);
             oppTeamMemberList.add(otm);             
         }    
     }
     
     if(userIds.size()> 0 && oppTeamMemberList.size() > 0)    
     {
         List<Opportunity> oppList = [SELECT OwnerId, Id from Opportunity where Id IN:oppIds];
         for(Opportunity opp:oppList){
             userIds.add(opp.OwnerId);        
         }
         
         List<User> userList = [SELECT Division, UserRole.Name, SC_Hierarchy__c, FirstName, LastName, Team_Role__c, Region__c, Id from User where Id IN:userIds];
     
         for (Opportunity opp : oppList){
             for(User user:userList){
                if(user.Id==opp.OwnerId){
                    oppOwnerMap.put(opp.Id,user);
                }
             }
         }
         
         for (OpportunityTeamMember otm : oppTeamMemberList){
             for(User user:userList){
                if(user.Id==otm.UserId){
                    memberOtmMap.put(otm.OpportunityId,user);
                }
                if(user.Id==UserInfo.getUserId()){
                    userOtmMap.put(otm.OpportunityId,user);
                }
             }
         }
         
         for (OpportunityTeamMember otm : oppTeamMemberList)
         {
             try{
                 User member = memberOtmMap.get(otm.OpportunityId);
                 if (member != null)
                 {
                     if(member.Division == 'Solution Consulting'|| otm.TeamMemberRole =='Solution Consultant')
                     {
                        User currentUser = userOtmMap.get(otm.OpportunityId);                    
                        if(otm.TeamMemberRole =='Solution Consultant' && member.Division != 'Solution Consulting'){
                            otm.addError('Only SC Team members can add Solution Consultant role');
                        } 
                  
                        if(currentUser.Team_Role__c != 'Lead'){
                            otm.addError(errorMsgUser);                                         
                        }else{

                           //otm.TeamMemberRole = 'Solution Consultant';
                           User oppOwner = oppOwnerMap.get(otm.OpportunityId);
                           //System.debug('Shuba = ' + oppOwner.UserRole.Name);
                           System.debug('Opp Owner Region = ' + oppOwner.Region__c);
                           System.debug('Current User Region = ' + currentUser.Region__c);
                            System.debug('Member  Region = ' + member.Region__c);
                           
                           /*if(oppOwner.UserRole.Name != null && !(oppOwner.UserRole.Name.substringAfterLast('-').contains(currentUser.Region__c)))
                           {
                               if(currentUser.Region__c != 'Global'){
                                   otm.addError(errorMsgSCLead);
                               }
                           }*/
                           if(oppOwner.Region__c != null && oppOwner.Region__c != currentUser.Region__c)
                           {
                               if(currentUser.Region__c != 'Global'){
                                   otm.addError(errorMsgSCLead);
                               }
                           }
                           
                           if(currentUser.Region__c != member.Region__c && currentUser.Region__c != 'Global'){
                                otm.addError(errorMsgSCLead);
                           }
                           if(String.isBlank(otm.SC_Role_Details__c)){
                                otm.SC_Role_Details__c.addError(errorMsgBlankSCRole);
                           } 
                           
                        }                                
                     }
                 }
             }catch(Exception e){
                 otm.addError('System Error - Please contact your administrator');                      
             }          
         }  
     }
     
     
}