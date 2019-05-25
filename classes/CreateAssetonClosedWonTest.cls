/*** 
* Class: CreateAssetonClosedWonTest
* Description: Unit test for trigger CreateAssetonClosedWon
* Author: Elmar Chen
* Create Time: 06/09/2015 14:15:19
*
**********************************************************************
*
*   Date            Author                 Change
*   06/09/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class CreateAssetonClosedWonTest {
    /*** 
    @isTest static void test_CreateAssetonClosedWon() {
        Account acct = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{
                'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
                'CloseDate' => date.Today(),
                'AccountId' => acct.Id
            })[0];
        Product2 p = new Product2(
            Name = 'Product',
            Category__c = 'Subscription'
        );
        insert p;

        PricebookEntry pe = new PricebookEntry(
                UnitPrice = 2,
                CurrencyIsoCode='USD',
                IsActive = true, 
                UseStandardPrice = false,
                Pricebook2Id=Test.getStandardPricebookId(), 
                Product2Id=P.Id
            );
        insert pe;
        List<OpportunityLineItem> items = TestDataFactory.createOpportunityLineItem(2, true, new Map<String, Object>{
                'OpportunityId' => opp.Id,
                'UnitPrice' => 200,
                'Quantity' => 20,
                'PricebookEntryId' => pe.Id,
                'Description' => 'OpportunityLineItem',
                'Converted_to_Asset__c' => false,
                'Max_Number_of_Incidents__c' => 2,
                'Number_of_Contacts__c' => 2,
                'Start_Date__c' => Date.today(),
                'End_Date__c' => Date.today().addDays(10)
                
        });
        
    Test.startTest();
        opp.StageName = 'Closed Won';
        opp.Forecast__c = 'Closed';
        update opp;
    Test.stopTest();
        items = [Select OpportunityId, UnitPrice, Quantity, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, Description, Converted_to_Asset__c,
                                  Max_Number_of_Incidents__c,Number_of_Contacts__c, Start_Date__c, End_Date__c 
                                  From OpportunityLineItem 
                                  where OpportunityId = :opp.Id and Converted_to_Asset__c = true and Category__c = 'Subscription'];
        List<Asset> aa = [SELECT AccountId, Product2Id, Max_Number_of_Incidents__c, Number_of_Contacts__c, Start_Date__c, 
            End_Date__c, Quantity, Price, PurchaseDate, Status, Description, Name FROM Asset WHERE Product2Id=:p.Id];

        OpportunityLineItem ol = items[0];
        System.assertEquals(2, items.size());
        System.assertEquals(2, aa.size());

        for(Asset a : aa){
            System.assertEquals(a.AccountId, opp.AccountId);
            System.assertEquals(a.Product2Id, ol.PricebookEntry.Product2Id);
            System.assertEquals(a.Max_Number_of_Incidents__c, ol.Max_Number_of_Incidents__c);
            System.assertEquals(a.Number_of_Contacts__c, ol.Number_of_Contacts__c);
            System.assertEquals(a.Start_Date__c, ol.Start_Date__c);
            System.assertEquals(a.End_Date__c, ol.End_Date__c); 
            System.assertEquals(a.Quantity, ol.Quantity);
            System.assertEquals(a.Price,  ol.UnitPrice);
            System.assertEquals(a.PurchaseDate, opp.CloseDate);
            System.assertEquals(a.Status, 'Purchased');
            System.assertEquals(a.Description, ol.Description);
            System.assertEquals(a.Name, ol.PricebookEntry.Product2.Name);
        }
    }
    ****/
}