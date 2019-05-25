public with sharing class NewWorkTaskController {


	Project__c proj = null; 
	String milestoneId = null;
	
	Milestone__c milestone;
    public NewWorkTaskController(ApexPages.StandardController controller) {
			String retUrl = ApexPages.currentPage().getParameters().get('retURL');
			mileStoneId = retUrl.replace('/', '');
			try {
				milestone = [select id,name,project__c,estimated_hours__c from Milestone__c where id=:milestoneid];
				proj = [select id,name,estimated_project_hours__c from Project__c where id=:milestone.project__c];	
			} catch (Exception e) {
				
				proj = [select id,name,estimated_project_hours__c from Project__c where id=:milestoneId]	;
				milestoneId = null;
				
			}
    }
    
    
    public NewWorkTaskController(String passedMilestone) {
    	
    	
    	
    	try {
				milestone = [select id,name,project__c,estimated_hours__c from Milestone__c where id=:passedmilestone];
				proj = [select id,name,estimated_project_hours__c from Project__c where id=:milestone.project__c];
				this.milestoneId = milestone.id;
			} catch (Exception e) {
				
				proj = [select id,name,estimated_project_hours__c from Project__c where id=:passedMilestone]	;
				this.milestoneId = null;
				
			}
    	
    		System.debug('Constructing this way, count it, miles: '+milestoneId);
			
			getResources();
    	
    	
    	
    	
    }
    
    
    Work_Task__c workTask = new Work_Task__c();
    
    public Work_Task__c getWorkTask() {
    	
    	return workTask;
    }
    
    public void setWorkTask(Work_Task__c workTask) {
    	this.workTask = workTask;
    }
    
    public String getMilestoneId() {
    	return milestoneId;
    }
    
    public List<Resource_Allocation__c> resources;
    
    public List<Resource_Allocation__c> getResources() {
    	
    	
    	
    	
    	System.debug('Getting resources, what in the world!!!'+milestoneId);
    	
    	if (proj==null&&milestoneId!=null) {
    	 resources = [select id,name,employee__r.name,role__r.name,assigned__c,employee__r.user__c from Resource_Allocation__c where milestone__c=:milestoneId];
    	 
    	 
    	 System.debug('Resources size: '+resources.size());
    	 
    	}
    	else if (proj!=null&&milestoneId!=null) {
    		
    		
    		   resources = [select id,name,employee__r.name,role__r.name,assigned__c,employee__r.user__c from Resource_Allocation__c where milestone__c=:milestoneId];
    		
    		System.debug('OK here: '+resources.size());
    	}
    	else {
    		
    		
    		resources = [select id,name,employee__r.name,role__r.name,assigned__c,employee__r.user__c from Resource_Allocation__c where project__c=:proj.id];
    		
    		System.debug('OK else: '+resources.size());
    	}
    	
    		
    	return resources;
    	
    }
    
    public void setResources(List<Resource_Allocation__c> resources) {
    	
    	this.resources = resources;
    }
    
    public PageReference saveWorkTask() {
    	
    	
    	System.debug('How in the world!! '+milestoneId);
    	
    	if (milestoneId!=null) {
    	workTask.Milestone__c = milestoneId;
    	
    	}
    	
    	
    	workTask.Project__c = proj.id;
    	
    	workTask.status__c = 'Open';
    	
    	if (milestone!=null) {
    		
    		System.debug('Milestone is not null when saving!!');
    		
    		// This means its the first work task, needs to zero out the milestone so that it will now roll up based on the work task and not the milestone
    		Work_Task__c[] existingTasks = [select id,name from Work_Task__c where milestone__c=:milestone.id];
    		
    		System.debug('Existing task size: '+existingTasks.size());
    		
    		if (existingTasks.size()==0) {
    			
    			
    			proj = [select id,name,estimated_project_hours__c from Project__c where id=:milestone.project__c];
    			
    			
    			System.debug('Just before project update: '+proj.Estimated_Project_Hours__c+ ' : '+proj.id+ ' : '+proj.name);
    			milestone.Estimated_Hours__c = 0;
    			milestone.Update_Project_Amount__c = true;
    			update milestone;
    			
    			proj = [select id,name,estimated_project_hours__c from Project__c where id=:milestone.project__c];
    			
    			milestone.update_project_amount__c = true;
    			
    			
    		}
    	
    	}
    	
    	else {
    		
    		
    		proj = [select id,name,estimated_project_hours__c from Project__c where id=:proj.id];
    		
    		if (workTask.Hours_Estimate__c!=null) {
    			
    			Double projHours = 0;
    			
    			if (proj.Estimated_Project_Hours__c!=null) {
    				
    				projHours = proj.Estimated_Project_Hours__c;
    				
    			}
    			
    			Double wtHours = workTask.Hours_Estimate__c;
    			projHours = projHours + wtHours;
    			
    			proj.Estimated_Project_Hours__c = projHours;
    			
    			update proj;
    			
    			
    			
    		}
    		
    		
    	}
    	
    	System.debug('Inserting work task : '+workTask.milestone__c);
    	
    	insert workTask;
    	
    	if (milestone!=null) {
    		
    		Double currentEstimate = milestone.Estimated_Hours__c;
    		
    		Double projEstimated = proj.Estimated_Project_Hours__c;
    		
    		if (workTask.hours_estimate__c!=null) {
    			
    			if (currentEstimate==null) {
    				currentEstimate = 0;
    			}
    			
    			currentEstimate = currentEstimate + workTask.hours_estimate__c;
    			
    			if (proj.Estimated_Project_Hours__c==null) {
    				proj.Estimated_Project_Hours__c = 0;
    			}
    			
    			projEstimated = projEstimated + workTask.hours_estimate__c;
    			
    			proj.Estimated_Project_Hours__c = projEstimated;
    			
    			
    		}
    		
    		milestone.estimated_hours__c = currentEstimate;
    		
    		milestone.update_project_amount__c = true;
    		
    		
    		
    		
    		
    		update milestone;
    		update proj;
    		
    	}
    	
    	Task[] tasks = new Task[0];
    	
    	if (resources!=null) {
    	
    	for (Resource_Allocation__c alloc:resources ) {
    		
    		if (alloc.Assigned__c ==true) {
    		
    		Task t = new Task();
    		t.subject = proj.name + ' : '+workTask.name;
    		t.activitydate = workTask.due_date__c;
    		
    		
    		Time tm = Time.newInstance(7,0,0,0);
    		
    		Date dueDate = workTask.Due_Date__c;
    		
    		dueDate = dueDate.addDays(-1);
    		
    		DateTime dt = DateTime.newInstance(dueDate, tm);
    		
    		t.ReminderDateTime = dt;
    		t.OwnerId = alloc.employee__r.user__c;
    		
    		t.Description = workTask.Description__c;
    		
    		
    		t.whatId = proj.id;
    		
    		tasks.add(t);
    		
    		}
    		
    	}
    	}
    	
    	System.debug('Tasks size to insert: '+tasks.size());
    	
    	insert tasks;
    	if (milestoneId!=null) {
    	PageReference ref = new PageReference('/'+milestoneId);
    	ref.setRedirect(true);
    	
    	return ref; 
    	
    	} else {
    		
    		PageReference ref = new PageReference('/'+proj.id);
    	ref.setRedirect(true);
    	
    	return ref;
    		
    		
    	}
    	
    }
    

}