trigger GenerateBillingRatesForProjects on Master_Rate__c (after insert, after update, before delete) {
	
	// This trigger populates existing projects with billing rates for all existing projects
	
	
	if (Trigger.isInsert) {
	Master_Rate__c newRate = Trigger.new[0];
	Pricing_Sheets__c[] sheets = new Pricing_Sheets__c[0]; 
	
	Project__c[] projects = [select id,name from project__c];
	
	
	for (Project__c project:projects) {
		
		Pricing_Sheets__c sheet = new Pricing_Sheets__c();
		sheet.master_rate__c = newrate.id;
		sheet.Project__c = project.id;
		sheet.name = newrate.name;
		sheet.principal_consultant_rate__c = newrate.principal_consultant_rate__c;
		sheets.add(sheet);
		
	}
	  
	
	insert sheets;
	} else if (Trigger.isUpdate) {
		/*
		
		Pricing_Sheets__c[] sheets = new Pricing_Sheets__c[0]; 
		
		
	Master_Rate__c newRate = Trigger.new[0];
	Pricing_Sheets__c[] oldsheets = [select id,name from pricing_sheets__c where master_rate__c=:newRate.id];
	
	for (Pricing_Sheets__c sheet:oldsheets) {
		
		sheet.principal_consultant_rate__c = newRate.principal_consultant_rate__c;
		sheets.add(sheet);
		
		
	}
	update (sheets);
		*/
		
	}
	
	 else if (Trigger.isDelete) {
	 	
	 	/*
		
		Pricing_Sheets__c[] sheets = new Pricing_Sheets__c[0]; 
		
	Master_Rate__c newRate = Trigger.old[0];
	Pricing_Sheets__c[] oldsheets = [select id,name from pricing_sheets__c where master_rate__c=:newRate.id];
	
	for (Pricing_Sheets__c sheet:oldsheets) {
		
		sheet.principal_consultant_rate__c = newRate.principal_consultant_rate__c;
		sheets.add(sheet);
		
		
	}
	delete (sheets);
		
		*/
	}
	

}