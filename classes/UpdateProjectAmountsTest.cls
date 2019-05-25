/*** 
* Class: UpdateProjectAmountsTest
* Description: Unit test for UpdateProjectAmountsTest
* Author: Elmar Chen
* Create Time: 06/29/2015 09:47:32
*
**********************************************************************
*
*   Date            Author                 Change
*   06/29/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class UpdateProjectAmountsTest {
	
	@isTest static void test_Delete() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		Milestone__c m = TestDataFactory.createMilestone(1, true, new Map<String, Object>{
			'Project__c' => prj,
			'actual_hours__c' => 20
 		})[0];
 		Work_Task__c wt = TestDataFactory.createWorkTask(1, true, new Map<String, Object>{
			'Project__c' => prj,
			'actual_hours__c' => 20
 		})[0];

 		Employee__c e = (Employee__c)TestDataFactory.createObjects(Employee__c.SObjectType, 1, true, new Map<String, Object>{
 			'name' => 'Test Employee'
 		})[0];
 		Time_log__c tl = (Time_log__c)TestDataFactory.createObjects(Time_log__c.SObjectType, 1, true, new Map<String, Object>{
 			'Project__c' => prj,
			'Milestone__c' => m,
 			'Work_Task__c' => wt,
 			'Employee__c' => e,
 			'activity_description__c' =>'activity_description__c'
 		})[0];

 	Test.startTest();
 		delete tl;
 	Test.stopTest();
 		m = [SELECT actual_hours__c FROM Milestone__c WHERE Id = :m.Id];
 		wt = [SELECT actual_hours__c FROM Work_Task__c WHERE Id = :wt.Id];
 		System.assertEquals(20, m.actual_hours__c);
 		System.assertEquals(20, wt.actual_hours__c);
	}
	
}