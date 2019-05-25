trigger OppTeam_ChatterAfterDelete on OpportunityTeamMember (after delete) {
        if(!Utilities.currentUser.Trigger_Override__c){
            
        Set<String> userIds = new Set<String>();
        List<FeedItem> feedList = new List<FeedItem>();
        List<EntitySubscription> subscriptionRemoveList = new List<EntitySubscription>();
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        Set<String> oppIds = new Set<String>();
        
        for (OpportunityTeamMember otm : Trigger.old){
            if(otm.TeamMemberRole=='Solutions Consultant - Primary' ||
               otm.TeamMemberRole=='Solutions Consultant - Secondary' ||
               otm.TeamMemberRole=='Solutions Consultant - Shadowing')
            { 
                userIds.add(otm.UserId);
                oppIds.add(otm.OpportunityId);
            }
        }
        
        if(userIds.size() > 0 && oppIds.size() > 0)     
        {
            List<User> userList = [SELECT FirstName, LastName, Id from User where Id IN:userIds];
            
            List <Opportunity> oppList = [SELECT 
                OwnerId, Id, Name,
                AccountId, Amount
                FROM Opportunity WHERE Id IN :oppIds];
                
                List<EntitySubscription> subscriptions = [ SELECT ID, ParentId, SubscriberId FROM EntitySubscription 
                                                WHERE ParentId IN :  oppIds];
                                                  
            
            for (OpportunityTeamMember otm : Trigger.old){
                FeedItem post = new FeedItem();
                FeedItem aePost = new FeedItem();
                
                //post.ParentId = otm.OpportunityId;
            
                for(User usr : userList){
                    if(usr.Id == otm.UserId){
                        post.Body = 'SC Removed : You have been removed as ' + otm.SC_Role_Details__c + ' SC from the opportunity below';
                        post.LinkURL = sfdcURL + otm.OpportunityId;
                        post.ParentId = usr.Id;    
                       
                        aePost.Body = 'SC Removed : ' + usr.FirstName + ' ' + usr.LastName + ' removed as the ' + otm.SC_Role_Details__c + ' SC on opportunity below';
                        aePost.LinkURL = sfdcURL + otm.OpportunityId;
                       
                        if(subscriptions.size() > 0){   
                            for(EntitySubscription esub:subscriptions){                                     
                              if(otm.OpportunityId == esub.ParentId && otm.UserId == esub.SubscriberId){
                                 subscriptionRemoveList.add(esub);  
                              }
                            }
                        }
                    } 
                }               
                for(Opportunity opp:oppList){
                    if(opp.Id == otm.OpportunityId){
                        aePost.ParentId = opp.OwnerId; 
                        post.Title = opp.Name;
                        aePost.Title = opp.Name;             
                    }         
                }
                feedList.add(post);
                feedList.add(aePost);                 
            }       

        }
       // List<EntitySubscription> followers = [select id, subscriberid, subscriber.name from EntitySubscription where parentid =:ot];
        if(subscriptionRemoveList.size() > 0){
            delete subscriptionRemoveList;
        }
        if(feedList.size() > 0){
            insert feedList;
        }
    }
}