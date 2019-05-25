trigger OppTeam_ChatterAfterInsert on OpportunityTeamMember (after insert) {
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
                userIds.add(otm.UserId);
                userIds.add(otm.CreatedById);
                oppIds.add(otm.OpportunityId);                       
            }
        }
        
        if(userIds.size() > 0 && oppIds.size() > 0)     
        {
        
            List<User> userList = [SELECT FirstName, LastName, Id from User where Id IN :userIds];
            List <Opportunity> oppList = [SELECT 
                OwnerId, Id, Name,
                AccountId, Amount
                FROM Opportunity WHERE Id IN :oppIds];
            
            for (OpportunityTeamMember otm : Trigger.new){
                
                if(otm.TeamMemberRole=='Solutions Consultant - Primary' ||
                   otm.TeamMemberRole=='Solutions Consultant - Secondary' ||
                   otm.TeamMemberRole=='Solutions Consultant - Shadowing')
                {
                    FeedItem post = new FeedItem();
                    FeedItem aePost = new FeedItem();
                
                    for(User usr : userList){
                        if(usr.Id == otm.UserId){
                            post.LinkURL = sfdcURL + otm.OpportunityId;
                            post.ParentId = usr.Id;
                            aePost.LinkURL = sfdcURL + otm.OpportunityId;
                            
                            aePost.Body = 'SC Assigned :  '+ usr.FirstName + ' ' + usr.LastName + ' is the ' + otm.SC_Role_Details__c + ' SC on ' + '\nOpportunity : ';
                            post.Body = 'SC Assigned : You have been assigned as ' + otm.SC_Role_Details__c + ' SC on ' + '\nOpportunity : ';                                         
                        } 
                    }
                    
                    for(Opportunity opp:oppList){
                        if(opp.Id == otm.OpportunityId){
                            aePost.ParentId = opp.OwnerId; 
                            post.Title = opp.Name;
                            aePost.Title = opp.Name; 
                            post.Body = post.Body + opp.Name;
                            aePost.Body = aePost.Body + opp.Name;                                
                        }         
                    }
                    
                    feedList.add(post);
                    feedList.add(aePost);
                }
              
            }       
    
        }
       // List<EntitySubscription> followers = [select id, subscriberid, subscriber.name from EntitySubscription where parentid =:ot];
        if(subscriptionList.size() > 0){
            insert subscriptionList;
        }
        
        if(feedList.size() > 0){
            insert feedList;
        }
      }  
}