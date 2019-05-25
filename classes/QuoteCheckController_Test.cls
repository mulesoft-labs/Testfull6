@isTest
public class QuoteCheckController_Test {
    @testSetup static void setup() {
              List<Quote_Check__c> listTriggerController = New List<Quote_Check__c>();
        Quote_Check__c customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Bill To Address';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Bill to Address is incomplete';
        listTriggerController.add(customSetting1);
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Cloud Term';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'A cloud amendment needs to be executed and the MSA object updated';
        listTriggerController.add(customSetting1);
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Direct Deal: Customer Logo';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Quote contains Market Materials Clarification';
        listTriggerController.add(customSetting1);
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Direct Deal: Services Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Account not allowed for Services Products';
        listTriggerController.add(customSetting1);
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Direct Deal: Status Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Agreement Status is Lapsed';
        listTriggerController.add(customSetting1);   
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Direct Deal: Subscription Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Account not allowed for Subscription Products';
        listTriggerController.add(customSetting1);   
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Direct Deal: Training Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Account not allowed for Training Products';
        listTriggerController.add(customSetting1);  
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Distributor End';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'End Customer in the quote does not equal the “Applicable End Customer” on the agreement or the “Applicable End Customer” field is not blank';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC End Customer Address';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'End Customer Address is incomplete';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Invoice To';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Invoice to Address is incomplete';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC MPA Country';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Country of the End Customer is not an Applicable Country marked in the MPA';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC No Agreement';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'No Agreement Found';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Opportunity Sales Channel';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Opportunity Sales Channel is blank';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Opportunity Sales Channel Indirect';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Opportunity Sales Channel needs a Partner Account/ Invoicing Account';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Primary Contact';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Primary Contact is blank';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Resell Deal: Exhibit';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Partner Reseller Exhibit is set to False';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Resell Deal: Software Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Account not allowed for Software Products';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Resell Deal: Status Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Agreement Status is Lapsed';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Resell Deal: Training Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Account not allowed for Training Products';
        listTriggerController.add(customSetting1); 
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Service Check';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = false;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'MPA does not allow the resell of services and the Quote contains services';
        listTriggerController.add(customSetting1);
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Subscription Amount';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Subscription Amount does not match Payment Schedule';
        listTriggerController.add(customSetting1);
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Subscription Amount Credit';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Subscription Amount with Credit does not match Payment Schedule';
        listTriggerController.add(customSetting1);
        customSetting1 = new Quote_Check__c();
        customSetting1.name ='QC Subscription Amount Date';
        customSetting1.isNull__c = false;
        customSetting1.Active__c = true;
        customSetting1.Error__c = true;
        customSetting1.isCompare__c = false;
        customSetting1.isRequired__c = false;
        customSetting1.Error_Message__c = 'Quote containing a subscription must have a start and end date';
        listTriggerController.add(customSetting1);
        insert listTriggerController;      
    }
    
