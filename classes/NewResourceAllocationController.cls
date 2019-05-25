public with sharing class NewResourceAllocationController {

	String milestoneId = null;
	Milestone__c milestone;
    public Resource_Allocation__c ra = new Resource_Allocation__c();    
    String retURL = '';
    
    String projectId = '';
    
    Project__c project;

    public NewResourceAllocationController(String milestoneId) {    	
		milestone = [select id,name,project__c from milestone__c where id=:milestoneId];
		ra.milestone__c = milestone.id;
    }


    public NewResourceAllocationController(ApexPages.StandardController controller) {
    	try{
			if (System.currentPageReference().getParameters().get('retURL')!=null) {
	        	milestoneId = System.currentPageReference().getParameters().get('retURL');
	        	retUrl = milestoneId;
	        	milestoneId = milestoneId.substring(1,milestoneId.length());
	        	milestone = [select id,name,project__c from milestone__c where id=:milestoneId];
	        	ra.milestone__c = milestone.id;
	        	
			}
		}catch(Exception e){
			
			System.debug('EXCEPTION: '+e);
			
			System.debug(System.currentPageReference().getParameters().get('retURL'));
			
			try {
	        	retUrl = System.currentPageReference().getParameters().get('retURL');
	        	projectId = retUrl.substring(1,retUrl.length());
	        	project = [select id,name from project__c where id=:projectId];
	        	ra.project__c = project.id;
	        	
			} catch (Exception se) {
				System.debug('Second EXCEPTION: '+se);
				
			}
			
			
			
		}
	}
    
    
    
    public String roleId;
    
    public void setRoleId(String roleId) {
    	
    	this.roleId = roleId;
    	
    }
    
    public String getRoleId() {
    	
    	return roleId;
    }
    
    
    
    public Resource_Allocation__c getRa() {
    	return ra;    	
    }
    
    public void setRa(Resource_Allocation__c ra) {
    	this.ra = ra;
    }
    
    public List<SelectOption> getRoles() {
    	Pricing_Sheets__c[] roles;    	
    	if (milestone!=null) { 
    	 roles = [select id,name from Pricing_Sheets__c where Project__c=:milestone.project__c];
    	} else {
    		 roles = [select id,name from Pricing_Sheets__c where Project__c=:project.id];
    	}     	
    	List<SelectOption> options = new List<SelectOption>();    	
    	for (Pricing_Sheets__c r:roles) {          
    		  		
        	options.add(new SelectOption(r.id,r.name));        
    	}
        return options;
    }
    
    
    public PageReference saveRa() {	
    	ra.Role__c = roleId;    	
    	insert ra;
    	PageReference ref = new PageReference(retUrl);
    	ref.setRedirect(true);
    	return ref;
    	
    }
    	
    	
    	
    	
    	
    	
    
    
    
    
    
    

}