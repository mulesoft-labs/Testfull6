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
private class InvoiceGenerationTests {

    static testMethod void generateInvoiceItems() {
        
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
    	
    	Expense_Log__c expense = new Expense_Log__c();
    	expense.employee__c = employee.id;
    	
    	expense.project__c = project.id;
    	expense.amount__c = 750.00;
    	expense.date__c = Date.today();
    	insert expense;
    	
    	Invoice__c invoice = new Invoice__c();
    	
    	invoice.Project__c = project.id;
    	
    	
    	insert invoice;
    	
    	
    	Invoice_Item__c[] items = [select id,name from invoice_item__c where invoice__c=:invoice.id];
    	
    	
    	System.assertEquals(items.size(),2);
    	
    	
    }
    
     static testMethod void generateExpenseItems() {
        
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
    	
    	Expense_Log__c expense = new Expense_Log__c();
    	expense.employee__c = employee.id;
    	
    	expense.project__c = project.id;
    	expense.amount__c = 750.00;
    	expense.date__c = Date.today();
    	insert expense;
    	
    	Invoice__c invoice = new Invoice__c();
    	
    	invoice.Project__c = project.id;
    	
    	
    	insert invoice;
    	
    	
    	Invoice_Expense__c[] items = [select id,name from invoice_expense__c where invoice__c=:invoice.id];
    	
    	
    	System.assertEquals(items.size(),1);
    	
    	
    	
    	
    }
    
}