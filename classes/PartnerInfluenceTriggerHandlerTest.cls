/**
 *@Author: Narasimhja
 *@Created: 02.FEB.2015
 *@Desc: Test class for the PartnerInfluenceTriggerHandler,PartnerInfluenceHelper class.
 *
 */
@isTest
private class PartnerInfluenceTriggerHandlerTest {

	@testSetup
    public static void testSetupInfo()
    {
    	//add user to exempted list
		User userIncontext = utilities.currentUser; 
        Profiles_With_Closing_Opp_Edit_Access__c editAccess = new Profiles_With_Closing_Opp_Edit_Access__c();
        editAccess.name = userIncontext.profile.name;
        editAccess.Profile_Name__c = userIncontext.profile.name;
        insert editAccess;

    	Account newAccount = MuleSoftInf_TestDataUtility.buildAccountRecord();
		newAccount.Type='Distributor';
		insert newAccount;
		
		Opportunity newOpportunity = MuleSoftInf_TestDataUtility.buildOpportunityRecord(newAccount.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 100.00, Date.today(), 'Likely');
		newOpportunity.LeadSource =  OpportunitySettings.sOpptyLeadSource_PartnerReferral;		
		newOpportunity.Type=OpportunitySettings.sType_AddOnBusiness;
		newOpportunity.Add_On_Type__c = OpportunitySettings.sType_AddOnType;	
		newOpportunity.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Opportunity in Closing').id;	
		insert newOpportunity;
    }


    @isTest 
	static void testPartnerInfluenceInsertOnClosingOppFailure() {
        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        Boolean cantCreatePartnerInfluenceOnOpportunityInClosing = false;

        Partner_Influence__c PartnerDetailsObj = new Partner_Influence__c();
		PartnerDetailsObj.Account__c = [Select Id from Account limit 1].Id;
		PartnerDetailsObj.Opportunity__c = [Select Id from Opportunity limit 1].Id;
		PartnerDetailsObj.Sourced__c=true;
		
        
        try{
        	insert PartnerDetailsObj;
        }
        catch(Exception ex){
        	cantCreatePartnerInfluenceOnOpportunityInClosing = true;
        }
        System.assert(cantCreatePartnerInfluenceOnOpportunityInClosing , 'Should have failed to create a partner influence on Opportunity in closing');
	}

