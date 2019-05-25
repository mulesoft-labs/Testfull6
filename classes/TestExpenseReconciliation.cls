@isTest
private class TestExpenseReconciliation {

    static testMethod void myUnitTest() {
        
        //Call dummy data for the tests
        List<Account> lstNewAccounts = EmployeeAssignment_Test_Functions.createDummyAccounts(1);
        List<Project__c> lstTestProjects = EmployeeAssignment_Test_Functions.createDummyProjects(1, false, lstNewAccounts);
        List<Pricing_Sheets__c> lstTestRole = EmployeeAssignment_Test_Functions.createDummyRoles(1, 100, lstTestProjects);
        List<Employee__c> lstEmployees = EmployeeAssignment_Test_Functions.createDummyEmployees(1);
        List<Resource_Allocation__c> lstAssignations = EmployeeAssignment_Test_Functions.createDummyResourceAllocations(lstTestProjects, lstEmployees, lstTestRole);
        List<Time_log__c> lstTestTimeLogs = EmployeeAssignment_Test_Functions.createDummyTimeLogs(10, 'Incurred', lstTestProjects, lstEmployees, lstTestRole);
        
        Expense_Log__c newExpenseLog = new Expense_Log__c();        
        newExpenseLog.Project__c = lstTestProjects[0].Id;
        newExpenseLog.Amount__c = 500.00;
        newExpenseLog.Percent_Markup__c = 10;        
        newExpenseLog.Employee__c = lstEmployees[0].id;        
        newExpenseLog.Billed_Status__c = 'Incurred';
        
        insert newExpenseLog;
        
        Invoice__c newInvoice = new Invoice__c();
        newInvoice.Project__c = lstTestProjects[0].Id;
        
        insert newInvoice;
        
        Invoice__c createdInvoice = [select Id,Name,Is_Finalized__c from Invoice__c where id=:newInvoice.id];        
        createdInvoice.Is_Finalized__c = true;
        
        update createdInvoice;
        
        
        ExpenseReconciliationController erc = new ExpenseReconciliationController();
        
        
        List<ExpenseComposite> ec = erc.getExpenses();
        erc.getPageNumber();
        erc.getPageSize();
        erc.getPreviousButtonEnabled();
        erc.getNextButtonDisabled();
        integer i = erc.getTotalPageNumber();
        
        
        for (ExpenseComposite e:ec) {
            
            if (e.expenseLog!=null&&e.expenseLog.Project__c==lstTestProjects[0].Id) {
                e.expenseLog.check_number__c = '12345431';
                
            }
            
            
        }
        
        erc.setSortField('Vendor__c');
        
        String testSort = erc.getSortField();
        
        System.assertEquals(testSort,'Vendor__c');
        
        
        erc.doSort();
        
        erc.saveChanges();
        
        Expense_Log__c checkLog = [select id,name,check_number__c from Expense_Log__c where id=:newExpenseLog.id];
        
     //   System.assertEquals('12345431',checkLog.check_number__c);
        
        
        
        
    }
}