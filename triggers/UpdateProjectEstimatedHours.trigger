trigger UpdateProjectEstimatedHours on Milestone__c (before insert, before update,before delete) {
    
    
    	
    
    	if (Trigger.isDelete) {
    		
    		
    						Milestone__c oldMilestone = Trigger.old[0];
    		
    		        
    			try {
    		
    		  				Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:oldmilestone.project__c];
	            
	            			decimal existingHours = 0;
	            			
	 						if (proj.Estimated_Project_Hours__c!=null) {
	 							
	 							existingHours = proj.estimated_project_hours__c;	
	 						}           
	           				 
	           				 
	           				double oldHours = 0;
	           				
	           				if (oldMilestone.Estimated_Hours__c!=null) {
	           				
	           					oldHours = 	oldMilestone.Estimated_Hours__c;
	           					
	           				}
	           				
	           				
			        		existingHours = existingHours - oldHours;
			        		
			        		
			        		proj.estimated_project_hours__c = existingHours;
			        		
			        		
			        		update proj;
    		
        
    			} catch (Exception e) {
    				
    			}
    	} else if (Trigger.isInsert) {
        Milestone__c milestone = Trigger.new[0];
        
        
      
        
        
        
        if (milestone.Update_Project_Amount__c==false) {
        
        
	            Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:milestone.project__c];
	            
	            if (proj.estimated_project_hours__c==null) {
	                
	                proj.estimated_project_hours__c = 0;
	                
	            }
	            
	            integer count = [select count() from Milestone__c where Project__c=:milestone.project__c];
	            
	            if (count==0) {
	            	
	            	proj.estimated_project_hours__c=0;
	            }
	            
	            
	            if (milestone.Estimated_Hours__c!=null) {
	                
	                proj.Estimated_Project_Hours__c = proj.Estimated_Project_Hours__c+milestone.Estimated_Hours__c;
	                
	            }
	            
	            System.debug('About to update project: '+proj.estimated_project_hours__c);
	            
	            update proj;
	            
	            
	            
	        }
	       
	       if (milestone.update_project_amount__c==true) {
	       		milestone.Update_Project_Amount__c=false;
	       }
	        
        }
        else if (Trigger.isUpdate) {
        	
        	        Milestone__c newMilestone = Trigger.new[0];
        	        
        	        boolean bypassTrigger = newMilestone.bypass_trigger__c;
        	        
        	        if (bypassTrigger==false) {
        	        
        	        Milestone__c oldMilestone = Trigger.old[0];
        	        
        	        
        	          Work_Task__c[] wts = [select id,name,description__c from Work_Task__c where Milestone__c=:newmilestone.id];
        
       				 integer size = wts.size();
        
        
       				 System.debug('Before update new milestone: '+size+ ' : '+newmilestone.Update_Project_Amount__c+ ' : '+newmilestone.name);
        
        
			        if (size==0&&newmilestone.Update_Project_Amount__c==true) {
			        	
			        	   Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:newmilestone.project__c];
	            
	            
	           				decimal existingHours = proj.estimated_project_hours__c;
	           				
	           			
	           				
	           				double oldHours = 0;
	           				
	           				double newHours = 0;
	           				
	           				if (oldMilestone.estimated_hours__c!=null) {
	           					
	           					oldHours = oldMilestone.estimated_hours__c;
	           				}
	           				
	           				if (newMilestone.estimated_hours__c!=null) {
	           					
	           					newHours = newMilestone.estimated_hours__c;
	           				}
			        		
			        		existingHours = existingHours - oldHours;
			        		
			        		existingHours = existingHours + newHours;
			        		
			        		proj.estimated_project_hours__c = existingHours;
			        		
			        		System.debug('Project new estimated: '+proj.estimated_project_hours__c);
			        		
			        		update proj;
			        	
			        }
			        else if (size>0&&newmilestone.Update_Project_Amount__c==true) {
			        	
			        	   Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:newmilestone.project__c];
	            
	            			System.debug('Inside what is going on??: '+proj.Estimated_Project_Hours__c+ ' : '+proj.id+ ' : '+proj.name);
	           				decimal existingHours = proj.estimated_project_hours__c;
	           				
	           				System.debug('Existing hours: '+existingHours);
	           				
	           				System.debug('Old estimated hours: '+oldMilestone.estimated_hours__c);
	           				System.debug('new estimated hours: '+newMilestone.estimated_hours__c);
			        		
			        		if (oldMilestone.Estimated_Hours__c!=null) {
			        			
			        			
			        		
			        		existingHours = existingHours - oldMilestone.Estimated_Hours__c;
			        		
			        		}
			        		
			        		existingHours = existingHours + newMilestone.Estimated_Hours__c;
			        		
			        		proj.estimated_project_hours__c = existingHours;
			        		
			        		System.debug('Project new estimated: '+proj.estimated_project_hours__c);
			        		
			        		update proj;
			        		
			         }
			        else if (size>0&&newmilestone.update_Project_Amount__c==false) {
			        	
			        	
			        /*	   Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:newmilestone.project__c];
	            
	            
	            			System.debug('Inside what is going on??: '+proj.Estimated_Project_Hours__c+ ' : '+proj.id+ ' : '+proj.name);
	           				decimal existingHours = proj.estimated_project_hours__c;
	           				
	           				System.debug('Existing hours: '+existingHours);
	           				
	           				System.debug('Old estimated hours: '+oldMilestone.estimated_hours__c);
	           				System.debug('new estimated hours: '+newMilestone.estimated_hours__c);
			        		
			        		existingHours = existingHours - oldMilestone.Estimated_Hours__c;
			        		
			        		existingHours = existingHours + newMilestone.Estimated_Hours__c;
			        		
			        		proj.estimated_project_hours__c = existingHours;
			        		
			        		System.debug('Project new estimated: '+proj.estimated_project_hours__c);
			        		
			        		update proj;
			        	
			        	*/
			        	
			        	//oldnew
			        	
			        	boolean isDifferent = false;
			        	
			        	double oldHours = oldMilestone.Estimated_Hours__c;
			        	
			        	double newHours = newMilestone.Estimated_Hours__c;
			        	
			        	if (newHours != oldHours) {
			        		
			        		isDifferent = true;
			        		
			        	}
			        	
			        	 if (isDifferent==true) {
			        	 	trigger.new[0].addError ('You cannot update a milestones hours estimate once there are work tasks under the milestone. There are currently '+size+ ' work tasks associated with this milestone');
			        	 	
			        	 }
			        	
			        	
			        }
			        else if (size==0) {
			        	
			        	
			        	   Project__c proj =  [select id,name,estimated_project_hours__c from Project__c where id=:newmilestone.project__c];
	            
	            
	            
	           				decimal existingHours = proj.estimated_project_hours__c;
	           				
	           				if (existingHours==null) {
	           					
	           					existingHours = 0;
	           					
	           				}
	           				
	           				double oldHours = oldMilestone.Estimated_Hours__c;
	           				
	           				if (oldHours==null) {
	           					
	           					oldHours = 0;
	           				}
	           				
	           				double newHours = newMilestone.Estimated_Hours__c;
	           				
	           				if (newHours==null) {
	           					
	           					newHours = 0;
	           					
	           					
	           				}
	           			    
			        		
			        		existingHours = existingHours - oldHours;
			        		
			        		existingHours = existingHours + newHours;
			        		
			        		proj.estimated_project_hours__c = existingHours;
			        		
			        		
			        		update proj;
			        		
			        	
			        }
			        else if (size>0) {
			        	
			        	trigger.new[0].addError ('You cannot update a milestones hours estimate once there are work tasks under the milestone. There are currently '+size+ ' work tasks associated with this milestone');
			        }
			        
			        
			         if (newmilestone.update_project_amount__c==true) {
	       					newmilestone.Update_Project_Amount__c=false;
	       			}
        	        } else {
        	        	
        	        		newmilestone.bypass_trigger__c=false;
        	        }
        	
        	
        }
        
    

}