@isTest
public with sharing class CMsViewLicenseKeyRedirectCtrlTest {
	
    static testMethod void testViewLicenseKeyWithLicenseKeyReq() {
        CMsTriggerRunCounter.skipAccountTrigger = true;    
      	CMsTriggerRunCounter.skipSubscriptionTrigger = true;
      	CMsTriggerRunCounter.skipQuoteTrigger = true;

 		Account acct = TestDataFactory.createAccounts(1, false, null)[0];
        acct.Status__c = 'Current';
        insert acct;

        Contact con = TestDataFactory.createContacts(1, acct.Id, true, null)[0];
    	Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => acct.Id })[0];        
    	SBQQ__Quote__c qt = TestDataFactory.createQuote(1, true, new Map<String, Object>{ 'SBQQ__Opportunity2__c' => opp.Id, 'SBQQ__PrimaryContact__c' => con.Id  })[0];

        List<Contract> Contracts = TestDataFactory.createContracts(1, true, new Map<String, Object>{'Status'=>'Draft',
                                                                                                    'StartDate' => date.today(),
                                                                                                    'EndDate' => date.today().addyears(1),
                                                                                                    'AccountId' => acct.id,
                                                                                                    'SBQQ__Quote__c' => qt.Id});
		//Create License Key Request        
    	Licence_Key_Request__c lkr = new Licence_Key_Request__c();
        lkr.Request_Status__c = 'Completed';
        lkr.contract__c = Contracts[0].id;
        lkr.Account__c = acct.id;
        lkr.Contact__c = con.Id;
        lkr.Country__c = 'United States';
        lkr.Expiration_Date__c = date.today();
        lkr.Company_Name__c = 'MuleSoft';
        lkr.Contact_Name__c = 'Jose Lopez';
        lkr.Contact_Email_Address__c  = 'Jose.Lopez@mulesoft.com';
        lkr.Generation_Date__c = datetime.now();
        insert lkr;
        
        //Create Temporary Entitlements and History record
    	Temporary_Entitlements__c  tempEnt = new Temporary_Entitlements__c ();
        tempEnt.Opportunity__c = opp.Id;
        tempEnt.Days_Requested__c = 30;
        tempEnt.Start_Date__c = Date.today();
        tempEnt.Business_Justification__c = 'Test';
        tempEnt.Customer_Name__c = con.id;
        insert tempEnt;

        Temporary_Entitlement_History__c tmpEntHistory = new Temporary_Entitlement_History__c();
        tmpEntHistory.Temporary_Entitlements__c = tempEnt.Id;
        tmpEntHistory.Start_Date__c = Date.today();
        tmpEntHistory.Days_Requested__c =30;
		insert tmpEntHistory;
		System.debug(LoggingLevel.ERROR, 'tmpEntHistory --> '+tmpEntHistory);       
		
        CMsViewLicenseKeyRedirectCtrl ctrl = new CMsViewLicenseKeyRedirectCtrl(new ApexPages.StandardController(tmpEntHistory));
		System.debug(LoggingLevel.ERROR, 'ctrl --> '+ctrl);       
        ctrl.url();        
        CMsViewLicenseKeyRedirectCtrl.checkLicenseKeyPermission(tempEnt.Id);

    }   	
}