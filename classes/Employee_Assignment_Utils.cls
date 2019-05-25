public with sharing class Employee_Assignment_Utils {
	
	public static List<Project__c> calculateProjectWeekHours(List<Project__c> lstProjects,List<Resource_Allocation__c> lstResAll){
		for(Project__c prj : lstProjects){
			Decimal sumHours = 0;
			Double daysForAcc = 0;			
			Decimal totalHours = 0;
			Double total = 0;
			Double weekTotal = 0;					
			Double projectLimit = prj.Project_Limit__c;					
			Date projStartDate = prj.Start_Date__c; 
			Date currentDate = System.today();
			Date startDateResAll = null;
			Date endDateResAll = null;
			
			for(Resource_Allocation__c resAll : lstResAll){					
				if(prj.Id==resAll.Project__c){
					if(resAll.Weeks_for_Projected_Completion_Date__c <= 0){
						Date pcd = 	prj.Projected_Completion_Date__c;
						
						if(pcd>=currentDate){
							startDateResAll = resAll.Start_Date__c;
							endDateResAll = resAll.End_Date__c;								
							if(startDateResAll<=currentDate){
								if(endDateResAll>=currentDate){
									sumHours = sumHours + resAll.Hours_Per_Week__c;
								}
							}								
						}else{
							startDateResAll = resAll.Start_Date__c;
							endDateResAll = resAll.End_Date__c;																
							if(endDateResAll>pcd){
								prj.Projected_Completion_Date__c = endDateResAll;
								pcd = 	prj.Projected_Completion_Date__c;
							}
							
							if(startDateResAll<=currentDate){
								if(endDateResAll>=currentDate){
									sumHours = sumHours + resAll.Hours_Per_Week__c;
								}
							}	
						}
					}else{
						if(resAll.Weeks_for_Projected_Completion_Date__c >0){
							startDateResAll = resAll.Start_Date__c;
							endDateResAll = resAll.End_Date__c;	
							if(startDateResAll<=currentDate){
								if(endDateResAll>=currentDate){
									sumHours = sumHours + resAll.Hours_Per_Week__c;
								}
							}
						}
					}
					
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
					if(totalHours!=0){
						weekTotal = projectLimit / total;
						daysForAcc = weekTotal * 7;
						prj.Calculated_Completion_Date__c = projStartDate.addDays(daysForAcc.intValue());
					}
				}
			}
			
								
			prj.Sum_of_Hours_Per_Week__c = sumHours;
		}
		return lstProjects;
	}
	
	public static List<Employee__c> calculateEmployeeWeekHours(List<Employee__c> lstEmployees,List<Resource_Allocation__c> lstResAll){
		for(Employee__c emp : lstEmployees){
			Decimal sumHours = 0;
			Date currentDate = System.today();
			
			for(Resource_Allocation__c resAll : lstResAll){
				Date startDateResAll = null;
			    Date endDateResAll = null;			    
			    
				if(emp.Id==resAll.Employee__c){
					if(resAll.Weeks_for_Projected_Completion_Date__c == 0){
						Date pcd = 	resAll.Project__r.Projected_Completion_Date__c;
						
						if(pcd>=currentDate){
							startDateResAll = resAll.Start_Date__c;
							endDateResAll = resAll.End_Date__c;								
							if(startDateResAll<=currentDate){
								if(endDateResAll>=currentDate){
									sumHours = sumHours + resAll.Hours_Per_Week__c;
								}
							}								
						}else{
							startDateResAll = resAll.Start_Date__c;
							endDateResAll = resAll.End_Date__c;																
							if(endDateResAll>pcd){
								pcd = endDateResAll;
							}
							
							if(startDateResAll<=currentDate){
								if(endDateResAll>=currentDate){
									sumHours = sumHours + resAll.Hours_Per_Week__c;
								}
							}	
						}
					}else{
						if(resAll.Weeks_for_Projected_Completion_Date__c >0){
							startDateResAll = resAll.Start_Date__c;
							endDateResAll = resAll.End_Date__c;
														
							if (startDateResAll != null && endDateResAll != null) {								
								if(startDateResAll <= currentDate){
									if(endDateResAll >= currentDate){
										sumHours = sumHours + resAll.Hours_Per_Week__c;
									}
								}
							}
						}
					}
				}
			}
			emp.Total_Hours_for_Week__c = sumHours;
		}
		return lstEmployees;
	}
}