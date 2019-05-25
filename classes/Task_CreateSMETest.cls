/*** 
* Class: Task_CreateSMETest
* Description: Unit test for Task_CreateSMETest
* Author: Elmar Chen
* Create Time: 06/18/2015 20:42:08
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class Task_CreateSMETest {
    /*
    @isTest static void test_Task_CreateSMETest() {
        User u1 = TestDataFactory.createUser('System Administrator',Label.TestClassRoleName, true);
        List<RecordType> recTypes = [SELECT Id, Name FROM RecordType 
            WHERE sObjectType = 'Task' AND isActive = true ]; 
        Map <string,Id> recordTypeMap = new Map<string,Id>();
        Id tSME = null, nonSME = null; 
        List<Id> testIds = new List<Id>(2);
        for(RecordType rt : recTypes){
            testIds[rt.Name == 'Request SME' ? 0 : 1] = rt.Id;
        }

    Test.startTest();
    System.runAs(u1){
        List<Task> ts = TestDataFactory.createObjects(Task.SObjectType, 20, true, new Map<String, Object>{
                'Agenda__c' => 'Agenda__c',
                'Subject' => 'Subject',
                'Status' => 'In Progress',
                'ActivityDate' => Date.today().addDays(10),
                'Requested_SME__c' => 'Requested_SME__c',
                'RecordTypeId' => testIds
            });
     }       
    Test.stopTest();
        List<Request_SME__c> rs = [SELECT Agenda__c, Subject__c, Status__c, Due_Date__c, Submitter__c, 
            SubmitterManager__c, OwnerId, Request_SME_Name__c FROM Request_SME__c];
        System.assertEquals(10, rs.size());
    }
    */
}