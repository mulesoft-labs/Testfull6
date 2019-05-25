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
private class ClientInvoiceTests {
	
	static testMethod void testInvoiceLogWithBlankTimeLog() {
		
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
    	
    	
    	
    	Invoice__c invoice = new Invoice__c();
    	
    	invoice.Project__c = project.id;
    	
    	
    	
    	
    	insert invoice;
    	
    	Invoice_Item__c invoiceItem = new Invoice_Item__c();
    	invoiceItem.Invoice__c = invoice.id;
    	
    	invoiceItem.Hours__c = 5;
    	
    	invoiceItem.bill_as__c = rate.id;
    	invoiceItem.Date__c = Date.today();
    	
    	insert invoiceItem;
    	
    	

		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		ServiceItemComposite[] logs = controller.getTimeLogs();
		
		
		
		Double total = controller.totalItemsExpensesCredits();
		
		System.assertEquals(total,1000);
		
		
		
   
    	
    }

    static testMethod void totalItemsExpenses() {
         
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

		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		Double total = controller.totalItemsExpensesCredits();
		
		System.assertEquals(total,2250);
    	
    }
    
     static testMethod void checkFinalize() {
         
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

		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		controller.finalizeWithoutUpdate();
		
		Invoice__c testInvoice = controller.getInvoice();
		
		Double amount = testInvoice.Total_Due__c;
		
		System.assertEquals(amount,2250);
		
    	
    }
    
     static testMethod void testDueDate() {
     	
     	
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
    	invoice.invoice_style__c = 'Fixed Fee';
    	invoice.payment_terms__c = 'Net 45';
    	
    	
    	
    	insert invoice;
    	
    	
		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		controller.finalizeInvoice();
		
		Invoice__c updatedinvoice = [select name,id,due_date__c from invoice__c where id=:invoice.id];
		
		Date d1 = updatedinvoice.due_date__c;
		
		Date dtoday = Date.today();
		
		Date d2 = dtoday.addDays(45);
		
		System.assertEquals(d1, d2); 
		
		    
    	
    
    
    
     }
    
    
     static testMethod void totalItemsExpensesCredits() {
         
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
    	
    	Invoice_Credit__c credit = new Invoice_credit__c();
    	
    	credit.invoice__c = invoice.id;
    	credit.amount__c = 750.00;
    	
    	insert credit;
    	
    	

		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		Double total = controller.totalItemsExpensesCredits();
		
		System.assertEquals(total,1500);
		
		System.assert(true, controller.getrenderExpenses());
		
    	
    }
    
      static testMethod void totalCredits() {
         
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
    	
    	
    	
    	Invoice__c invoice = new Invoice__c();
    	
    	invoice.Project__c = project.id;
    	
    	
    	
    	
    	insert invoice;
    	
    	Invoice_Credit__c credit = new Invoice_credit__c();
    	
    	credit.invoice__c = invoice.id;
    	credit.amount__c = 750.00;
    	
    	insert credit;
    	
    	credit = new Invoice_credit__c();
    	credit.invoice__c = invoice.id;
    	credit.amount__c = 500.23;
    	
    	insert credit;
    	
    	

		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		Double total = controller.getTotalCredits();
		
		System.assertEquals(total,1250.23);
		System.assert(true, controller.getrenderCredits());
		
    	
    }
    
     static testMethod void hasInvoiceLegend() {
         
        Project__c project = new Project__c();
    	
    	project.name = 'Testing Another Project';
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
    	
    	
    	
    	Invoice__c invoice = new Invoice__c();
    	
    	invoice.Project__c = project.id;
    	
    	
    	insert invoice;
    	
    	Invoice_Legend__c invoicelegend = new Invoice_Legend__c();
    	insert invoicelegend;
    	
    	invoice.invoice_legend__c = invoicelegend.id;
    	update invoice;
    	
    	
    	Legend__c legend = new Legend__c();
    	legend.invoice_legend__c = invoicelegend.id;
    	legend.abbreviation__c = 'ABBR';
    	legend.full_description__c = 'Abbreviation';
    	insert legend;
    	
    	
		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		System.assert(controller.getHasLegend()==true);		
    	
    }
    
     static testMethod void doesNotHaveInvoiceLegend() {
         
        Project__c project = new Project__c();
    	
    	project.name = 'Testinggg Project';
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
    	
    	
    	
    	Invoice__c invoice = new Invoice__c();
    	
    	invoice.Project__c = project.id;
    	
    	
    	insert invoice;
    	
    	Id ilid = invoice.invoice_legend__c;
    	
    	boolean hasId = true;
    	
    	if (ilid==null)
    		hasId = false;
    		
    	System.debug('Invoice legend: '+ilid);
    		
    	System.assert(hasId==false);
    	
    	
    	
		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);

		System.assert(controller.getHasLegend()==false);
		
    	
    }
    
     static testMethod void invoiceAccount() {
         
        Account acc = new Account();
        acc.name = 'Test Account';
        acc.BillingCountry = 'US';
        insert acc;
        
        
        Project__c project = new Project__c();
    	
    	project.name = 'Testing Project';
    	Date d = Date.today();
    	project.start_date__c = d;
    	project.Account__c = acc.id;
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
    	
    	
    	
    	
    	Invoice__c invoice = new Invoice__c();
    	
    	invoice.Project__c = project.id;
    	
    	
    	
    	insert invoice;
    	
    	
		ClientInvoiceController controller = new ClientInvoiceController(invoice.id);
		
		Account invoiceAccount = controller.getAccount();
		
		System.assertEquals('Test Account',invoiceAccount.name);
		
		
		    	
    }
    
    
}