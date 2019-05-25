@isTest
public class TestCopyFieldsFromOrigToRenewalOpp {
	static testMethod void testCopyFieldsFromOrigToRenewalOpp1(){
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingCountry = 'US';
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'TestOpportunity';
        o.AccountId = a.id;
        o.CloseDate = Date.today();
        o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        o.CurrencyIsoCode = 'USD';
        o.Type = 'New Business';
        o.Amount=1000;
        o.NextStep='Discovery Call';
        o.Opportunity_Source__c ='Direct';
        o.Primary_Solution_Interest__c = 'SOA';
        o.Sales_Channel__c = 'Enterprise Direct';
        o.Opportunity_Source__c = 'Direct';
        o.Billing_Contact_Email__c = 'test@gmail.com';
        o.Payment_Terms__c = 'Net 15';
        o.Intacct_Message__c = 'Test Message';
        o.Foreign_Currency__c = 'GBP';
        o.Foreign_Currency_Exchange_Rate__c = 2;
        o.ContractEndDate__c = Date.today();
        o.Renewal_Contact__c = 'Test Contact';
        o.Auto_Renew__c = 'yes';
        o.Renewal_Pricing_Restrictions__c = 'yes';
        o.Renewal_Special_Terms__c = 'N/A';
        o.Multi_Year_Deal__c = 'yes';
        o.If_yes_Year_X_of_Total_Years__c = '1';
        insert o;
        
        Contract c = new Contract();
        c.AccountId = a.Id;
        c.SBQQ__Opportunity__c = o.Id;
        c.EndDate = Date.today();
        insert c;
        
        Opportunity o2 = new Opportunity();
        o2.SBQQ__RenewedContract__c = c.Id;
        o2.SBQQ__Renewal__c = TRUE;
        o2.Name = 'TestOpportunity';
        o2.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        o2.AccountId = a.Id;
        insert o2;
        
        o2 = [SELECT Id,CloseDate,Sales_Channel__c,Opportunity_Source__c,Billing_Contact_Email__c,Primary_Solution_Interest__c,
                                  Payment_Terms__c,Reference_PO__c,Intacct_Message__c,Parent_Opportunity__c,
                                  Foreign_Currency__c,Foreign_Currency_Exchange_Rate__c,Shipping_Address_Override__c,Billing_Address_Override__c,
                                  ContractEndDate__c,Renewal_Contact__c,Auto_Renew__c,Renewal_Pricing_Restrictions__c,
                                  Renewal_Special_Terms__c,Multi_Year_Deal__c,If_yes_Year_X_of_Total_Years__c,Push_to_Intacct__c
                                 FROM Opportunity WHERE Id =: o2.Id];
        System.assertEquals(o2.CloseDate,Date.today().addDays(1));
        System.assert(o2.Opportunity_Source__c =='Direct');
        System.assert(o2.Sales_Channel__c == 'Enterprise Direct');
        System.assert(o2.Renewal_Contact__c == 'Test Contact');
    }
    
    static testMethod void testCopyFieldsFromOrigToRenewalOpp2(){
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingCountry = 'US';
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'TestOpportunity';
        o.AccountId = a.id;
        o.CloseDate = Date.today();
        o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        o.CurrencyIsoCode = 'USD';
        o.Type = 'New Business';
        o.Amount=1000;
        o.NextStep='Discovery Call';
        o.Opportunity_Source__c ='Direct';
        o.Primary_Solution_Interest__c = 'SOA';
        o.Sales_Channel__c = 'Enterprise Direct';
        o.Opportunity_Source__c = 'Direct';
        o.Billing_Contact_Email__c = 'test@gmail.com';
        o.Payment_Terms__c = 'Net 15';
        o.Intacct_Message__c = 'Test Message';
        o.Foreign_Currency__c = 'GBP';
        o.Foreign_Currency_Exchange_Rate__c = 2;
        o.ContractEndDate__c = Date.today();
        o.Renewal_Contact__c = 'Test Contact';
        o.Auto_Renew__c = 'yes';
        o.Renewal_Pricing_Restrictions__c = 'yes';
        o.Renewal_Special_Terms__c = 'N/A';
        o.Multi_Year_Deal__c = 'yes';
        o.If_yes_Year_X_of_Total_Years__c = '1';
        insert o;
        
        Contract c = new Contract();
        c.AccountId = a.Id;
        c.SBQQ__Opportunity__c = o.Id;
        insert c;
        
        Opportunity o2 = new Opportunity();
        o2.SBQQ__RenewedContract__c = c.Id;
        o2.Primary_Solution_Interest__c = 'SOA';
        o2.Name = 'TestOpportunity';
        o2.CloseDate = Date.today();
        o2.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        o2.AccountId = a.Id;
        insert o2;
        
        o2 = [SELECT Id,Sales_Channel__c,Opportunity_Source__c,Billing_Contact_Email__c,
                                  Payment_Terms__c,Reference_PO__c,Intacct_Message__c,Parent_Opportunity__c,
                                  Foreign_Currency__c,Foreign_Currency_Exchange_Rate__c,Shipping_Address_Override__c,Billing_Address_Override__c,
                                  ContractEndDate__c,Renewal_Contact__c,Auto_Renew__c,Renewal_Pricing_Restrictions__c,
                                  Renewal_Special_Terms__c,Multi_Year_Deal__c,If_yes_Year_X_of_Total_Years__c,Push_to_Intacct__c
                                 FROM Opportunity WHERE Id =: o2.Id];
        System.assert(o2.Opportunity_Source__c !='Direct');
    }
}