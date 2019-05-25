/*** 
* Class: Employee_Assignment_UtilsTest
* Description: Unit test for Employee_Assignment_UtilsTest
* Author: Elmar Chen
* Create Time: 06/18/2015 11:36:10
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class Employee_Assignment_UtilsTest {
	
	@isTest static void test_calculateProjectWeekHours() {
		List<Project__c> prjs = TestDataFactory.createProject(2, true, new Map<String, Object>{
			'Projected_Completion_Date__c' => new List<Date>{
				Date.today().addDays(-500), 
				Date.today().addDays(500)},
			'Project_Limit__c' => 6,
			'Start_Date__c' => Date.today().addDays(-30)
		});

		List<Resource_Allocation__c> ras = new List<Resource_Allocation__c>();		
    	for(Integer i=0; i<prjs.size(); i++){
    		Pricing_Sheets__c r = (Pricing_Sheets__c) TestDataFactory.createObjects(Pricing_Sheets__c.SObjectType,
				1, true, new Map<String, Object>{
	    			'Principal_consultant_rate__c' => 100,
	    			'Project__c' => prjs[i].Id
    		})[0];
					
			ras.addAll((List<Resource_Allocation__c>)TestDataFactory.createObjects(Resource_Allocation__c.SObjectType,
		 		20, true, new Map<String, Object>{
					'Start_Date__c' => new List<Date>{
						Date.today().addDays(1), 
						Date.today().addDays(-100),
						Date.today().addDays(-100)},
					'End_Date__c' => new List<Date>{
						Date.today().addDays(-1), 
						Date.today().addDays(100),
						Date.today().addDays(100)},
					'Hours_Per_Week__c' => 40,	
					'Role__c' => r.Id,
					'Project__c' => prjs[i].Id
			}));
		}
		prjs = [SELECT Id, Projected_Completion_Date__c, Project_Limit__c, Start_Date__c, Name FROM Project__c ORDER BY Name];

		ras = [SELECT Start_Date__c, End_Date__c, Hours_Per_Week__c, Role__c, Project__c, Project__r.Id, Project__r.Name, 
			Role__r.Principal_Consultant_Rate__c, Weeks_for_Projected_Completion_Date__c FROM Resource_Allocation__c ];
	Test.startTest();
		Employee_Assignment_Utils.calculateProjectWeekHours(prjs, ras);
	Test.stopTest();
		System.assertEquals(Date.today().addDays(-30), prjs[0].Calculated_Completion_Date__c);
		System.assertEquals(Date.today().addDays(-30), prjs[1].Calculated_Completion_Date__c);
		System.assertEquals(520, prjs[0].Sum_of_Hours_Per_Week__c);
		System.assertEquals(520, prjs[1].Sum_of_Hours_Per_Week__c);
	}

	@isTest static void test_calculateEmployeeWeekHours() {
		List<Project__c> prjs = TestDataFactory.createProject(2, true, new Map<String, Object>{
			'Projected_Completion_Date__c' => new List<Date>{
				Date.today().addDays(-7), 
				Date.today().addDays(500)},
			'Project_Limit__c' => 6,
			'Start_Date__c' => Date.today().addDays(-30)
		});
		List<Employee__c> emps = TestDataFactory.createObjects(Employee__c.SObjectType, 2, true, new Map<String, Object>{
			
		});
		List<Resource_Allocation__c> ras = new List<Resource_Allocation__c>();		
    	for(Integer i=0; i<prjs.size(); i++){
    		Pricing_Sheets__c r = (Pricing_Sheets__c) TestDataFactory.createObjects(Pricing_Sheets__c.SObjectType,
				1, true, new Map<String, Object>{
	    			'Principal_consultant_rate__c' => 100,
	    			'Project__c' => prjs[i].Id
    		})[0];
					
			ras.addAll((List<Resource_Allocation__c>)TestDataFactory.createObjects(Resource_Allocation__c.SObjectType,
		 		3, true, new Map<String, Object>{
					'Start_Date__c' => new List<Date>{
						Date.today().addDays(0), 
						Date.today().addDays(-100),
						Date.today().addDays(-100)},
					'End_Date__c' => new List<Date>{
						Date.today().addDays(0), 
						Date.today().addDays(100),
						Date.today().addDays(100)},
					'Hours_Per_Week__c' => 40,	
					'Role__c' => r.Id,
					'Project__c' => prjs[i].Id,
					'Employee__c' => emps[i].Id
			}));
		}
		prjs = [SELECT Id, Projected_Completion_Date__c, Project_Limit__c, Start_Date__c, Name FROM Project__c ORDER BY Name];

		ras = [SELECT Start_Date__c, End_Date__c, Hours_Per_Week__c, Employee__c, Role__c, Project__c, Project__r.Id, Project__r.Name,
			Project__r.Projected_Completion_Date__c,
			Role__r.Principal_Consultant_Rate__c, Weeks_for_Projected_Completion_Date__c FROM Resource_Allocation__c ];
		for(Resource_Allocation__c ra : ras){
			System.debug(ra.Weeks_for_Projected_Completion_Date__c);
			System.debug(ra.Project__r.Projected_Completion_Date__c);
		}
	Test.startTest();
		Employee_Assignment_Utils.calculateEmployeeWeekHours(emps, ras);
	Test.stopTest();
		System.assertEquals(120, emps[0].Total_Hours_for_Week__c);
		System.assertEquals(120, emps[1].Total_Hours_for_Week__c);
	}
}