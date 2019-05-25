trigger OppTeam_ChatterAfterUpdate on OpportunityTeamMember (after update) {
        if(!Utilities.currentUser.Trigger_Override__c){
        Set<String> userIds = new Set<String>();
        List<FeedItem> feedList = new List<FeedItem>();
        List<EntitySubscription> subscriptionList = new List<EntitySubscription>();
        Set<String> oppIds = new Set<String>();
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 

        for (OpportunityTeamMember otm : Trigger.new){
            if(otm.TeamMemberRole=='Solutions Consultant - Primary' ||
               otm.TeamMemberRole=='Solutions Consultant - Secondary' ||
               otm.TeamMemberRole=='Solutions Consultant - Shadowing')
            {
               OpportunityTeamMember oldTeam = Trigger.oldMap.get(otm.ID);
               if (otm.SC_Role_Details__c != oldTeam.SC_Role_Details__c){ 
                   userIds.add(otm.UserId);
                   oppIds.add(otm.OpportunityId);                        
                   userIds.add(oldTeam.UserId);
               }              
            }//Solution Consultant
        }//FOR
        
        if(userIds.size() > 0 && oppIds.size() > 0)     
        {
        
            List<User> userList = [SELECT FirstName, LastName, Id from User where Id IN:userIds];
            List <Opportunity> oppList = [SELECT 
                OwnerId, Id, Name,
                AccountId, Amount
                FROM Opportunity WHERE Id IN :oppIds];
                  
            for (OpportunityTeamMember otm : Trigger.new){
                
                FeedItem post = new FeedItem();
                FeedItem aePost = new FeedItem();
                OpportunityTeamMember oldTeam = Trigger.oldMap.get(otm.ID);          
                for(User usr : userList)
                {
                    if(usr.Id == otm.UserId)
                    {
                        post.LinkURL = sfdcURL + otm.OpportunityId;
                        post.ParentId = usr.Id;
                        aePost.LinkURL = sfdcURL + otm.OpportunityId;
                        aePost.Body = 'SC Role Changed : ' + usr.FirstName + ' ' + usr.LastName + 'has NEW ' + otm.SC_Role_Details__c + ' SC Role in the opportunity below';                                      post.Body = 'SC Role Changed : ' + ' your role changed to  ' + otm.SC_Role_Details__c + ' SC in the opportunity below';                             
                             
                     }                                
                  } 
                
                for(Opportunity opp:oppList){
                    if(opp.Id == otm.OpportunityId){
                        aePost.ParentId = opp.OwnerId; 
                        post.Title = opp.Name;
                        aePost.Title = opp.Name; 
                                    
                    }         
                }
                System.debug ('PRINT Chatter Body = ' + post.body );
                feedList.add(post);
                feedList.add(aePost);
               
            }       
    
        }
        if(feedList.size() > 0){
            insert feedList;
        }
    }    
}