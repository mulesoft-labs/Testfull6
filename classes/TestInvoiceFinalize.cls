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
private class TestInvoiceFinalize {

    static testMethod void testFinalize() {
    	
    	
    	Account a = new Account();
    	a.name = 'Second Account';
        a.BillingCountry = 'US';
    	insert a;
    	
    	Contact c1 = new Contact();
    	c1.firstName = 'Contact';
    	c1.lastName = 'Name';
    	c1.email = 'contact@email.com';
    	
    	c1.Accounts_Receivable_Contact__c = true;
    	c1.AccountId = a.id;
    	
    	insert c1;
    	
    	Contact c2 = new Contact();
    	c2.firstName = 'Name';
    	c2.lastName = 'Contact';
    	c2.email = 'email@contact.com';
    	c2.Accounts_Receivable_Contact__c = true;
    	c2.Email_Selected__c = true;
    	
    	c2.AccountId = a.id;
    	
    	insert c2;
    	
    	
    	Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	
    	project.account__c = a.id;
    	
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
    	
    	    	String invoiceId = invoice.id;
    	
    	
    		PageReference pdf =  Page.ClientInvoice;
		pdf.getParameters().put('id',invoiceId);
		pdf.setRedirect(true);
		
		 Test.setCurrentPage(pdf);
		 
		
		String invoiceNumber = invoice.Invoice_Number__c;
		if (invoiceNumber==null) {
			invoiceNumber = invoiceId;
		}
		
		Blob b = Blob.valueOf('Hi there');
		
		
		InvoiceRecipientSelectController irs = new InvoiceRecipientSelectController(invoiceId);
		
		irs.setBlob(b);

				
		
    	
    	irs.emailSelectedContacts(b);
    	
    
    	
    	Invoice_Item__c[] invoiceLogs = [select name,id,time_log__c from invoice_Item__c where invoice__c=:invoice.id];

		System.assertEquals(invoiceLogs.size(),2);
		
		Invoice_Item__c firstItem = invoiceLogs[0];
		Invoice_Item__c secondItem = invoiceLogs[1];
		
		String firstTimeLogIdToCheck = firstItem.time_log__c;
		String secondTimeLogIdToCheck = secondItem.time_log__c;
		
				
		delete firstItem;
		

		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);
		controller.finalizeInvoice();
		
		Time_Log__c firstLog = [select name,id,billed_status__c from time_log__c where id=:firstTimeLogIdToCheck];
		Time_Log__c secondLog = [select name,id,billed_status__c from time_log__c where id=:secondTimeLogIdToCheck];
		
		
		System.assertEquals(firstLog.billed_status__c, 'Incurred');
		System.assertEquals(secondLog.billed_status__c, 'Invoiced');

    }
}