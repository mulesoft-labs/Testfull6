public class NewTimeLogController {
    
    public boolean hasMilestone = false;
    public String billAs {get;set;}
    
    public String selectedCustomerDeliverable {get;set;}
    
    public String selectedWorkCategory {get;set;}
    
    
    public boolean hasWorkItems = false;
    
    public boolean hasDeliverables = false;
    
    public String selectedEmployee {get;set;}
    
    
    public String selectedWorkItem {get;set;}
    
    
    private boolean fromSave = false;
    
        
    String projectId = null; 
    Time_log__c log = new Time_log__c();
    Pricing_Sheets__c[] sheets;
    Project__c project;
    Milestone__c milestone;
    Work_Task__c workTask;
    User taskUser = null;
    List<SelectOption> options;
    
    List<SelectOption> projectOptions;
    List<SelectOption> cdOptions;
    
    List<SelectOption> employeeOptions;
    
    List<SelectOption> wtskOptions;
    
    List<SelectOption> projectWorkCategories;
    
    private String passedProjectId = null;
    
    
    public boolean completeWorkItem {get;set;}
    
    public boolean getIsSelectedProjectNull() {
        
        
        if (selectedProjectId == null) {
            
            return true;
        }
        else {
            return false;
        }
        
        
    }
    
    public boolean getIsPortalUser () {
    	
    	
    	String id = UserInfo.getUserId();
    		
    		User[] users = [select id,name, contactid from User where id=:id];
    		
    		User u;
    		if (users.size()>0) {
    			u = users[0];
    		}
    		
    		if (u.ContactId != null) {
    			
    			return true;
    		}
    		else {
    			
    			return false;
    		}
    	
    	
    }
    
    
         public List<SelectOption>  getProjectEmployees() {
        
         employeeOptions = new List<SelectOption>();
            
            employeeOptions.add(new SelectOption('None','None'));
        	 
        		Resource_Allocation__c[] ras = [select id,name,project__c,employee__c,employee__r.name from Resource_Allocation__c where project__c=:selectedProjectId];
            
            Id[] ids = new Id[0];
            
            for (Resource_Allocation__c ra:ras) {
                
                employeeOptions.add(new SelectOption(ra.employee__c,ra.employee__r.name));
            } 	
         	
         	return employeeOptions;
         	
         }
         
         
         public boolean getHasDeliverables() {
         	
         	
         	System.debug('Setting get has deliverables: '+selectedProjectId);
         	
         	Customer_Deliverable__c[] cds = [select id,name from Customer_Deliverable__c where Project__c=:selectedProjectId];
         	
         	if (cds.size()>0) {
         		return true;
         	}
         	else {
         		return false;
         	}
         }
         
         public void setHasDeliverables(boolean value) {
         	
         	this.hasDeliverables = value;
         	
         }
    
  
    
    public boolean getisProjectManager() {
    	
    		Project__c[] projects = [select id,name,recordtypeid,project_manager__c from Project__c where id=:selectedprojectid limit 1];
    		
    		if (projects.size()>0) {
    		
    		Project__c proj = projects[0];
    	
    		String id = UserInfo.getUserId();
    		
    		User[] users = [select id,name from User where id=:proj.project_manager__c];
    		
    		User u;
    		if (users.size()>0) {
    			u = users[0];
    		}
    		
    		if (u!=null) {
    		String userId = u.id;
    		
    		System.debug('User ids: '+userId + ': '+id);
    		if (id==userId) {
    			
    			return true;
    		}
    		else {
    			
    			return false;
    		}
    		} else {
    			return false;
    		}
    		
    		} else {
    			
    			return false;
    		}
    	
    }
    
    public boolean getIsiAppProject() {
    	
    	   //RecordType[] rtProjects = [Select Id,name From RecordType Where SObjectType = 'Project__c' ];
            
            //return true;
            
            if (selectedProjectId!=null&&selectedProjectId!='None') {
                
            		Project__c[] projects = [select id,name,recordtypeid from Project__c where id=:selectedprojectid limit 1];
            		
            		Project__c proj = null;
            		if (projects.size()>0) {
            			proj = projects[0];
            		}
           
           		if (proj!=null) {
           			RecordType[] rtProjects = [Select Id,name From RecordType Where SObjectType = 'Project__c' and id=:proj.recordtypeid limit 1];
           
		           if (rtProjects.size()>0) {
		           	
		           		RecordType rtProject = rtProjects[0];
		           		
		           		if (rtProject.name == 'iApp') {
		           			
		           			return true;
		           		}
		           		else {
		           			return false;
		           		}
		           		
		           } else {
		           	
		           	return false;
		           }
           		} else {
           			return null;
           		}
           
            }
            else {
            	
            	return false;
            }
    	
    	
    	
    }
    
    public boolean getHasWorkItems() {
        
          
          
		if (selectedProjectId!=null&&selectedProjectId!='None') {
          
        Work_Task__c[] wtsk = [select id,name from Work_Task__c where (Project__c!=null AND Project__c=:selectedProjectId)];
        
            
            if (wtsk.size()>0) {
                
                this.hasWorkItems = true;
            }
            
            return hasWorkItems;
            
                      }
                      else {
                      	
                      	return false;
                      	
                      }
            
            
    
    }
    
    
    public boolean getIsProjectExternal() {
        
        
            System.debug('In get is project external');
           RecordType[] rtProjects = [Select Id,name From RecordType Where SObjectType = 'Project__c' ];
            
            //return true;
            boolean isExternal = false;
            
            if (selectedProjectId!=null&&selectedProjectId!='None') {
                
                
            
            	Project__c[] projects = [select id,name,recordtypeid from Project__c where id=:selectedprojectid limit 1];
            		
            		Project__c proj = null;
            		if (projects.size()>0) {
            			proj = projects[0];
            		}
            		
            		
            		if (proj!=null) {
            
            for (RecordType rt:rtProjects)  {
                
                System.debug('RT name: '+rt.name);
                
                System.debug('ids: '+proj.RecordTypeId + ' : '+rt.id);
                
                if (proj.recordtypeid==rt.id) {
                    
                    String rtname = rt.name;
                    if (rtname.lastIndexOf('External')!=-1||rtname.equals('iApp')||rtname.equals('New Build')) {
                    
                        isExternal = true;
                    }
                }
                
                
            }
            }
            }
            
            System.debug('Returning! : '+isExternal);
            
            return isExternal;
            
            /*
            if (rtProject.name=='External') {
                return true;
            }
            else {
                
                return false;
            }
            */
        
        
    }
    
    
    /*  public void setSelectedCustomerDeliverable(String id) {
        
        this.selectedCustomerDeliverable = id;
    }
    public String getSelectedCustomerDeliverable() {
        
        return this.selectedCustomerDeliverable;
    }
    */
    
    Expense_Log__c expense = new Expense_Log__c();
    
    public Expense_Log__c getExpense() {
        
        return expense;
    }
    
    public void setExpense(Expense_Log__c expense) {
        
        this.expense = expense;
    }
    
    
    Case newCase = new Case();
    
    public Case getNewCase() {
        
        return newCase;
    }
    
    public void setNewCase(Case newCase) {
        
        this.newCase = newCase;
        
    }
    
    public void setBillAs(String billAs) {
        this.billAs = billAs;
    }
    
    public String selectedProjectId
{
   get ;
   
   
set;
}


    
    
    public boolean getHasMilestone() {
        return hasMilestone;
    }
    
    public void setTaskUser(User u) {
        this.taskUser = u;
    }
    
    public void setLog(Time_log__c log) {
        this.log = log;
    }
    
    public Time_log__c getLog() {
        log.date__c = Date.today();
        log.Billed_Status__c = 'Incurred';
        return log;
    }
    
    public NewTimeLogController(String projectId) {
        this.projectId = projectId;
        this.selectedProjectId = projectId; 
        project = [select id,name from project__c where id=:projectId];
        sheets = [select id,name from pricing_sheets__c where project__c=:project.id];
        
        log.date__c = Date.today();
    }
    
    public PageReference cancel() {
        PageReference ref = new PageReference('/'+projectId);
        ref.setRedirect(true);
        return ref;
    }
    
    public List<SelectOption> getBillAsList() {
        options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        
        for (Pricing_Sheets__c sheet:sheets) {
            options.add(new SelectOption(sheet.name,sheet.name));
        }    
        
        return options;
    }
    
    public List<SelectOption>  getActiveProjects() {
    	
    	System.debug('Getting active projects, what is selectedprojectid at this point: '+selectedProjectId);
    	
    	
    	//selectedProjectId = selectedProjectId.substring(0,15);
        
        
        try {
            String id = UserInfo.getUserId();
            Employee__c employee = [select name,id from employee__c where user__c=:id limit 1];
            
            Resource_Allocation__c[] ras = [select id,name,project__c from Resource_Allocation__c where employee__c=:employee.id];
            
            Id[] ids = new Id[0];
            
            for (Resource_Allocation__c ra:ras) {
                
                ids.add(ra.project__c);
            }
            
            Project__c[] projects = [select id,name from Project__c where Project_Status__c!='Completed' and id in:ids];
            
        
        projectOptions = new List<SelectOption>();
        projectOptions.add(new SelectOption('None','None'));
        
        for (Project__c proj:projects) {
        	
        	System.debug('Constructing here: '+proj.id);
        	
        	String tmpid = proj.id;
            projectOptions.add(new SelectOption(tmpid,proj.name));
        }
        
        return projectOptions;    
        } catch (Exception e) {
        	
        	return null;
        }
        
        
    
            
        
    }
    
     public List<SelectOption>  getProjectWorkCategories() {
        
        
        /// Need to check if external first
        
        if (selectedProjectId!=null&&selectedProjectId!='None') { 
        boolean isExternal = this.getIsProjectExternal();
        
        
        
           RecordType[] rtProjects = [Select Id,name From RecordType Where SObjectType = 'Time_Log__c' ];
            
            
            
        
        projectWorkCategories = new List<SelectOption>();
        projectWorkCategories.add(new SelectOption('None','None'));
        
        for (RecordType rt:rtProjects) {
            
            if (isExternal==true) {
                String name = rt.name;
                
                if (name.lastIndexOf('External')!=-1) {
                projectWorkCategories.add(new SelectOption(rt.id,rt.name));
                }
            } else {
                 String name = rt.name;
                
                if (name.lastIndexOf('External')==-1) {
                    
                    projectWorkCategories.add(new SelectOption(rt.id,rt.name));
                }
                
            }
        } 
        }
        return projectWorkCategories;
    
            
        
    }
    
    public List<SelectOption>  getProjectCustomerDeliverables() {
        
        
        Customer_Deliverable__c[] cds = [select id,name from Customer_Deliverable__c where Project__c=:selectedProjectId];
            
            
            System.debug('Firing getprojectcustomerdeliverables: '+selectedProjectId);
                
            cdOptions = new List<SelectOption>();
            cdOptions = new List<SelectOption>();
            cdOptions.add(new SelectOption('None','None'));
            
            for (Customer_Deliverable__c cd:cds) {
                cdOptions.add(new SelectOption(cd.id,cd.name));
            }    
            
            return cdOptions;
    
    }
    
     public List<SelectOption>  getWorkItems() {
        
        
        String queryId = null;
        
        if (passedprojectId!=null) {
            
            queryId = projectId;
            passedProjectId = null;
        }
        else {
            
            queryId = selectedProjectId;
            
            
        }
        
        String id = UserInfo.getUserId();
        
        
        
     Work_Task__c[] wtsk;
        
        
        if (this.getIsiAppProject()==false) {
        
        wtsk = [select id,name from Work_Task__c where (Project__c!=null AND Project__c=:queryId AND status__c!='Completed' AND from_template__c=false) AND ownerid=:id ];
        
        } else {
        	
        	
        	wtsk = [select id,name from Work_Task__c where (Project__c!=null AND Project__c=:queryId AND status__c!='Completed') ];
        	
        }       
            
            
            System.debug('Firing getworkitems: '+selectedProjectId);
                
            wtskOptions = new List<SelectOption>();
            wtskOptions = new List<SelectOption>();
            wtskOptions.add(new SelectOption('None','None'));
            
            for (Work_Task__c wt:wtsk) {
                wtskOptions.add(new SelectOption(wt.id,wt.name));
            } 
            
            return wtskOptions;
    
            
        
    }
    
    
    
    
    public Pricing_Sheets__c getAutoSheet() {
        Pricing_Sheets__c autosheet = null;
        Set<Id> sIdRoles = new Set<Id>();
        
        String id = UserInfo.getUserId();
        Employee__c employee;
        
          if (selectedEmployee==null) {
        	
        	
        	
        	employee = [select name,id from employee__c where user__c=:id limit 1];
        	
        }
        else {
        	
        	employee = [select name,id from employee__c where id=:selectedEmployee limit 1];
        }
        
        
        if (hasMilestone==true) {
            System.debug('Has milestone true');
            
            log.Employee__c = employee.id;
            Resource_Allocation__c[] ras = [select id,name,employee__c,role__c from Resource_Allocation__c where milestone__c=:milestone.id and employee__c=:employee.id];
            
            for(Resource_Allocation__c resAll : ras){
                if(resAll.Role__c != null){
                        sIdRoles.add(resAll.Role__c);
                }           
            }
            
            if(sIdRoles.size()>0){
                List<Pricing_Sheets__c> roleLst = [Select Id, Project__c From Pricing_Sheets__c Where Id in:sIdRoles Limit 1];
                if (roleLst.size()>0) {
                    autosheet = roleLst[0];
                    return autoSheet;
                }
            }
            
            
        }
        else {
            
            System.debug('Has milestone NOT true');
         
            log.Employee__c = employee.id;
            
            System.debug('Employee: '+employee.id);
            
            System.debug('Project Id: '+projectid);
            
            if (projectId==null) {
                
                projectid = selectedprojectid;
            }
            
            System.debug('Selectedprojectid : '+selectedProjectId);
            System.debug('Selectedprojectid : '+projectId);
            
            Resource_Allocation__c[] ras = [select id,name,employee__c,role__c from Resource_Allocation__c where project__c=:projectid and employee__c=:employee.id];
            
            
            System.debug('RAS size: '+ras.size());
            for(Resource_Allocation__c resAll : ras){
                if(resAll.Role__c != null){
                        sIdRoles.add(resAll.Role__c);
                }           
            }
            
            if(sIdRoles.size()>0){
                List<Pricing_Sheets__c> roleLst = [Select Id, Project__c From Pricing_Sheets__c Where Id in:sIdRoles Limit 1];
                if (roleLst.size()>0) {
                    autosheet = roleLst[0];
                    System.debug('Returning autosheet: '+autosheet);
                    
                    return autoSheet;
                }
            }
            
            
            
        }
        return null;
    }
    
    public NewTimeLogController(String projectId, String milestoneId, String workTaskId) {
        this.projectId = projectId; 
        
        
        project = [select id,name from project__c where id=:projectId];
        this.selectedProjectId = project.id;
        sheets = [select id,name from pricing_sheets__c where project__c=:project.id];
        milestone = [select id,name,project__c from milestone__c where id=:milestoneId];
        workTask = [select id,name,project__c from work_task__c where id=:workTaskId];
        log.Project__c = projectId;
        log.Milestone__c = milestoneId;
        log.Work_Task__c = workTaskId;
        
        this.selectedWorkItem = workTaskId;
        
        log.date__c = Date.today();
        
        hasMilestone = true;
    }
    
   
    
    public NewTimeLogController(ApexPages.StandardController controller) {
    	
    	boolean tryMilestone = false;
    	
    	String phaseID = null;
    	
    	String work_taskID = null;
    	
    	System.debug('Constructing this way!!');
    	
        
        if(System.currentPageReference().getParameters().get('projectID')!=null&&System.currentPageReference().getParameters().get('projectID').length()>0) {
            
            projectId = System.currentPageReference().getParameters().get('projectID');
            
            System.debug('Project Id here: '+projectId);
            
            Project__c[] projs = [select id,name from project__c where id=:projectId];
                    
                    if (projs.size()>0) {
                    	
                    
                    		project = projs[0];
                    		
                    		projectId = project.id;
                    		
                    }
            
            this.passedProjectId = projectId;
            this.selectedProjectId = projectId;
            
            System.debug('Project ID: '+selectedProjectId);
            
        }
        
         if(System.currentPageReference().getParameters().get('work_taskID')!=null) {
            
           			 
           			 	
           			 	work_taskID= System.currentPageReference().getParameters().get('work_taskID');
           			 	
           			 	System.debug('Work task id: '+work_taskID);
           			 	
           			 Work_Task__c[] wts = [select id,name,project__c,milestone__c from Work_Task__c where id=:work_taskID];
           			 
           			 System.debug('Size returned from that: '+wts.size());
           			 
           			 Work_Task__c wttmp;
           			 
           			 if (wts.size()>0) {
           			 	
           			 	 wttmp = wts[0];
           			 	
           			 	log.Work_Task__c = wttmp.id;
           			 	
           			 	this.selectedWorkItem = wttmp.id;
           			 	
           			 	this.selectedProjectId = wttmp.project__c;
           			 	
           			 }
           			 
           			 
           			 String phaseIDParam = System.currentPageReference().getParameters().get('phaseID');
           			 
           			if((phaseIDParam!=null||phaseIDParam.length()>0)&&wttmp!=null) {
           				
           				
           				   
			                    Project__c[] projs = [select id,name from project__c where id=:wttmp.project__c];
			                    
			                    System.debug('Size returned projs here: '+projs.size());
			                    
			                    if (projs.size()>0) {
			                    	
			                    
			                    		project = projs[0];
			                    		
			                    		 this.passedProjectId = project.Id;
			                    		 this.selectedProjectId = project.Id;
			                    
			                    }
			                    
			                    log.work_task__c = wttmp.id;
			                } else if (wttmp!=null) {
			                	
			                	 Project__c[] projs = [select id,name from project__c where id=:wttmp.project__c];
			                    
			                    System.debug('Size returned projs here: '+projs.size());
			                    
			                    if (projs.size()>0) {
			                    	
			                    
			                    		project = projs[0];
			                    		
			                    		 this.passedProjectId = project.Id;
			                    		 this.selectedProjectId = project.Id;
			                    
			                    }
			                	
			                	
			                	
			                }
			           				
           				
           				
           				
         }
           			  
           			 
            
       		 
        
           if(System.currentPageReference().getParameters().get('phaseID')!=null) {
            
            	phaseID = System.currentPageReference().getParameters().get('phaseID');
            	
            	
            	
            	System.debug('Phase Id: '+phaseID);
            	
            
             	Milestone__c[] milestones = [select id,name,project__c from milestone__c where id=:phaseID];
                Milestone__c milestone = null;
                
                if(milestones.size()>0) {
                	hasMilestone = true;
                    milestone = milestones[0];
                    
                    
                    Project__c[] projs = [select id,name from project__c where id=:milestone.project__c];
                    
                    System.debug('Size returned: '+projs.size());
                    
                    if (projs.size()>0) {
                    	
                    
                    		project = projs[0];
                    		
                    		 this.passedProjectId = project.Id;
                    		 this.selectedProjectId = project.Id;
                    
                    }
                    
                    log.Milestone__c = milestone.id;
                }
                
                
                
                System.debug('Selected project Id: '+selectedProjectId);
                
                this.projectId = selectedProjectId;
                
                
            
            
            
            
        }
        
           
        
        if(System.currentPageReference().getParameters().get('retURL')!=null&&projectID!=null) {
        	
        	System.debug('In here');
            
            if (projectID==null) {
            projectId = System.currentPageReference().getParameters().get('retURL');
            projectId = projectId.substring(1,projectId.length());
            
            }
            
            
            try{
                project = [select id,name from project__c where id=:projectId];
                selectedProjectId = project.id;
                sheets = [select id,name from pricing_sheets__c where project__c=:project.id];
                log.Project__c = project.id;
            }catch (Exception e) {
                tryMilestone = true;
            }
            
            log.date__c = Date.today();
            
            if(tryMilestone==true&&log.milestone__c==null) {
                Milestone__c[] milestones = [select id,name,project__c from milestone__c where id=:projectId];
                Milestone__c milestone = null;
                
                if(milestones.size()>0) {
                    milestone = milestones[0];
                }
                
                if(milestone!=null) {
                    hasMilestone = true;
                    projectId = milestone.project__c;
                    project = [select id,name from project__c where id=:projectId];
                    sheets = [select id,name from pricing_sheets__c where project__c=:project.id];
                    log.Project__c = project.id;
                    log.Milestone__c = milestone.id;
                }
            }
            
            if(project==null) {
                
                System.debug('Project was still null');
                
                Milestone__c milestone = null;
                
		               	if (work_taskID==null) {
		                Work_Task__c wt = [select id,name,project__c,milestone__c from Work_Task__c where id=:projectId];
		                Milestone__c[] milestones = [select id,name,project__c from milestone__c where id=:wt.milestone__c];
		                
		               	 
		               	
		                
		                if(milestones.size()>0) {
		                    milestone = milestones[0];
		                }
                
               			} else  {
               		
		               		 Work_Task__c[] wts = [select id,name,project__c,milestone__c from Work_Task__c where id=:work_taskID];
		           			 
		           			 if (wts.size()>0) {
		           			 	
		           			 	Work_Task__c wt = wts[0];
		           			 	
		           			 	log.Work_Task__c = wt.id;	
		           			 	
		           			}
               		
               		
               	}
                
                if (milestone!=null) {
                    System.debug('Milestone was not null!');
                    hasMilestone = true;
                    projectId = milestone.project__c;
                    project = [select id,name from project__c where id=:projectId];
                    sheets = [select id,name from pricing_sheets__c where project__c=:project.id];
                    log.Project__c = project.id;
                    log.Milestone__c = milestone.id;
                }
            }
        }
        
        System.debug('Project ID at end: '+selectedProjectId);
    }
    
     public PageReference saveExpense() {
        
        if (log.Status_Update__c!=null||log.Activity_Description__c!=null) {
            
            if (fromSave==false) {
        
                this.save();
                
            }
        }
        
        String id = UserInfo.getUserId();
            Employee__c employee = [select name,id from employee__c where user__c=:id limit 1];
            
        expense.Employee__c = employee.id;
        
        if (projectid==null) {
            
            projectId = selectedProjectId;
        }
        
        expense.Project__c = projectid;
        insert expense;
        
        
        PageReference ref = new PageReference('/'+projectId);
        ref.setRedirect(true);
        return ref;
        
        
     
     }
     
      public PageReference saveCase() {
     
        newCase.project__c = projectid;
        
        insert newCase;
        
                    
                       
                            
                            
                            if (newCase.Priority=='S1') {
                            
                            Project__c proj = [select id,name,account__r.ownerid from Project__c where id=:projectid limit 1];
                            
                             try {
                                EntitySubscription es = new EntitySubscription();
                                es.ParentId = proj.id;
                                es.SubscriberId = proj.account__r.ownerid;
                                
                                insert es;
                            } catch (Exception e) {
                            
                            }
                            
                            FeedItem fi = new FeedItem ();
                            
                            User u = [select id,name from User where id=:proj.account__r.ownerId limit 1];
                            
                            fi.Body = 'New case with severity S1 created. '+u.name + ' is now following the case';
                            
                            fi.ParentId = proj.id;
                            
                            insert fi;
                            
                            try {
                                EntitySubscription es2 = new EntitySubscription();
                                es2.ParentId = newCase.id;
                                es2.SubscriberId = proj.account__r.ownerid;
                                
                                insert es2;
                            } catch (Exception e) {
                                
                            }
                                
                            }
                            
                        
            
            PageReference ref = new PageReference('/'+projectId);
        ref.setRedirect(true);
        return ref;
     
      }
    
    public PageReference save() {
        
        // Save validation
        
        
        System.debug('Saving: '+selectedWorkCategory);
        if ((selectedWorkCategory==null||selectedWorkCategory=='None')) {
            
            if (this.getIsProjectExternal()==false&&this.getIsiAppProject()==false) {
            	
            	
			            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please select a work category');
			            ApexPages.addMessage(myMsg);
			            return null;
            	
            
            
            }
            
            
        }
        
       
        
        if (log.Hours__c == null) {
        	
        	// ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please indicate hours for this update');
             //   ApexPages.addMessage(myMsg);
             //   return null; 
        	
        }
        
        if (this.selectedWorkCategory!=null) {
        	
        	
        	log.RecordTypeId = this.selectedWorkCategory;
        }
        
        if (this.selectedWorkItem!=null&&this.selectedWorkItem!='None') {
        	
        	log.Work_Task__c = selectedWorkItem;
        	
        }
        
        if (this.getIsiAppProject()==true) {
        	
        	if (log.blockers_status__c==null&&log.blockers__c==null) {
        		
        		log.blockers_status__c = 'Not Started';
        	}
        	
        }
        	
        
        
        if (this.getIsProjectExternal()==true) {
        	
        	
        	
        	        Project__c proj = [select id,name,recordtypeid from Project__c where id=:selectedprojectid limit 1];
    
           			RecordType[] rtProjects = [Select Id,name From RecordType Where SObjectType = 'Project__c' and id=:proj.recordtypeid limit 1];
           
		           if (rtProjects.size()>0) {
		           	
		           		RecordType rtProject = rtProjects[0];
		           		
		           		
		           		if (rtProject.name == 'External Consulting') {
		           			
		           			RecordType[] rtItems = [Select Id,name From RecordType Where SObjectType = 'Time_Log__c' and name = 'External Consulting' limit 1];
								           			
							
							if (rtItems.size()>0) {
		           	
		           					RecordType rtItem = rtItems[0];
		           		
		           				log.RecordTypeId = rtitem.id;
							}	           			
								           			
		           			
		           		}
		           		else if (rtProject.name == 'External Training') {
		           			
		           			
		           			RecordType[] rtItems = [Select Id,name From RecordType Where SObjectType = 'Time_Log__c' and name = 'External Training' limit 1];
		           			
		           			if (rtItems.size()>0) {
		           	
		           					RecordType rtItem = rtItems[0];
		           					
		           					log.RecordTypeId = rtitem.id;
		           		
							}
		           			
		           		}
		           		else if (rtproject.Name == 'External') {
		           			
		           			RecordType[] rtItems = [Select Id,name From RecordType Where SObjectType = 'Time_Log__c' and name = 'External Consulting' limit 1];
								           			
							
							if (rtItems.size()>0) {
		           	
		           					RecordType rtItem = rtItems[0];
		           		
		           				log.RecordTypeId = rtitem.id;
							}	   
		           			
		           			
		           		}
		           		
		           }
		         
        	
        	
        	
        }
        
        if (selectedWorkItem!=null&&selectedWorkItem!='None') {
            
            if (this.completeWorkItem==true) {
                
                Work_Task__c wt = [select id,name,status__c from Work_Task__c where id=:selectedWorkItem limit 1];
                wt.status__c = 'Completed';
                
                log.Work_Task__c = wt.id;
                
                update wt;
                
                if (this.getIsPortalUser()==false) {
                if (this.log.update_project_chatter_stream__c==true) {
                	
                	System.debug('Updating chatter stream');
                	
                	String ownerid = null;
                	
                	if(selectedEmployee!=null) {
         			   Employee__c employee = [select name,id,user__c from employee__c where id=:selectedEmployee limit 1];
            			ownerid = employee.user__c;
            			
            			System.debug('Selected not null: '+ownerid);
    					}
    					else {
    						
    						ownerid = UserInfo.getUserId();
    						
    						System.debug('Selected WAS null: '+ownerid);
    					}
			                	
			                	FeedItem fi = new FeedItem();
			                	
			                	
			                	fi.CreatedById = ownerid;
					
								if (log.project__c == null) {
			            
			            fi.parentid = selectedProjectId;
			        }
			        else {
			        	fi.parentid = log.project__c;
			        	
			        }
					
					
								if (log.hours__c!=null) {
								
								fi.body = 'Completed Work Item in '+log.Hours__c+' hours: '+wt.name;
								} else {
									
									fi.body = 'Completed Work Item: '+wt.name;
								}
								fi.type = 'LinkPost';
								fi.LinkUrl = '/'+wt.id;
								fi.Title = wt.name;
								
								
								
								
								
								log.Update_Project_Chatter_Stream__c = false;
								
							insert fi;
							
							
							FeedComment comment = new FeedComment();
							
							comment.CreatedById = ownerid;
							
							
							comment.FeedItemId = fi.id;
							comment.commentbody = log.Status_Update__c;
							
							insert comment;
                    
                    
                }
                }
            }
                
            
            
        }
        
        if (expense.Amount__c!=null&&expense.Date__c!=null&&expense.Description__c!=null) {
            
            
            this.fromSave = true;
            saveExpense();
        }
        
        if (log.date__c==null) {
            
            log.Date__c = Date.today();
        }
        
        String id = UserInfo.getUserId();
        Pricing_Sheets__c autoSheet = null;
        
        if (taskUser!=null) {
            id = taskUser.id;
        }

        // Try to get the billing rate from the resource allocation associated with a milestone, if there are any
        
        if (billAs==null) {
            
            System.debug('Bill As Was Null!');
            autoSheet = getAutosheet();
        } else {
            
            System.debug('Bill As Was NOT Null!');
        }
        
        if (log.project__c == null) {
            
            log.Project__c = selectedProjectId;
        }
                
        System.debug('AUTO Sheet: '+autoSheet);
                
        if (billAs!=null) {
            if (billAs.equals('None')&&autoSheet==null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'You must select a billing rate');
                ApexPages.addMessage(myMsg);
                return null; 
            }
        }
        if(autoSheet != null){
            if(autoSheet.Project__c!=null) {
                if(autoSheet.Project__c == log.Project__c){
                    log.Pricing_Sheet__c = autoSheet.Id;
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'You must have at least 1 valid role for the project assigned to this time log');
                    ApexPages.addMessage(myMsg);
                    return null; 
                }
                
                
                System.debug('Auto sheet was not null!: '+log.pricing_sheet__c);
            }else {
                for (Pricing_Sheets__c sheet:sheets) {
                    String name = sheet.name;
                    if (name.equals(billAs)) {
                        log.Pricing_Sheet__c = sheet.id;
                    }
                            
                }
            }
        }else{
            for (Pricing_Sheets__c sheet:sheets) {
                String name = sheet.name;
                if (name.equals(billAs)) {
                    log.Pricing_Sheet__c = sheet.id;
                }
                        
            }
        }
        
        if (selectedEmployee!=null) {
        	
        	log.employee__c = selectedEmployee;
        }
        
        if(log.employee__c==null) {
            Employee__c employee = [select name,id from employee__c where user__c=:id limit 1];
            log.Employee__c = employee.id;
        }        
        
        
        if (log.Status_Update__c!=null&&log.Activity_Description__c==null) {
            
            log.Activity_Description__c = log.status_update__c;
            
        }
        
        if (selectedCustomerDeliverable!=null&&selectedCustomerDeliverable!='None') {
            
            log.customer_deliverable__c = selectedCustomerDeliverable;
            
        }
        
        
        
        insert log;
        
        PageReference ref = new PageReference('/'+projectId);
        ref.setRedirect(true);
        return ref;
    }
}