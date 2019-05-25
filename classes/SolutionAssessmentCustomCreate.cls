public with sharing class SolutionAssessmentCustomCreate {
   
    ApexPages.StandardController c;
    public Opportunity o { get; set; }

    public SolutionAssessmentCustomCreate(ApexPages.StandardController controller) {
        this.c=controller;
        this.o=(Opportunity)c.getRecord();
    }
    
    public pageReference NewSolutionAssessment() {
        
        PageReference newSolnAssessmentURL = null;
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        
        System.debug ('Oppportunity Id = ' + o.Id);
        
        List<Opportunity> currentOpp = [SELECT Id, Tech_Assessment__c, Name,
            What_business_problem_are_they_solving__c,
            Opp_Business_Impact_ROI__c, What_products_are_they_evaluating__c, Compelling_Event__c,
            Who_cares_about_it__c, What_are_the_consequence_of_waiting__c, Evaluation_Go_live_Timelines__c,
            Describe_Evaluation_Process__c, Who_is_the_competition__c, Existing_ESB_other_technology__c,
            What_company_integration_strategy__c, Company_Description__c,Developer_skills__c,
            AccountId, Amount, Additional_Information_Comments__c 
        from Opportunity where Id=:o.Id];
        
        //List <Mutual_Close_Plan__c> mcPlanList = [SELECT mcp.Id, mcp.Opportunity__c from Mutual_Close_Plan__c mcp where mcp.Opportunity__c=:o.Id];
        //List <Mutual_Close_Plan__c> upMCPlanList = new List <Mutual_Close_Plan__c> ();
        
        if(currentOpp.size() > 0)
        {
            System.debug ('Current Opp Id = ' + currentOpp[0].Id);
        
            if(currentOpp[0].Tech_Assessment__c !=null)
            {
               newSolnAssessmentURL = new PageReference(sfdcURL + currentOpp[0].Tech_Assessment__c + '/e?retURL=%2F' + currentOpp[0].Tech_Assessment__c);
            }
            else{
              
                 Profile_Qualification__c solnAssessment = new Profile_Qualification__c();
                 solnAssessment.Name = currentOpp[0].Name + '-' + 'Solution Assessment';
                 solnAssessment.Opportunity__c = currentOpp[0].Id;
                 
                 //solnAssessment.What_is_the_use_case_s__c = currentOpp[0].What_is_the_use_case_s__c;
                 solnAssessment.What_business_problem_are_they_solving__c = currentOpp[0].What_business_problem_are_they_solving__c;
                 solnAssessment.What_is_the_business_impact_AND_ROI__c = currentOpp[0].Opp_Business_Impact_ROI__c;
                 solnAssessment.What_is_the_compelling_event__c = currentOpp[0].Compelling_Event__c;
                 solnAssessment.Evaluation_Go_live_Timelines__c = currentOpp[0].Evaluation_Go_live_Timelines__c;
                 solnAssessment.Current_or_Past_Integration_Strategy__c = currentOpp[0].What_company_integration_strategy__c;
                 solnAssessment.Competition__c = currentOpp[0].Who_is_the_competition__c;
                 solnAssessment.Existing_ESB_or_other_technology__c = currentOpp[0].Existing_ESB_other_technology__c;
                 solnAssessment.Describe_Developer_Skillset__c = currentOpp[0].Developer_skills__c;
                 solnAssessment.Account__c = currentOpp[0].AccountId;
                 
                 insert solnAssessment;
                 
                 /*for(Mutual_Close_Plan__c mc:mcPlanList){
                    upMCPlanList .add(mc);
                 }
                 update upMCPlanList ;*/
                 
                 newSolnAssessmentURL = new PageReference(sfdcURL + solnAssessment.Id + '/e?retURL=%2F' + solnAssessment.Id);
             
            }
        
        }
        
        return newSolnAssessmentURL;
    }

}