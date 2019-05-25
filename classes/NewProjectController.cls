public with sharing class NewProjectController {
	
	ApexPages.StandardController projController;
	public Project__c kasaiProject{get;set;}
	public Project__c cloningProject{get;set;}
	public boolean cloneFromExistingProject{get;set;}
	
	
	public boolean cloneFromProjectTemplate{get;set;}
	
	List<SelectOption> projectOptions;
	
	
    public List<Pricing_Sheets__c> lstRoles{get;set;}
    public boolean enableLookup = false;
    public boolean enableLookupSection{get;set;} 
    
    
    private String projectId = null;    
    private String oppId = null;
    private String accId = null;
    private String oppName = null;
    private String oppQuantity = null;
    private boolean updtOpp = false;
    String selectedProjectId = null;
    
    
    public String getSelectedProjectId() {
        
        return selectedProjectId;
    }
    
    public void setSelectedProjectId(String id) {
        
        this.selectedProjectId = id;
        
    }
    
    
    
    
    
    
    public NewProjectController(ApexPages.StandardController controller) {
        projController = controller;
        projectId = projController.getId();
        kasaiProject = (Project__c)projController.getRecord();
        init();
    }
    
    
     public List<SelectOption>  getProjectTemplates() {
        
        
        try {
           
            
            Project__c[] projects = [select id,name from Project__c where Project_Template__c=true];
            
        
        projectOptions = new List<SelectOption>();
        projectOptions.add(new SelectOption('None','None'));
        
        for (Project__c proj:projects) {
            projectOptions.add(new SelectOption(proj.id,proj.name));
        }
        
        return projectOptions;    
        } catch (Exception e) {
        	
        	return null;
        }
    
    
            
        
    }
    
    public void init(){    	
    	
    	if((System.currentPageReference().getParameters().get('cloningId')!=null)&&(System.currentPageReference().getParameters().get('clone')!=null)){
    		selectedProjectId = ApexPages.currentPage().getParameters().get('cloningId');
    		lstRoles = [Select Id, Name, Principal_Consultant_Rate__c, Master_Rate__c  From Pricing_Sheets__c Where Project__c =:selectedProjectId];        	
        	cloningProject = [Select Id, Name, Account__c, Projected_Completion_Date__c, Project_Limit__c, Generate_Default_Milestones__c, Generate_Default_Work_Tasks__c, Primary_Contact__c, Opportunity_Source__c, Special_Handling__c, RecordTypeId From Project__c Where Id =:selectedProjectId];
        	cloneProjects(cloningProject);
        	enableLookupSection=true;
        	enableLookup=true;
    		
    	}else{
			if (System.currentPageReference().getParameters().get('retURL')!=null) {
				projectId = System.currentPageReference().getParameters().get('retURL');
				projectId = projectId.substring(1,projectId.length());
			}
	         
	        if (System.currentPageReference().getParameters().get('oppId')!=null) {
	         	oppId= System.currentPageReference().getParameters().get('oppId');
	         	if(oppId!=''){
	         		kasaiProject.Opportunity_Source__c = oppId;
	         		updtOpp=true;
	         	}
	        }
	         
	        if (System.currentPageReference().getParameters().get('accId')!=null) {
	         	accId=System.currentPageReference().getParameters().get('accId');
	         	if(accId!=''){
	         		Contact projContact = getPrimaryContact();
	         		if(projContact!=null){
	         			kasaiProject.Primary_Contact__c = projContact.Id;
	         		}
	         		kasaiProject.Account__c = accId;
	         	}
	         }
	         
	         if (System.currentPageReference().getParameters().get('specHdn')!=null) {
	         	String specHdln =System.currentPageReference().getParameters().get('specHdn');
	         	if(specHdln!=''){
	         		if(specHdln=='1'){
	         			kasaiProject.Special_Handling__c = true;
	         		}else{
	         			kasaiProject.Special_Handling__c = false;
	         		}
	         	}
	         }
	         
	         if (System.currentPageReference().getParameters().get('oppName')!=null) {         	
	         	oppName=System.currentPageReference().getParameters().get('oppName');
	         	if(oppName!=''){
	         		kasaiProject.Name=oppName;
	         	}         	
	         }
	         
	         if (System.currentPageReference().getParameters().get('oppTotal')!=null) {
	         	oppQuantity=System.currentPageReference().getParameters().get('oppTotal');
	         	if(oppQuantity!=''){
		         	String valueOne = oppQuantity.replace('$', '');
		         	String valuetwo = valueOne.replace(',', '');
		         	Decimal total = Decimal.valueOf(valuetwo);
		         	kasaiProject.Project_Limit__c = total;
	         	}
	         }
	         
	         kasaiProject.Projected_Completion_Date__c = System.today();  
    	 }
    }
    
    public Contact getPrimaryContact(){
    	try{
    		Contact primaryContact=null;
    		boolean contactAss = false;
    		List<Contact> lstPrimContacts = [Select Id, Primary_Project_Contact__c From Contact];
    		if(lstPrimContacts.size()==1){
    			return lstPrimContacts[0];
    		}else{
    			for(Contact cont: lstPrimContacts){
    				if(contactAss==false){
	    				if(cont.Primary_Project_Contact__c==true){
	    					primaryContact = cont;
	    					contactAss=true;
	    				}
    				}
    			}
    		}
    		return primaryContact;
    	}catch(Exception e){
    		System.debug('The Account has no Contacts');
    		return null;
    	}     	
    }
    
	public PageReference projectSelected() {
        selectedProjectId = ApexPages.currentPage().getParameters().get('projId');
        if(selectedProjectId != null){
        	lstRoles = [Select Id, Name, Principal_Consultant_Rate__c, Master_Rate__c  From Pricing_Sheets__c Where Project__c =:selectedProjectId];        	
        	cloningProject = [Select Id, Name, Account__c, Projected_Completion_Date__c, Project_Limit__c, Generate_Default_Milestones__c, Generate_Default_Work_Tasks__c, Primary_Contact__c, Opportunity_Source__c, Special_Handling__c, RecordTypeId From Project__c Where Id =:selectedProjectId];
        	cloneProjects(cloningProject);
        }
        return null;
    }
    
    public void cloneProjects(Project__c clonedProject){
    	kasaiProject.Name = clonedProject.Name;
    	kasaiProject.Account__c = clonedProject.Account__c;
    	kasaiProject.Projected_Completion_Date__c = clonedProject.Projected_Completion_Date__c;
    	kasaiProject.Project_Limit__c = clonedProject.Project_Limit__c;
    	kasaiProject.Generate_Default_Milestones__c = clonedProject.Generate_Default_Milestones__c;
    	kasaiProject.Generate_Default_Work_Tasks__c = clonedProject.Generate_Default_Work_Tasks__c;
    	kasaiProject.Primary_Contact__c = clonedProject.Primary_Contact__c;
    	kasaiProject.Opportunity_Source__c = clonedProject.Opportunity_Source__c;
    	kasaiProject.Special_Handling__c = clonedProject.Special_Handling__c;
    	kasaiProject.RecordTypeId = clonedProject.RecordTypeId;
    }
    
    public PageReference saveProject() {
    	
    	System.debug('Start saveproject: '+selectedProjectId);
    	
    	System.debug('Clone from existing: '+cloneFromExistingProject);
    	
        if(cloneFromExistingProject==true){
        	List<Pricing_Sheets__c> newRoles = new List<Pricing_Sheets__c>();
        	
        	insert kasaiProject;
        	
        	
        	for(Pricing_Sheets__c role :lstRoles){
        		Pricing_Sheets__c newRole = new Pricing_Sheets__c();
        		newRole.Project__c = kasaiProject.Id;
        		newRole.Name = role.Name;
        		newRole.Master_Rate__c = role.Master_Rate__c;
        		newRole.Principal_Consultant_Rate__c = role.Principal_Consultant_Rate__c;
        		newRoles.add(newRole);
        	}
        	
        	if(!newRoles.isEmpty()){
        		insert newRoles;
        	}
        	
        	List<Milestone__c> milestones;  
        	      
	        if (kasaiProject.generate_default_milestones__c==true) {
	        	milestones = AutoGenMilestones.generateMilestones(kasaiProject.id);
	        }
	        
	        if (kasaiProject.generate_default_work_tasks__c==true&&kasaiProject.generate_default_milestones__c==true) {
				AutoGenMilestones.generateWorkTasks(milestones);
	        }
	        
        }else{
        	
	        if(updtOpp==true){
	        	Opportunity oppUpd = [Select Id, StageName From Opportunity Where Id =:oppId];
	        	oppUpd.StageName ='Closed Won';
	        	update oppUpd;        	
	        }
	        
	        insert kasaiProject;
	        
	        //if (this.cloneFromProjectTemplate==true) {
	        
	        if (this.selectedProjectId!=null&&this.selectedProjectId!='None') {
	        	
	        	System.debug('Ok going to clone');
	        	
	        	String templateId = selectedProjectId;
	        	String projectId = kasaiProject.id;
	        	
	        	CopyDocumentsAsAttachments.deepCloneProject(projectId,templateId);
	        	
	        }
	        else {
	        	
	        	System.debug('Will not clone');
	        }
	        
	        List<Milestone__c> milestones;        
	        if (kasaiProject.generate_default_milestones__c==true) {
	        	milestones = AutoGenMilestones.generateMilestones(kasaiProject.id);
	        }
	        
	        if (kasaiProject.generate_default_work_tasks__c==true&&kasaiProject.generate_default_milestones__c==true) {
				AutoGenMilestones.generateWorkTasks(milestones);
	        }
        }
        PageReference ref = new PageReference('/'+kasaiProject.id);
        ref.setRedirect(true);
        return ref;
        
	}
	
	public List<projectComposite> getProjectCompletion(){
		List<Project__c> lstProjectCompletion = [Select Id, Name, Projected_Completion_Date__c From Project__c Where Project_Status__c = 'Active' Order By Projected_Completion_Date__c DESC LIMIT 10];
		List<projectComposite> lstProjectComp = new List<projectComposite>();
		for(Project__c p : lstProjectCompletion){
			projectComposite pc = new projectComposite();
			pc.proj = p;
			String projCompletionDate = ''+ p.Projected_Completion_Date__c;
			pc.dateString = ''+ projCompletionDate.substring(0,10); 
			lstProjectComp.add(pc);
		}
		
		
		return lstProjectComp;
	}
	
	
	public PageReference cancelOp(){
		return null;
	}
	
	public boolean getEnableLookup(){
		return enableLookup;
	}
	
	public PageReference setEnableLookup(){
		if(enableLookup==true){
    		enableLookup=false;
    	}else{
    		enableLookup=true;
    	}
    	return null;
	}
	
	public class projectComposite{
		public String dateString {get;set;}
		public Project__c proj {get;set;}
	}
}