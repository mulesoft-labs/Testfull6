@isTest
private class ContentDocumentLinkTriggerHandler_Test {
    
    @isTest 
    static void testFileWithMissingColumns() {
        Boolean contentDocumentInsertFailed = false;
        
        //create test account
        Account Acc1 = MuleSoftInf_TestDataUtility.buildAccountRecord();
        insert Acc1;

        //insert test enablement Activity
        Id actualEnablementRecordTypeId = [Select Id from RecordType where DeveloperName = 'Actual' and SobjectType = 'Enablement_Activity__c'].Id;
        Enablement_Activity__c enablementActivity = new Enablement_Activity__c();
        enablementActivity.Date_Scheduled__c = Date.Today().adddays(7);
        enablementActivity.Event_Type__c = 'Hack-a-Thons';
        enablementActivity.Partner__c = Acc1.Id;
        enablementActivity.RecordTypeId = actualEnablementRecordTypeId;
        insert enablementActivity;
        
        //create csv document
        ContentVersion v = new ContentVersion();
        v.versionData = Blob.valueOf('test');
        v.title = 'Enablement Activity';
        v.pathOnClient ='/Enablement Activity.csv';
        insert v;
        
        Id contentDocumentId = [Select ContentDocumentId from ContentVersion where ID =: v.Id].ContentDocumentId;
        
        //create content document link
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = enablementActivity.Id;
        cdl.ShareType = 'I';
        
        try{
            insert cdl; 
        }
        catch(Exception ex){
            contentDocumentInsertFailed = true;
        }
        System.assert(contentDocumentInsertFailed, 'File save should have failed');
	}
	
	@isTest 
	static void testSUccessfulFileLoadWithNoContactsINPlace() {
	    //insert test accounts
		Account Acc1 = MuleSoftInf_TestDataUtility.buildAccountRecord();
        insert Acc1;
        
        //insert test enablement Activity
        Id actualEnablementRecordTypeId = [Select Id from RecordType where DeveloperName = 'Actual' and SobjectType = 'Enablement_Activity__c'].Id;
        Enablement_Activity__c enablementActivity = new Enablement_Activity__c();
        enablementActivity.Date_Scheduled__c = Date.Today().adddays(7);
        enablementActivity.Event_Type__c = 'Hack-a-Thons';
        enablementActivity.Partner__c = Acc1.Id;
        enablementActivity.RecordTypeId = actualEnablementRecordTypeId;
        insert enablementActivity;
        

        String sampleCsv = '"First Name", "Last Name", "Email"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test@test1.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test1@test.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test2@test.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test3@test.com"';


        ContentVersion v = new ContentVersion();
        v.versionData = Blob.valueOf(sampleCsv);
        v.title = 'Enablement Activity';
        v.pathOnClient ='/Enablement Activity.csv';
        insert v;
        
        Id contentDocumentId = [Select ContentDocumentId from ContentVersion where ID =: v.Id].ContentDocumentId;
        
        //create content document link
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = enablementActivity.Id;
        cdl.ShareType = 'I';
        insert cdl;
        
        //assert there are four contacts in ACC1
        System.assert([select count() from Contact Where AccountId =: Acc1.Id] == 4);        
        
        //assert there are four Enablment Activity Participans
         System.assert([select count() from Enablement_Activity_Participant__c ] == 4);

	} 
	
	@isTest 
	static void testSUccessfulFileLoadWithContactInPlace() {
	    //insert test accounts
		Account Acc1 = MuleSoftInf_TestDataUtility.buildAccountRecord();
        insert Acc1;
        
        Contact testContact1 = new Contact();
        testContact1.FirstName= 'Test First';
        testContact1.LastName = 'Test Last';
        testContact1.Email = 'test@test1.com';
        testContact1.AccountId = Acc1.Id;

        Contact testContact2 = new Contact();
        testContact2.FirstName= 'Test First2';
        testContact2.LastName = 'Test Last2';
        testContact2.Email = 'test@test1.com';
        testContact2.AccountId = Acc1.Id;
        insert new List<Contact>{testContact1, testContact2};
        
        //insert test enablement Activity Id
        Id actualEnablementRecordTypeId = [Select Id from RecordType where DeveloperName = 'Actual' and SobjectType = 'Enablement_Activity__c'].Id;
        Enablement_Activity__c enablementActivity = new Enablement_Activity__c();
        enablementActivity.Date_Scheduled__c = Date.Today().adddays(7);
        enablementActivity.Event_Type__c = 'Hack-a-Thons';
        enablementActivity.Partner__c = Acc1.Id;
        enablementActivity.RecordTypeId = actualEnablementRecordTypeId;
        insert enablementActivity;
        
         //create activity Participan
        Enablement_Activity_Participant__c participant = new Enablement_Activity_Participant__c();
        participant.Contact__c = testContact1.Id;
        participant.Account__c = Acc1.Id;
        participant.Enablement_Activity__c = enablementActivity.Id;
        insert participant;
        

        String sampleCsv = '"First Name", "Last Name", "Email"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test@test1.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test1@test.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test2@test.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test3@test.com"';


        ContentVersion v = new ContentVersion();
        v.versionData = Blob.valueOf(sampleCsv);
        v.title = 'Enablement Activity';
        v.pathOnClient ='/Enablement Activity.csv';
        insert v;
        
        Id contentDocumentId = [Select ContentDocumentId from ContentVersion where ID =: v.Id].ContentDocumentId;
        
        //create content document link
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = enablementActivity.Id;
        cdl.ShareType = 'I';
        insert cdl;
        
        //assert there are five contacts in ACC1
        System.assert([select count() from Contact Where AccountId =: Acc1.Id] == 5);        
        
        //assert there are four Enablment Activity Participans
         System.assert([select count() from Enablement_Activity_Participant__c ] == 4);

	} 
	

