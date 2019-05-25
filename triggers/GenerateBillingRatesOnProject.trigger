trigger GenerateBillingRatesOnProject on Project__c (after insert, before update, before delete) {
	
	if (Trigger.isDelete==true) {
		
		
		Project__c project = Trigger.old[0];
		
		Milestone__c[] milestones = [select id,name from Milestone__c where project__c=:project.id];
	    	
	    	Work_Task__c[] items = [select id,name from Work_Task__c where project__c=:project.id];
	    	
	    	delete milestones;
	    	
	    	delete items;
		
		
		
	}
	
	if(Trigger.isInsert==true){
		Pricing_Sheets__c[] sheets = new Pricing_Sheets__c[0];
		
		Project__c project = Trigger.new[0];

		Master_Rate__c[] masterRates = [select name,id,principal_consultant_rate__c from master_rate__c];
		
		for (Master_Rate__c mr:masterRates) {
			
			Pricing_Sheets__c rate = new Pricing_Sheets__c();
			rate.name = mr.name;
			rate.project__c = project.id;
			rate.principal_consultant_rate__c = mr.principal_consultant_rate__c;
			rate.master_rate__c = mr.id;
			
			sheets.add(rate);
			
		}

		insert(sheets);
	}
	
	if(Trigger.isUpdate==true){
		Set<Id> sProjIds = new Set<Id>();
		for(Project__c prj : Trigger.new){
			for(Project__c oldPrj: Trigger.old){
				if(prj.Id==oldPrj.Id){
					if(prj.Project_Limit__c!=oldPrj.Project_Limit__c){
						sProjIds.add(prj.Id);
					}
				}
			}
		}
		
		if(sProjIds.isEmpty()==false){
			List<Resource_Allocation__c> lstResAll = [Select Id, Hours_Per_Week__c, End_Date__c, Start_Date__c, Project__c, Project__r.Projected_Completion_Date__c, Role__c,Role__r.Principal_Consultant_Rate__c, Employee__c, Weeks_for_Projected_Completion_Date__c From Resource_Allocation__c Where Project__c in:sProjIds ];
			
			for(Project__c prj : Trigger.new){				
				Double daysForAcc = 0;
				Double projectLimit = prj.Project_Limit__c;
				Decimal totalHours = 0;
				Double total = 0;
				Double weekTotal = 0;				
				Date startDate = prj.Start_Date__c; 
				
				for(Resource_Allocation__c resAll : lstResAll){					
					if(prj.Id==resAll.Project__c){						
						if(resAll.Role__c!=null){
							if(resAll.Role__r.Principal_Consultant_Rate__c!=null){
								if(resAll.Hours_Per_Week__c!=null){									
									totalHours = resAll.Hours_Per_Week__c * resAll.Role__r.Principal_Consultant_Rate__c;
									total = total + totalHours;	
								}
							}
						}									
					} 
				}
				
				if(prj.Start_Date__c!=null){
					if(prj.Project_Limit__c!=null){
						if(total!=0){
							weekTotal = projectLimit / total;
							daysForAcc = weekTotal * 7;
							startDate = prj.Start_Date__c;
							prj.Calculated_Completion_Date__c = startDate.addDays(daysForAcc.intValue());
						}
					}
				}
			}
		}
	}

}