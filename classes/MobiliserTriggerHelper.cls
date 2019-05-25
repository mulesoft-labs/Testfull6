/*************
 * Class: MobiliserTriggerHelper
 * Description: Update Sal Audited Mobiliser Count and Mobiliser Count on opportunity
 * Date: 11/20/2016
 * Author: Santoshi (Perficient), Rucha (Perficient)
 ***********/
public without sharing class MobiliserTriggerHelper {
    
    public static void processMobiliser(List<Mobiliser__c> triggerNewList,List<Mobiliser__c> triggerOldList){
    	Set<String> OpportunityIds = new Set<String>();
    	List<Opportunity> updateOpportunity = new List<Opportunity> ();
    	List<Mobiliser__c> triggerList = new List<Mobiliser__c>();
    	
    	if(trigger.isafter){
    		if(trigger.isInsert || trigger.isupdate){
    			if(triggerNewList != null)
    			triggerList.addAll(triggerNewList);
    		}  if(trigger.isDelete || trigger.isupdate){
                
    			if(triggerOldList != null)
    			triggerList.addAll(triggerOldList);
    		}
    		
    		
    		if(!triggerList.isEmpty()){
    			 for(Mobiliser__c mob : triggerList ){
    			 	if(mob.Opportunity__c != null)
    			 	OpportunityIds.add(mob.Opportunity__c);
    			 }
    		
    			
    			if(!OpportunityIds.isEmpty()){
    				updateSALMobiliserCount(OpportunityIds);
                    updateMobiliserCountOnOpty(OpportunityIds);
    			}
    		}
    	}
    }
    

    public static void updateSALMobiliserCount(Set<String> OpportunityIds ){
        AggregateResult[] groupedResults  = [SELECT Count(Id),Opportunity__c  FROM Mobiliser__c 
    					 WHERE (SAL_Audited__c = true and Opportunity__c in :OpportunityIds)
     					 GROUP BY Opportunity__c];
        
        updateOpportunityCount(groupedResults,'Count_of_SAL_Audited_Mobilisers__c',opportunityIds);
    }
    
    public static void updateMobiliserCountOnOpty(Set<String> opportunityIds){
        
        List<AggregateResult> optyCount = [SELECT Opportunity__c, count(Id) 
                                          	FROM Mobiliser__c
                                          	WHERE Opportunity__c in :opportunityIds
                                          	GROUP BY Opportunity__c];
        
        updateOpportunityCount(optyCount,'Mobiliser_Count__c',opportunityIds);
        
    }
    
    public static void updateOpportunityCount(List<AggregateResult> groupedResults,  
                                               	String optyFieldToUpdate,
                                              	Set<String> opportunityIds){
    		List<Opportunity> updateOpportunity = new List<Opportunity> ();
           
        	Set<String> opportunityProcessed = new Set<String>();
    	
					for (AggregateResult ar : groupedResults)  {
					    
					    Opportunity opp = new Opportunity();
					    if(ar.get('Opportunity__c') != null){
					    	opp.Id = (Id) ar.get('Opportunity__c');
						
					    	if(ar.get('expr0') != null)
					    		opp.put(optyFieldToUpdate,(Decimal) ar.get('expr0'));
					    	else 
					     		opp.put(optyFieldToUpdate,0);
                            
					   		opportunityProcessed.add(opp.Id);
					   		updateOpportunity.add(opp);
						}
    				
					}
					
					for(String str : OpportunityIds){
						if(!opportunityProcessed.contains(str)){
							Opportunity opp = new Opportunity();
							opp.Id = str;
							opp.put(optyFieldToUpdate,0);
							updateOpportunity.add(opp);
						} 
					}
					
					if(!updateOpportunity.isEmpty()){
                        try{
                            update updateOpportunity;
                        }
                        catch(Exception e){
                            System.debug('Exception in updating mobiliser counts: ' + e.getMessage() + ' : ' + e.getStackTraceString());
                        }
					}
    }
}