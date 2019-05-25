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
private class ExpenseLogControllerTest {


     static testMethod void autoSelectEmployee() {
         Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	
    	project.Project_Limit__c  = 10000;
    	project.Projected_Completion_Date__c = Date.today();
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.name='Main Rate';
    	rate.Project__c = project.id;
    	insert rate;
    	
    	         Profile p = [select id from profile where name='Standard User']; 
    	 User newuser = new User(alias = 'standt', email='bonzai@bonzai.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username=System.now().millisecond() +'bonzai@bonzai.com'+System.now().millisecond());
            
            insert newuser;

    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	employee.user__c = newuser.id; 
    	
    	insert employee;
    	
    	
    	Expense_Log__c log = new Expense_Log__c();
    	
    	log.project__c = project.id;
    	log.amount__c = 100;
    	log.description__c = 'Test description';
    	
    	
		NewExpenseLogController tlc = new NewExpenseLogController(project.id);
		
		tlc.setLog(log);
		
		System.runAs(newuser) {
			
			PageReference ref = tlc.save();
			
			System.assertEquals(ref.getURL(),'/'+project.id);
			
			
			
		}
		
		    	
    	
    	
    }
    
    
    static testMethod void testCancel() {
         Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Projected_Completion_Date__c = Date.today();
    	project.Project_Limit__c  = 10000;
    	
    	insert project;
    	
    	Pricing_Sheets__c rate = new Pricing_Sheets__c();
    	rate.principal_consultant_rate__c = 100;
    	rate.Project__c = project.id;
    	insert rate;
    	
    	         Profile p = [select id from profile where name='Standard User']; 
    	 User newuser = new User(alias = 'standt', email='bonzai@bonzai.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username = System.now().millisecond() +'bonzai@bonzai.com'+System.now().millisecond());
            
            insert newuser;

    	
    	Employee__c employee = new Employee__c();
    	employee.name = 'Karl Kasai';
    	employee.user__c = newuser.id; 
    	
    	insert employee;
    	
    	
    	
    	Expense_Log__c log = new Expense_Log__c();
    	
    	log.project__c = project.id;
    	log.amount__c = 100;
    	log.description__c = 'Test description';
    	
		
		NewExpenseLogController tlc = new NewExpenseLogController(project.id);
		
		tlc.setLog(log);
		
		System.runAs(newuser) {
			
			PageReference ref = tlc.cancel();
			
			System.assertEquals(ref.getURL(),'/'+project.id);
			
			
			
		}
    }
}