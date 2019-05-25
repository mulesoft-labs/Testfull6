/**
*	Global Execute_ProjectDateUpdate Class
*	@version: 1.0
*	@author Victor Vargas Reyes
*	@date 09/26/2011
*	@description Class that implements bacthable content to update the information of the project date.   
*/

global class Execute_ProjectDateUpdate {
		
	public Boolean IsTest = false;
    
/**
*	executeProjUpdate
*	@version: 1.0
*	@author Victor Vargas Reyes
*	@date 09/26/2011
*	@description Method that executes the batch class ProjectDateUpdateBatch    
*/
    
    public AsyncApexJob executeProjUpdate() {
    	
    	ProjectDateUpdateBatch PDUB = new ProjectDateUpdateBatch();		
		
		if(IsTest == true)
		{
			PDUB.query = 'SELECT p.Id, p.Projected_Completion_Date__c FROM Project__c p WHERE p.Is_Recurring__c = TRUE LIMIT 30';
		}
		else
		{		
			PDUB.query = 'SELECT p.Id, p.Projected_Completion_Date__c FROM Project__c p WHERE p.Is_Recurring__c = TRUE';
		}	
		
		Id idbatch = Database.executeBatch(PDUB);
		if(idbatch!=null){
			AsyncApexJob aaj = [Select Id, Status, MethodName, CompletedDate, ExtendedStatus, LastProcessed, JobType, LastProcessedOffset, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = :idbatch];
        	return aaj;
		}else{
			return null;
		}	
    }
}