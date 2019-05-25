/*********************************************************************
*
*   File Name: UpdateConvertedOpportunity.trigger
*
*   File Description: Updates related opportunity records on lead
*   conversion
*
**********************************************************************
*
*   Date        Author          Change
*   03/12/15    Robert          Updated to remove soql queries outside
*                               of for loop
*   07/15/14    Robert          Updated to exclude this logic for                              
*                               PRM Deal Registration record types
*   XX/XX/XX    Unknown         Initial Creation
*       
*********************************************************************/      

trigger UpdateConvertedOpportunity on Lead (after update) 
{
    /*List<Opportunity> opps = new List<Opportunity>(); 
    List<OpportunityContactRole> list_opptyContactRolesToUpdate = new List<OpportunityContactRole>(); 

    Set<Id> convertedOppIdsSet = new Set<Id>();
    Set<Id> convertedOwnerIdSet = new Set<Id>();
    Set<Lead> StageTrackingLeads = new Set<Lead>();
    for(Lead l : Trigger.new)
    {
        convertedOppIdsSet.add(l.ConvertedOpportunityId);
        convertedOwnerIdSet.add(l.OwnerId);
    }

    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT 
            What_is_the_use_case_s__c,  What_business_problem_are_they_solving__c,
            Opp_Business_Impact_ROI__c, What_products_are_they_evaluating__c, Compelling_Event__c,
            Who_cares_about_it__c, What_are_the_consequence_of_waiting__c, Evaluation_Go_live_Timelines__c,
            Describe_Evaluation_Process__c, Who_is_the_competition__c, Existing_ESB_other_technology__c,
            What_company_integration_strategy__c, Company_Description__c, Id, 
            AccountId, Amount, Additional_Information_Comments__c 
            FROM Opportunity where Id in: convertedOppIdsSet]);

    Map<Id, User> userMap = new Map<Id, User>([SELECT Division FROM User where Id in: convertedOwnerIdSet]);

    for(Lead convertedLead: Trigger.new)
    {
        if( (convertedLead.IsConverted != trigger.oldmap.get(convertedLead.id).IsConverted || 
                convertedLead.ConvertedOpportunityId != trigger.oldmap.get(convertedLead.id).ConvertedOpportunityId) 
                && convertedLead.IsConverted == TRUE && convertedLead.ConvertedOpportunityId != NULL)
        {                       
            //Query Opportunity fields to update
            Opportunity o = opportunityMap.get(convertedLead.ConvertedOpportunityId);
            
            o.Who_cares_about_it__c=convertedLead.Who_cares_about_it__c ; 
            o.What_is_the_use_case_s__c = convertedLead.PQ_Makeup_of_Current_Environment__c;
            
            o.What_company_integration_strategy__c = convertedLead.PQ_Current_or_Past_Integration_Strategy__c;
            o.Compelling_Event__c= convertedLead.PQ_Project_Description__c; 
            o.What_business_problem_are_they_solving__c = convertedLead.PQ_Business_or_Technical_Challenges__c;
            o.Opp_Business_Impact_ROI__c = convertedLead.PQ_Business_Impact__c;      
            o.Evaluation_Go_live_Timelines__c=convertedLead.PQ_Key_Milestones__c;
            o.What_are_the_consequence_of_waiting__c = convertedLead.PQ_Goals_and_Objectives__c;
            
            o.What_products_are_they_evaluating__c=convertedLead.What_products_are_they_evaluating__c;
            o.Who_is_the_competition__c= convertedLead.Who_is_the_competition__c;
            o.Existing_ESB_other_technology__c = convertedLead.Existing_ESB_other_technology__c;               
            o.Describe_Evaluation_Process__c = convertedLead.PQ_Evaluation_Process_and_Criteria__c;
            o.Additional_Information_Comments__c = convertedLead.PQ_Additional_Information_or_Questions__c;
            o.Primary_Solution_Interest__c = convertedLead.Lead_Main_Interest__c;
                 
            o.Lead_Source_Detail__c = convertedLead.Lead_Source_Detail__c;
            o.Lead_Source_Asset__c = convertedLead.Lead_Source_Asset__c;
      
            //Check if LeadSource is unknown
            if(String.isNotBlank(convertedLead.LeadSource))
            {
                o.LeadSource = convertedLead.LeadSource;
            }
            else
            {
                o.LeadSource = 'Unknown';
            }
            
            //Check if Lead Type is unknown    
            if(String.isNotBlank(convertedLead.Lead_Type__c))
            {
                o.Lead_Type__c = convertedLead.Lead_Type__c;
            }
            else
            {
                o.Lead_Type__c = 'Unknown';
            }

            o.Lead_Passed_By__c= convertedLead.OwnerId;
            o.Amount=1.00;
            
            // When lead is first converted, there's a delay in setting the
            // converted date so it doesn't get passed to the opportunity
            // So setting used today's date if it's null.
            if(convertedLead.ConvertedDate == null)
            {                
                o.Lead_Passed_On__c = Date.today(); // convertedLead.ConvertedDate;
            }
            else
            {             
                o.Lead_Passed_On__c = convertedLead.ConvertedDate;
            }

            if(userMap.get(convertedLead.OwnerId) != null)
            {
                o.Lead_Passed_By_Group__c = userMap.get(convertedLead.OwnerId).Division;
            }
            
            opps.add(o);  
            StageTrackingLeads.add(convertedLead);
        }        
    }
  
    if(opps.size() > 0)
    {
        update opps;
    }
    
    

    if (list_opptyContactRolesToUpdate.size() > 0)
    {
        update list_opptyContactRolesToUpdate;
    }
    
    
      if(StageTrackingLeads.size() > 0)
        {    
            LeadTriggerHandler.createStageTrackingLeads(StageTrackingLeads);
        }
    */
 }