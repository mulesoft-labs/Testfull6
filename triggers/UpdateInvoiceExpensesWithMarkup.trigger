trigger UpdateInvoiceExpensesWithMarkup on Expense_Log__c (before update) {
	
	
	Expense_Log__c log = Trigger.new[0];
	
	Double markup = log.percent_markup__c;
	
	if (markup!=null) {
	Invoice_Expense__c[] invoiceExpenses = [select id,name,amount__c from Invoice_Expense__c where Expense_Log__c=:log.id and billed_status__c='Incurred'];
	
	
			for (Invoice_Expense__c ie:invoiceExpenses) {
				
								
							Double multiply = (markup/100 * log.amount__c)+log.amount__c;
							ie.amount__c = multiply;
		
		
			}
			
			update invoiceExpenses;
	
	}
	


}