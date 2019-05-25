/**
 *@Author: Narasimhja
 *@Created: 02.FEB.2015
 *@Desc: Test class for the AccountTriggerHandler and AccountHelper class.
 *
 */
@isTest
private class AccountTriggerHandlerTest {

    static testMethod void AccountTriggerHandlerUnitTest() {
     
     	AccountTriggerHandler atriggerHandler = new AccountTriggerHandler();
     	
		User uobj = MuleSoftInf_TestDataUtility.buildUser(Label.TestClassRoleName, '2_18 ADR', 'TESTUSEROPPTY21312@TESTUser32432.COM');
		uobj.ManagerId = UserInfo.getUserId();
		
		User uobj2 = MuleSoftInf_TestDataUtility.buildUser(Label.TestClassRoleName, '2_18 ADR', 'TESTUSEROPPTY21323@TESTUser32423.COM');
		uobj2.ManagerId = UserInfo.getUserId();
		
		Account newAccount = MuleSoftInf_TestDataUtility.buildAccountRecord();
		system.runAs(uobj){	
			insert newAccount;	
			Opportunity newOpportunity = MuleSoftInf_TestDataUtility.buildOpportunityRecord(newAccount.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 100.00, Date.today(), 'Likely');
			newOpportunity.LeadSource = OpportunitySettings.sOpptyLeadSource_PartnerReferral;		
			newOpportunity.Type=OpportunitySettings.sType_AddOnBusiness;
			newOpportunity.Add_On_Type__c = OpportunitySettings.sType_AddOnType;
			insert newOpportunity;
			//invloke insert handler on Account
			map<Id,Account> accnewMp = new map<Id,Account>{newAccount.Id=>newAccount};
			atriggerHandler.onAfterInsert(accnewMp);
		}
		system.runAs(uobj2){	
			
			Account updateAccount = newAccount.clone(true,true,false,false);
			updateAccount.OwnerId = uobj2.Id;
			
			map<Id,Account> accOldMp = new map<Id,Account>{newAccount.Id=>newAccount};
			map<Id,Account> accUpdateMp = new map<Id,Account>{updateAccount.Id=>updateAccount};
			//invoke update Handler
			atriggerHandler.onAfterUpdate(accUpdateMp, accOldMp);

		}
		
    }
}