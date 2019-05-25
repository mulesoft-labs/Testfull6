/*
*@Author: Narasimha
*@Created Date: 01/21/2015
*@Desc: Helper Class for AccountTrigger handler class
Add/update the Account owner in the Account Team and Opportunity Team
*
*
*/

public without sharing class AccountHelper {
    
    public static final String sSALES_Manager_Role =OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_SALES_MGR; //'Sales Manager'
    public static final String sAccount_EXE_Role =OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ACCOUNT_EXE; //'Account Executive'
    public static final String sUSER_Role =OpportunitySettings.sUSER_ROLE_SALES; //'Sales'
    
    
    /*
*	Method:createAccountTeam
*	Desc: Add account Owner(Role contains 'sales') Manager as Sales manager 	
*/
    
    //This is called by: 1) After Insert 2) updateAccountTeam() method
    public void createAccountTeam(map<Id,Account> accountNewMap){
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createAccountTeam ---> ');                
        map<id,Id> mapAccountOwner = new map<id,Id>();
        for(Account acc:accountNewMap.values()){
            mapAccountOwner.put(acc.Id,acc.OwnerId);
        }
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createAccountTeam ---> mapAccountOwner --> '+mapAccountOwner);        
        map<id,User> mapUserObj = getOwnerMap(mapAccountOwner.values());
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createAccountTeam ---> mapUserObj --> '+mapUserObj);        
        map<id,Id> AccountSalesManagerMap = getAccountManager(mapAccountOwner,mapUserObj,AccountHelper.sUSER_Role);
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createAccountTeam ---> AccountSalesManagerMap --> '+AccountSalesManagerMap);                
        list<AccountTeamMember> lstAccTeamMember = createAccountTeamMember(AccountSalesManagerMap,AccountHelper.sSALES_Manager_Role);
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createAccountTeam ---> lstAccTeamMember --> '+lstAccTeamMember);                
        Database.insert(lstAccTeamMember,false);        
    }
    
    /*
*	Method:updateAccountTeam
*	Desc: update current Sales manager with new Owner Manager	
*/
    
    public void updateAccountTeam(map<Id,Account> accountNewMap,map<Id,Account> accountOldMap){
        
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: updateAccountTeam ---> ');        
        map<id,Account> mapAccoountOwnerupdate = new map<id,Account>();
        map<id,Account> mapPrvsAccoountOwner = new map<id,Account>();
        for(id accid:accountNewMap.KeySet()){
            Account accNewobj =accountNewMap.get(accid);
            Account accOldObj =accountOldMap.get(accid);
            if(accNewobj.OwnerId!=accOldObj.OwnerId){
                mapAccoountOwnerupdate.put(accid,accountNewMap.get(accid));
                mapPrvsAccoountOwner.put(accid,accountOldMap.get(accid));
            }
            
        }
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: updateAccountTeam ---> mapAccoountOwnerupdate --> '+mapAccoountOwnerupdate);        
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: updateAccountTeam ---> mapPrvsAccoountOwner --> '+ mapPrvsAccoountOwner);        
        deleteAccountTeam(mapPrvsAccoountOwner);
        createAccountTeam(mapAccoountOwnerupdate);
        
    }
    
    
    /* Method:updateOpportunityTeam
* Desc: Update Current Opportunity Team member(Account Owner) with new Account Owner
*/	
    
    public void updateOpportunityTeam(map<Id,Account> accountNewMap,map<Id,Account> accountOldMap){
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: updateOpportunityTeam ---> ');                        
        map<id,Account> mapAccoountOwnerupdate = new map<id,Account>();
        map<id,Account> mapPrvsAccoountOwner = new map<id,Account>();
        for(id accid:accountNewMap.KeySet()){
            Account accNewobj =accountNewMap.get(accid);
            Account accOldObj =accountOldMap.get(accid);
            if(accNewobj.OwnerId!=accOldObj.OwnerId){
                mapAccoountOwnerupdate.put(accid,accountNewMap.get(accid));
                mapPrvsAccoountOwner.put(accid,accountOldMap.get(accid));
            }
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: updateOpportunityTeam ---> mapAccoountOwnerupdate -->'+mapAccoountOwnerupdate);                        
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: updateOpportunityTeam ---> mapPrvsAccoountOwner --> '+mapPrvsAccoountOwner);                        
        }

        if(mapPrvsAccoountOwner!= null && mapPrvsAccoountOwner.size()>0){
            deleteOpportunityTeam(mapPrvsAccoountOwner);
        }
        if(mapAccoountOwnerupdate!=null && mapAccoountOwnerupdate.size()>0){
            createOpportunityTeam(mapAccoountOwnerupdate);
        }
        
    }
    
    
/*********************************************************************************************************************************************
Helper functions 
****************************************************************************************************************************************/
    public void deleteAccountTeam(map<Id,Account> accountOldMap){
	    System.debug(LoggingLevel.ERROR, 'Inside deleteAccountTeam ---> accountOldMap --> '+ accountOldMap);                        
        
        map<id,Id> mapAccountOwner = new map<id,Id>();
        for(Account acc:accountOldMap.values()){
            mapAccountOwner.put(acc.Id,acc.OwnerId);
        }
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteAccountTeam ---> mapAccountOwner --> '+mapAccountOwner);        
        map<id,User> mapUserObj = getOwnerMap(mapAccountOwner.values());
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteAccountTeam ---> mapUserObj --> '+mapUserObj);        
        map<id,Id> AccountManagerMap = getAccountManager(mapAccountOwner,mapUserObj,AccountHelper.sUSER_Role);
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteAccountTeam ---> AccountManagerMap --> '+AccountManagerMap);        
        list<AccountTeamMember> lstAccTeamMember = getCurrentMgr(AccountHelper.sSALES_Manager_Role, AccountManagerMap);
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteAccountTeam ---> lstAccTeamMember --> '+lstAccTeamMember);        
        Database.delete(lstAccTeamMember,false);
    }
    
    
    public list<AccountTeamMember> getCurrentMgr(string sRole,map<id,Id> AccountManagerMap){
        list<AccountTeamMember> lstdeleteAccTeam = new list<AccountTeamMember>();
        list<AccountTeamMember> lstAccTeamSrMgr =[select Id,AccountId,UserId,TeamMemberRole 
                                                  from AccountTeamMember 
                                                  where AccountId IN:AccountManagerMap.keySet() and TeamMemberRole=:sRole];
        for(AccountTeamMember accteam:lstAccTeamSrMgr){
            if(AccountManagerMap.containsKey(accteam.AccountId) && AccountManagerMap.get(accteam.AccountId)==accteam.UserId){
                lstdeleteAccTeam.add(accteam);
            }
        }
        return lstdeleteAccTeam;
    }
    
    
    
    
    public map<id,Id> getAccountManager(map<Id,Id> accOwnermap,map<id,User> mapUserObj,String sUserRole){
        
        map<id,Id> mapAccountManager = new map<id,Id>();
        for(Id accid:accOwnermap.keySet()){
            if(mapUserObj.containsKey(accOwnermap.get(accid)))
            {
                User userObj = mapUserObj.get(accOwnermap.get(accid));
                if(userObj.UserRole.Name.containsIgnoreCase(sUserRole)){
                    mapAccountManager.put(accid,userObj.ManagerId);
                }
            }
        }
        return mapAccountManager;
    }
    
    public map<Id,User> getOwnerMap(list<id> ownerIdset){
        // modified 12/08/2016 by Tia Xuan for limit exception
        map<id,User> mapUserObj =new map<id,user>();
        if (ownerIdSet.size() > 0){
        	mapUserObj =new map<id,user>([select Id,ManagerId,UserRoleId,UserRole.Name from User 
                                                   where Id IN:ownerIdset
                                                   AND ManagerId!=null 
                                                   AND Manager.isActive=true
                                                   AND UserRoleId!=NULL]);
        }
        return mapUserObj;
    }
    
    public list<AccountTeamMember> createAccountTeamMember(map<id,Id> AccountManagerMap,String sRole){
        
        list<AccountTeamMember> lstAccTeam = new list<AccountTeamMember>();
        for(Id accId:AccountManagerMap.keySet()){
            AccountTeamMember accTeam = new AccountTeamMember(AccountId=accId,UserId=AccountManagerMap.get(accId),TeamMemberRole=sRole);
            lstAccTeam.add(accTeam);
        }
        return lstAccTeam;
    }
    
    public void createOpportunityTeam(map<Id,Account> accountNewMap){
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createOpportunityTeam ---> ');                                        
        list<OpportunityTeamMember> lstOpptyTeamMember = new list<OpportunityTeamMember>();
        list<Opportunity> lstAccountOppty = [select Id,AccountId,Account.OwnerId,IsClosed FROM Opportunity 
                                             WHERE IsClosed=false 
                                             AND AccountId IN:accountNewMap.keySet()];	
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createOpportunityTeam ---> lstAccountOppty --> '+lstAccountOppty);                                        
        for(Opportunity oppty:lstAccountOppty){
            OpportunityTeamMember opptyTeamMemeber = new OpportunityTeamMember(OpportunityId=oppty.id,
                                                                               UserId=oppty.Account.OwnerId,
                                                                               TeamMemberRole=AccountHelper.sAccount_EXE_Role
                                                                              );
            lstOpptyTeamMember.add(opptyTeamMemeber);
        }
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: createOpportunityTeam ---> lstOpptyTeamMember --> '+lstOpptyTeamMember);                                        
        Database.insert(lstOpptyTeamMember,false);
    }
    
    public void deleteOpportunityTeam(map<id,Account> mapOldAccountMap){
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteOpportunityTeam ---> ');                                
        set<Id> setAccountOwnerId = new set<Id>();
        list<OpportunityTeamMember> lstDeleteOpptyTeam = new list<OpportunityTeamMember>();
        for(Account accObj:mapOldAccountMap.values()){
            setAccountOwnerId.add(accObj.OwnerId);
        }	
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteOpportunityTeam ---> setAccountOwnerId --> '+setAccountOwnerId);                                
        
        list<OpportunityTeamMember> lstOpptyTeam = [select Id,
                                                    OpportunityId,
                                                    Opportunity.AccountId,
                                                    Opportunity.Account.OwnerId,
                                                    Opportunity.IsClosed,
                                                    UserId,
                                                    TeamMemberRole
                                                    FROM OpportunityTeamMember
                                                    WHERE Opportunity.IsClosed=false
                                                    AND Opportunity.AccountId IN :mapOldAccountMap.keySet()
                                                    AND UserId IN :setAccountOwnerId
                                                    AND TeamMemberRole =:AccountHelper.sAccount_EXE_Role];
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteOpportunityTeam ---> lstOpptyTeam --> '+lstOpptyTeam);                                        
        for(OpportunityTeamMember opptyTeam:lstOpptyTeam){
            if(mapOldAccountMap.containsKey(opptyTeam.Opportunity.AccountId)){
                Account oldAccount = mapOldAccountMap.get(opptyTeam.Opportunity.AccountId);
                if(oldAccount.OwnerId==opptyTeam.UserId){
                    lstDeleteOpptyTeam.add(opptyTeam);
                }
            }
        }
	    System.debug(LoggingLevel.ERROR, 'Inside AccountHelper class --> Method: deleteOpportunityTeam ---> lstDeleteOpptyTeam --> '+lstDeleteOpptyTeam);                                                
        Database.delete(lstDeleteOpptyTeam,false);
    }
}