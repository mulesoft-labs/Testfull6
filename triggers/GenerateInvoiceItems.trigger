trigger GenerateInvoiceItems on Invoice__c (before insert,after insert, after update) {
	
	Invoice__c invoice = Trigger.new[0];
	Project__c project = [select id,name,start_date__c, purchase_order__c,completion_date__c from project__c where id=:invoice.project__c];
	
	if (trigger.isAfter&&trigger.isInsert)  {
	
	Invoice_Item__c[] items = new Invoice_Item__c[0];
	
		Invoice_Expense__c[] exitems = new Invoice_Expense__c[0];
	
	
	
	System.debug('Project: '+project.name);
	
	Time_Log__c[] logs = [select name,id,hours__c,amount__c,activity_description__c,date__c from time_log__c where project__c=:project.id and billed_status__c='Incurred'];
		
		
		Expense_Log__c[] exlogs = [select name,id,amount__c,percent_markup__c,description__c,date__c,vendor__c,vendor_invoice_number__c from expense_log__c where project__c=:project.id and billed_status__c='Incurred'];
	
	
	System.debug('Time logs size: '+logs.size());
	
	
	for (Time_Log__c log:logs) {
		
		Invoice_Item__c item = new Invoice_Item__c();
		item.Invoice__c = invoice.id;
		item.description__c = log.activity_description__c;
		item.hours__c = log.hours__c;
		item.date__c = log.date__c;
		item.amount__c = log.amount__c;
		item.time_log__c = log.id;
		
		items.add(item);
		
		
	}
	
	
	for (Expense_Log__c log:exlogs) {
		
		Invoice_Expense__c item = new Invoice_Expense__c();
		item.Invoice__c = invoice.id;
		item.description__c = log.description__c;
		
		item.date__c = log.date__c;
		
		Double markup = invoice.expense_markup_percentage__c;
		
		if (markup!=null) {
			
			if (log.percent_markup__c==null) { 
			
			Double multiply = (markup/100 * log.amount__c)+log.amount__c;
			item.amount__c = multiply;
			
			} else {
				
				markup = log.percent_markup__c;
				
				Double multiply = (markup/100 * log.amount__c)+log.amount__c;
				item.amount__c = multiply;
				
				
			}
			
			
		}else {
			
						if (log.percent_markup__c==null) { 
			
							item.amount__c = log.amount__c;
						} else {
							markup = log.percent_markup__c;
											
							Double multiply = (markup/100 * log.amount__c)+log.amount__c;
							item.amount__c = multiply;
										
						}
		
		}
		
		item.vendor__c = log.vendor__c;
		item.expense_log__c = log.id;
		item.vendor_invoice_number__c = log.vendor_invoice_number__c;
		
		exitems.add(item);
		
		
	}
	
		
	
		insert(items);
		insert(exitems);
	}
	else if (trigger.isBefore&&trigger.isInsert) {	
		invoice.start_date__c = project.start_date__c;
		
		invoice.completion_date__c = project.completion_date__c;
		
		
		
	}
	
	if (trigger.isUpdate&&trigger.isAfter) {
		
		Invoice__c invoiceold = Trigger.old[0];
		
		
		
		if (invoice.Is_Finalized__c==true&&invoiceold.Is_Finalized__c==false) {
			
			ClientInvoiceController cic = new ClientInvoiceController(invoice.id);
			
			cic.finalizeWithoutUpdate();
			
			invoice = cic.getInvoice();
			
			invoice.Client_PO__c = project.purchase_order__c;
			
			update invoice;
			
			project.unbilled_amount_dyn__c = 0;
			
			update project;
			
			
		}
		
	}
	
	//		for (Invoice__c inv:Trigger.new) {
				
				
				
				
	//		}
	
	
	

}