	@isTest 
	static void testPartnerInfluenceUpdateOnClosingOppFailure() {       

        Boolean cantUpdatePartnerInfluenceOnOpportunityInClosing = false;

        Partner_Influence__c PartnerDetailsObj = new Partner_Influence__c();
		PartnerDetailsObj.Account__c = [Select Id from Account limit 1].Id;
		PartnerDetailsObj.Opportunity__c = [Select Id from Opportunity limit 1].Id;
		PartnerDetailsObj.Sourced__c=true;
		insert PartnerDetailsObj;
        
        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
        	update PartnerDetailsObj;
        }
        catch(Exception ex){
        	cantUpdatePartnerInfluenceOnOpportunityInClosing = true;
        }
        System.assert(cantUpdatePartnerInfluenceOnOpportunityInClosing , 'Should have failed to update a partner influence on Opportunity in closing');
	}

	@isTest 
	static void testPartnerInfluenceDeleteOnClosingOppFailure() {       

        Boolean cantDeletePartnerInfluenceOnOpportunityInClosing = false;

        Partner_Influence__c PartnerDetailsObj = new Partner_Influence__c();
		PartnerDetailsObj.Account__c = [Select Id from Account limit 1].Id;
		PartnerDetailsObj.Opportunity__c = [Select Id from Opportunity limit 1].Id;
		PartnerDetailsObj.Sourced__c=true;
		insert PartnerDetailsObj;
        
        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
        	delete PartnerDetailsObj;
        }
        catch(Exception ex){
        	cantDeletePartnerInfluenceOnOpportunityInClosing = true;
        }
        System.assert(cantDeletePartnerInfluenceOnOpportunityInClosing , 'Should have failed to delete a partner influence on Opportunity in closing');
	}


	@isTest 
	static void testPartnerInfluenceUpdateOnClosingOpp() {       

        Boolean canUpdatePartnerInfluenceOnOpportunityInClosing = true;

        Partner_Influence__c PartnerDetailsObj = new Partner_Influence__c();
		PartnerDetailsObj.Account__c = [Select Id from Account limit 1].Id;
		PartnerDetailsObj.Opportunity__c = [Select Id from Opportunity limit 1].Id;
		PartnerDetailsObj.Sourced__c=false;
		insert PartnerDetailsObj;  

        try{
        	PartnerDetailsObj.Sourced__c=true;
        	update PartnerDetailsObj;
        }
        catch(Exception ex){
        	canUpdatePartnerInfluenceOnOpportunityInClosing = false;
        }
        System.assert(canUpdatePartnerInfluenceOnOpportunityInClosing , 'Should have not failed to update a partner influence on Opportunity in closing');
	}

	@isTest 
	static void testOppFieldsOnParterInfluenceDML() {
        Account parentAcc = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => parentAcc.Id })[0];        

        Partner_Influence__c PartnerDetailsObj1 = new Partner_Influence__c();
		PartnerDetailsObj1.Account__c = parentAcc.Id;
		PartnerDetailsObj1.Opportunity__c = opp.Id;
		PartnerDetailsObj1.Sourced__c=true;
		PartnerDetailsObj1.Influence__c=true;
		PartnerDetailsObj1.delivery__c=true;
		PartnerDetailsObj1.reseller__c=true;
        insert PartnerDetailsObj1;
        
        //Validate INSERT scenario
        Opportunity oppResult1 = [SELECT SI_Partner_Account_1__c, Org62_Lead_Sales_Partner_Role__c,
                                 		SI_Partner_Account_2__c, App_Partner_Account_1__c
                                 FROM Opportunity WHERE id = :opp.Id][0];
		System.assertEquals(oppResult1.SI_Partner_Account_1__c, PartnerDetailsObj1.Account__c);
 		System.assertEquals(oppResult1.Org62_Lead_Sales_Partner_Role__c, 'Sourced Lead');
 		System.assertEquals(oppResult1.SI_Partner_Account_2__c, PartnerDetailsObj1.Account__c);
 		System.assertEquals(oppResult1.App_Partner_Account_1__c, PartnerDetailsObj1.Account__c);
		
        //Validate UPDATE scenario
        PartnerDetailsObj1.Sourced__c = false;
        PartnerDetailsObj1.Influence__c = false;
        PartnerDetailsObj1.delivery__c = false;
        PartnerDetailsObj1.reseller__c = false;
		update PartnerDetailsObj1;
        
        Opportunity oppResult2 = [SELECT SI_Partner_Account_1__c, Org62_Lead_Sales_Partner_Role__c,
                                 		SI_Partner_Account_2__c, App_Partner_Account_1__c
                                 FROM Opportunity WHERE id = :opp.Id][0];
		System.assertEquals(oppResult2.SI_Partner_Account_1__c, null);
 		System.assertEquals(oppResult2.Org62_Lead_Sales_Partner_Role__c, null);
 		System.assertEquals(oppResult2.SI_Partner_Account_2__c, null);
 		System.assertEquals(oppResult2.App_Partner_Account_1__c, null);
        
        Account childAcc = TestDataFactory.createAccounts(1, false, null)[0];
        childAcc.parentId = parentAcc.Id;
        insert childAcc;

        Partner_Influence__c PartnerDetailsObj2 = new Partner_Influence__c();
        PartnerDetailsObj2.Account__c = childAcc.Id;
		PartnerDetailsObj2.Opportunity__c = opp.Id;
		PartnerDetailsObj2.Sourced__c = true;
        PartnerDetailsObj2.Influence__c = true;
        PartnerDetailsObj2.delivery__c = true;
        PartnerDetailsObj2.reseller__c = true;
        insert PartnerDetailsObj2;

        Opportunity oppResult3 = [SELECT SI_Partner_Account_1__c, Org62_Lead_Sales_Partner_Role__c,
                                 		SI_Partner_Account_2__c, App_Partner_Account_1__c
                                 FROM Opportunity WHERE id = :opp.Id][0];
        System.assertEquals(oppResult3.SI_Partner_Account_1__c, parentAcc.Id);
 		System.assertEquals(oppResult3.Org62_Lead_Sales_Partner_Role__c, 'Sourced Lead');
 		System.assertEquals(oppResult3.SI_Partner_Account_2__c, parentAcc.Id);
 		System.assertEquals(oppResult3.App_Partner_Account_1__c, parentAcc.Id);
        
        delete PartnerDetailsObj2;
        //Validate DELETION Scenario
        Opportunity oppResult4 = [SELECT SI_Partner_Account_1__c, Org62_Lead_Sales_Partner_Role__c,
                                 		SI_Partner_Account_2__c, App_Partner_Account_1__c
                                 FROM Opportunity WHERE id = :opp.Id][0];
		System.assertEquals(oppResult4.SI_Partner_Account_1__c, null);
 		System.assertEquals(oppResult4.Org62_Lead_Sales_Partner_Role__c, null);
 		System.assertEquals(oppResult4.SI_Partner_Account_2__c, null);
 		System.assertEquals(oppResult4.App_Partner_Account_1__c, null);
    }    
}