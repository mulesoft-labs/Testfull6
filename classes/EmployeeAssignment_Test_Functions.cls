/**
*	@author Victor Vargas
*	@date 09/30/2011
*	@version: 1.0
*	@description Class to create dummy data for the test classes only
*/
public class EmployeeAssignment_Test_Functions {
	
	/**
    * @author Victor Vargas
    * @date 09/30/2011
    * @description Function that creates Dummy Accounts
    * @param NumberOfRecords Total Number of Account records that the function will insert
    * @return List<Account> list of Accounts created with the specified parameters
    */ 
	public static List<Account> createDummyAccounts(Integer NumberOfRecords){
		List<Account> lstResult = new List<Account>();
		
		for(Integer i = 0; i<NumberOfRecords; i++){
        	Account newAccount = new Account();
        	newAccount.Name = 'Sample Account Name '+i;
        	newAccount.BillingCountry = 'US';
        	lstResult.add(newAccount);
        }
		
		insert lstResult;
		return lstResult;
	}
	
	/**
    * @author Victor Vargas
    * @date 09/30/2011
    * @description Function that creates Dummy Projects.
    * @param NumberOfRecords Total Number of Project records that the function will insert.
    * @param isRecurring Indicates if the projects created will have the field Is_Recurring__c active of inactive.
    * @param lstAccount List of account records to associate the projects.
    * @return List<Project__c> list of Projects created with the specified parameters
    */ 
	
	public static List<Project__c> createDummyProjects(Integer NumberOfRecords, boolean isRecurring, List<Account> lstAccount){
		List<Project__c> lstResult = new List<Project__c>();
		for(Account newAccount : lstAccount){
			for(Integer i = 0; i<NumberOfRecords; i++){
	        	Project__c newProject = new Project__c();
	        	newProject.Name = 'Sample Project Name '+i;
	        	newProject.Account__c = newAccount.Id;
	        	newProject.Projected_Completion_Date__c = System.today().addDays(30);
	        	newProject.Project_Limit__c = 10000;
	        	newProject.Project_Status__c = 'Active';
	        	newProject.Is_Recurring__c = isRecurring;
	        	newProject.Start_Date__c = System.today()-1;
        		newProject.Estimated_Project_Hours__c = 500;
	        	lstResult.add(newProject);
	        }
		}
		
		
		insert lstResult;
		return lstResult;
	}
	
	/**
    * @author Victor Vargas
    * @date 09/30/2011
    * @description Function that creates Dummy Employees.
    * @param NumberOfRecords Total Number of Employee records that the function will insert.
    * @return List<Project__c> list of Employees created with the specified parameters
    */ 
	
	public static List<Employee__c> createDummyEmployees(Integer NumberOfRecords){
		List<Employee__c> lstResult = new List<Employee__c>();
		
		for(Integer i = 0; i<NumberOfRecords; i++){
        	Employee__c newEmployee = new Employee__c();
	        newEmployee.Name = 'Sample Employee Name '+i;
	        newEmployee.Hourly_Rate__c = 20;
	        lstResult.add(newEmployee);
        }
		
		insert lstResult;
		return lstResult;
	}
	
	/**
    * @author Victor Vargas
    * @date 09/30/2011
    * @description Function that creates Dummy Roles.
    * @param NumberOfRecords Total Number of Pricing_Sheets__c records that the function will insert.
    * @param roleRate Rate for the new roles.
    * @param lstProject List of Projects to associate the new roles.
    * @return List<Pricing_Sheets__c> list of Projects created with the specified parameters
    */ 
	
	public static List<Pricing_Sheets__c> createDummyRoles(Integer NumberOfRecords, Integer roleRate, List<Project__c> lstProject){
		List<Pricing_Sheets__c> lstResult = new List<Pricing_Sheets__c>();
		
		for(Project__c newProject: lstProject){
			for(Integer i = 0; i<NumberOfRecords; i++){
	        	Pricing_Sheets__c newRole = new Pricing_Sheets__c();
		        newRole.Name = 'Test Role '+i;
		        newRole.Principal_Consultant_Rate__c = roleRate;
		        newRole.Project__c = newProject.Id;         
	        	lstResult.add(newRole);
        	}
		}
		
		insert lstResult;
		return lstResult;
	}
	
	/**
    * @author Victor Vargas
    * @date 09/30/2011
    * @description Function that creates Dummy Resource Allocations.
    * @param lstProject List of Projects to associate the new records.
    * @param lstEmployee List of Employees to associate the new records.
    * @param lstRoles List of Roles for the new records.
    * @return List<Resource_Allocation__c> list of Resource Allocations created with the specified parameters
    */ 
	
	public static List<Resource_Allocation__c> createDummyResourceAllocations(List<Project__c> lstProject, List<Employee__c> lstEmployee, List<Pricing_Sheets__c> lstRoles){
		List<Resource_Allocation__c> lstResult = new List<Resource_Allocation__c>();
		for(Project__c newProject : lstProject){
			for(Employee__c newEmployee : lstEmployee){
				Resource_Allocation__c newResAll = new Resource_Allocation__c();
		        newResAll.Project__c = newProject.Id;
				newResAll.Employee__c = newEmployee.Id;
		        newResAll.Role__c = lstRoles[0].Id;
		        newResAll.Hours_Per_Week__c = 10;
		        newResAll.Start_Date__c=System.today();
		        newResAll.End_Date__c=System.today().addDays(30);
		        lstResult.add(newResAll);
			}
		}

		insert lstResult;
		return lstResult;
	}
	
	/**
    * @author Victor Vargas
    * @date 09/30/2011
    * @description Function that creates Dummy Time Logs.
    * @param NumberOfRecords Total Number of Pricing_Sheets__c records that the function will insert.
    * @param billedStatus Billed Status for the new Time Logs.
    * @param lstProject List of Projects to associate the new records.
    * @param lstEmployee List of Employees to associate the new records.
    * @param lstRoles List of Roles for the new records.    
    * @return List<Time_log__c> list of Time Logs created with the specified parameters
    */ 
	
	public static List<Time_log__c> createDummyTimeLogs(Integer NumberOfRecords, String billedStatus, List<Project__c> lstProject, List<Employee__c> lstEmployee, List<Pricing_Sheets__c> lstRoles){
		List<Time_log__c> lstResult = new List<Time_log__c>();
		for(Project__c newProject : lstProject){
			for(Employee__c newEmployee : lstEmployee){
				for(Integer i = 0; i<NumberOfRecords; i++){
					Time_log__c newTimeLog = new Time_log__c();
			        newTimeLog.Date__c = System.today();
			        newTimeLog.Activity_Description__c = 'Sample Activity '+i;
			        newTimeLog.Project__c = newProject.Id;
			        newTimeLog.Employee__c = newEmployee.Id;
			        newTimeLog.Hours__c = 10;
			        newTimeLog.Billed_Status__c = billedStatus;
			        lstResult.add(newTimeLog);
				}
			}
		}

		insert lstResult;
		return lstResult;
	}
	
}