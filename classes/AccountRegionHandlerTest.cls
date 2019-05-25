/*********************************************************************
*
*   File Name: AccountRegionHandlerTest.cls
*
*   File Description: Test class for the AccountRegionHandler
*   class.
*
**********************************************************************
*
*   Date            Author                 Change
*   12/10/14        Rob                    Initial Creation                          
*   08/06/15        Elmar Chen             Add test_AccountBeforeUpdate
*                                          Move code of creating custom setting to a shared method.
*
*********************************************************************/
@isTest
private class AccountRegionHandlerTest 
{
    /**
    *Test Method for AccountRegionHandler
    */
    private static testMethod void accountRegionSubRegionTest() 
    {
        prepareCustomSettings();
         
        Test.startTest();
         
            Account testAccount= new Account();
            testAccount.Name= 'testName'; 
            testAccount.BillingCountry='Aaland';
            //testAccount.Territory__c = 'APAC';
            insert testAccount;
             
            Account testAccount2= new Account();
            testAccount2.Name= 'testName'; 
            testAccount2.BillingState='Alabama';
            testAccount2.BillingCountry='Aaland11';
            //testAccount2.Territory__c = 'NA';
            insert testAccount2;
             
            testAccount.BillingState='Alabama';
            //testAccount.Territory__c = 'NA';
            update testAccount;
            testAccount2.BillingState='Alabama11';
            testAccount2.BillingCountry='Aaland';
            //testAccount2.Territory__c = 'APAC';
            update testAccount2;
                  
        Test.stopTest();         
    }

    @isTest
    private static void test_AccountBeforeUpdate(){
            
            prepareCustomSettings();
            
            List<Account> accounts = new List<Account>{
                new  Account(
                    Name = 'testName1',
                    BillingCountry = 'Aaland'),

                new  Account(
                    Name = 'testName2',
                    BillingCountry = 'Aaland',
                    BillingState = 'Alabama')
                
            };
            insert accounts;

        Test.startTest();    
            accounts[0].BillingCountry = 'Baland';
            accounts[1].BillingState = 'California';
            update accounts;
        Test.stopTest();
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Region__c, Sub_Region__c FROM Account]);

        //System.assertEquals('BACH', accMap.get(accounts[0].Id).Region__c);
        //System.assertEquals('BBB', accMap.get(accounts[0].Id).Sub_Region__c);
        //System.assertEquals('BACH122', accMap.get(accounts[1].Id).Region__c);
        //System.assertEquals('BBB123', accMap.get(accounts[1].Id).Sub_Region__c);

    }

    private static void prepareCustomSettings(){
        List<Account_Region_Rules__c> customsetting = new List<Account_Region_Rules__c>{
            new Account_Region_Rules__c(Key__c = 'Country - Aaland', Name = 'Country - Aaland',Region__c = 'DACH',Sub_Region__c ='GER'),
            new Account_Region_Rules__c(Key__c = 'State - Alabama',Name = 'State - Alabama',Region__c = 'DACH122',Sub_Region__c ='GER123'),
            new Account_Region_Rules__c(Key__c = 'Country - Baland',Name = 'Country - Baland',Region__c = 'BACH',Sub_Region__c ='BBB'),
            new Account_Region_Rules__c(Key__c = 'State - California',Name = 'State - California',Region__c = 'BACH122',Sub_Region__c ='BBB123')
        };
        insert customsetting;
    }
}