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
private class TestInvoiceExpenseMarkup {

    static testMethod void myUnitTest() {
        
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
    	
    	Expense_Log__c log = new Expense_Log__c();
    	
    	log.project__c = project.id;
    	log.amount__c = 500.00;
    	log.percent_markup__c = 10;
    	
    	log.Employee__c = employee.id;
    	
    	log.Billed_Status__c = 'Incurred';
    	
    	insert log;
    	
    	Invoice__c invoice = new Invoice__c();
    	invoice.project__c = project.id;
    	
    	insert invoice;
    	
    	Invoice__c newInvoice = [select id,name,is_finalized__c from Invoice__c where id=:invoice.id];
    	
    	newInvoice.Is_Finalized__c = true;
    	
    	update newInvoice;
    	
    	Invoice_Expense__c ie = [select id,name,amount__c from Invoice_Expense__c where Expense_Log__c=:log.id];
        
        System.assertEquals(ie.amount__c, 550);
        
    }
}