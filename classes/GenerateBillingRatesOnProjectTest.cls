/*** 
* Class: GenerateBillingRatesOnProjectTest
* Description: Unit test for GenerateBillingRatesOnProjectTest
* Author: Elmar Chen
* Create Time: 06/18/2015 17:30:20
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class GenerateBillingRatesOnProjectTest {
	
	@isTest static void test_Delete(){ 
		List<Project__c> prjs = TestDataFactory.createProject(10, true, null);
		List<Milestone__c> ms = TestDataFactory.createMilestone(20, true, new Map<String, Object>{
				'Project__c' => prjs
		});
	    List<Work_Task__c> wts = TestDataFactory.createWorkTask(20, true, new Map<String, Object>{
				'Project__c' => prjs
		});
	Test.startTest();
		delete prjs;
	Test.stopTest();
		ms = [SELECT Id, Name FROM Milestone__c WHERE Project__c in :prjs];
		wts = [SELECT Id, Name FROM Work_Task__c WHERE Project__c in :prjs];
		System.assertEquals(0, ms.size());
		System.assertEquals(0, wts.size());
	}

	@isTest static void test_Insert() {
		List<Master_Rate__c> masterRates = TestDataFactory.createObjects(
			Master_Rate__c.SObjectType, 20, true, new Map<String, Object>{
				'principal_consultant_rate__c' => 300 
			});
	Test.startTest();
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
	Test.stopTest();
		List<Pricing_Sheets__c> pss = [SELECT Id, Name FROM Pricing_Sheets__c WHERE Project__c = :prj.Id];
		System.assertEquals(20, pss.size());
	}

	@isTest static void test_Update() {
		Project__c prj = TestDataFactory.createProject(1, true, new Map<String, Object>{
			'Projected_Completion_Date__c' => Date.today().addDays(500),
			'Project_Limit__c' => 6,
			'Start_Date__c' => Date.today().addDays(-30)
		})[0];
		Pricing_Sheets__c r = (Pricing_Sheets__c) TestDataFactory.createObjects(Pricing_Sheets__c.SObjectType,
				1, true, new Map<String, Object>{
	    			'Principal_consultant_rate__c' => 100,
	    			'Project__c' => prj.Id
    		})[0];
		List<Resource_Allocation__c> ras = TestDataFactory.createObjects(Resource_Allocation__c.SObjectType,
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
					'Project__c' => prj.Id
			});

	Test.startTest();
		prj.Project_Limit__c = 12;
		update prj;
	Test.stopTest();
		prj = [SELECT Calculated_Completion_Date__c FROM Project__c WHERE Id = :prj.Id];
		System.assertEquals(Date.today().addDays(-30), prj.Calculated_Completion_Date__c);
	}
	
}