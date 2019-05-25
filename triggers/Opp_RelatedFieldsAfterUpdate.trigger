trigger Opp_RelatedFieldsAfterUpdate on Opportunity (after update) {

       /*List<Profile_Qualification__c> solnAssessments = new List<Profile_Qualification__c>();
       Set<String> oppIds = new Set<String>();
       Set<String> oppNameChangedIds = new Set<String>();
       
       
       for (Opportunity o : Trigger.new) {
           if(o.Type == 'New Business' || o.Type =='Add-On Business'){
                if(o.StageName != 'Closed Won' && o.StageName != 'Rejected Lead'){
                    oppIds.add(o.Id);
                }      
           }
        }
        
        List<Profile_Qualification__c> solnList = [SELECT Id,   
             What_is_the_use_case_s__c,
             What_business_problem_are_they_solving__c,
             What_is_the_business_impact_AND_ROI__c,
             What_is_the_compelling_event__c,
             Evaluation_Go_live_Timelines__c,
             Current_or_Past_Integration_Strategy__c,
             Competition__c,
             Existing_ESB_or_other_technology__c,
             Describe_Developer_Skillset__c
             from Profile_Qualification__c where Opportunity__c IN :oppIds ORDER BY CreatedDate DESC];
             
       //Update Related Field in Tech Assessment
       if(!solnList.isEmpty())
       {                   
            for (Opportunity o : Trigger.new) {
                boolean isOppChanged = false;
                Opportunity oldOpportunity = Trigger.oldMap.get(o.ID);  
                for(Profile_Qualification__c solnAssessment:solnList)
                {
                  if(solnAssessment.Id == o.Tech_Assessment__c)
                  
                  {
                    if(o.Name != oldOpportunity.Name){
                         solnAssessment.Name = o.Name + '-' + 'Solution Assessment';
                         oppNameChangedIds.add(o.Id);
                         isOppChanged = true;                    
                    }
                    if(o.What_is_the_use_case_s__c != oldOpportunity.What_is_the_use_case_s__c){
                       solnAssessment.What_is_the_use_case_s__c=o.What_is_the_use_case_s__c;
                       isOppChanged = true;
                    }
                    if(o.What_business_problem_are_they_solving__c != oldOpportunity.What_business_problem_are_they_solving__c){
                        solnAssessment.What_business_problem_are_they_solving__c = o.What_business_problem_are_they_solving__c;
                        isOppChanged = true;
                    }
                    if(o.Opp_Business_Impact_ROI__c != oldOpportunity.Opp_Business_Impact_ROI__c){
                        solnAssessment.What_is_the_business_impact_AND_ROI__c = o.Opp_Business_Impact_ROI__c;
                        isOppChanged = true;
                    }
                    if(o.Compelling_Event__c != oldOpportunity.Compelling_Event__c){
                        solnAssessment.What_is_the_compelling_event__c = o.Compelling_Event__c;
                        isOppChanged = true;
                    }
                    
                    if(o.Evaluation_Go_live_Timelines__c != oldOpportunity.Evaluation_Go_live_Timelines__c){
                        solnAssessment.Evaluation_Go_live_Timelines__c = o.Evaluation_Go_live_Timelines__c;
                        isOppChanged = true;
                    }
                    
                    if(o.What_company_integration_strategy__c != oldOpportunity.What_company_integration_strategy__c){
                        solnAssessment.Current_or_Past_Integration_Strategy__c = o.What_company_integration_strategy__c;
                        isOppChanged = true;
                    }
                    
                    if(o.Who_is_the_competition__c != oldOpportunity.Who_is_the_competition__c){
                        solnAssessment.Competition__c = o.Who_is_the_competition__c;
                        isOppChanged = true;
                    }
                    
                    if(o.Existing_ESB_other_technology__c != oldOpportunity.Existing_ESB_other_technology__c){
                        solnAssessment.Existing_ESB_or_other_technology__c = o.Existing_ESB_other_technology__c;
                        isOppChanged = true;
                    }
                    
                    if(o.Developer_skills__c != oldOpportunity.Developer_skills__c){
                        solnAssessment.Describe_Developer_Skillset__c = o.Developer_skills__c;
                        isOppChanged = true;
                    }
                    
                    if(isOppChanged == true){      
                        solnAssessments.add(solnAssessment);           
                    }
                
                    }
                }//FOR TECH           
            }//FOR OPP
        }
        if(!solnAssessments.isEmpty()){ 
            update solnAssessments;
        }*/
}