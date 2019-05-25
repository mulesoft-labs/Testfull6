/*** 
* Class: ExpenseReconciliationControllerTest
* Description: Unit test for ExpenseReconciliationController
* Author: Elmar Chen
* Create Time: 06/10/2015 20:32:18
*
**********************************************************************
*
*   Date            Author                 Change
*   06/10/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class ExpenseReconciliationControllerTest {
	private static void initTestData(Integer numOfRecords){
		List<Project__c> prjs = TestDataFactory.createProject(numOfRecords, true, null);
		List<Vendor__c> vs = TestDataFactory.createVendors(numOfRecords, true, null);

		List<Invoice_Expense__c> ies = new List<Invoice_Expense__c>();
		List<Expense_Log__c> els = new List<Expense_Log__c>();
		for(Integer i=0; i<numOfRecords; i++){
			els.add(new Expense_Log__c(Project__c = prjs[i].Id, Amount__c=i*100, Vendor__c=vs[numOfRecords-1].Id));
		}
		insert els;
		List<Invoice__c> is = new List<Invoice__c>();
		for(Integer i=0; i<numOfRecords; i++){
			is.add(new Invoice__c(Is_Finalized__c = i<=9, Project__c = prjs[i].Id));
		}
		insert is;
		for(Integer i=0; i<numOfRecords; i++){
			System.debug('#'+i+' id is: '+is[i].Id+', Is_Finalized__c is: '+is[i].Is_Finalized__c);
			
		}
		for(Integer i=0; i<numOfRecords; i++){
			ies.add(new Invoice_Expense__c(Expense_Log__c=els[i].Id, Amount__c=i*50, Invoice__c=is[i].Id));

		}
		insert ies;

	}

	@isTest 
	static void test_Init() {
		
		initTestData(100);
	
	Test.startTest();
		ExpenseReconciliationController ctrl = new ExpenseReconciliationController();
	Test.stopTest();
		System.assertEquals(1, ctrl.getPageNumber());
		System.assertEquals(30, ctrl.getPageSize());
		System.assertEquals(true, ctrl.getPreviousButtonEnabled());
		System.assertEquals(false, ctrl.getNextButtonDisabled());
		System.assertEquals(4, ctrl.getTotalPageNumber());
	}

	@isTest 
	static void test_SortByAmount() {
		initTestData(20);
		ExpenseReconciliationController ctrl = new ExpenseReconciliationController();
	Test.startTest();
		ctrl.sortField='amount__c';
		ctrl.lastOrder='asc';
		ctrl.doSort();
	Test.stopTest();	
		for(Integer i=1; i<ctrl.exp1.size();i++){
			System.assert(ctrl.exp1[i-1].invoiceExpense.Amount__c > ctrl.exp1[i].invoiceExpense.Amount__c);
		}
		
	}

	@isTest 
	static void test_SortByIsFinalized() {
		initTestData(20);
		ExpenseReconciliationController ctrl = new ExpenseReconciliationController();
	Test.startTest();
		ctrl.setSortField('Is_Finalized__c');
		ctrl.lastOrder='desc';
		ctrl.doSort();

	Test.stopTest();	
		System.assertEquals('Is_Finalized__c', ctrl.getSortField());
		for(Integer i=0; i<ctrl.exp1.size();i++){
			System.assertEquals(i>9, ctrl.exp1[i].invoiceExpense.Invoice__r.Is_Finalized__c);
		}
	}

	@isTest 
	static void test_PageNav() {
		
		initTestData(100);
	
		ExpenseReconciliationController ctrl = new ExpenseReconciliationController();
		
	Test.startTest();
		ctrl.nextBtnClick();
		ctrl.nextBtnClick();
		ctrl.nextBtnClick();
		Boolean isPreviousButtonEnabled = ctrl.getPreviousButtonEnabled();
		Integer pageNumber = ctrl.getPageNumber();
		Boolean isNextButtonDisabled = ctrl.getNextButtonDisabled();
		ctrl.previousBtnClick();
	Test.stopTest();

		System.assertEquals(4, pageNumber);
		System.assertEquals(false, isPreviousButtonEnabled); 
		//seems to be an bug. Or the function shall be rename to getPreviousButtonDisabled
		System.assertEquals(true, isNextButtonDisabled);
		
		System.assertEquals(3, ctrl.getPageNumber());
		System.assertEquals(false, ctrl.getPreviousButtonEnabled());
		System.assertEquals(false, ctrl.getNextButtonDisabled());

	}

	@isTest 
	static void test_NoRecord() {
		
		
	Test.startTest();
		ExpenseReconciliationController ctrl = new ExpenseReconciliationController();
	Test.stopTest();
		System.assert(ApexPages.hasMessages(ApexPages.severity.INFO));
	}

	@isTest 
	static void test_Save() {
		initTestData(20);
		ExpenseReconciliationController ctrl = new ExpenseReconciliationController();
		ctrl.vendorId = ctrl.VendorList[0].getValue();
		ctrl.vendorName = [SELECT Id, Name FROM Vendor__c WHERE Id = :ctrl.vendorId];
		List<Id> ieIds = new List<Id>();
		List<Id> elIds = new List<Id>();
		for(Integer i=0; i<ctrl.exp1.size(); i++){
			ctrl.exp1[i].invoiceExpense.Amount__c = 10;
			ctrl.exp1[i].expenseLog.Amount__c = 10;
			ieIds.add(ctrl.exp1[i].invoiceExpense.Id);
			elIds.add(ctrl.exp1[i].expenseLog.Id);
			ctrl.exp1[i].expenseLog.Selected_Vendor__c = ctrl.VendorList[0].getValue();
		}
	Test.startTest();
		ctrl.saveChanges();
	Test.stopTest();
		for(Integer i=0; i<ctrl.exp1.size(); i++){
			ctrl.exp1[i].invoiceExpense.Amount__c = 10;
			ctrl.exp1[i].expenseLog.Amount__c = 10;
		}
		List<Invoice_Expense__c> ies = [SELECT Amount__c FROM Invoice_Expense__c WHERE Id in :ieIds];
		List<Expense_Log__c> els = [SELECT Amount__c, Vendor__c FROM Expense_Log__c WHERE Id in :elIds];
		
		for(Integer i=0; i<ies.size(); i++){
			System.debug('#'+i+'ie id is: '+ ies[i].Id+', Amount is: ' + ies[i].Amount__c);
		}

		for(Integer i=0; i<els.size(); i++){
			System.debug('#'+i+'el id is: '+ els[i].Id+', Amount is: ' + els[i].Amount__c);
		}
		for(Invoice_Expense__c ie : ies){
			System.assertEquals(10, ie.Amount__c);
		}
		for(Expense_Log__c el : els){
			System.assertEquals(10, el.Amount__c);
			System.assertEquals(ctrl.vendorId, el.Vendor__c);
		}
	}

	@isTest 
	static void test_Misc() {
		
		
	Test.startTest();
		ExpenseReconciliationController ctrl = new ExpenseReconciliationController(null);
		ctrl.setExpenses(new List<ExpenseComposite>(80));
		List<ExpenseComposite> es = ctrl.getExpenses();
	Test.stopTest();
		System.assertEquals(80, es.size());
		System.assertEquals(null, ctrl.getPageNumber());
		System.assertEquals(null, ctrl.getPageSize());
		System.assertEquals(true, ctrl.getPreviousButtonEnabled());
		//System.assertEquals(false, ctrl.getNextButtonDisabled());
		System.assertEquals(null, ctrl.getTotalPageNumber());
	}
}