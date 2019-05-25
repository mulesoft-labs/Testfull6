@IsTest
private class TaskTriggerTest {

    static testMethod void testTaskInsert(){
        Account acc = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acc.Id })[0];

        TestDataFactory.createCallTypetoOpportunityMappings();
        Task newTask = new Task();
        newTask.WhatId = opp.Id;
        newTask.Subject = 'test';
        newTask.Call_Type__c = 'AE Connect Scheduled - Call';

        Test.startTest();
        insert newTask;
        Test.stopTest();

        opp = [ SELECT Id, AE_Connect_Scheduled__c FROM Opportunity WHERE Id =: opp.id ];
        System.assert( opp.AE_Connect_Scheduled__c );
    }

    static testMethod void testTaskUpdate(){
        Account acc = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acc.Id })[0];

        TestDataFactory.createCallTypetoOpportunityMappings();
        Task newTask = new Task();
        newTask.WhatId = opp.Id;
        newTask.Subject = 'test';
        newTask.Call_Type__c = 'AE Connect Scheduled - Call';
        insert newTask;

        Test.startTest();
        newTask.Call_Type__c = 'C-level connect scheduled';
        update newTask;
        Test.stopTest();
        opp = [ SELECT Id, AE_Connect_Scheduled__c, C_level_Connect_Scheduled__c  FROM Opportunity WHERE Id =: opp.id ];
        System.assertEquals( false, opp.AE_Connect_Scheduled__c );
        System.assert( opp.C_level_Connect_Scheduled__c);
    }

    static testMethod void testTaskDelete(){
        Account acc = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acc.Id })[0];

        TestDataFactory.createCallTypetoOpportunityMappings();
        Task newTask = new Task();
        newTask.WhatId = opp.Id;
        newTask.Subject = 'test';
        newTask.Call_Type__c = 'AE Connect Scheduled - Call';
        insert newTask;
        opp = [ SELECT Id, AE_Connect_Scheduled__c FROM Opportunity WHERE Id =: opp.id ];
        System.assert( opp.AE_Connect_Scheduled__c );

        Test.startTest();
        delete newTask;
        Test.stopTest();

        opp = [ SELECT Id, AE_Connect_Scheduled__c FROM Opportunity WHERE Id =: opp.id ];
        System.assert( !opp.AE_Connect_Scheduled__c );
    }

    static testMethod void testValidateCLevelConnect(){
        Account acc = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acc.Id })[0];

        TestDataFactory.createCallTypetoOpportunityMappings();
        Task newTask = new Task();
        newTask.WhatId = opp.Id;
        newTask.Subject = 'test';
        newTask.Call_Type__c = 'C-level connect completed';
        try{
            Test.startTest();
            insert newTask;
            Test.stopTest();
        }catch(Exception e){
            Boolean expectedExceptionThrown =  (e.getMessage().contains('A Contact or Lead is required for a C-level connect completed'))? true : false;
            System.assertEquals(expectedExceptionThrown, true);
        }
    }
}