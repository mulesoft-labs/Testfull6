@isTest
private class PRFT_CaseListLightning_ControllerTest {

    @isTest
    static void testGetViewIdByName() {
        ListView testViewList = [SELECT Id, DeveloperName FROM ListView WHERE SobjectType = 'Case' LIMIT 1];
        System.debug(testViewList);
        
        Test.startTest();
        String viewId = PRFT_CaseListLightning_Controller.getViewIdByName(testViewList.DeveloperName);
        Test.stopTest();
        //assert
        System.assertEquals(testViewList.Id, viewId, 'View Id should be returned.');
    }
    
    @isTest
    static void testGetColumns() {
        String objectName = 'Case';
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.FieldSet> m = sObjType.getDescribe().FieldSets.getMap();
        System.assert(!m.isEmpty(), 'At least One Field Set is required for the object - ' + objectName);
        Schema.FieldSet fieldSetObj = m.values().get(0);
        String fieldSetName = fieldSetObj.Name;
        
        Test.startTest();
        List<String> columns = PRFT_CaseListLightning_Controller.getColumns(fieldSetName, ObjectName);
        Test.stopTest();
        //assert
        System.assertEquals(columns.size(), fieldSetObj.getFields().size(), 'All fields in field set should be there as columns.');
    }
    
    @isTest
    static void testGetFilteredCaseList() {
        String objectName = 'Case';
        ListView testViewList = [SELECT Id, DeveloperName FROM ListView WHERE SobjectType = 'Case' LIMIT 1];
        String filterName = testViewList.DeveloperName;
        
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.FieldSet> m = sObjType.getDescribe().FieldSets.getMap();
        System.assert(!m.isEmpty(), 'At least One Field Set is required for the object - ' + objectName);
        Schema.FieldSet fieldSetObj = m.values().get(0);
        String fieldSetName = fieldSetObj.Name;
        
        Test.startTest();
        List<List<Object>> caseList = PRFT_CaseListLightning_Controller.getFilteredCaseList(filterName, fieldSetName, ObjectName);
        Test.stopTest();
        //assert
        //System.assertEquals(columns.size(), fieldSetObj.getFields().size(), 'All fields in field set should be there as columns.');
    }
    
    @isTest
    static void testCaseToList() {
        Account testAccount = TestDataFactory.createAccounts(1, true, new Map<String,Object>{})[0];
        Case newCase = new Case(Subject = 'Test Case', AccountId = testAccount.Id);
        insert newCase;

        String objectName = 'Case';
        
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.FieldSet> m = sObjType.getDescribe().FieldSets.getMap();
        System.assert(!m.isEmpty(), 'At least One Field Set is required for the object - ' + objectName);
        Schema.FieldSet fieldSetObj = m.values().get(0);
        String fieldSetName = fieldSetObj.Name;
        
        ObjectListView o =  PRFT_CaseListLightning_Controller.getObjectListView(fieldSetName, ObjectName);
        Test.startTest();
        List<List<Object>> caseList = PRFT_CaseListLightning_Controller.caseToList(new List<Case>{newCase}, o.columns, ObjectName);
        Test.stopTest();
        
    }
}