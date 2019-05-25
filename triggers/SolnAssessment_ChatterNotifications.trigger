trigger SolnAssessment_ChatterNotifications on Profile_Qualification__c (after insert, after update) 
{
        Set<String> userIds = new Set<String>();
        Set<String> scLeadIds = new Set<String>();
        List<FeedItem> feedList = new List<FeedItem>();
        Set<String> oppIds = new Set<String>();
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        Map<String, String> usrSCLeadMaps = new Map<String,String>();
      
        
        for (Profile_Qualification__c  pq : Trigger.new){
           if(pq.Is_MuleSoft_Technical_Fit__c=='No') {                           
                userIds.add(pq.LastModifiedById);
               /* if(pq.Owner__c != null){
                    userIds.add(pq.Owner__c);
                }*/
                oppIds.add(pq.Opportunity__c);                       
           }
        }//FOR
        
        if(userIds.size() > 0 && oppIds.size() > 0)     
        {
        
            List<User> userList = [SELECT Region__c, SC_Hierarchy__c, FirstName, LastName, Id from User where Id IN:userIds];
            List<String> scHierarchyList = new List<String>();
           
            for(User usr : userList){
                System.debug('SC Hierarchy Id = ' + usr.SC_Hierarchy__c);
                scHierarchyList.add(usr.SC_Hierarchy__c);  
                usrSCLeadMaps.put(usr.Id, usr.SC_Hierarchy__c);             
            }
            
            List<User> scLeadList = [SELECT Region__c, SC_Hierarchy__c, FirstName, LastName, Id from User where Id IN:scHierarchyList];

            List <Opportunity> oppList = [SELECT 
                OwnerId, Id, Name, StageName, Probability, Tech_Assessment__c,
                AccountId, Amount
                FROM Opportunity WHERE Id IN :oppIds];
            
             for (Profile_Qualification__c pq : Trigger.new)
             {
                try{    
                    FeedItem post = new FeedItem();
                
                    for(User usr : userList){
                        if(usr.Id == pq.LastModifiedById){
                            post.LinkURL = sfdcURL + pq.Id;
                            post.ParentId = usrSCLeadMaps.get(usr.Id);
                            post.Title = pq.Name;
                            post.Body = 'SC usecase is not a technical fit : ' + ' \nOpportunity : ' ;                                      
                        } 
                    }//userList
                    
              
                    for(Opportunity opp:oppList){
                        if(opp.Id == pq.Opportunity__c){                   
                             post.Body = post.Body + opp.Name + 
                             '\nStage : ' + opp.StageName +
                             '\nProbability : ' + opp.Probability +
                             '\nAmount : ' + opp.Amount;
                        }         
                    }
                    
                    for(User usr : userList){
                        if(usr.Id == pq.LastModifiedById){
                           post.Body = post.Body   + '\nCreated by : ' + usr.FirstName + ' ' + usr.LastName;                       
                        }
                    }
                    
                    System.debug ('PRINT Chatter Body = ' + post.body );
                    System.debug ('PRINT Parent Id = ' + post.ParentId);
                    if(post.ParentId !=null){
                        feedList.add(post);  
                    }     
                    
                     
                }catch (Exception e){
                    pq.addError ('ERROR : Please contact you system admistrator');
                }
            
            } //SCA Trigger    


        }//End If
        if(feedList.size() > 0){
            insert feedList;
        }

}