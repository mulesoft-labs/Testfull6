@isTest
private class TestNewCaseAttachmentNotification{
    static testMethod void newCaseAttachmentTest(){
        Account testAccount = TestDataFactory.createAccounts(1, true, new Map<String,Object>{})[0];
        Case newCase = (Case)TestDataFactory.createObjects(Case.SObjectType, 1, true, 
        	new Map<String, Object>{
            	'AccountId' =>  testAccount
        })[0];
        Attachment newAttachment = new Attachment(Name = 'Test Attachment',
                                   body = blob.valueOf('Attachment'), parentId = newCase.Id);
        insert newAttachment;
    }
}