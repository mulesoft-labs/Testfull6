trigger WorkTaskUpdateMilestone on Work_Task__c (before update, before delete) {
	
	
						
	
	
			if (Trigger.isUpdate) {
	
				Work_Task__c newWt = Trigger.new[0];
					Work_Task__c oldWt = Trigger.old[0];
					
					
					
					System.debug('Newwt.milestone: '+newWt.milestone__c);
					Milestone__c[] milestones = [select id,name,estimated_hours__c from Milestone__c where id=:newWt.milestone__c];
					
					
					Milestone__c milestone = null;
					
					if (milestones.size()>0) {
						
						milestone = milestones[0];
					} 
					
					if (milestone!=null) {
						
						
						
						Double currHours = milestone.estimated_hours__c;
						
						Double oldHours = oldWt.hours_estimate__c;
						
						if (oldHours==null) {
							oldHours = 0;
						}
						
								Double newHours = newWt.hours_estimate__c;
						
						if (newHours==null) {
							newHours = 0;
						}
						
						if (currHours == null) {
							currHours = 0;
						}
						
						
						
						currHours = currHours - oldHours;
						
						currHours = currHours + newHours;
						
						
						milestone.estimated_hours__c = currHours;
						
						milestone.Update_Project_Amount__c = true;
						
						
						update milestone;
						
					}
					else {
						
						
						
						System.debug('Ok then, now update project!! ');
						
						
			        	   Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:newWt.project__c];
	            
	            
	           				decimal existingHours = proj.estimated_project_hours__c;
	           				
	           			
	           				if (existinghours!=null) {
	           				
	           				double oldHours = 0;
	           				
	           				double newHours = 0;
	           				
	           				if (oldWt.hours_estimate__c!=null) {
	           					
	           					oldHours = oldWt.hours_estimate__c;
	           					
	           				}
	           				
	           				if (newWt.hours_estimate__c!=null) {
	           					
	           					newHours = newWt.hours_estimate__c;
	           				}
			        		
			        		existingHours = existingHours - oldHours;
			        		
			        		existingHours = existingHours + newHours;
			        		
			        		proj.estimated_project_hours__c = existingHours;
			        		
			        		System.debug('Project new estimated: '+proj.estimated_project_hours__c);
			        		
			        		update proj;
						
	           				}
						
						
						
						
					}
	
	} else if (Trigger.isDelete) {
		
		
		Work_Task__c newWt = Trigger.old[0];
			
					Milestone__c[] milestones = [select id,name,estimated_hours__c from Milestone__c where id=:newWt.milestone__c];
					
					
					Milestone__c milestone;
					
					if (milestones.size()>0) {
						
							milestone = milestones[0];
					
					}
					
					if (milestone!=null) {
						
						Double currHours = milestone.estimated_hours__c;
						
						
						
						Double newHours = newWt.hours_estimate__c;
						
						if (newHours==null) {
							newHours = 0;
						}
						
						
						
						currHours = currHours - newHours;
						
						
						
						milestone.estimated_hours__c = currHours;
						
						milestone.Update_Project_Amount__c = true;
						
						update milestone;
						
					}
					else {
						
						try {
							
							Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:newWt.Project__c limit 1];
							
							
							if (proj!=null) {					
						
							decimal existingHours = proj.estimated_project_hours__c;
	           				
	           				
	           				double oldHours = 0;
	           				
	           				if (newWT.hours_estimate__c!=null) {
	           					
	           					oldHours = newWT.hours_estimate__c;
	           					
	           				}
	           				
			        		
			        		existingHours = existingHours - oldHours;
			        		
			        		
			        		proj.estimated_project_hours__c = existingHours;
			        		
			        		System.debug('Project new estimated: '+proj.estimated_project_hours__c);
			        		
			        		update proj;
							}
						
						} catch (Exception e) {
						
					}
						
						
						
					}
					
		
		
	}
	

}