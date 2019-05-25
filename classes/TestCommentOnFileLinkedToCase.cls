@isTest
private class TestCommentOnFileLinkedToCase {
    static testMethod void commentOnFileLinkedToCase(){
        Account testAccount = TestDataFactory.createAccounts(1, true, new Map<String,Object>{})[0];
        Case newCase = new Case(accountId = testAccount.Id);
        insert newCase;
        ContentVersion attachment = new ContentVersion(Title = 'Test Title',
                                                       PathOnClient = 'tempFile',
                                                       VersionData = blob.valueOf('Attachment'));
        insert attachment;
        ContentVersion contentVersion = [SELECT ContentDocumentId FROM ContentVersion where Id = :attachment.Id];
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = contentVersion.ContentDocumentId,
                                                          LinkedEntityId = newCase.Id,
                                                          ShareType = 'I');
        insert cdl;
    }
}