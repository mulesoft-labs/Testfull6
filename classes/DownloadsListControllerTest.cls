/*****************************************************************************
 * Description : Test class for DownloadsListController
 *
 *        
 * Author      : Wade Liu (Perficient)
 * Date        : 05/31/2016
 * Version     : 1.0
 *
 * Version History : 
 * 
 *****************************************************************************/
@isTest
private class DownloadsListControllerTest {
    //private static String WORKSPACE_NAME = 'Studio';
    private static String WORKSPACE_NAME = 'Anypoint Studio';
    private static ContentWorkspace testWorkspace = [SELECT Id FROM ContentWorkspace WHERE Name =:WORKSPACE_NAME LIMIT 1];
    private static Integer size = 5;
    private static String filter = 'Version__c';
    private static String orderSeq = 'DESC';


    static testMethod void getLibraryTitleTest(){
        system.assertEquals(WORKSPACE_NAME, DownloadsListController.getLibraryTitle(testWorkspace.Id));
    }

    static testMethod void getDownloadWrapMethodsTest(){
        Id contentRecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get('Support Center').getRecordTypeId();
        ContentVersion testContentInsert = new ContentVersion();
        testContentInsert.RecordTypeId = contentRecordTypeId;
        testContentInsert.Type__c = 'Document';
        testContentInsert.Title = 'DownloadsListControllerTest';
        testContentInsert.Version__c = '6.0.0';
        testContentInsert.Public__c = true;
        testContentInsert.ContentUrl = 'www.test.com';
        testContentInsert.Release_Date__c = Date.today();
        insert testContentInsert;
        testContentInsert = [SELECT ContentDocumentId FROM ContentVersion where Id = :testContentInsert.Id];
        ContentWorkspaceDoc newWorkspaceDoc = new ContentWorkspaceDoc();
        newWorkspaceDoc.ContentWorkspaceId = testWorkspace.Id;
        newWorkspaceDoc.ContentDocumentId = testContentInsert.ContentDocumentId;
        insert newWorkspaceDoc;
        system.assertEquals('DownloadsListControllerTest', DownloadsListController.getDownloadWraps(testWorkspace.Id, size, filter, orderSeq)[0].Title);
        system.assertEquals('DownloadsListControllerTest', DownloadsListController.getCurrentDownloadWrap(testContentInsert.Id).Title);
    }
}