/*********************************************************************
*
*   File Name: MutualCloseP_RelatedFieldsUpdate
*
*   File Description: This triggers executes on insert,update and 
*   delete of Mutal Close Plan
*
**********************************************************************
*
*   Date            Author          Change
*   08/29/14        Rob             Added a validation for Opportunity
*                                   Close Lost Reason
*   XX/XX/XX        Unknown         Initial Creation
*
*********************************************************************/
trigger MutualCloseP_RelatedFieldsUpdate on Mutual_Close_Plan__c (after insert, after update, after delete) 
{
    List<Mutual_Close_Plan__c> mcPlans = new List<Mutual_Close_Plan__c>();
    Set<String> oppIds = new Set<String>();
    Set<String> mcPlanIds = new Set<String>(); 
    List<Opportunity> oppUpdateList = new List<Opportunity>();
    static final string STAGENAME ='Closed Lost';
    Map<Id, String> oppMCPlanMap = new Map<Id,String>();
    Map<Id, Integer> oppMCPlanCountMap = new Map<Id,Integer>();
    
    Map<Id, Mutual_Close_Plan__c> oppMCPlanErrorMap = new Map<Id,Mutual_Close_Plan__c>();
    List<Mutual_Close_Plan__c> mcPlanList = null;
    if(trigger.isdelete)
    {
       mcPlanList = Trigger.old;    
    }
    else
    {
        mcPlanList = Trigger.new;
    }
    if(mcPlanList != null)
    {
        for(Mutual_Close_Plan__c mcp:mcPlanList)
        { 
            oppMCPlanErrorMap.put(mcp.Opportunity__c,mcp);   
            oppIds.add(mcp.Opportunity__c);   
            mcPlanIds.add(mcp.Id);
        }
    }
    List<Opportunity> oppList = [SELECT StageName,Mutual_Close_Plan_Summary__c,If_Closed_Lost_Primary_Reason__c, Id from Opportunity where Id IN : oppIds];
    mcPlans = [SELECT Opportunity__c, Action_Owner__c, Due_Date__c, Mutual_Close_Action_Name__c, Id 
                       FROM Mutual_Close_Plan__c  
                       WHERE (Opportunity__c IN : oppIds AND Is_Completed__c =:false)                      
                       ORDER BY CreatedDate ASC LIMIT 5];
                       
    for(Opportunity o:oppList)
    {  
       for(Mutual_Close_Plan__c mcp:mcPlans)
       {
            String mcpSummary =   '\n' + mcp.Due_Date__c.format() + ' : ' + mcp.Mutual_Close_Action_Name__c + ' : ' +  mcp.Action_Owner__c +  '\n';
            if(mcp.Opportunity__c == o.Id)
            {
                if(!oppMCPlanMap.containsKey(o.Id))
                {
                   oppMCPlanMap.put(o.Id,mcpSummary);  
                }
                else
                {
                    String existingMCPSummary = oppMCPlanMap.get(o.Id);                   
                    String newMcpSummary = existingMCPSummary+mcpSummary;
                    oppMCPlanMap.put (o.Id,newMcpSummary);      
                }
            }                                                  
        }    
    }
    for(Opportunity o:oppList)
    {  
        if(oppMCPlanMap.containsKey(o.Id))
        {
            if(o.StageName==STAGENAME && o.If_Closed_Lost_Primary_Reason__c==null)
            {
               Mutual_Close_Plan__c originalMCPlan =oppMCPlanErrorMap.get(o.id);
               originalMCPlan.adderror('Opportunity requires a Closed Lost Reason');
            }
            else
            {
                o.Mutual_Close_Plan_Summary__c = oppMCPlanMap.get(o.Id);
                oppUpdateList.add(o);
            }
        }
    }
    if(!oppUpdateList.isEmpty())
    {
        update oppUpdateList;
    }
}