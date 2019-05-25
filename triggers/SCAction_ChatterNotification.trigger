trigger SCAction_ChatterNotification on SC_Action__c (after insert, after update) {

        Set<String> userIds = new Set<String>();
        Set<String> scLeadIds = new Set<String>();
        List<FeedItem> feedList = new List<FeedItem>();
        Set<String> oppIds = new Set<String>();
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        Map<String, String> usrSCLeadMaps = new Map<String,String>();
      
        
        for (SC_Action__c sca : Trigger.new){
           if(sca.Not_Available__c == true || sca.Need_Help__c==true) {                           
                userIds.add(sca.CreatedById);
                userIds.add(sca.LastModifiedById);
                oppIds.add(sca.Opportunity__c);                       
           }
        }//FOR
        
        if(userIds.size() > 0 && oppIds.size() > 0)     
        {
        
            List<User> userList = [SELECT Region__c, SC_Hierarchy__c, FirstName, LastName, Id from User where Id IN:userIds];
            List<String> scHierarchyList = new List<String>();
           
            for(User usr : userList){
                System.debug('SC Hierarchy Id = ' + usr.SC_Hierarchy__c);
                scHierarchyList.add(usr.SC_Hierarchy__c);               
            }
            
            List<User> scLeadList = [SELECT Region__c, SC_Hierarchy__c, FirstName, LastName, Id from User where Id IN:scHierarchyList];

            /*if(scLeadList.size () > 0)            
            {
                System.debug('SC Lead Exists = ' + scLeadList.size());
                for(User usr : userList){
                    for(User scLead : scLeadList){
                        if(usr.Region__c == scLead.Region__c){
                            usrSCLeadMaps.put(usr.Id, scLead.Id);
                        }
                    }
                }
            }*/
         
            List <Opportunity> oppList = [SELECT 
                OwnerId, Id, Name, StageName, Probability, Tech_Assessment__c,CloseDate,
                AccountId, Amount
                FROM Opportunity WHERE Id IN :oppIds];
                
            for (SC_Action__c sca : Trigger.new)
            {
                try{    
                    FeedItem notAvailablepost = new FeedItem();
                    FeedItem needHelppost = new FeedItem();
                
                    for(User usr : userList){
                        if(usr.Id == sca.LastModifiedById){                            
                            if(sca.Not_Available__c == true){
                                notAvailablepost.LinkURL = sfdcURL + sca.Id;
                                notAvailablepost.ParentId = usr.SC_Hierarchy__c;
                                notAvailablepost.Title = sca.Action_Type__c;
                                notAvailablepost.Body = 'SC Not Available : ' + '\nCreated By : ' + usr.FirstName + ' ' + usr.LastName +                                  
                                 '\nSC Action : ' + sca.Action_Type__c + + '\nOpportunity : ' ;  
                            }if(sca.Need_Help__c == true){
                                 needHelppost.LinkURL = sfdcURL + sca.Id;
                                 needHelppost.ParentId = usr.SC_Hierarchy__c;
                                 needHelppost.Title = sca.Action_Type__c;
                                 needHelppost.Body = 'SC Needs Help : ' + '\nCreated By : ' + usr.FirstName + ' ' + usr.LastName + 
                                 '\nSC Action : ' + sca.Action_Type__c + ' \nOpportunity : ' ;                                  
                            }                                         
                        } 
                    }//userList
                    
              
                    for(Opportunity opp:oppList){
                        if(opp.Id == sca.Opportunity__c){  
                            String oppdetails = opp.Name + 
                             '\nStage : ' + opp.StageName +
                             '\nProbability : ' + opp.Probability +
                             '\nAmount : ' + opp.Amount + 
                             '\nClose Date : ' + opp.CloseDate;
                            
                            if(!String.isBlank(needHelppost.Body))
                            {                         
                                 needHelppost.Body = needHelppost.Body + oppdetails;
                            }
                            if(!String.isBlank(notAvailablepost.Body))
                            {                         
                                 notAvailablepost.Body = notAvailablepost.Body + oppdetails;
                            }
                        }         
                    }
                    
                    
                    System.debug ('PRINT Chatter Body Not Available = ' + notAvailablepost.body );
                     System.debug ('PRINT Chatter Body Need HElp = ' + needHelppost.body );
                    
                    if(!String.isBlank(notAvailablepost.Body) && notAvailablepost.parentId != null){
                        feedList.add(notAvailablepost);  
                    } 
                    if(!String.isBlank(needHelppost.Body) && needHelppost.parentId != null){
                        feedList.add(needHelppost);  
                    }     
                }catch (Exception e){
                    sca.addError ('ERROR : Please contact you system admistrator');
                }
            
            } //SCA Trigger    
        }// main if condition
        if(feedList.size() > 0){
            insert feedList;
        }

}