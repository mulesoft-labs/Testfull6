public with sharing class InvoiceRecipientSelectController {

	String invoiceId;
	
	Invoice__c invoice = null;
	//List<Contact>
	//Contact[] 
	
	Contact[] accountContacts = new Contact[0];
	
	boolean isInvoiceFinalized = false;
	
	public boolean getIsInvoiceFinalized() {
		
		if (invoice.Is_Finalized__c==true) {
			return true;
		}
		else {
			return false;
		}
		
	}
	
	public InvoiceRecipientSelectController(String invoiceId) {
			
		
		List<Invoice__c> invoices = [select id,name,is_finalized__c,project__r.account__c,project__r.account__r.name,invoice_number__c from Invoice__c where id=:invoiceId];
		
		invoice = invoices[0];
		
		String accountId = invoice.project__r.account__c;
		
		accountContacts = [select id,name,email,email_selected__c from Contact where accountid=:accountId and accounts_receivable_contact__c=true];
			
		
		
	}
	
    public InvoiceRecipientSelectController(ApexPages.StandardController controller) {
		
		invoiceId = controller.getId();
		
		//invoiceId = ApexPages.currentPage().getParameters().get('id');
		
		
		List<Invoice__c> invoices = [select id,name,is_finalized__c,project__r.account__c,project__r.account__r.name,invoice_number__c from Invoice__c where id=:invoiceId];
		
		invoice = invoices[0];
		
		String accountId = invoice.project__r.account__c;
		
		accountContacts = [select id,name,email,email_selected__c from Contact where accountid=:accountId and accounts_receivable_contact__c=true];
			
		
    }
    
    
    public List<Contact> getAccountContacts() {
    	
    	return accountContacts;
    	
    }
    
    public PageReference emailSelectedContacts() {
    	
    	List<String> emailAddresses = new List<String>();
    	
    	for (Contact c:accountContacts) {
    		
    		if (c.email_selected__c==true) {
    	
    				emailAddresses.add(c.email);		
    			
    			
    		}
    		
    		
    	}
    	
    	emailPDF(accountContacts);
    	
    	Task_Create_Template__c[] tcts = [select related_object_name__c,user__c,due_date_days__c,task_subject__c,private_task__c from task_create_template__c];
    	
    	
    	System.debug('Tct size: '+tcts.size());
    	
    	Task[] insertTasks = new Task[0];
    		
    	for (Task_Create_Template__c tct:tcts) {
    		
    		Task t = new Task();
    		
    		
    		
    		String subject = tct.task_subject__c;
    		
    		if (subject.lastIndexOf('{!accountname')!=null) {
    			
    			subject = subject.replace('{!accountname}', invoice.project__r.account__r.name);
    					
    		}
    		
    		if (invoice.invoice_number__c!=null) {
    		if (subject.lastIndexOf('{!invoicenumber')!=null) {
    			
    			subject = subject.replace('{!invoicenumber}', invoice.invoice_number__c);
    					
    		}
    		}
    		
    		t.Subject = subject;
    		t.ownerid = tct.user__c;
    		
    		String objectName = tct.related_object_name__c;
    		
    		if (objectName!=null) {
    			
    			if (objectName.equals('Invoice__c')) {
    				
    				t.WhatId = invoice.id;
    				
    			}
    			else if (objectName.equals('Account')) {
    				
    				t.WhatId = invoice.project__r.account__c;
    				
    			}
    			
    			
    			
    		}
    		
    		decimal dueDateDays = tct.due_date_days__c;
    		
    		if (dueDateDays!=null) {
    			
    			Date d = Date.today();
    			
    			
    			integer days = duedatedays.intvalue();
    			
    			Date newDate = d.addDays(days);
    			
    			
    			t.activityDate = newDate; 
    			
    		}
    		
    		if (tct.private_task__c==true) {
    			
    			Private_Task__c pt = new Private_Task__c();
    			insert pt;
    			
    			t.whatid = pt.id;
    			
    		}
    		
    		
    		insertTasks.add(t);
    		
    		
    	} 
    	
    //	insert (insertTasks);
    	
    	
		PageReference ref = new PageReference('/'+invoiceId);
		ref.setRedirect(true);
		return ref;
    	
    }
    
    public boolean createTasks {get;set;}
    
      public PageReference emailSelectedContacts(Blob b) {
    	
    	List<String> emailAddresses = new List<String>();
    	
    	for (Contact c:accountContacts) {
    		
    		if (c.email_selected__c==true) {
    	
    				emailAddresses.add(c.email);		
    			
    			
    		}
    		
    		
    	}
    	
    	emailPDF(accountContacts);
    	
    	
		PageReference ref = new PageReference('/'+invoiceId);
		ref.setRedirect(true);
		return ref;
    	
    }
    
    public PageReference goBack() {
    	
    	
		PageReference ref = new PageReference('/'+invoiceId);
		ref.setRedirect(true);
		return ref;
		
    	
    }
    
    Blob b = null;
    
    public void setBlob(Blob b) {
    	
    	this.b = b;
    }
    
     public void emailPDF(Contact[] accountContacts) {
    	
    	
    	//https://c.na3.visual.force.com/apex/ClientInvoice?scontrolCaching=1&id=a0850000003Iz23
    	
    	PageReference pdf =  Page.ClientInvoice;
		pdf.getParameters().put('id',invoiceId);
		pdf.setRedirect(true);
		
		
		String invoiceNumber = invoice.Invoice_Number__c;
		if (invoiceNumber==null) {
			invoiceNumber = invoiceId;
		}
		
		if (b==null) {
				b = pdf.getContent();
		
		}
		
		  List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();
		
		
		for (Contact c:accountContacts) {
			
			if (c.email_selected__c==true) {
    	
    	
    	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setFileName('invoice_'+invoiceNumber+'.pdf');
		
		efa.setBody(b);
    	
                
                        
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              
    	                String[] toAddresses = new String[] {c.email}; 
    	
    	mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
    	
    	                     String userName = UserInfo.getUserName();
                User activeUser = [Select Email From User where Username = : userName limit 1];
                String userEmail = activeUser.Email;
    	
    	
    	                mail.setReplyTo(userEmail);
    	                
    	                
    	        String fromName = UserInfo.getFirstName() + ' '+UserInfo.getLastName();
                
                fromName = UserInfo.getName();
                
                mail.setSenderDisplayName(fromName);
                
                mail.setWhatId(invoice.project__r.account__c);
                
                
                mail.setTargetObjectId(c.id);
	                mail.setSaveAsActivity(true);
	                
	                 //String[] ccAddresses = new String[]{'karl@kasai-consulting.com','rebecca@kasai-consulting.com','david@kasai-consulting.com'};
	                 String[] ccAddresses = new String[]{'karl@kasai-consulting.com','david@kasai-consulting.com'}; // Should be done as a static config
                
                
                mail.setCcAddresses(ccAddresses);
				
                String usersetsubject = 'Invoice';
                
                EmailTemplate[] ets = [SELECT id FROM EmailTemplate WHERE name like '%Invoice Template%'];
                
                if (ets.size()>0) {
                	EmailTemplate et = ets[0];
                mail.setTemplateId(et.id);
                
                } else {
                
                  String body = 'Please find your invoice attached';
                
             mail.setHtmlBody(body);
              mail.setSubject(userSetSubject);
              
                   
                String plainText = body.replace('<br/>', '\n');
                
                plainText = plainText.replace('<html>', '');
                plainText = plainText.replace('</html>', '');
                plainText = plainText.replace('<body>', '');
                plainText = plainText.replace('</body>', '');
                
                mail.setPlainTextBody(plainText);
              
                }
                
                
                
                mail.setToAddresses(toAddresses);
                
                myEmails.add(mail);
                
			}
                
		}
		
		invoice.Approval_Status__c = 'Invoiced';
		update invoice;
                
                
                Messaging.sendEmail( myEmails);
    	
    	
    	
    }
    
    
    
    
    
    

}