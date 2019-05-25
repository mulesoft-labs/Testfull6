@isTest
public class CMsAddOnModelTest {
    
    @isTest
    static void testAddOnModelFieldUpdates(){
        List<Account> accts = TestDataFactory.createAccounts(1, true, null);   
        ApexPages.standardController stdCon = new ApexPages.standardController(accts[0]);
        ApexPages.currentPage().getParameters().put('Id',accts[0].Id);        
        CMsAddOnModel addOnModel = new CMsAddOnModel(stdCon);
        addOnModel.accounts = accts;
        addOnModel.Save();
        List<Account> accounts = [SELECT Id, Account_Plan__c,Account_Plan_Heat_Map__c FROM Account WHERE Id =:accts[0].Id];        
        System.assertEquals(accounts[0].Account_Plan__c, null);  
        System.assertEquals(accounts[0].Account_Plan_Heat_Map__c, null);    
    }
}