@isTest
private class Test_ProjectDateBatchUpdate {

    static testMethod void UpdateProject() {
        //Call dummy data for the tests
        List<Account> lstNewAccounts = EmployeeAssignment_Test_Functions.createDummyAccounts(1);
        List<Project__c> lstTestProjects = EmployeeAssignment_Test_Functions.createDummyProjects(20, true, lstNewAccounts);
        
        Execute_ProjectDateUpdate ExecuteProjectUpdate = new Execute_ProjectDateUpdate();
        ExecuteProjectUpdate.IsTest=true;
        Test.startTest();
        ExecuteProjectUpdate.executeProjUpdate();
        Test.stopTest();
        
    }
    
    static testMethod void Schedule_UpdateProject() {
        //Call dummy data for the tests
        List<Account> lstNewAccounts = EmployeeAssignment_Test_Functions.createDummyAccounts(1);
        List<Project__c> lstTestProjects = EmployeeAssignment_Test_Functions.createDummyProjects(20, true, lstNewAccounts);
       
        Test.startTest();
        Schedule_ProjectUpdate scheduleProject = new Schedule_ProjectUpdate();
        String CRON_EXP = '0 0 0 30 9 ? 2022';
        String jobId = System.schedule('Test_Schedulable_Project_Update', CRON_EXP, scheduleProject);
        
        Test.stopTest();
        
    }
}