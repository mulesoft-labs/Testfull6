/**
*	@author Victor Vargas
*	@date 09/23/2011
*	@version: 1.0
*	@description Class that updates the Target Completion Date of the recurring projects. 
*/

global class ProjectDateUpdateBatch implements Database.Batchable<sObject> {
	
	public String query;
	
/**
*	start() Method 
*	@author Victor Vargas
*	@date 09/23/2011
*	@version: 1.0 
*/
   	
   	global Database.QueryLocator start(Database.BatchableContext BC)
   	{   		
    	return Database.getQueryLocator(query);   		
   	}
   
/**
*	execute() Method 
*	@author Victor Vargas
*	@date 09/26/2011
*	@version: 1.0
*	@description Main method that updates all the projects 
*	@param Database.BatchableContext BC variable that is used to process the batch.
*	@param List<sObject> scope Storage List of sObject type that saves the result of the query to the Project object.
*/
    
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		
   		//Variables for the Process
   		Date monthStart = null;
   		Date nextMonth = null;
   		Date targetDate = null;
   		Integer days = 0;   		
   		
   		//Local list that will store all the projects that will be updated   		
   		List<Project__c> lstProjects = new List<Project__c>();  		
   		
   		//Start the updating process...
   		for(sObject sobj : scope) {
   			//Seting date to the end of the month
   			monthStart = Date.today().toStartOfMonth();
   			nextMonth = Date.newInstance(monthStart.year(), (monthStart.month()+1), 1);
   			days = (monthStart.daysBetween(nextMonth))-1;
   			targetDate = monthStart.addDays(days);
   			
   			//Updating Project
   			Project__c proj=(Project__c)sobj;   			   			
   			proj.Projected_Completion_Date__c = targetDate; 
   			lstProjects.add(proj);	
   		}
   		
   		if(lstProjects.isEmpty()==false){
   			update lstProjects;
   		}
   		
   	}
   	
/**
*	finish() Method
*	@author Victor Vargas
*	@date 09/23/2011
*	@version: 1.0
*	@description Finishing method that will send a notification email when the process is finished 
*	@param Database.BatchableContext BC variable that is used to process the batch.    
*/
    
   	global void finish(Database.BatchableContext BC)
   	{
 			 		
   	}

   	
}