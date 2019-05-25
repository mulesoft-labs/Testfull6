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
private class BulkUpdateTests {

    static testMethod void myUnitTest() {
    	
    	/*
      
       Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	
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
    	
    		
    	Project__c tproj = [select id,name,unbilled_amount_dyn__c from project__c where name = 'Testing Project' ];
    	
    	
    	System.assertEquals(tproj.unbilled_amount_dyn__c,500);
    	
    	
    	 Project__c project2 = new Project__c();
    	
    	project2.name = 'Testing Project2';
    	project2.unbilled_amount_dyn__c = 10000;
    	
    	project2.start_date__c = d;
    	
    	insert project2;
    	
    	
    	BulkUpdateTimeLogController butlc = new BulkUpdateTimeLogController();
    	butlc.zeroOutProjects();
    	
    	Project__c[] projects = [select id,name,unbilled_amount_dyn__c from Project__c where id=:project.id OR id=:project2.id];
      	
      	for (Project__c proj:projects) {
      		System.assertEquals(proj.unbilled_amount_dyn__c,0);
      		
      	}
      	
      	butlc.updateTimeLogs();
      	
      	
      */
      
    }
}