public with sharing class BulkUpdateTimeLogController {

    public BulkUpdateTimeLogController(ApexPages.StandardController controller) {

    }
    
    public BulkUpdateTimeLogController() {

    }
    


	public void zeroOutProjects() {
		Project__c[] toupdate = new Project__c[0];
		
		Project__c[] projects = [select id,name,unbilled_amount_dyn__c from project__c];
		
		for (Project__c proj:projects) {
			
			proj.unbilled_amount_dyn__c = 0;
			toupdate.add(proj);
			
			
		}
		
		update toupdate;
		
		
		
		
		
		
		
	}
	
	public void updateTimeLogs() {
		
		BulkUpdateTimeLogController.updateStatic();
	}
	
	
	@future 
	public static void findOrphans() {
	
	
	Project__c[] toupdate = new Project__c[0];
	Project__c[] projects = [select id,name,unbilled_amount_dyn__c from project__c];
	
		
	Pricing_Sheets__c[] rates = [select name,id,principal_consultant_rate__c,project__r.id from Pricing_Sheets__c];
		
		
	
	Time_Log__c[] tls = [select name,id,project__c,project__r.unbilled_amount_dyn__c,hours__c,pricing_sheet__r.project__c, pricing_sheet__r.principal_consultant_rate__c from Time_Log__c where billed_status__c='Incurred'];
	Orphaned_Time_Log__c[] orphans = new Orphaned_Time_Log__c[0];
	
	
	//for (Project__c proj:projects) {
	
	
	Id[] projIds = new Id[0];
		
		for (Time_Log__c tl:tls) {
			
				//if (tl.Project__c == proj.id) {
				
				//projIds.add()
						
					
					//	if (tl.pricing_sheet__r==null) {
							
						//	System.debug('This one is null: '+tl.id);
						
						Orphaned_Time_Log__c otl = new Orphaned_Time_Log__c();
							otl.time_log__c = tl.id;
						orphans.add(otl);
							
					//	}
						
						
						//proj.Unbilled_Amount_Dyn__c += tl.Hours__c*tl.pricing_sheet__r.principal_consultant_rate__c;
						
					
				
			//	}
				
				
				
		//	}
			
			
			
			
		
		
		//toupdate.add(proj);
		
	}
	
		insert orphans;
		
	//update toupdate;	
	
		
		
		
	}
	
	@future 
	public static void updateStatic() {
	
	
	Project__c[] toupdate = new Project__c[0];
	
		
	Pricing_Sheets__c[] rates = [select name,id,principal_consultant_rate__c,project__r.id from Pricing_Sheets__c];
		
		
	
	Time_Log__c[] tls = [select name,id,project__c,project__r.unbilled_amount_dyn__c,hours__c,pricing_sheet__r.project__c, pricing_sheet__r.principal_consultant_rate__c from Time_Log__c where billed_status__c='Incurred'];
	Orphaned_Time_Log__c[] orphans = new Orphaned_Time_Log__c[0];
	
	
	Id[] projIds = new Id[0];
		
		for (Time_Log__c tl:tls) {
			
				projIds.add(tl.project__c);
		
		
	}
	
		Map<Id,Project__c> projectMap =  new Map<Id,Project__c>([select Id,name,unbilled_amount_dyn__c from Project__c where Id in :projIds]);
		
		
				for (Time_Log__c tl:tls) {
						
							Project__c proj = projectMap.get(tl.project__c);
							
							if (proj.unbilled_amount_dyn__c==null) {
								proj.unbilled_amount_dyn__c = 0;
								
							}
							
							if (tl.pricing_sheet__r!=null) {
							proj.Unbilled_Amount_Dyn__c += tl.Hours__c*tl.pricing_sheet__r.principal_consultant_rate__c;
							projectMap.put(proj.id,proj);
							}
							//	toUpdate.add(proj);
								
					}
		
		
				for (Project__c proj:projectMap.values()) {
		
								toUpdate.add(proj);
		
				}
				
				update (toUpdate);
		
		
		
		//update (toUpdate);
		
		
	}
	

}