/**
 * Description : CaseTriggerHandler Test Class
 *
 * Author      : Nikhil (Perficient)
 * Date        : 29/10/2015
 * Version     : 1.0
 *
 * Version History : Nikhil 10/29/2015 Initial Development
 */
@isTest
private class CaseTriggerHandlerTest
{

    public static testMethod void geoNaInsert()
    {
        User testUser =  TestDataFactory.createUser('System Administrator','NA-SC Lead',true);

        System.runAs(testUser)
        {
        performGeoTest('NA');
        }
    }
    
     public static testMethod void geoOemInsert()
    {
        User testUser =  TestDataFactory.createUser('System Administrator','OEM',true);

        System.runAs(testUser)
        {
        performGeoTest('OEM');
        }
    }
    
     public static testMethod void geoLatamInsert()
    {
        User testUser =  TestDataFactory.createUser('System Administrator','LATAM-SC Lead',true);

        System.runAs(testUser)
        {
        performGeoTest('LATAM');
        }
    }
    
     public static testMethod void geoEmeaInsert()
    {
        User testUser =  TestDataFactory.createUser('System Administrator','EMEA-SC Lead',true);

        System.runAs(testUser)
        {
        performGeoTest('EMEA');
        }
    }
    
     public static testMethod void geoApacInsert()
    {
        User testUser =  TestDataFactory.createUser('System Administrator','APAC-SC Lead',true);

        System.runAs(testUser)
        {
        performGeoTest('APAC');
        }
    }
    
 
    
    private static void performGeoTest(String RoleType){
        Map<String,Id> caseRecTypeId =CaseTriggerHandler.getRecordTypesByDeveloperName('Case');
        id RecTypeId;
        if(!caseRecTypeId.IsEmpty() && caseRecTypeId.containsKey('Sales_Operations_Case')){
            RecTypeId=caseRecTypeId.get('Sales_Operations_Case');
        }
       List<Case> Cases= (List<Case>)TestDataFactory.createObjects(Case.getsObjectType(),200,false,
                                new Map<String, Object>{'SuppliedEmail' => 'MrUser@test.com',
                                                        'SuppliedCompany' => 'TestCompany',
                                                        'SuppliedName' => 'TestCompany',
                                                        'RecordTypeId' => RecTypeId,
                                                        'origin' => 'Email'
                                                        });
        Test.startTest();
           insert Cases;    
        Test.stopTest();
        for( case c: [SELECT Geo__c,Id FROM Case WHERE Id IN :Cases]){
            system.assertEquals(RoleType,c.Geo__c);
        }
    }
    
    static testMethod void beforeUpdate_Test() {
        List<Case> newCases = (List<Case>) TestDataFactory.createObjects(Case.getsObjectType(),1,false,
            new Map<String, Object>{'RecordTypeId' => '012800000002y3wAAA',
                'MsDispatching_Time__c' => null,
                'Defect_ER_Number__c' => '',
                'Escalation_JIRA__c' => '',
                'Defect_ER_Impediment__c' => 'BLAH',
                'Defect_ER_Status__c' => 'BLAH',
                'Defect_ER_Subject__c' => 'BLAH',
                'Defect_ER_target_timeframe__c' => 'BLAH',
                'Defect_ER_Type__c' => 'BLAH',
                'Escalation_JIRA_Impediment__c' => 'BLEH',
                'Escalation_JIRA_Status__c' => 'BLEH',
                'Escalation_JIRA_Subject__c' => 'BLEH',
                'Escalation_JIRA_Target_Timeframe__c' => 'BLEH',
                'Escalation_JIRA_Type__c' => 'BLEH'
            });

        List<Case> newCases2 = (List<Case>) TestDataFactory.createObjects(Case.getsObjectType(),1,false,
            new Map<String, Object>{'RecordTypeId' => '012800000002y3wAAA',
                'MsDispatching_Time__c' => null,
                'Defect_ER_Number__c' => 'SE-111',
                'Escalation_JIRA__c' => 'sE-999',
                'Defect_ER_Impediment__c' => 'BLAH',
                'Defect_ER_Status__c' => 'BLAH',
                'Defect_ER_Subject__c' => 'BLAH',
                'Defect_ER_target_timeframe__c' => 'BLAH',
                'Defect_ER_Type__c' => 'BLAH',
                'Escalation_JIRA_Impediment__c' => 'BLEH',
                'Escalation_JIRA_Status__c' => 'BLEH',
                'Escalation_JIRA_Subject__c' => 'BLEH',
                'Escalation_JIRA_Target_Timeframe__c' => 'BLEH',
                'Escalation_JIRA_Type__c' => 'BLEH'
            });

        List<Case> oldCases = (List<Case>) TestDataFactory.createObjects(Case.getsObjectType(),1,false,
            new Map<String, Object>{'RecordTypeId' => '012800000002y3wAAA',
                'Dispatch_Completed__c' => false,
                'Status' => 'Work in Progress',
                'LastModifiedDate' => Date.today().addDays(-1)
            });

        List<Case> oldCases2 = (List<Case>) TestDataFactory.createObjects(Case.getsObjectType(),1,false,
            new Map<String, Object>{'RecordTypeId' => '012800000002y3wAAA',
                'Dispatch_Completed__c' => false,
                'Defect_ER_Number__c' => 'xx-111',
                'Escalation_JIRA__c' => 'xx-999',
                'Status' => 'Work in Progress',
                'LastModifiedDate' => Date.today().addDays(-100)
            });

        System.Test.startTest();
        CaseTriggerHandler.beforeUpdate(newCases, oldCases);
        CaseTriggerHandler.beforeUpdate(newCases2, oldCases2);
        System.Test.stopTest();
        for( case c: newCases){
            system.assert(c.MsDispatching_Time__c > 0);
            system.assertEquals('', c.Defect_ER_Impediment__c);
            system.assertEquals('', c.Defect_ER_Status__c);
            system.assertEquals('', c.Defect_ER_Subject__c);
            system.assertEquals('', c.Defect_ER_target_timeframe__c);
            system.assertEquals('', c.Defect_ER_Type__c);
            system.assertEquals('', c.Escalation_JIRA_Impediment__c);
            system.assertEquals('', c.Escalation_JIRA_Status__c);
            system.assertEquals('', c.Escalation_JIRA_Subject__c);
            system.assertEquals('', c.Escalation_JIRA_Target_Timeframe__c);
            system.assertEquals('', c.Escalation_JIRA_Type__c);
        }
        for( case c: newCases2){
            system.assert(c.MsDispatching_Time__c == 9999);
            system.assertEquals('', c.Defect_ER_Impediment__c);
            system.assertEquals('', c.Defect_ER_Status__c);
            system.assertEquals('', c.Defect_ER_Subject__c);
            system.assertEquals('', c.Defect_ER_target_timeframe__c);
            system.assertEquals('', c.Defect_ER_Type__c);
            system.assertEquals('', c.Escalation_JIRA_Impediment__c);
            system.assertEquals('', c.Escalation_JIRA_Status__c);
            system.assertEquals('', c.Escalation_JIRA_Subject__c);
            system.assertEquals('', c.Escalation_JIRA_Target_Timeframe__c);
            system.assertEquals('', c.Escalation_JIRA_Type__c);
        }        
    }


}