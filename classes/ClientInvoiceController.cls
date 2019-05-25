public class ClientInvoiceController {


    List<Invoice_Item__c> invoiceItems;
    List<Invoice_Expense__c> invoiceExpenses;
    List<Invoice_Credit__c> invoiceCredits;
    
    List<Pricing_Sheets__c> rates;
    
    List<Time_Log__c> logs;
    
    List<Fixed_Fee_Log__c> fflogs;
    
    Date dueDate {get;set;}
    
    List<Pricing_Sheets__c> allRates;
    
    List<Pricing_Sheets__c> masterRateList;
    
    String invoiceId = null;
    
    
    
    public Date getDueDate() {
    	
    	return calculateDueDate();
    }
    
     public ClientInvoiceController(Invoice__c invoice) {
    	this.invoice = invoice;
    	
    	
    	
    }
    
     
    
  
    public Date getTodaysDate() {
    	
    	if (invoice==null) {
    		
    		System.debug('Invoice is null');
    		
    	}
    	
    	System.debug('Invoice id: '+invoice.id+ ': invoice name: '+invoice.name);
    	
    	System.debug('TODAY DATE: '+invoice.invoice_date__c+  ' : '+invoice.invoice_number__c);
    	
    	
    	
    	return invoice.invoice_date__c;
    }
    
    Opportunity opp;
    public Opportunity getOpportunity() {
        return opp;
    }
    
    public Invoice_Expense__c[] getInvoiceExpenses() {
    	
    	return invoiceExpenses;
    }
    
    public Invoice_Credit__c[] getInvoiceCredits() {
    	
    	return invoiceCredits;
    }
    
    public Invoice__c getInvoice() {
    	
    	return invoice;
    }
    
    Invoice__c invoice;
    
    Project__c project;
    
    public boolean getRenderFixedFee() {
    	
    	String invoiceStyle = invoice.invoice_style__c;
    	
    	if (invoiceStyle==null)
    		return false;
    	
    	if (invoiceStyle.equals('Fixed Fee')) {
    		return true;
    	}
    	else {
    		
    		return false;
    	}
    	
    }
    
    
    
    public ClientInvoiceController(String invoiceId) {
    	
    	        
    	
    	List<Invoice__c>invoices  = [select name,id,client_po__c,project__c,invoice_number__c,start_date__c,completion_date__c,invoice_date__c,payment_terms__c,invoice_legend__c,invoice_style__c,due_date__c from invoice__c where id=:invoiceid];
    	
    	invoice = invoices[0];
    	
        List<Project__c> projects = [select name,id,account__c,purchase_order__c from project__c where id=:invoice.Project__c];
        
        project = projects[0];
        
        allRates = [select name,id,principal_consultant_rate__c from pricing_sheets__c where project__c=:project.id];
        invoiceItems = [select name,id,description__c,hours__c,date__c,amount__c,time_log__c,bill_as__c,bill_as__r.name from invoice_item__c where invoice__c =:invoice.id order by date__c];
        invoiceExpenses = [select name,id,description__c,date__c,amount__c from invoice_expense__c where invoice__c =:invoice.id order by date__c];
        invoiceCredits = [select name,id,description__c,date__c,amount__c from invoice_credit__c where invoice__c =:invoice.id order by date__c];
        
        rates = [select name,id,principal_consultant_rate__c from pricing_sheets__c where project__c=:project.id];
        logs = [select name,id,amount__c,hours__c,pricing_sheet__c,date__c,activity_description__c from time_log__c where project__c=:project.id];
    	
    	fflogs = [select name,id,amount__c,Description__c,date__c from fixed_fee_log__c where invoice__c=:invoice.id];
    	
    	invoice.total_due__c = this.getTotalDue();
    	
    	invoice.due_date__c = this.calculateDueDate();
    	
    	invoice.Client_PO__c = project.purchase_order__c;
    	
    	
    	
    	System.debug('Invoice date in construct: '+invoice.invoice_date__c);
    	
    	
    }
    public ClientInvoiceController(ApexPages.StandardController controller) {
    	
      invoiceId = System.currentPagereference().getParameters().get('id');
      
      if (invoiceId!=null) {
               allRates = [select name,id,principal_consultant_rate__c from pricing_sheets__c];
      
List<Invoice__c>invoices  = [select name,id,client_po__c,project__c,invoice_number__c,start_date__c,completion_date__c,invoice_date__c,payment_terms__c,invoice_legend__c,invoice_style__c,due_date__c from invoice__c where id=:invoiceid];
    	
    	invoice = invoices[0];
    	
    	      
  List<Project__c> projects = [select name,id,account__c,purchase_order__c from project__c where id=:invoice.Project__c];
        
        project = projects[0];
        
        
        
        invoiceItems = [select name,id,description__c,hours__c,date__c,amount__c,time_log__c,bill_as__c,bill_as__r.name from invoice_item__c where invoice__c =:invoice.id  order by date__c];
        invoiceExpenses = [select name,id,description__c,date__c,amount__c from invoice_expense__c where invoice__c =:invoice.id order by date__c];
        invoiceCredits = [select name,id,description__c,date__c,amount__c from invoice_credit__c where invoice__c =:invoice.id order by date__c];
    	rates = [select name,id,principal_consultant_rate__c from pricing_sheets__c where project__c=:project.id];
       logs = [select name,id,amount__c,hours__c,pricing_sheet__c,date__c,activity_description__c from time_log__c where project__c=:project.id];
        fflogs = [select name,id,amount__c,description__c,date__c from fixed_fee_log__c where invoice__c=:invoice.id];
        invoice.total_due__c = this.getTotalDue();
        invoice.due_date__c = this.calculateDueDate();
        invoice.Client_PO__c = project.purchase_order__c;
        
        System.debug('Invoice date in construct: '+invoice.invoice_date__c);
      }
        
    }
    
    public List<Fixed_Fee_Log__c> getFFLogs() {
    	
    	return fflogs;
    	
    }
    
    public List<Invoice_Item__c> getInvoiceItems() {
    
        return invoiceItems;
    
    }
    
    public Date calculateDueDate() {
    	
    	
    	Date dueDate = Date.today();
    	
    	
    	String terms = invoice.Payment_Terms__c;
    	
    	System.debug('Terms; '+terms);
    	
    	if (terms==null) {
    		
    		return dueDate;
    		
    	}
    	
    	
    	if (terms.equals('Payable on Receipt')) {
    		
    		return dueDate;
    	}
    	else if (terms.equals('Net 30')) {
    		
    		return dueDate.addDays(30);
    		
    	}
    	else if (terms.equals('Net 45')) {
    		
    		System.debug('It equaled net 45. '+dueDate.addDays(45));
    		
			return dueDate.addDays(45);   
			 		
    	}
    	else if (terms.equals('Net 75')) {
    		
    		return dueDate.addDays(75);
    		
    	}
    	else if (terms.equals('Net 90')) {
    		
    		return dueDate.addDays(90);
    		
    	}
    	else {
    		
    		return dueDate;
    	}
    	
    	
    }
    
    
    
    public List<Legend__c> getInvoiceLegends() {
    	
    	Invoice_Legend__c il = null;
    	Legend__c[] legends = new Legend__c[0];
    	try {
    		il = [select name,id from invoice_legend__c where id=:invoice.invoice_legend__c];
    	
    	} catch (Exception e) {
    		
    	}
    	
    	
    	if (il!=null) {
    	
    	System.debug('IL Name: '+il.name);	
    	
    	legends = [select name,id,abbreviation__c,full_description__c from legend__c where invoice_legend__c=:il.id];
    	
    	}
    	
    	System.debug('Returning legends of size: '+legends.size());
    	return legends;
    	
    }
    
    public boolean getHasLegend() {
    	
    	return this.getInvoiceLegends().size()>0;
    	
    }
    
    public ServiceItemComposite[] getTimeLogs() {
    	
    	List<ServiceItemComposite> tlcs = new List<ServiceItemComposite>();
    	
    	for (Invoice_Item__c item:invoiceItems) {
    		
    		
    		if (item.Time_Log__c!=null) {
    		    		ServiceItemComposite tlc = new ServiceItemComposite();
    		
    		
			    		for (Time_Log__c tl:logs) {
			    			
			    			if (tl.id==item.time_log__c) {
			    				
			    				System.debug('The time log was there: '+item.description__c);
			    				
			    				//tlc.itemDate = tl.Date__c;
			    				
			    				//tlc.log = tl;	
			    				
			    				for (Pricing_Sheets__c rate:rates) {
			    			
			    					if (tl.pricing_sheet__c==rate.id) {
			    						
			    						tlc.hourlyrate = rate.Principal_Consultant_Rate__c;
			    						tlc.amount = rate.Principal_Consultant_Rate__c*item.Hours__c;
			    						tlc.hours = item.Hours__c;
			    						tlc.itemdate = item.date__c;
			    						tlc.rateName = rate.Name;
			    						tlc.description = item.Description__c;
			    						
			    					}
			    				
			    				}
			    				
			    					
			    					
			    				}
			    				
			    				
			    			}
			    			tlcs.add(tlc);
			    			
    			
    		}
    		else {
    			
    			
    					
    					    	ServiceItemComposite tlc = new ServiceItemComposite();
    					
    						
    					
		    					for (Pricing_Sheets__c rate:rates) {
		    			
		    					if (item.bill_as__c!=null) {
		    					
		    					String itratename = item.bill_as__r.name;
		    						
		    					
		    					String rateName = rate.name;
		    					
		    					if (itratename.equals(rateName)) {
		    						
		    						
		    							tlc.hourlyrate = rate.Principal_Consultant_Rate__c;
			    						tlc.amount = rate.Principal_Consultant_Rate__c*item.Hours__c;
			    						tlc.hours = item.Hours__c;
			    						tlc.itemdate = item.date__c;
			    						tlc.rateName = rateName;
			    						
			    						
			    						tlc.description = item.description__c;
		    						
		    						
		    						}
		    						else {
		    							
		    							System.debug('Did not find the rate: '+itratename+ ' : '+rate.name+ ' : '+item.Description__c);
		    						}
		    				
		    						}
		    					}
		    					    				    						    			tlcs.add(tlc);


    			
    		}
    			
    			

    			
    		}
    		
    		
    		    	return tlcs;
    		
    		
    		/*
    			
    				if (item.time_log__c==null) {
    					
    					System.debug('The pricing sheet is still null... need to now associate: '+item.description__c);
    					for (Invoice_Item__c it:invoiceItems) {
    						
    						System.debug('Checking item: '+item.description__c);
    					
    					for (Pricing_Sheets__c rate:rates) {
    			
    					if (it.bill_as__c!=null) {
    					
    					String itratename;	
    						for (Pricing_Sheets__c dumbRate:allRates) {
    							if (dumbrate.id==it.bill_as__c) {
    								itratename = dumbrate.name;
    							}
    							
    						}
    						
    						System.debug('Bill as was not null: '+it.bill_as__c);
    						
    					
    					String rateName = rate.name;
    					
    					if (itratename.equals(rateName)) {
    						
    						System.debug('Found the rate... '+rate.Principal_Consultant_Rate__c+ ' : '+it.Hours__c+ ' : '+it.Description__c);
    						
    						tlc.ps = rate;
    						//item.Amount__c = rate.Principal_Consultant_Rate__c*it.Hours__c;
    						
    						tlc.amount = rate.Principal_Consultant_Rate__c*it.Hours__c;
    						
    						
    						}
    						else {
    							
    							System.debug('Did not find the rate: '+itratename+ ' : '+rate.name+ ' : '+it.Description__c);
    						}
    				
    						}
    					}
    					}
    				}
    			
    			System.debug ('For this item, setting tlc to this: '+tlc.amount+ ' : '+item.Description__c);	
    			if (tlc.amount==null) {
    				
    				
    				//tlc.amount = tlc.log.amount__c;
    				
    			}
    				
    			tlc.item = item;
    					
    			tlc.itemDate = item.Date__c;
    			tlcs.add(tlc);   		
    			
    		}
    		
    			
    		*/
    		
    			
    				
    		
    	//	if (tlc.itemDate==null) {
    			
    			
    			
    	//	}
    		
    		
    		
    	
    	
    	
    	
    	
    }
    
     public Double getAmountForInvoiceItem(Pricing_Sheets__c[] rates, Invoice_Item__c it) {
    	
    	Double amount = 0;
    	for (Pricing_Sheets__c rate:rates) {
    			
    					if (it.bill_as__c==rate.id) {
    						
    						
    						
    						
    						amount = rate.Principal_Consultant_Rate__c*it.Hours__c;
    						
    						
    						}
    				
    			}
    			
    			return amount;
    	
    	
    }
    
   
    
    
    public Double getTotalDue() {
       
       Double total = totalItemsExpensesCredits();
           total = total+.00;
           
           
            return total;
    }
    
    public boolean getRenderTimeLogs() {
    	
    	if (this.getRenderFixedFee()) {
    		return false;
    	}
    	else {
    		return true;
    	}
    	
    }
    
    public boolean getRenderCredits() {
    	
    	return invoiceCredits.size()>0;
    	
    }
    
    public boolean getrenderExpenses() {
    	
    	return invoiceExpenses.size()>0;
    	
    }
    
    public Double getTotalCredits() {
    	
    	Double total = 0;

		if (invoiceCredits!=null) {    	
    	  for (Invoice_Credit__c credit:invoiceCredits) {
       	
       
          total = total+credit.amount__c;
          
       }
		}
    	
    	return total;
    	
    }
    
    public Double getTotalExpenses() {
    	
    	Double total = 0;
    	
    	if (invoiceExpenses!=null) {
    	   for (Invoice_Expense__c expense:invoiceExpenses) {
       	
          total = total+expense.amount__c;
          
       }
    	}
    	
    	return total;
    	
    }
    
    public Double getTotalServiceItems() {
    	
    	Double total = 0;
    	
    	if (this.getRenderFixedFee()==false) {
       	 List<ServiceItemComposite> sic = getTimeLogs();
       	
       	for (ServiceItemComposite sc:sic) {
       	  
       	  
       	  if (sc.amount!=null) {
       	  
          total = total+sc.amount;
       	  }
       	  
          
       }
    	}
    	else {
    		
    		if (fflogs!=null) {
    		for (Fixed_Fee_Log__c fflog:fflogs) {
    			
    			if (fflog.amount__c!=null) {
    			total = total+fflog.amount__c;
    			}
    		}
    		}
    		
    	}
    	
    	return total;
       
    	
    	
    	
    }
    
    public Double totalItemsExpensesCredits() {
    	
    	Double total = getTotalServiceItems();
    	
    	
       
       Double expenses = getTotalExpenses();
       
       Double credits = getTotalCredits();
       
       total = total + expenses - credits;
       
       return total;
    	
    	
    }
    
    
    public Account getAccount() {
        
        Account acc;
        
        
        Account[] accounts = [select id,name,billingstreet,billingstate,billingpostalcode,billingcity,billing_attention_of__c from account where id=:project.account__c];
        
        if (accounts.size()>0) {
        acc = accounts[0];
        }
        
        if (acc==null) {
        	
        	acc = new Account();
        	acc.name = 'No Account Associated';
        }
        
        return acc;
        
    }
    
    public Project__c getProj() {
        
        return project;
    }
    
    public void finalizeWithoutUpdate() {
    	Invoice_Transaction__c invTrans = new Invoice_Transaction__c();
 		invTrans.transaction_time__c = System.now();
 		invTrans.invoice__c = invoice.id;
 		insert invTrans;
 
 		List<Invoice_Item__c> invoiceItemsFinal = [select name,id,description__c,hours__c,date__c,amount__c,time_log__c,invoice_transaction__c from invoice_item__c where invoice__c =:invoice.id order by date__c];
        List<Invoice_Expense__c> invoiceExpensesFinal = [select name,id,description__c,date__c,amount__c,expense_log__c,invoice_transaction__c from invoice_expense__c where invoice__c =:invoice.id order by date__c];
		List<Invoice_Credit__c> invoiceCreditsFinal = [select name,id,description__c,date__c,amount__c,invoice_transaction__c from invoice_credit__c where invoice__c =:invoice.id order by date__c];
		      	
      	List<Id> timeLogIds = new List<Id>();
      	List<Id> expenseIds = new List<Id>();
      	
      	
      	
      	for (Invoice_Item__c item:invoiceItemsFinal) {
      		timeLogIds.add(item.time_log__c);
      		item.invoice_transaction__c = invTrans.id;
      		
      	}
      	
      	for (Invoice_Expense__c expense:invoiceExpensesFinal) {

      		expenseIds.add(expense.expense_log__c);
			expense.invoice_transaction__c = invTrans.id;
      	}
      	for (Invoice_Credit__c credit:invoiceCreditsFinal) {

      		
			credit.invoice_transaction__c = invTrans.id;
      	}
      	update invoiceItemsFinal;
      	update invoiceExpensesFinal;
      	update invoiceCreditsFinal;
      	
      	
      	Time_Log__c[] timeLogs = [select name,id,billed_status__c from time_log__c where id in:timeLogIds];
      	
      	Expense_Log__c[] expenseLogs = [select name,id,billed_status__c from expense_log__c where id in:expenseIds];
      	
      	for (Time_Log__c log:timeLogs) {
      		
      		log.Billed_Status__c = 'Invoiced';
      		
      	}
      	
      	update timeLogs;
      	
      	for (Expense_Log__c log:expenseLogs) {
      		log.Billed_Status__c = 'Invoiced';
      		
      	}
      	
      	update expenseLogs;
 		
 		invoice.is_finalized__c = true;
 		
 		invoice.due_date__c = this.getDueDate();
 		
 		invoice.total_due__c = this.getTotalDue();
    	
    	
    }
    
    public PageReference finalizeInvoice() {
    	
    	//System.debug('Will finalize this invoice: '+invoice.id);
 		Invoice_Transaction__c invTrans = new Invoice_Transaction__c();
 		invTrans.transaction_time__c = System.now();
 		invTrans.invoice__c = invoice.id;
 		insert invTrans;
 
 		List<Invoice_Item__c> invoiceItemsFinal = [select name,id,description__c,hours__c,date__c,amount__c,time_log__c,invoice_transaction__c from invoice_item__c where invoice__c =:invoice.id order by date__c];
        List<Invoice_Expense__c> invoiceExpensesFinal = [select name,id,description__c,date__c,amount__c,expense_log__c,invoice_transaction__c from invoice_expense__c where invoice__c =:invoice.id order by date__c];
		List<Invoice_Credit__c> invoiceCreditsFinal = [select name,id,description__c,date__c,amount__c,invoice_transaction__c from invoice_credit__c where invoice__c =:invoice.id order by date__c];
		      	
      	List<Id> timeLogIds = new List<Id>();
      	List<Id> expenseIds = new List<Id>();
      	
      	
      	
      	for (Invoice_Item__c item:invoiceItemsFinal) {
      		timeLogIds.add(item.time_log__c);
      		item.invoice_transaction__c = invTrans.id;
      		
      	}
      	
      	for (Invoice_Expense__c expense:invoiceExpensesFinal) {

      		expenseIds.add(expense.expense_log__c);
			expense.invoice_transaction__c = invTrans.id;
      	}
      	for (Invoice_Credit__c credit:invoiceCreditsFinal) {

      		
			credit.invoice_transaction__c = invTrans.id;
      	}
      	update invoiceItemsFinal;
      	update invoiceExpensesFinal;
      	update invoiceCreditsFinal;
      	
      	
      	Time_Log__c[] timeLogs = [select name,id,billed_status__c from time_log__c where id in:timeLogIds];
      	
      	Expense_Log__c[] expenseLogs = [select name,id,billed_status__c from expense_log__c where id in:expenseIds];
      	
      	for (Time_Log__c log:timeLogs) {
      		
      		log.Billed_Status__c = 'Invoiced';
      		
      	}
      	
      	update timeLogs;
      	
      	for (Expense_Log__c log:expenseLogs) {
      		log.Billed_Status__c = 'Invoiced';
      		
      	}
      	
      	update expenseLogs;
 		
 		invoice.is_finalized__c = true;
 		
 		invoice.due_date__c = this.getDueDate();
 		
 		invoice.total_due__c = this.getTotalDue();
 		
 		update invoice;
 		   	
    	String invoiceId = invoice.id;
    	
    	PageReference ref = new PageReference('/'+invoiceId);
    	ref.setRedirect(true);
    	return ref;
    	
    }
    
    



    

}