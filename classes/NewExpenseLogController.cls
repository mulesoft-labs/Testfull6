public class NewExpenseLogController {

Expense_Log__c log = new Expense_Log__c();

public Expense_Log__c getLog() {
	
	return log;
}

    public string VendorID {get ; set ;}

public NewExpenseLogController(Id projectId) {
		
		this.projectId = projectId; 
		
		project = [select id,name from project__c where id=:projectId];
		
	}

public void setLog(Expense_Log__c log) {
	this.log = log;
}

Project__c project;
	   String projectId = null; 


    public NewExpenseLogController(ApexPages.StandardController controller) {
 	 if (System.currentPageReference().getParameters().get('retURL')!=null) {
        
        	projectId = System.currentPageReference().getParameters().get('retURL');
        	
        	projectId = projectId.substring(1,projectId.length());
        	
        	project = [select id,name from project__c where id=:projectId];
        	log.Project__c = project.id;
        	
        	
    }
    }
    
      public List<selectOption> VendorList {get {
        List<selectOption> myVendorList = new List<selectOption>();
        for (Vendor__c vend : [select Name,id from Vendor__c])
            myVendorList.add(new selectOption(vend.id, vend.name));
        return myVendorList;
        }
        private set;
    }
    
    
    public PageReference save() {
    	
    	String id = UserInfo.getUserId();
    	Employee__c employee = [select name,id from employee__c where user__c=:id];
    	log.Employee__c = employee.id;
    	
    	log.vendor__c = vendorId;
    	
    	insert log;
    	PageReference ref = new PageReference('/'+projectId);
    	ref.setRedirect(true);
    	
    	return ref;
    	
    }
    
    public PageReference cancel() {
    	
    		
    	PageReference ref = new PageReference('/'+projectId);
    	ref.setRedirect(true);
    	
    	return ref;
    	
    }

}