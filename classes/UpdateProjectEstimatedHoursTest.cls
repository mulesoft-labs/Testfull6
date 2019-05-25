/*** 
* Class: UpdateProjectEstimatedHoursTest
* Description: Unit test for UpdateProjectEstimatedHoursTest
* Author: Elmar Chen
* Create Time: 06/28/2015 23:45:24
*
**********************************************************************
*
*   Date            Author                 Change
*   06/28/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class UpdateProjectEstimatedHoursTest {
	
	@isTest static void test_withWtChangeHours() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		Milestone__c m = TestDataFactory.createMilestone(1, true, new Map<String, Object>{
			'Project__c' => prj,
			'update_Project_Amount__c' => true,
			'Estimated_Hours__c' => 10
		})[0];
		List<Work_Task__c> wts = TestDataFactory.createWorkTask(
			1, true, new Map<String, Object>{
			'Milestone__c' => m
		});
		Boolean hasError = false;
	Test.startTest();
		try {
			m.Estimated_Hours__c = 20;
			update m;
			hasError = false;
		}catch(Exception e){
			hasError = true;
			System.debug('An expepected error shall happen.');
		}
	Test.stopTest();
		System.assertEquals(true, hasError);
	}
	
	@isTest static void test_withoutWT() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		Milestone__c m = TestDataFactory.createMilestone(1, true, new Map<String, Object>{
			'Project__c' => prj,
			'update_Project_Amount__c' => true
		})[0];
		m = [SELECT update_Project_Amount__c, Project__c FROM Milestone__c WHERE Id = :m.Id];
	Test.startTest();
		m.Estimated_Hours__c = 20;
		update m;
	Test.stopTest();
		prj = [SELECT Estimated_Project_Hours__c FROM Project__c WHERE Id = :prj.Id];
		System.assertEquals(20, prj.Estimated_Project_Hours__c);
	}
	
}