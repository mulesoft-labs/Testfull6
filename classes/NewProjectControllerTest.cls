/*** 
* Class: NewProjectControllerTest
* Description: Unit test for NewProjectController
* Author: Elmar Chen
* Create Time: 06/11/2015 11:44:32
*
**********************************************************************
*
*   Date            Author                 Change
*   06/11/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class NewProjectControllerTest {
	private static Project__c prj;
	private static Opportunity opp;
	private static Account a;
	private static Contact c;
	private static void initTestData(){
		a = TestDataFactory.createAccounts(1, true, null)[0];
		c = TestDataFactory.createContacts(1, a.Id, true,  new Map<String, Object>{
			'Primary_Project_Contact__c' => false
		})[0];
		opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{
			'forecast__c'=>'Closed',
			'Multi_Year_Deal__c' => 'yes',
			'If_yes_Year_X_of_Total_Years__c' => '1'
		})[0];
		prj = TestDataFactory.createProject(1, true, new Map<String, Object>{
			      'Name' => 'A Name',
			      'Account__c' => a.Id,
			      'Projected_Completion_Date__c' => Date.Today().AddDays(10),
			      'Project_Limit__c' => 1000,
			      'Generate_Default_Milestones__c' => true,
			      'Generate_Default_Work_Tasks__c' => true,
			      'Primary_Contact__c' => c.Id,
			      'Opportunity_Source__c' => opp.Id,
			      'Special_Handling__c' => false,
			      'Project_Template__c'=>false
		})[0];
		Master_Rate__c mr = new Master_Rate__c(principal_consultant_rate__c = 10, Name='Test MR');

		insert mr;
	}
	private static void initWithoutCloneParams() {
		System.currentPageReference().getParameters().put('retURL', ':'+prj.Id);
		System.currentPageReference().getParameters().put('oppId', opp.Id);
		System.currentPageReference().getParameters().put('accId', a.Id);
		System.currentPageReference().getParameters().put('specHdn', '1');
		System.currentPageReference().getParameters().put('oppName', 'Opp Name');          
		System.currentPageReference().getParameters().put('oppTotal', '$10,000');
	}
	private static void initWithCloneParams() {
		System.currentPageReference().getParameters().put('cloningId', prj.Id);
		System.currentPageReference().getParameters().put('clone', 'true');
	}
	@isTest static void test_InitWithClone() {
		initTestData();
		initWithCloneParams(); 
	Test.startTest();	
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);
	Test.stopTest();
		System.debug('ctrl.lstRoles is: '+ ctrl.lstRoles);
		System.assertEquals(1, ctrl.lstRoles.size());
		System.assertEquals('Test MR', ctrl.lstRoles[0].Name);
		System.assertEquals(10, ctrl.lstRoles[0].Principal_Consultant_Rate__c);
		System.assertEquals(true, ctrl.enableLookupSection);
		System.assertEquals(true, ctrl.enableLookup);
		System.assertEquals(null, ctrl.cloneFromProjectTemplate);
		
		doPrjectAssertion(ctrl);
	}
	
	@isTest static void test_InitWithoutClone() {
		initTestData();
		initWithoutCloneParams();
	Test.startTest();	
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);
		Boolean specHdn1 = ctrl.kasaiProject.Special_Handling__c;
		System.currentPageReference().getParameters().put('specHdn', '0');
		NewProjectController ctrl2 = new NewProjectController(stdCtrl);
	Test.stopTest();
	    System.assertEquals(opp.Id, ctrl.kasaiProject.Opportunity_Source__c);
	    System.assertEquals(c.Id, ctrl.kasaiProject.Primary_Contact__c);
	    System.assertEquals(a.Id, ctrl.kasaiProject.Account__c);
	    System.assertEquals(true, specHdn1);
	    System.assertEquals('Opp Name', ctrl.kasaiProject.Name);
	    System.assertEquals(10000, ctrl.kasaiProject.Project_Limit__c);

		System.assert(ctrl.kasaiProject.Projected_Completion_Date__c==System.today() 
			|| ctrl.kasaiProject.Projected_Completion_Date__c==System.today().addDays(-1));//if test execution is crossing days.

	    System.assertEquals(false, ctrl2.kasaiProject.Special_Handling__c);
	}

	@isTest static void test_ProjectSelected() {
		initTestData();
		System.currentPageReference().getParameters().put('projId', prj.Id);
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);
	Test.startTest();
	 	PageReference r = ctrl.projectSelected();
	Test.stopTest();
		System.assertEquals(null, r);
		System.assertEquals(prj.Id, ctrl.getSelectedProjectId());
		ctrl.setSelectedProjectId(null);
		System.assertEquals(null, ctrl.getSelectedProjectId());
		doPrjectAssertion(ctrl);
	}


	@isTest static void test_PrimaryContact() {
		initTestData();
		Contact c2 = TestDataFactory.createContacts(1, a.Id, true, new Map<String, Object>{
			'Primary_Project_Contact__c' => true
		})[0];
		
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);
	Test.startTest();
	 	Contact pc = ctrl.getPrimaryContact();
	Test.stopTest();
		System.assertEquals(c2.Id, pc.Id);
	}

	@isTest static void test_GetProjectTemplates() {
		initTestData();
		TestDataFactory.createProject(20, true, new Map<String, Object>{
			'Project_Template__c'=>true
		});
		
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);
	Test.startTest();
	 	List<SelectOption> ops= ctrl.getProjectTemplates();
	Test.stopTest();
		System.assertEquals(21, ops.size());
		System.assertEquals('None', ops[0].getValue());
		System.assertEquals('None', ops[0].getLabel());
	}

	@isTest static void test_SaveWithoutClone() {
		initTestData();
		initWithoutCloneParams();
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);
	Test.startTest();
		RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='Project__c' AND Name='Support'];
		ctrl.kasaiProject = new Project__c();
		ctrl.cloneProjects(prj); //Workaround
		ctrl.setSelectedProjectId(prj.Id);
		ctrl.kasaiProject.RecordTypeId = rt.Id;
		ctrl.saveProject();
	Test.stopTest();
		Opportunity o = [SELECT StageName FROM Opportunity WHERE id= :opp.Id];
		System.assertEquals('Closed Won', o.StageName);
		System.assert(ctrl.kasaiProject.Id != null);
	   	List<Pricing_Sheets__c> pss = [SELECT Id FROM Pricing_Sheets__c WHERE Project__c = :ctrl.kasaiProject.Id]; 
	   	List<Milestone__c> ms = [SELECT Id FROM Milestone__c WHERE Project__c = :ctrl.kasaiProject.Id]; 
	   	List<Work_Task__c> wts = [SELECT Id FROM Work_Task__c WHERE Project__c = :ctrl.kasaiProject.Id];

	   	System.assert(pss.size()>0);
		System.assert(ms.size()>0);
		System.assert(wts.size()>0);
	}

	@isTest static void test_SaveWithClone() {
		initTestData();
		initWithCloneParams();
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);
		ctrl.cloneFromExistingProject = true;
	Test.startTest();
		ctrl.kasaiProject = new Project__c();
		ctrl.cloneProjects(prj); //Workaround
		ctrl.saveProject();
	Test.stopTest();
	   	System.assert(ctrl.kasaiProject.Id != null);
	   	List<Pricing_Sheets__c> pss = [SELECT Id FROM Pricing_Sheets__c WHERE Project__c = :ctrl.kasaiProject.Id]; 
	   	List<Milestone__c> ms = [SELECT Id FROM Milestone__c WHERE Project__c = :ctrl.kasaiProject.Id]; 
	   	List<Work_Task__c> wts = [SELECT Id FROM Work_Task__c WHERE Project__c = :ctrl.kasaiProject.Id];

	   	System.assert(pss.size()>0);
		System.assert(ms.size()>0);
		System.assert(wts.size()>0);
	}

	@isTest static void test_GetProjectCompletion() {
		initTestData();
		List<Project__c> prjs = TestDataFactory.createProject(20, false, null);

		for(Integer i=0; i<prjs.size(); i++){
			prjs[i].Project_Status__c = 'Active';
			prjs[i].Projected_Completion_Date__c = Date.today().addDays(i);
			prjs[i].Project_Limit__c = 60;
		}
		insert prjs;
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);

	Test.startTest();
		List<NewProjectController.projectComposite> pcs = ctrl.getProjectCompletion();
	Test.stopTest();
	   	System.assertEquals(10, pcs.size());
		for(Integer i=0; i<10;i++){
			System.assertEquals((''+ prjs[19-i].Projected_Completion_Date__c).substring(0,10), pcs[i].dateString);
			System.assertEquals(prjs[19-i].Id, pcs[i].proj.Id);
		}
	}
	@isTest static void test_Misc() {
		initTestData();
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(prj);
		NewProjectController ctrl = new NewProjectController(stdCtrl);

	Test.startTest();
		Boolean enableLookup1 = ctrl.getEnableLookup();
		ctrl.setEnableLookup();
		Boolean enableLookup2 = ctrl.getEnableLookup();
		ctrl.setEnableLookup();
		Boolean enableLookup3 = ctrl.getEnableLookup();
		
	Test.stopTest();
	   	System.assertEquals(null, ctrl.cancelOp());
	   	System.assert(enableLookup1!=enableLookup2);
	   	System.assert(enableLookup2!=enableLookup3);
	}

	private static void doPrjectAssertion(NewProjectController ctrl){
		System.assertEquals(prj.Name, ctrl.kasaiProject.Name);
		System.assertEquals(prj.Name, ctrl.cloningProject.Name);
		System.assertEquals(prj.Account__c, ctrl.kasaiProject.Account__c);
		System.assertEquals(prj.Account__c, ctrl.cloningProject.Account__c);
		System.assertEquals(prj.Projected_Completion_Date__c, ctrl.kasaiProject.Projected_Completion_Date__c);
		System.assertEquals(prj.Projected_Completion_Date__c, ctrl.cloningProject.Projected_Completion_Date__c);
		System.assertEquals(prj.Project_Limit__c, ctrl.kasaiProject.Project_Limit__c);
		System.assertEquals(prj.Project_Limit__c, ctrl.cloningProject.Project_Limit__c);
		System.assertEquals(prj.Generate_Default_Milestones__c, ctrl.kasaiProject.Generate_Default_Milestones__c);
		System.assertEquals(prj.Generate_Default_Milestones__c, ctrl.cloningProject.Generate_Default_Milestones__c);
		System.assertEquals(prj.Generate_Default_Work_Tasks__c, ctrl.kasaiProject.Generate_Default_Work_Tasks__c);
		System.assertEquals(prj.Generate_Default_Work_Tasks__c, ctrl.cloningProject.Generate_Default_Work_Tasks__c);
		System.assertEquals(prj.Primary_Contact__c, ctrl.kasaiProject.Primary_Contact__c);
		System.assertEquals(prj.Primary_Contact__c, ctrl.cloningProject.Primary_Contact__c);
		System.assertEquals(prj.Opportunity_Source__c, ctrl.kasaiProject.Opportunity_Source__c);
		System.assertEquals(prj.Opportunity_Source__c, ctrl.cloningProject.Opportunity_Source__c);
		System.assertEquals(prj.Special_Handling__c, ctrl.kasaiProject.Special_Handling__c);
		System.assertEquals(prj.Special_Handling__c, ctrl.cloningProject.Special_Handling__c);
	}
}