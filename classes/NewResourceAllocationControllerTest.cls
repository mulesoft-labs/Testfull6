/*** 
* Class: NewResourceAllocationControllerTest
* Description: Unit test for NewResourceAllocationControllerTest
* Author: Elmar Chen
* Create Time: 06/25/2015 10:58:50
*
**********************************************************************
*
*   Date            Author                 Change
*   06/25/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class NewResourceAllocationControllerTest {
	
	@isTest static void test_ConstructByMilestone() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		Milestone__c m = TestDataFactory.createMilestone(1, true, new Map<String, Object>{
			'Project__c' => prj
		})[0];
	Test.startTest();
		System.currentPageReference().getParameters().put('retURL', '/'+m.Id);
		NewResourceAllocationController ctrl = 
			new NewResourceAllocationController(new ApexPages.StandardController(m));
	Test.stopTest();
		System.assertEquals(m.Id, ctrl.ra.Milestone__c);
	}

	@isTest static void test_ConstructByPrj() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		Milestone__c m = TestDataFactory.createMilestone(1, true, new Map<String, Object>{
			'Project__c' => prj
		})[0];
	Test.startTest();
		System.currentPageReference().getParameters().put('retURL', '/'+prj.Id);
		NewResourceAllocationController ctrl = 
			new NewResourceAllocationController(new ApexPages.StandardController(m));
	Test.stopTest();
		System.assertEquals(prj.Id, ctrl.ra.Project__c);
	}

	@isTest static void test_ConstructError() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		Milestone__c m = TestDataFactory.createMilestone(1, true, new Map<String, Object>{
			'Project__c' => prj
		})[0];
	Test.startTest();
		System.currentPageReference().getParameters().put('retURL', '/somethingwrong');
		NewResourceAllocationController ctrl = 
			new NewResourceAllocationController(new ApexPages.StandardController(m));
	Test.stopTest();
		System.assertEquals(null, ctrl.ra.Project__c);
		System.assertEquals(null, ctrl.getRoleId());
		ctrl.setRa(null);
		System.assertEquals(null, ctrl.getRa());
	}


}