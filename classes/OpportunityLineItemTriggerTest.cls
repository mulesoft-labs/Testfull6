@isTest
private class OpportunityLineItemTriggerTest {
	
	@testSetup
    public static void testSetupInfo()
    {
    	//add user to exempted list
		User userIncontext = utilities.currentUser; 
        Profiles_With_Closing_Opp_Edit_Access__c editAccess = new Profiles_With_Closing_Opp_Edit_Access__c();
        editAccess.name = userIncontext.profile.name;
        editAccess.Profile_Name__c = userIncontext.profile.name;
        insert editAccess;

		Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;

        Opportunity opp = new Opportunity();
        opp.Name='Oppty_test1';
        opp.AccountID = Acc1.ID;
        opp.StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        opp.Type ='New Business';
        opp.CloseDate=System.Today();
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Opportunity in Closing').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';  
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        opp.forecast__c='Commit';
        //opp.Pre_SAL_Type__c = 'Other';
        opp.AE_Connect_Completed__c  = true;
        insert opp;

        //create test product
        Product2 prod = new Product2();
        prod.Name = 'test api product'; 
        prod.Family = 'API';
        insert prod;

        //insert test product to standard price book
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = prod.Id;
        standardPrice.UnitPrice = 10000;
        standardPrice.IsActive = true;
        insert standardPrice;

    }
	
	@isTest 
	static void testOppLineInsertOnClosingOppFailure() {
        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        Boolean cantCreateOppLineOnOpportunityInClosing = false;

        OpportunityLIneItem testOli = new OpportunityLIneItem();        
        testOli.OpportunityId = [Select Id from Opportunity limit 1].Id;
        testOli.Quantity = 1;
        testOli.UnitPrice = 100;
        PricebookEntry pbe = [select Id from PricebookEntry where isActive = true limit 1];
        testOli.PriceBookEntryID = pbe.Id;

        try{
        	insert testOli;
        }
        catch(Exception ex){
        	cantCreateOppLineOnOpportunityInClosing = true;
        }
        System.assert(cantCreateOppLineOnOpportunityInClosing , 'Should have failed to create an Opportunity line on Opportunity in closing');
	}

	@isTest 
	static void testOppLineUpdateOnClosingOppFailure() {

        Boolean cantUpdateOppLineOnOpportunityInClosing = false;

        OpportunityLIneItem testOli = new OpportunityLIneItem();        
        testOli.OpportunityId = [Select Id from Opportunity limit 1].Id;
        testOli.Quantity = 1;
        testOli.UnitPrice = 100;
        PricebookEntry pbe = [select Id from PricebookEntry where isActive = true limit 1];
        testOli.PriceBookEntryID = pbe.Id;        
        insert testOli;

        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
        	update testOli;
        }
        catch(Exception ex){
        	cantUpdateOppLineOnOpportunityInClosing  = true;
        }
        System.assert(cantUpdateOppLineOnOpportunityInClosing , 'Should have failed to update an opportunity line on Opportunity in closing');
	}

	@isTest 
	static void testOppLineDeleteOnClosingOppFailure() {

        Boolean cantDeleteOppLineOnOpportunityInClosing = false;

        OpportunityLIneItem testOli = new OpportunityLIneItem();        
        testOli.OpportunityId = [Select Id from Opportunity  limit 1].Id;
        testOli.Quantity = 1;
        testOli.UnitPrice = 100;
        PricebookEntry pbe = [select Id from PricebookEntry where isActive = true limit 1];
        testOli.PriceBookEntryID = pbe.Id;        
        insert testOli;

        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
        	delete testOli;
        }
        catch(Exception ex){
        	cantDeleteOppLineOnOpportunityInClosing  = true;
        }
        System.assert(cantDeleteOppLineOnOpportunityInClosing , 'Should have failed to delete an opportunity line on Opportunity in closing');
	}	
	
}