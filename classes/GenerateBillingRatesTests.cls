@isTest
private class GenerateBillingRatesTests {

    static testMethod void insertNewProject() {
		
		
		
		Master_Rate__c mr = new Master_Rate__c();
    	mr.name = 'Consultant Test Rate';
    	mr.principal_consultant_rate__c = 500;
    	
    	insert mr;
    	
    	 Master_Rate__c[] mrs = [select id from master_rate__c];
		integer count = mrs.size();
		
		Project__c project = new Project__c();
    	
    	project.name = 'Testingasdf Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c[] ps = [select name,id,master_rate__c from pricing_sheets__c where project__c=:project.id];
    	
    	boolean found = false;
    	for (Pricing_Sheets__c sheet:ps) {
    		
    		if (sheet.master_rate__c==mr.id) {
    			found = true;	
    		}
    		
    	}
    	
    	System.assert(found);
    	System.assert(ps.size()==count);
    	
    		        
        
    }
    
    static testMethod void createNewMasterRate() {
    	
    	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	
    	Master_Rate__c mr = new Master_Rate__c();
    	mr.name = 'Consultant Test Rate';
    	mr.principal_consultant_rate__c = 500;
    	
    	insert mr;
    	
    	 Master_Rate__c[] mrs = [select id from master_rate__c];
		integer count = mrs.size();
    	
    	
    	Pricing_Sheets__c[] ps = [select name,id,principal_consultant_rate__c,master_rate__c from pricing_sheets__c where project__c=:project.id];
    	
    	System.assert(ps.size()==count);
    	
    	   	
    	
    }
    
      static testMethod void updateMasterRate() {
      	
    	
    	Master_Rate__c mr = new Master_Rate__c();
    	mr.name = 'Consultant Test Rate 500';
    	mr.principal_consultant_rate__c = 500;
    	
    	insert mr;
    	
    	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Project__c project2 = new Project__c();
    	
    	project2.name = 'Testing Project 2';
    	
    	project2.start_date__c = d;
    	project2.Project_Limit__c  = 10000;
    	project2.Projected_Completion_Date__c = Date.today();
    	
    	insert project2;
    	
    	/*
    	
    	Pricing_Sheets__c[] ps = [select name,id,principal_consultant_rate__c,master_rate__c from pricing_sheets__c where master_rate__c=:mr.id];
    	
		
		for (Pricing_Sheets__c sheet:ps) {
			
			System.assert(500==sheet.principal_consultant_rate__c);
			
		}
    	
    	Master_Rate__c mrupdate = [select name,id,principal_consultant_rate__c from master_rate__c where id=:mr.id];
    	mrupdate.principal_consultant_rate__c = 250;
    	
    	update mrupdate;
    	
    	
    	ps = [select name,id,principal_consultant_rate__c,master_rate__c from pricing_sheets__c where master_rate__c=:mr.id];
    	
    	
				
		for (Pricing_Sheets__c sheet:ps) {
			
			System.assert(250==sheet.principal_consultant_rate__c);
			
		}
    	
      	*/
      	
      }
    
    
    
}