    private static testMethod void testValidateQuoteFields1() {

        
        Account objAccount = new Account(Name = 'Test Account', BillingCity = 'New York', BillingCountry = 'USA', BillingPostalCode='10001',BillingStreet ='77 Geary Street',
                BillingState ='NY');
        insert objAccount;
        List<Product2> lstProduct2 = new List<Product2>{    new Product2(Name = 'TRAINING: Flexible Training Credit Bundle', ProductCode = 'TCFlexBundle', Category__c = 'Training',
                                                                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Premium Platform Support', ProductCode = 'PremPlatSupp', Category__c = 'Subscription',
                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Pre-Production Subscription - Gold (per Core)', ProductCode = 'PremPlatSupp', 
                         Category__c = 'Subscription', Family = 'ESB', CurrencyIsoCode = 'USD')
            };
                insert lstProduct2;
        Id bussinessRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard / New Business').getRecordTypeId();
        Opportunity objOpportunity = new Opportunity(Name='New Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                     Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                     RecordTypeId = bussinessRecordTypeId, AccountId = objAccount.Id);
        insert objOpportunity;
        
        Id MulesoftRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        SBQQ__Quote__c objQuote = new SBQQ__Quote__c(RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = objOpportunity.Id, 
                                                     Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert objQuote;
        
        List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLine;
                    
        /*List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                       SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLine;
                    System.assertEquals(String.valueOf(lstQuoteLine),'asasa');*/
        
        objOpportunity.SBQQ__Contracted__c = true;
        update objOpportunity;
        
        test.startTest();
        Id renewRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Opportunity').getRecordTypeId();
        
        
        
        Contract objContract = new Contract(SBQQ__Opportunity__c = objOpportunity.Id,SBQQ__Quote__c = objQuote.Id, AccountId = objAccount.Id, 
                                            SBQQ__RenewalOpportunityRecordTypeId__c = renewRecordTypeId, SBQQ__RenewalOpportunityStage__c = '0. Sales Qualified Lead');
        insert objContract;
        
        Opportunity renewOpportunity = new Opportunity(Name='ReNew Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                       Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                       RecordTypeId = renewRecordTypeId, AccountId = objAccount.Id, SBQQ__RenewedContract__c = objContract.Id);
        insert renewOpportunity;
        
        SBQQ__Quote__c renweQuote = new SBQQ__Quote__c(Multi_Year_Annual_Pay_v2__c = true,RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = renewOpportunity.Id, 
                                                       Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert renweQuote;
        
        List<SBQQ__QuoteLine__c> lstQuoteLineRenew = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLineRenew;
                    
        /*List<SBQQ__QuoteLine__c> lstQuoteLineRenew = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                       SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLineRenew;*/
        
        Test.setCurrentPage(Page.QuoteCheck);
        QuoteCheckController controller = new QuoteCheckController(new ApexPages.StandardController(renweQuote));
        controller.checkQuote();
        QuoteCheckController.checkQuote(renweQuote.id);
        test.stopTest();
        
    }
    
       private static testMethod void testValidateQuoteFields2() {
        
        Account objAccount = new Account(Name = 'Test Account', BillingCity = 'New York', BillingCountry = 'USA', BillingPostalCode='10001',BillingStreet ='77 Geary Street',
                BillingState ='NY');
        insert objAccount;
        List<Product2> lstProduct2 = new List<Product2>{    new Product2(Name = 'TRAINING: Flexible Training Credit Bundle', ProductCode = 'TCFlexBundle', Category__c = 'Training',
                                                                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Premium Platform Support', ProductCode = 'PremPlatSupp', Category__c = 'Subscription',
                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Pre-Production Subscription - Gold (per Core)', ProductCode = 'PremPlatSupp', 
                         Category__c = 'Subscription', Family = 'ESB', CurrencyIsoCode = 'USD')
            };
                insert lstProduct2;
        Id bussinessRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard / New Business').getRecordTypeId();
        Opportunity objOpportunity = new Opportunity(Sales_Channel__c = 'Distributor',Name='New Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                     Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                     RecordTypeId = bussinessRecordTypeId, AccountId = objAccount.Id);
        insert objOpportunity;
        
        Id MulesoftRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        SBQQ__Quote__c objQuote = new SBQQ__Quote__c(RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = objOpportunity.Id, 
                                                     Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert objQuote;
        
        List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                
        /*List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                       SBQQ__Number__c = 100, Category__c = 'Subscription')
                };*/
                    insert lstQuoteLine;
        
        objOpportunity.SBQQ__Contracted__c = true;
        update objOpportunity;
        
        test.startTest();
        Id renewRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Opportunity').getRecordTypeId();
        
        
        
        Contract objContract = new Contract(SBQQ__Opportunity__c = objOpportunity.Id,SBQQ__Quote__c = objQuote.Id, AccountId = objAccount.Id, 
                                            SBQQ__RenewalOpportunityRecordTypeId__c = renewRecordTypeId, SBQQ__RenewalOpportunityStage__c = '0. Sales Qualified Lead');
        insert objContract;
        
        Opportunity renewOpportunity = new Opportunity(Sales_Channel__c = 'Distributor',Name='ReNew Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                       Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                       RecordTypeId = renewRecordTypeId, AccountId = objAccount.Id, SBQQ__RenewedContract__c = objContract.Id);
        insert renewOpportunity;
        
        SBQQ__Quote__c renweQuote = new SBQQ__Quote__c(Multi_Year_Annual_Pay_v2__c = true,RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = renewOpportunity.Id, 
                                                       Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert renweQuote;
        
        List<SBQQ__QuoteLine__c> lstQuoteLineRenew = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
        /*List<SBQQ__QuoteLine__c> lstQuoteLineRenew = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                       SBQQ__Number__c = 100, Category__c = 'Subscription')
                };*/
                    insert lstQuoteLineRenew;
        
        Test.setCurrentPage(Page.QuoteCheck);
        QuoteCheckController controller = new QuoteCheckController(new ApexPages.StandardController(renweQuote));
        controller.checkQuote();
        QuoteCheckController.checkQuote(renweQuote.id);
        test.stopTest();
        
    }
    
    private static testMethod void testCheckBillingAddress() {

        
        Account objAccount = new Account(Name = 'Test Account', BillingCity = null, BillingCountry = 'USA', BillingPostalCode='10001',BillingStreet ='77 Geary Street',
                BillingState ='NY');
        insert objAccount;
        List<Product2> lstProduct2 = new List<Product2>{    new Product2(Name = 'TRAINING: Flexible Training Credit Bundle', ProductCode = 'TCFlexBundle', Category__c = 'Training',
                                                                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Premium Platform Support', ProductCode = 'PremPlatSupp', Category__c = 'Subscription',
                         Family = 'ESB', CurrencyIsoCode = 'USD'),
            new Product2(Name = 'Pre-Production Subscription - Gold (per Core)', ProductCode = 'PremPlatSupp', 
                         Category__c = 'Subscription', Family = 'ESB', CurrencyIsoCode = 'USD')
            };
                insert lstProduct2;
        Id bussinessRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard / New Business').getRecordTypeId();
        Opportunity objOpportunity = new Opportunity(Name='New Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                     Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                     RecordTypeId = bussinessRecordTypeId, AccountId = objAccount.Id);
        insert objOpportunity;
        
        Id MulesoftRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        SBQQ__Quote__c objQuote = new SBQQ__Quote__c(RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = objOpportunity.Id, 
                                                     Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert objQuote;
        
        List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription', Is_Subscription__c=true)
                };
                    insert lstQuoteLine;
                    
        /*List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = objQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                       SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLine;
                    System.assertEquals(String.valueOf(lstQuoteLine),'asasa');*/
        
        objOpportunity.SBQQ__Contracted__c = true;
        update objOpportunity;
        
        test.startTest();
        Id renewRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Opportunity').getRecordTypeId();
        
        
        
        Contract objContract = new Contract(SBQQ__Opportunity__c = objOpportunity.Id,SBQQ__Quote__c = objQuote.Id, AccountId = objAccount.Id, 
                                            SBQQ__RenewalOpportunityRecordTypeId__c = renewRecordTypeId, SBQQ__RenewalOpportunityStage__c = '0. Sales Qualified Lead');
        insert objContract;
        
        Opportunity renewOpportunity = new Opportunity(Name='ReNew Opportunity', Type='New Bussiness', CurrencyIsoCode='USD', CloseDate=Date.today(),
                                                       Amount=20000, StageName='0. Sales Qualified Lead', forecast__c = 'Commit',
                                                       RecordTypeId = renewRecordTypeId, AccountId = objAccount.Id, SBQQ__RenewedContract__c = objContract.Id);
        insert renewOpportunity;
        
        SBQQ__Quote__c renweQuote = new SBQQ__Quote__c(Multi_Year_Annual_Pay_v2__c = true,RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = renewOpportunity.Id, 
                                                       Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert renweQuote;
        
        List<SBQQ__QuoteLine__c> lstQuoteLineRenew = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLineRenew;
                    
        /*List<SBQQ__QuoteLine__c> lstQuoteLineRenew = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[1].Id,
                                   SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                   SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                   SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                   SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                   SBQQ__Number__c = 100, Category__c = 'Subscription'),
                new SBQQ__QuoteLine__c(SBQQ__Quote__c = renweQuote.Id, SBQQ__Product__c = lstProduct2[2].Id,
                                       SBQQ__ListPrice__c = 1000, SBQQ__PartnerPrice__c = 1000, 
                                       SBQQ__CustomerPrice__c = 1000, SBQQ__NetPrice__c = 1000,
                                       SBQQ__SpecialPrice__c = 1000, SBQQ__RegularPrice__c = 1000,
                                       SBQQ__ProratedListPrice__c = 1000, SBQQ__Quantity__c = 1, 
                                       SBQQ__Number__c = 100, Category__c = 'Subscription')
                };
                    insert lstQuoteLineRenew;*/
        
        Test.setCurrentPage(Page.QuoteCheck);
        QuoteCheckController controller = new QuoteCheckController(new ApexPages.StandardController(renweQuote));
        controller.checkQuote();
        QuoteCheckController.checkQuote(renweQuote.id);
        test.stopTest();
        
    }
    
}