	@isTest 
	static void testFileLoadWithEnablementActivityWithNoAccount() {
	    Boolean contentDocumentInsertFailed = false;
        
	    //insert test accounts
		Account Acc1 = MuleSoftInf_TestDataUtility.buildAccountRecord();
        insert Acc1;
        
        //insert test enablement Activity Id
        Id targetEnablementRecordTypeId = [Select Id from RecordType where DeveloperName = 'Target' and SobjectType = 'Enablement_Activity__c'].Id;
        Enablement_Activity__c enablementActivity = new Enablement_Activity__c();
        enablementActivity.Date_Scheduled__c = Date.Today().adddays(7);
        enablementActivity.Event_Type__c = 'Hack-a-Thons';
        enablementActivity.RecordTypeId = targetEnablementRecordTypeId;
        insert enablementActivity;
        

        String sampleCsv = '"First Name", "Last Name", "Email"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test@test1.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test1@test.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test2@test.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test3@test.com"';


        ContentVersion v = new ContentVersion();
        v.versionData = Blob.valueOf(sampleCsv);
        v.title = 'Enablement Activity';
        v.pathOnClient ='/Enablement Activity.csv';
        insert v;
        
        Id contentDocumentId = [Select ContentDocumentId from ContentVersion where ID =: v.Id].ContentDocumentId;
        
        //create content document link
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = enablementActivity.Id;
        cdl.ShareType = 'I';
        try{
            insert cdl;
        }
        catch(Exception ex){
            contentDocumentInsertFailed = true;
        }
        System.assert(contentDocumentInsertFailed, 'File save should have failed');
	} 

    @isTest 
    static void testFileWithInvalidContactEmail() {
        Boolean contentDocumentInsertFailed = false;
        
        //create test account
        Account Acc1 = MuleSoftInf_TestDataUtility.buildAccountRecord();
        insert Acc1;

        //insert test enablement Activity
        Id actualEnablementRecordTypeId = [Select Id from RecordType where DeveloperName = 'Actual' and SobjectType = 'Enablement_Activity__c'].Id;
        Enablement_Activity__c enablementActivity = new Enablement_Activity__c();
        enablementActivity.Date_Scheduled__c = Date.Today().adddays(7);
        enablementActivity.Event_Type__c = 'Hack-a-Thons';
        enablementActivity.Partner__c = Acc1.Id;
        enablementActivity.RecordTypeId = actualEnablementRecordTypeId;
        insert enablementActivity;

        String sampleCsv = '"First Name", "Last Name", "Email"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test@test1.com"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test1@test"';
        
        //create csv document
        ContentVersion v = new ContentVersion();
        v.versionData = Blob.valueOf(sampleCsv);
        v.title = 'Enablement Activity';
        v.pathOnClient ='/Enablement Activity.csv';
        insert v;
        
        Id contentDocumentId = [Select ContentDocumentId from ContentVersion where ID =: v.Id].ContentDocumentId;
        
        //create content document link
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = enablementActivity.Id;
        cdl.ShareType = 'I';
        insert cdl;

        //assert there is one contacts in ACC1
        System.assert([select count() from Contact Where AccountId =: Acc1.Id] == 1);        
        
        //assert there is one Enablment Activity Participans
        System.assert([select count() from Enablement_Activity_Participant__c ] == 1);

        //assert there is one entry in error log
        System.assert([select count() from Enablement_Participant_Load_Error_Log__c ] == 1);
    }
	
	@isTest 
    static void testFileWithLeadConversion() {
        Boolean contentDocumentInsertFailed = false;
        
        //create test account
        Account Acc1 = MuleSoftInf_TestDataUtility.buildAccountRecord();
        insert Acc1;
        //insert test enablement Activity
        Id actualEnablementRecordTypeId = [Select Id from RecordType where DeveloperName = 'Actual' and SobjectType = 'Enablement_Activity__c'].Id;
        Enablement_Activity__c enablementActivity = new Enablement_Activity__c();
        enablementActivity.Date_Scheduled__c = Date.Today().adddays(7);
        enablementActivity.Event_Type__c = 'Hack-a-Thons';
        enablementActivity.Partner__c = Acc1.Id;
        enablementActivity.RecordTypeId = actualEnablementRecordTypeId;

        insert enablementActivity;

        //create a lead 
        Lead testLead = new Lead();
        testLead.FirstName = 'Test First';
        testLead.LastName = 'Test Last';
        testLead.Email = 'test@test1.com';
        testLead.Company = 'test company';
        insert testLead;

        String sampleCsv = '"First Name", "Last Name", "Email"';
        sampleCsv += '\r\n';
        sampleCsv += '"Test first", "test last", "test@test1.com"';
        
        
        //create csv document
        ContentVersion v = new ContentVersion();
        v.versionData = Blob.valueOf(sampleCsv);
        v.title = 'Enablement Activity';
        v.pathOnClient ='/Enablement Activity.csv';
        insert v;
        
        Id contentDocumentId = [Select ContentDocumentId from ContentVersion where ID =: v.Id].ContentDocumentId;
        
        //create content document link
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = enablementActivity.Id;
        cdl.ShareType = 'I';
        insert cdl;

        //assert there is one contacts in ACC1
        System.assert([select count() from Contact Where AccountId =: Acc1.Id] == 1);       

        //assert lead is converted
        System.assert([Select isConverted from Lead].IsConverted); 

    }
}