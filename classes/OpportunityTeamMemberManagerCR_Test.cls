/**
 *@Author: Narasimhja
 *@Created: 02.FEB.2015
 *@Desc: Test class for the OpportunityTeamMemberManager class. covers Opportunity Enhancements.
 *
 */
@isTest(seeAllData=true)
private class OpportunityTeamMemberManagerCR_Test {

    static testMethod void opportunityTeamMemberManagerUnitTest() {
       		
       	// Create test data
		Account newAccount = MuleSoftInf_TestDataUtility.buildAccountRecord();
		insert newAccount;
		
		Contact newContact = MuleSoftInf_TestDataUtility.buildContactRecord(newAccount.Id, 'Inbound - Email');
		insert newContact;
		
		Opportunity newOpportunity = MuleSoftInf_TestDataUtility.buildOpportunityRecord(newAccount.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 100.00, Date.today(), 'Likely');
		newOpportunity.LeadSource =  OpportunitySettings.sOpptyLeadSource_PartnerReferral;		
		newOpportunity.Type=OpportunitySettings.sType_AddOnBusiness;
		newOpportunity.Add_On_Type__c = OpportunitySettings.sType_AddOnType;
		newOpportunity.Partner_Contact__c = newContact.Id;
		
	
		Test.startTest();

		insert newOpportunity;		
		
		//add Oppty Team member
		OpportunityTeamMember teamObj = MuleSoftInf_TestDataUtility.buildOpportunityTeamMember(UserInfo.getUserId(), newOpportunity.Id, OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_CSM,'test');
		insert teamObj;
		
		Opportunity updateOppy =newOpportunity.clone(true,true,false,false);
		updateOppy.OwnerId=UserInfo.getUserId();
		
		map<id,Opportunity> mapOldOppty = new map<id,Opportunity>{newOpportunity.id=>newOpportunity};
		map<id,Opportunity> mapnewOppty = new map<id,Opportunity>{updateOppy.id=>updateOppy};
		
		OpportunityTeamMemberManager opptyTeamMemberObj = new OpportunityTeamMemberManager();
		opptyTeamMemberObj.createOppTeamMember(mapOldOppty, mapnewOppty, false, true);
    
        Test.stopTest();	
    }
    
    static testMethod void validateLeadPassByTest() {
	    User testUser = [SELECT Id from User where Name = 'Mule Test Services'];  

	    User CSR = [SELECT Id from User where Name like 'Mule Test CS%' LIMIT 1];  
        List<Account> newAccountList = TestDataFactory.createAccounts(1,false,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Manager_new__c'=>CSR.Id,'Account_Classification__c'=>'Strategic'});
        Account newAccount = newAccountList[0];
        insert newAccount;
        Contact newContact = MuleSoftInf_TestDataUtility.buildContactRecord(newAccount.Id, 'Inbound - Email');
        insert newContact;
                
        Opportunity newOpportunity = MuleSoftInf_TestDataUtility.buildOpportunityRecord(newAccount.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 100.00, Date.today(), 'Likely');
        newOpportunity.LeadSource =  OpportunitySettings.sOpptyLeadSource_PartnerReferral;		
        newOpportunity.Type=OpportunitySettings.sType_AddOnBusiness;
        newOpportunity.Add_On_Type__c = OpportunitySettings.sType_AddOnType;
        newOpportunity.Probability = 0.50;
        newOpportunity.Partner_Contact__c = newContact.Id;
        newOpportunity.Lead_Passed_By__c=testUser.Id;
        
        Test.startTest();
        
        insert newOpportunity;	
        Test.stopTest();
        
	    User testUser2 = [SELECT Id from User where Name = 'Mule Test AD'];  
        newOpportunity.Lead_Passed_By__c=testUser2.Id;

        User testUser3 = [SELECT Id from User where Name = 'Mule Test AE'];  
        newOpportunity.Owner = testUser3;
        update newOpportunity;
                
    }
    
    static testMethod void validateEMAddedToOppTeamTest() {        
            List<Account> newAccountList = TestDataFactory.createAccounts(1,false,new  Map<String, Object>{'Name'=>'Test Acc','Account_Classification__c'=>'Strategic'});
            Account newAccount = newAccountList[0];
	        insert newAccountList[0];
            Opportunity newOpportunity = MuleSoftInf_TestDataUtility.buildOpportunityRecord(newAccount.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 100.00, Date.today(), 'Likely');
            newOpportunity.LeadSource =  OpportunitySettings.sOpptyLeadSource_PartnerReferral;		
            newOpportunity.Type=OpportunitySettings.sType_AddOnBusiness;
            newOpportunity.Add_On_Type__c = OpportunitySettings.sType_AddOnType;
            newOpportunity.Probability = 0.50;
        	newOpportunity.Added_EM_to_Team__c = false;
            insert newOpportunity;	
 
			PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true and Product2.Name like '%SERVICES: Consulting (Per Hour)%' limit 1];
        	OpportunityLineItem oli = new OpportunityLineItem(opportunityId = newOpportunity.Id);
        	oli.PriceBookEntryID = pbID.Id;
        	oli.Quantity = 100;
        	oli.UnitPrice = 20000.00;
            Test.startTest();
	        insert oli;        
            Test.stopTest();        
        }    
}