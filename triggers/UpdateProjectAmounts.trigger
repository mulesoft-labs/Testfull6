trigger UpdateProjectAmounts on Time_log__c (after insert, before insert, after update, after delete) {


    Project__c[] projectsToUpdate = new Project__c[0];
    
	Project__c project = null;
	if (trigger.isDelete) {
		project = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c from project__c where id=:Trigger.Old[0].Project__c];
	} else {
		project = [select id,name,unbilled_amount_dyn__c,collected_amount_dyn__c from project__c where id=:Trigger.New[0].Project__c];	
	}
	
	System.debug('Project id: '+project.id);
	
	
	Pricing_Sheets__c[] rates = [select name,id,principal_consultant_rate__c from Pricing_Sheets__c where project__c=:project.id];
	
	if ((Trigger.isBefore && Trigger.isUpdate )|| (Trigger.isInsert && Trigger.isBefore)) {
		
		Trigger.new[0].Hourly_Cost_of_Resource_Static__c = Trigger.new[0].Hourly_Cost_of_Resource__c;  
		
	}
	
	if (!Trigger.isAfter&&Trigger.isUpdate) {
		Time_log__c newtl = Trigger.new[0];
		if (newtl.hours__c==null) {
			
			
			newtl.hours__c = 0;
		
		}
		
	}
	
	if (!Trigger.isBefore) {
	
	if (Trigger.isUpdate) {
		
		
		Time_log__c oldtl = Trigger.Old[0];
		Time_log__c newtl = Trigger.new[0];
		
		
		
		String oldbilledStatus = oldtl.Billed_Status__c;
		
		
		
		String billedStatus = newtl.Billed_Status__c;
		
		boolean statusChange = false;
		if (!oldbilledStatus.equals(billedStatus)) {
			
			statusChange = true;
			
		}
		
		
		
		
		if (statusChange==true) {
		
		Double oldtlRate = 0;
		for (Pricing_Sheets__c rate:rates) {
				String rateId = rate.id;
				String tlRateId = oldtl.Pricing_Sheet__c;
				if (rateId.equals(tlRateId)) {
					oldtlRate = rate.Principal_Consultant_Rate__c;
				}
			}
			
			
		Double unbilledAmount = project.Unbilled_Amount_dyn__c;
			//unbilledAmount = unbilledAmount - tlRate*oldtl.Hours__c;
		//	project.Unbilled_Amount_dyn__c = unbilledAmount;
			
			
		Double newtlRate = 0;
			
		for (Pricing_Sheets__c rate:rates) {
				String rateId = rate.id;
				String tlRateId = newtl.Pricing_Sheet__c;
				if (rateId.equals(tlRateId)) {
					newtlRate = rate.Principal_Consultant_Rate__c;
				}
			}
			
			
			if (oldBilledStatus.equals('Incurred')&&(billedStatus.equals('Collected')||billedStatus.equals('Invoiced'))) {
			
			
					if (project.unbilled_amount_dyn__c==null) {
						project.unbilled_amount_dyn__c= 0;
					}
			
			unbilledAmount = project.Unbilled_Amount_Dyn__c;
			
			project.Unbilled_Amount_Dyn__c= unbilledAmount - oldtlRate*oldtl.Hours__c;
			
			if (project.Collected_Amount_Dyn__c == null) {
				project.Collected_Amount_Dyn__c = 0;
				
			}
			Double collectedAmount = project.Collected_Amount_dyn__c;
			
			
			collectedAmount = collectedAmount + newtlRate*newtl.Hours__c;
			project.Collected_Amount_Dyn__c = collectedAmount;
			}
			else if ((oldBilledStatus.equals('Collected')||oldBilledStatus.equals('Invoiced'))&&billedStatus.equals('Incurred')) {
				
				if (project.unbilled_amount_dyn__c==null) {
				project.unbilled_amount_dyn__c= 0;
			}
			
			Double collectedAmount = project.collected_Amount_Dyn__c;
			
			project.collected_Amount_Dyn__c= collectedAmount - oldtlRate*oldtl.Hours__c;
			
			
			unbilledAmount = project.unbilled_Amount_dyn__c;
			unbilledAmount = unbilledAmount + newtlRate*newtl.Hours__c;
			project.unbilled_Amount_Dyn__c = unbilledAmount;
				
				
				
			}
		}
		
		else {
			
			
					Double oldtlRate = 0;
					Double newtlRate = 0;
			
			
			
			for (Pricing_Sheets__c rate:rates) {
				String rateId = rate.id;
				String tlRateId = newtl.Pricing_Sheet__c;
				if (rateId.equals(tlRateId)) {
					
					
					newtlRate = rate.Principal_Consultant_Rate__c;
					
					System.debug('Rate was equal: '+rateId + ' : '+newtlRate);
				}
			}
			
		for (Pricing_Sheets__c rate:rates) {
				String rateId = rate.id;
				String tlRateId = oldtl.Pricing_Sheet__c;
				if (rateId.equals(tlRateId)) {
					oldtlRate = rate.Principal_Consultant_Rate__c;
				}
			}
			
			
		
		Double oldtlhours = oldtl.hours__c;
		
		if (oldtlhours==null) {
			
			oldtlhours = 0;
		}
		
		Double newtlhours = newtl.hours__c;
		
		if (newtlhours==null) {
			
			newtlhours = 0;
		}
		
		
		String newbilledStatus = newtl.Billed_Status__c;
		
		if (newBilledStatus.equals('Incurred')) {
			
			Double unbilledAmount = project.Unbilled_Amount_dyn__c;
			
			
			
			
			
			unbilledAmount = unbilledAmount - oldtlRate*oldtlhours;
			project.Unbilled_Amount_dyn__c = unbilledAmount;
			
			project.Unbilled_Amount_dyn__c += newtlRate*newtlhours;
			
			
			
			
		}
		else if (newBilledStatus.equals('Collected')) {
			
			Double collectedAmount = project.collected_Amount_dyn__c;
			collectedAmount = collectedAmount - oldtlRate*oldtlhours;
			project.collected_Amount_dyn__c = collectedAmount;
			
			project.collected_Amount_dyn__c += newtlRate*newtlhours;
			
			
			
			
		}
		
			
			
			
			
		}
		
		
		
		projectsToUpdate.add(project);
		
		
		update(projectsToUpdate);
		 
			
		
		
	}
	
	else if (Trigger.isInsert)  {
	
	System.debug('Its insert at least');
	
	
	
	Time_log__c tl = Trigger.new[0];
	double tlhours = 0;
	
	if (tl.hours__c==null) {
		
		tlhours = 0;
	}
	else {
		tlhours = tl.hours__c;
	}
	
	
	if (tl.update_project_chatter_stream__c==true) {
	
		FeedPost fp = new FeedPost();
		
		fp.parentId = tl.project__c;
		
		Employee__c emp = [select id,name,user__c, is_portal_user__c from Employee__c where id=:tl.employee__c];
		
		if (tlhours!=0&&(tl.project_status__c=='--None--'||tl.project_status__c==null)) {
		fp.body = ' Logged '+ tlhours + ' hours: '+tl.activity_description__c+'';
		
		}
		else if (tlhours!=0&&(tl.project_status__c!='--None--'&&tl.project_status__c!=null)) {
					fp.body = ' Logged '+ tlhours + ' hours with status: "'+tl.project_status__c+ '", '+tl.activity_description__c+'';
			
		}
		
		else if (tlhours==0&&(tl.project_status__c!='--None--'&&tl.project_status__c!=null)) {
					fp.body = 'Project status: "'+tl.project_status__c+ '", '+tl.activity_description__c+'';
			
		}
		else {
			
			fp.body = tl.activity_description__c;
		}
			
    		//User[] users = [select id,name, contactid from User where id=:emp.user__c];
    		
    		//User u;
    		//if (users.size()>0) {
    		//	u = users[0];
    		//}
    		
    		System.debug('Employee info here: '+emp.id + ' : '+emp.name + ' : '+emp.is_portal_user__c);
    		
    		if (emp.is_portal_user__c==false) {
		    		
		    			
		    				fp.createdbyid = emp.user__c;
				
						insert fp;
		    			
		    		
    		} else {
    			
    			System.debug('User was null in update project amounts');
    		}
    	
    	
    
		
	
		
	}
		
	
	if (tl.milestone__c!=null) {
		
			Milestone__c ms = [select id,name,actual_hours__c from Milestone__c where id=:tl.milestone__c];
			
			
			ms.Update_Project_Amount__c = true;
			
			
			Double hours = ms.actual_hours__c;
			
			if (hours==null) {
				hours = 0;
			}
			hours = hours+tlhours;
			
			ms.actual_hours__c = hours;
			
			update ms;	
		
			
	}
	else if (tl.work_task__c!=null) {
		
		
		Work_Task__c wt = [select id,name,actual_hours__c from Work_Task__c where id=:tl.work_task__c limit 1];
		
		if (wt!=null) {
			
			Double hours = wt.actual_hours__c;
			
			if (hours==null) {
				hours = 0;
			}
			hours = hours+tlhours;
			
			wt.actual_hours__c = hours;
			
			//update wt;
			
			
			
			
			
		}
		
	}
		
		String billedStatus = tl.Billed_Status__c;
		
		Double tlRate = 0;
		
		System.debug('tl pricing sheet: '+tl.pricing_sheet__c);
		
		for (Pricing_Sheets__c rate:rates) {
				String rateId = rate.id;
				System.debug('Checking all of these rates: '+rateId);
				String tlRateId = tl.Pricing_Sheet__c;
				if (rateId.equals(tlRateId)) {
					
					tlRate = rate.Principal_Consultant_Rate__c;
					 System.debug('Found one id equaled another: '+tlRate);
					
				}
			}
			System.debug('Tl rate : '+tlRate);
			
			
		if (tlRate==0) {
			
			//throw new ApplicationException('The principal consulting rate is 0. Please check the Billing Rate configuration.'); 
			
		}
		
		if (billedStatus.equals('Incurred')) {
			
			System.debug('Billed status was incurred');
			
			if (project.unbilled_amount_dyn__c==null) {
				project.unbilled_amount_dyn__c= 0;
			}
			project.Unbilled_Amount_Dyn__c+= tlRate*tlhours;
			
   			System.debug('Project unbilled amount in incurred before project update: '+project.Unbilled_Amount_Dyn__c);	
			
			update project;
			
			
		 		
		}
		else if (billedStatus.equals('Collected')) {
			System.debug('It was collected! '+tlRate + ' : '+tlhours);
			if (project.collected_amount_dyn__c==null) {
				project.collected_amount_dyn__c= 0;
			}
			
			
			Double collectedAmount = project.Collected_Amount_Dyn__c;
			collectedAmount = collectedAmount + tlRate*tlhours;
			project.Collected_Amount_Dyn__c = collectedAmount;
			
			Double unbilledAmount = project.Unbilled_Amount_dyn__c;
			unbilledAmount = unbilledAmount - tlRate*tlhours;
			project.Unbilled_Amount_dyn__c = unbilledAmount;
		
		System.debug('Project unbilled amount in collected before project update: '+project.Unbilled_Amount_Dyn__c);	
			update project;
			
		}
			
		
		
		
		
	
	
	}
	else if (Trigger.isDelete) {
		
		Time_log__c tl = Trigger.old[0];
		
		double tlhours = tl.hours__c;
		
		if (tl.hours__c==null) {
			tlhours = 0;
		}
		
		String milestoneId = tl.milestone__c;
		
		String workTaskId = tl.work_task__c;
		
		boolean projectUpdated = false;
		
		if (milestoneId!=null) {
			
			Milestone__c milestone = [select id,name,actual_hours__c from Milestone__c where id=:milestoneId limit 1];
			
			milestone.actual_hours__c = milestone.actual_hours__c - tlhours;
			
			milestone.update_project_amount__c = true;
			
			projectUpdated = true;
			
			milestone.bypass_trigger__c = true;
			
			update milestone;
			
		}
		
		if (workTaskId!=null) {
			
			Work_Task__c workTask = [select id,name,actual_hours__c from Work_Task__c where id=:workTaskId limit 1];
			
			if (workTask.actual_hours__c!=null) {
			workTask.actual_hours__c = workTask.actual_hours__c - tlhours;
			
			update workTask;
			}
			
		}
		
		String billedStatus = tl.Billed_Status__c;
		
		Double tlRate = 0;
		for (Pricing_Sheets__c rate:rates) {
				String rateId = rate.id;
				String tlRateId = tl.Pricing_Sheet__c;
				if (rateId.equals(tlRateId)) {
					tlRate = rate.Principal_Consultant_Rate__c;
				}
			}
		
		if (billedStatus.equals('Incurred')) {
			
			
			
			if (project.unbilled_amount_dyn__c==null) {
				project.unbilled_amount_dyn__c= 0;
			}
			
			Double unbilledAmount = project.Unbilled_Amount_Dyn__c;
			project.Unbilled_Amount_Dyn__c= unbilledAmount - tlRate*tlhours;
			update project;
			
			
		}
		else if (billedStatus.equals('Collected')) {
			System.debug('It was collected! '+tlRate + ' : '+tlhours);
			if (project.collected_amount_dyn__c==null) {
				project.collected_amount_dyn__c= 0;
			}
			
			
			Double collectedAmount = project.Collected_Amount_Dyn__c;
			collectedAmount = collectedAmount - tlRate*tlhours;
			project.Collected_Amount_Dyn__c = collectedAmount;
			
			Double unbilledAmount = project.Unbilled_Amount_dyn__c;
			unbilledAmount = unbilledAmount - tlRate*tlhours;
			project.Unbilled_Amount_dyn__c = unbilledAmount;
			
			
		update project;	
		}
		
		
		
	}
	}
	
		
	
	

}