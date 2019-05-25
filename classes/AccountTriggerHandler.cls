/*
 *@Author: Narasimha
 *@Created Date: 01/21/2015
 *@Desc: Handler for AccountTrigger 
 		 Add/update the Account owner in the Account Team and Opportunity Team
 *
 */


public without sharing class AccountTriggerHandler {
	public void onAfterInsert(map<Id,Account> accountNewMap){
		AccountHelper helperObj = new AccountHelper();
		helperObj.createAccountTeam(accountNewMap);
		
	}
	public void onAfterUpdate(map<Id,Account> accountNewMap,map<Id,Account> accountOldMap){
		AccountHelper helperObj = new AccountHelper();
		helperObj.updateAccountTeam(accountNewMap,accountOldMap);
		helperObj.updateOpportunityTeam(accountNewMap,accountOldMap);
	}	
	
	
}