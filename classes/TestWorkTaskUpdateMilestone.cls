/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestWorkTaskUpdateMilestone {

    static testMethod void myUnitTest() {
    	
    	
       Project__c project = new Project__c();
       project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
       
       	        
       	        /*
       	         Profile p = [select id from profile where name='Standard User'];
	         User u = new User(alias = 'standt', email='anothertest@testorg.com',
	            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
	            localesidkey='en_US', profileid = p.Id,
	            timezonesidkey='America/Los_Angeles', username='anothertest@testorg.com');
	            
	            */
	            
	            
	 Milestone__c milestone;
	 
	 
	 String milestoneId = null;
	 
	 Work_Task__c wt;
	 
	 Work_Task__c wt2;
	 
	 Task[] ts = new Task[0];
	 
	//insert u;
	 
	  //       System.runAs(u) {
	           // The following code runs as user 'u'
	     //      System.debug('Current User: ' + UserInfo.getUserName());
	      //     System.debug('Current Profile: ' + UserInfo.getProfileId()); 
	           // Run some code that checks record sharing
    	
    	project.name = 'Testing5 Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	
    	insert project;
    	
    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'David Thomson';
    	employee.User__c = UserInfo.getUserId();
    	insert employee;
    	
    	
    	
    	Pricing_Sheets__c pricingSheet = new Pricing_Sheets__c();
    	pricingSheet.name = 'Project Manager';
    	pricingSheet.principal_consultant_rate__c = 150;
    	pricingSheet.project__c = project.id;
    	
    	insert pricingSheet;
    	
    		
    	milestone = new Milestone__c();
    	milestone.name='Whatever testing unique';
    	
    	milestone.Estimated_Hours__c = 200;
    	
    	milestone.Project__c = project.id;
    	
    	insert milestone;
    	
    	milestoneId = milestone.id;
    	NewResourceAllocationController rac = new NewResourceAllocationController(milestoneId);
    	
    	
    	
    	
    	
    	Resource_Allocation__c ra = rac.getRa();
    	
    	System.assertEquals(ra.milestone__c,milestone.id);
    	
    	ra.Employee__c = employee.id;
    	
    	rac.setRa(ra);
    	
    	rac.setRoleId(pricingSheet.id);
    	
    	rac.saveRa();
    	
    	
    	Resource_Allocation__c[] testResources = [select id,name,employee__r.name,role__r.name,assigned__c,employee__r.user__c from Resource_Allocation__c where milestone__c=:milestoneId];
    	
    		
    		System.assertEquals(1,testResources.size());
    	
    	
    	wt = new Work_Task__c();
    	
    	wt.Hours_Estimate__c = 50;
    	wt.Due_Date__c = Date.Today();
    	wt.Milestone__c = milestone.id;
    	
    	
    	NewWorkTaskController nwt = new NewWorkTaskController(milestone.id);
    	nwt.setWorkTask(wt);
    	
    	String testmilestoneId = nwt.getMilestoneId();
    	
    	System.assertEquals(milestoneId,testMilestoneId);
    	
    	
    	
    		Resource_Allocation__c[] resources = nwt.getResources();
    		
    		System.assertEquals(1,resources.size());
    	
    	Resource_Allocation__c resource = resources[0];
    	
    	resource.assigned__c = true;
    	
    	resources[0] = resource;
    	
    	nwt.setResources(resources);
    	
    	nwt.saveWorkTask();
    	
    	
    	
    	
    	wt = nwt.getWorkTask();
    	
    	ts = [select id,subject,whatid from Task where whatid=:wt.id];
    	
    	///System.assertEquals(1,ts.size());
    	
    
    	
    	Milestone__c testMilestone = [select id,name,estimated_hours__c from Milestone__c where id=:milestone.id];
    	
    	Double milestoneHours = testMilestone.estimated_hours__c;
    	
    	System.assertEquals(milestoneHours,50);
    	
    	
    	Work_Task__c testWt = [select id,name,milestone__c,hours_estimate__c from Work_Task__c where id=:wt.id];
    	
    	
    	System.debug('TESTWT: '+testWt.milestone__c);
    	testWt.hours_estimate__c = 200;
    	
    	update testWt;
    	
    	testMilestone = [select id,name,estimated_hours__c from Milestone__c where id=:milestone.id];
    	
    	milestoneHours = testMilestone.estimated_hours__c;
    	
    	System.assertEquals(milestoneHours,200);
    	
    	
    	
    	
    	
    	
    	
    	NewWorkTaskController nwt2 = new NewWorkTaskController(project.id);
    	
    	wt2 = new Work_Task__c();
    	
    	wt2.Hours_Estimate__c = 200;
    	wt2.Due_Date__c = Date.Today();
    	
    	nwt2.setWorkTask(wt2);
    	
    	nwt2.saveWorkTask();
    	
    	
    	wt2 = nwt2.getWorkTask();
    	
    	wt2.hours_estimate__c = 20;
    	
    	update wt2;
    	
    	
    	Project__c testP = [select id,name,estimated_project_hours__c from Project__c where id=:project.id];
    	
    	Double testHours = testP.estimated_project_hours__c;
    	
    	
    	System.assertEquals(220,testHours);
    	
    	
    	
    	/*
    	Task t = ts[0];
    	t.ownerid = UserInfo.getUserId();
    	
    	t.WhatId = wt.id;
    	
    	t.Hours__c = 55;
    	
    	t.Status = 'Completed';
    	
    	update t;
    	
    	
    
     
    	
    	Time_Log__c[] tls = [select id,name from Time_Log__c where milestone__c=:milestoneId];
    	

    	 
    	 
    	System.assertEquals(tls.size(),1);
    	*/
    	
    	
    	
    	
    }
}