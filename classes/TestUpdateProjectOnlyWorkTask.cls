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
private class TestUpdateProjectOnlyWorkTask {

    static testMethod void myUnitTest() {
		
		Project__c project = new Project__c();
    	
    	project.name = 'Testing2 Project';
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
    	employee.name = 'David Thomson';
    	insert employee;
    	
    	
    	Project__c testP = [select id,name,Estimated_Project_Hours__c from Project__c where id=:project.id ];
    	
    	
    	
    	Milestone__c milestone = new Milestone__c();
    	milestone.name='Whatever testing unique';
    	
    	milestone.Estimated_Hours__c = 200;
    	
    	milestone.Project__c = project.id;
    	
    	insert milestone;
    	
    	testP = [select id,name,Estimated_Project_Hours__c from Project__c where id=:project.id ];
    	
    	System.assertEquals(testP.Estimated_Project_Hours__c,200);
    	
    	
    	
    	NewWorkTaskController nwt = new NewWorkTaskController(milestone.id);
    	Work_Task__c wt = nwt.getWorkTask();
    	wt.Hours_Estimate__c = 500;
    	
    	nwt.setWorkTask(wt);
    	
    	nwt.saveWorkTask();
    	
    	
    	testP = [select id,name,Estimated_Project_Hours__c from Project__c where id=:project.id ];
    	
    	System.assertEquals(testP.Estimated_Project_Hours__c,500);
    	
    	       


    }
}