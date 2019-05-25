/**
*	@author Victor Vargas
*	@date 09/30/2011
*	@version: 1.0
*	@description Trigger that updates the Project Total Hours per Week and the Employee Total Hours per Week
*/

trigger Update_AvgHoursPerWeek on Resource_Allocation__c (after delete, after insert, after update, before insert) {
	
		
	List<Resource_Allocation__c> lstResAll = new List<Resource_Allocation__c>();
	Set<Id> ProjectIds =new Set<Id>();	
	Set<Id> EmployeeIds =new Set<Id>();
	
	 if(Trigger.isInsert==true && Trigger.isBefore==true){
	 	
	 	for(Resource_Allocation__c ra:Trigger.new){
			if(ra.Project__c!=null){
				
					ProjectIds.add(ra.Project__c);
					
					if (ra.Employee__c != null) {
						
						Employee__c employee = [select id,name,user__c from Employee__c where id=:ra.employee__c];
						
						
						try {
							EntitySubscription es = new EntitySubscription();
							es.ParentId = ra.project__c;
							es.SubscriberId = employee.user__c;
							
							insert es;
						} catch (Exception e) {
							
						}
						
						
					}
				
			}
	 	}
	 	
	 	
		
	 }
	else if(Trigger.isInsert==true || Trigger.isUpdate==true){
		for(Resource_Allocation__c ra:Trigger.new){
			if(ra.Project__c!=null){
				if(ra.Project_Status__c == 'Active'){
					ProjectIds.add(ra.Project__c);
				}
			}
			if(ra.Employee__c!=null){
				if(ra.Project_Status__c == 'Active'){
					EmployeeIds.add(ra.Employee__c);
				}
			}
		}
				
	}else{
		for(Resource_Allocation__c ra:Trigger.old){
			if(ra.Project__c!=null){
				if(ra.Project_Status__c == 'Active'){
					ProjectIds.add(ra.Project__c);
				}
			}
			if(ra.Employee__c!=null){
				if(ra.Project_Status__c == 'Active'){
					EmployeeIds.add(ra.Employee__c);
				}
			}
		}
	}
	
	if(ProjectIds.isEmpty()==false){
		if(EmployeeIds.isEmpty()==false){
			lstResAll = [Select Id, Hours_Per_Week__c, End_Date__c, Start_Date__c, Project__c, Project__r.Projected_Completion_Date__c, Role__c,Role__r.Principal_Consultant_Rate__c, Employee__c, Weeks_for_Projected_Completion_Date__c From Resource_Allocation__c Where Project__c in:ProjectIds Or Employee__c in:EmployeeIds ];
		}else{
			lstResAll = [Select Id, Hours_Per_Week__c, End_Date__c, Start_Date__c, Project__c, Project__r.Projected_Completion_Date__c, Role__c,Role__r.Principal_Consultant_Rate__c, Employee__c, Weeks_for_Projected_Completion_Date__c From Resource_Allocation__c Where Project__c in:ProjectIds ];
		}
	}else{
		if(EmployeeIds.isEmpty()==false){
			lstResAll = [Select Id, Hours_Per_Week__c, End_Date__c, Start_Date__c, Project__c, Project__r.Projected_Completion_Date__c, Role__c,Role__r.Principal_Consultant_Rate__c,Employee__c, Weeks_for_Projected_Completion_Date__c From Resource_Allocation__c Where Employee__c in:EmployeeIds ];
		}
	}
	
	if(Trigger.isInsert==true){			

		if(ProjectIds.isEmpty()==false){			
			List<Project__c> lstProjects = [Select Id, Sum_of_Hours_Per_Week__c, Calculated_Completion_Date__c, Start_Date__c, Project_Limit__c, Projected_Completion_Date__c From Project__c Where Id in:ProjectIds ];
			System.debug('calculating project Hours');
			List<Project__c> lstProjectsToUpdate = Employee_Assignment_Utils.calculateProjectWeekHours(lstProjects, lstResAll);			
			
			update lstProjectsToUpdate;
		}
		
		if(EmployeeIds.isEmpty()==false){			
			List<Employee__c> lstEmployees = [Select Id, Total_Hours_for_Week__c From Employee__c Where Id in:EmployeeIds ];
			List<Employee__c> lstEmployeesToUpdate = Employee_Assignment_Utils.calculateEmployeeWeekHours(lstEmployees, lstResAll);
			update lstEmployeesToUpdate;
		}				
	}
	
	if(Trigger.isUpdate==true){

		if(ProjectIds.isEmpty()==false){			
			List<Project__c> lstProjects = [Select Id, Sum_of_Hours_Per_Week__c, Calculated_Completion_Date__c, Start_Date__c, Project_Limit__c, Projected_Completion_Date__c From Project__c Where Id in:ProjectIds ];
			System.debug('calculating project Hours');
			List<Project__c> lstProjectsToUpdate = Employee_Assignment_Utils.calculateProjectWeekHours(lstProjects, lstResAll);			
			
			update lstProjectsToUpdate;
		}
		
		if(EmployeeIds.isEmpty()==false){			
			List<Employee__c> lstEmployees = [Select Id, Total_Hours_for_Week__c From Employee__c Where Id in:EmployeeIds ];
			List<Employee__c> lstEmployeesToUpdate = Employee_Assignment_Utils.calculateEmployeeWeekHours(lstEmployees, lstResAll);
			update lstEmployeesToUpdate;
		}		
	}
	
	if(Trigger.isDelete==true){			

		if(ProjectIds.isEmpty()==false){			
			List<Project__c> lstProjects = [Select Id, Sum_of_Hours_Per_Week__c, Calculated_Completion_Date__c, Start_Date__c, Project_Limit__c, Projected_Completion_Date__c From Project__c Where Id in:ProjectIds ];
			List<Project__c> lstProjectsToUpdate = Employee_Assignment_Utils.calculateProjectWeekHours(lstProjects, lstResAll);			
			
			update lstProjectsToUpdate;
		}
		
		if(EmployeeIds.isEmpty()==false){			
			List<Employee__c> lstEmployees = [Select Id, Total_Hours_for_Week__c From Employee__c Where Id in:EmployeeIds ];
			List<Employee__c> lstEmployeesToUpdate = Employee_Assignment_Utils.calculateEmployeeWeekHours(lstEmployees, lstResAll);
			update lstEmployeesToUpdate;
		}
	}
}