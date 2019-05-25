@isTest
private class ProjectAmountTests {
	
	
	
    static testMethod void generateTestData() {
    	
    	
    	 Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	
    	System.assertEquals(500, ttl.amount__c);
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    }
    
    
    static testMethod void testProjectUnbilledAmount () {
    	
    	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.unbilled_amount_dyn__c,500);
    	
    	
    }
	
	
    
    
     static testMethod void deleteTimeLog(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	delete ttl;
    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.unbilled_amount_dyn__c,0);

		


    }
    
     static testMethod void deleteTimeLogWithNull(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Collected_Amount_dyn__c = null;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Collected';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	delete ttl;
    	
    	
    	Project__c tproj = [select id,name,collected_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.collected_amount_dyn__c,0);
    	



    }
    
    static testMethod void changeTimeLogStatus(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	ttl.Billed_Status__c = 'Collected';
    	
    	update ttl;
    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.unbilled_amount_dyn__c,0);
    	System.assertEquals(tproj.collected_amount_dyn__c,500);

		


    }
    
     static testMethod void projectHoursIncurred(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 10;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 15;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	
    	timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 15;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Collected';
    	
    	insert timeLog;
    	    	
    	
    	    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c,hours_incurred__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.hours_incurred__c,30);
    	

    }
    
    static testMethod void changeTimeLogStatusTwice(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	ttl.Billed_Status__c = 'Collected';
    	
    	update ttl;
    	
    	Time_log__c ttlinc = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	ttlinc.Billed_Status__c = 'Incurred';
    	
    	update ttlinc;
    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.unbilled_amount_dyn__c,500);
    	System.assertEquals(tproj.collected_amount_dyn__c,0);

		


    }
    
     static testMethod void updateIncurredHoursWithoutStatusChange(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Incurred';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
		
		ttl.Hours__c = 4;
		    	
    	update ttl;
    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.unbilled_amount_dyn__c,400);
    	

		


    }
    
     static testMethod void updateCollectedHoursWithoutStatusChange(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Collected';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
		
		ttl.Hours__c = 4;
		    	
    	update ttl;
    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertNotEquals(tproj.unbilled_amount_dyn__c,400);
    	
    	System.assertEquals(tproj.collected_amount_dyn__c,400);

		


    }
    
     static testMethod void updateCollectedHoursAndBillAsRate(){
     	
     	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	
    	Pricing_Sheets__c higherrate = new Pricing_Sheets__c();
    	higherrate.principal_consultant_rate__c = 200;
    	higherrate.Project__c = project.id;
    	insert higherrate;
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	insert employee;
    	
    	Time_Log__c timeLog = new Time_Log__c();
    	
    	timeLog.project__c = project.id;
    	timeLog.Hours__c = 5;
    	timeLog.Pricing_Sheet__c = rate.id;
    	timeLog.Employee__c = employee.id;
    	
    	timeLog.Billed_Status__c = 'Collected';
    	
    	insert timeLog;
    	
    	Time_log__c ttl = [select name,id,amount__c from time_log__c where id=:timeLog.id];
    	
    	ttl.Pricing_Sheet__c = higherrate.id;
    	
		
		ttl.Hours__c = 4;
		    	
    	update ttl;
    	
    	
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	
    	System.assertEquals(tproj.collected_amount_dyn__c,800);

		


    }
    
    
    
    
    

}