/*** 
* Class: WorkTaskUpdateMilestoneTest
* Description: Unit Test for trigger WorkTaskUpdateMilestone
* Author: Elmar Chen
* Create Time: 06/09/2015 11:06:47
*
**********************************************************************
*
*   Date            Author                 Change
*   06/09/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class WorkTaskUpdateMilestoneTest {
	
	@isTest static void test_UpdateWithMileStone() {
		List<Project__c> projects = TestDataFactory.createProject(3, true, new Map<String, Object>{
			'Estimated_Project_Hours__c' => 50
			});
		List<Work_Task__c> wts = TestDataFactory.createWorkTask(3, false, null);
		List<Milestone__c> ms = TestDataFactory.createMilestone(3, false, null);
		for(Integer i=0; i<3; i++){
			ms[i].estimated_hours__c = i==0?null:50;
			ms[i].Project__c = projects[i].Id;
		}
		insert ms;
		for(Integer i=0; i<3; i++){
			wts[i].Project__c = projects[i].Id;
			wts[i].Milestone__c = ms[i].Id; 
			wts[i].hours_estimate__c = i==0 ? null : 30; 
		}
		insert wts;

		
	Test.startTest();
		for(Integer i=0; i<3; i++){
			wts[i].hours_estimate__c = i==2 ? null : 20; 
			update wts[i];
		}
		
	Test.stopTest();
		ms = [SELECT estimated_hours__c, Update_Project_Amount__c FROM Milestone__c];
		Map<Id, Milestone__c> mMap = new Map<Id, Milestone__c>(ms);
		
		System.assertEquals(20, mMap.get(ms[0].Id).estimated_hours__c);
		System.assertEquals(40, mMap.get(ms[1].Id).estimated_hours__c);
		System.assertEquals(20, mMap.get(ms[2].Id).estimated_hours__c);

	}

	@isTest static void test_UpdateWithoutMileStone() {
		List<Project__c> projects = TestDataFactory.createProject(2, true, new Map<String, Object>{
			'Estimated_Project_Hours__c' => 50
			});
		List<Work_Task__c> wts = TestDataFactory.createWorkTask(2, false, null);
		for(Integer i=0; i<2; i++){
			wts[i].Project__c = projects[i].Id;
			wts[i].hours_estimate__c = i==0 ? null : 30; 
		}
		insert wts;

		
	Test.startTest();
		for(Integer i=0; i<2; i++){
			wts[i].hours_estimate__c = i==1 ? null : 20; 
			update wts[i];
		}
		
	Test.stopTest();
		projects = [SELECT estimated_project_hours__c FROM Project__c];
		Map<Id, Project__c> prjMap = new Map<Id, Project__c>(projects);
		System.debug('new estimated_project_hours__c is:' + prjMap.get(projects[0].Id).estimated_project_hours__c);
		System.debug('new estimated_project_hours__c is:' + prjMap.get(projects[1].Id).estimated_project_hours__c);

		System.assertEquals(70, prjMap.get(projects[0].Id).estimated_project_hours__c);
		System.assertEquals(20, prjMap.get(projects[1].Id).estimated_project_hours__c);
	}

	@isTest static void test_DeleteWithoutMileStone() {
		List<Project__c> projects = TestDataFactory.createProject(2, true, new Map<String, Object>{
			'Estimated_Project_Hours__c' => 50
			});
		List<Work_Task__c> wts = TestDataFactory.createWorkTask(2, false, null);
		for(Integer i=0; i<2; i++){
			wts[i].Project__c = projects[i].Id;
			wts[i].hours_estimate__c = i==0 ? null : 30; 
		}
		insert wts;

		
	Test.startTest();
		for(Integer i=0; i<2; i++){
			delete wts[i];
		}
		
	Test.stopTest();
		projects = [SELECT estimated_project_hours__c FROM Project__c];
		Map<Id, Project__c> prjMap = new Map<Id, Project__c>(projects);
		System.debug('new estimated_project_hours__c is:' + prjMap.get(projects[0].Id).estimated_project_hours__c);
		System.debug('new estimated_project_hours__c is:' + prjMap.get(projects[1].Id).estimated_project_hours__c);

		System.assertEquals(50, prjMap.get(projects[0].Id).estimated_project_hours__c);
		System.assertEquals(20, prjMap.get(projects[1].Id).estimated_project_hours__c);
	}

	@isTest static void test_DeleteWithMileStone() {
		List<Project__c> projects = TestDataFactory.createProject(3, true, new Map<String, Object>{
			'Estimated_Project_Hours__c' => 50
			});
		List<Work_Task__c> wts = TestDataFactory.createWorkTask(3, false, null);
		List<Milestone__c> ms = TestDataFactory.createMilestone(3, false, null);
		for(Integer i=0; i<3; i++){
			ms[i].estimated_hours__c = 50;
			ms[i].Project__c = projects[i].Id;
		}
		insert ms;
		for(Integer i=0; i<3; i++){
			wts[i].Project__c = projects[i].Id;
			wts[i].Milestone__c = ms[i].Id; 
			wts[i].hours_estimate__c = i==2 ? null : 30; 
		}
		insert wts;

		
	Test.startTest();
		for(Integer i=0; i<3; i++){
			delete wts[i];
		}
		
	Test.stopTest();
		ms = [SELECT estimated_hours__c, Update_Project_Amount__c FROM Milestone__c];
		Map<Id, Milestone__c> mMap = new Map<Id, Milestone__c>(ms);
		
		System.assertEquals(20, mMap.get(ms[0].Id).estimated_hours__c);
		System.assertEquals(20, mMap.get(ms[1].Id).estimated_hours__c);
		System.assertEquals(50, mMap.get(ms[2].Id).estimated_hours__c);

	}
}