@isTest
private class QuoteLineItemTriggerHandlerTest {
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
        /*prod.Base__c = 0;
        prod.Production__c = 0; 
        prod.Pre_Production__c = 0;
        prod.Services__c  = 0;
        prod.Training__c = 0;*/
        insert prod;

        //insert test product to standard price book
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = prod.Id;
        standardPrice.UnitPrice = 10000;
        standardPrice.IsActive = true;
        insert standardPrice;

        Quote testQuote = new Quote();
        testQuote.Name = 'Quote 1';
        testQuote.OpportunityId = Opp.Id;
        testQuote.pricebook2Id = Test.getStandardPricebookId();
        insert testQuote;

    }

    @isTest 
	static void testQuoteLineInsertOnClosingOppFailure() {
        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        Boolean cantCreateQuoteLineOnOpportunityInClosing = false;
        QuoteLineItem testQuoteLine = new QuoteLineItem();        
        testQuoteLine.QuoteId = [Select Id from Quote where name ='Quote 1' limit 1].Id;
        testQuoteLine.Quantity = 1;
        testQuoteLine.UnitPrice = 100;
        PricebookEntry pbe = [select Id from PricebookEntry where isActive = true limit 1];
        testQuoteLine.PriceBookEntryID = pbe.Id;
        try{
        	insert testQuoteLine;
        }
        catch(Exception ex){
        	cantCreateQuoteLineOnOpportunityInClosing = true;
        }
        System.assert(cantCreateQuoteLineOnOpportunityInClosing , 'Should have failed to create a quote line on Opportunity in closing');
	}

	@isTest 
	static void testQuoteLineUpdateOnClosingOppFailure() {

        Boolean cantUpdateQuoteLineOnOpportunityInClosing = false;

        QuoteLineItem testQuoteLine = new QuoteLineItem();        
        testQuoteLine.QuoteId = [Select Id from Quote where name ='Quote 1' limit 1].Id;
        testQuoteLine.Quantity = 1;
        testQuoteLine.UnitPrice = 100;
        PricebookEntry pbe = [select Id from PricebookEntry where isActive = true limit 1];
        testQuoteLine.PriceBookEntryID = pbe.Id;
        insert testQuoteLine;

        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
        	update testQuoteLine;
        }
        catch(Exception ex){
        	cantUpdateQuoteLineOnOpportunityInClosing  = true;
        }
        System.assert(cantUpdateQuoteLineOnOpportunityInClosing , 'Should have failed to update a quote line on Opportunity in closing');
	}

	@isTest 
	static void testQuoteLineDeleteOnClosingOppFailure() {

        Boolean cantDeleteQuoteLineOnOpportunityInClosing = false;

        QuoteLineItem testQuoteLine = new QuoteLineItem();        
        testQuoteLine.QuoteId = [Select Id from Quote where name ='Quote 1' limit 1].Id;
        testQuoteLine.Quantity = 1;
        testQuoteLine.UnitPrice = 100;

        PricebookEntry pbe = [select Id from PricebookEntry where isActive = true limit 1];
        testQuoteLine.PriceBookEntryID = pbe.Id;
        insert testQuoteLine;

        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
        	delete testQuoteLine;
        }
        catch(Exception ex){
        	cantDeleteQuoteLineOnOpportunityInClosing  = true;
        }
        System.assert(cantDeleteQuoteLineOnOpportunityInClosing , 'Should have failed to delete a quote line on Opportunity in closing');
	}	
	
}