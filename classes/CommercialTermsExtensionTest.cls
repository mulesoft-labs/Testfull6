@istest

public with sharing class CommercialTermsExtensionTest {
    
    
    private static testMethod void test1(){
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Renewal_Year_1_Uplift__c =5;
        insert q;
        
        Product2 prod = new Product2();
        prod.Name = 'test api product'; 
        prod.Family = 'API';
        insert prod;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,Last_Annual_Committed_Payment__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);
      
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;

        Test.startTest(); 
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest();
        
        
        
    }
    
    private static testMethod void test2(){
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Number_of_Payments__c = 2;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Renewal_Year_1_Uplift__c =5;
        insert q;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,Last_Annual_Committed_Payment__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);

        Test.startTest(); 
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;
        
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        q.Project_Specific_Department__c ='blah';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        com.Save();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest();
        
    }
    
    private static testMethod void test3(){
        
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Renewal_Year_1_Uplift__c =5;
        q.Renewal_Year_2_Uplift__c =5;
        q.Renewal_Year_3_Uplift__c =5;
        q.Renewal_Year_4_Uplift__c =5;
        q.Number_of_Years2__c = 4;
        q.Multi_Year_Annual_Pay_v2__c = true;
        q.Non_Annual_Payments_Schedule__c = true;
        insert q;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,Last_Annual_Committed_Payment__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);
       
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;

        Test.startTest(); 
        pr = com.MultiYearsChanged();
        pr = com.MultiYearsChangedAmount();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest(); 
    }
    
    private static testMethod void test4(){
        
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Renewal_Year_1_Uplift__c =5;
        q.Renewal_Year_2_Uplift__c =5;
        q.Renewal_Year_3_Uplift__c =5;
        q.Renewal_Year_4_Uplift__c =5;
        q.Number_of_Years__c = 6;
        q.Number_of_Years2__c = 4;
        insert q;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,Last_Annual_Committed_Payment__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);
     
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;
        
        Test.startTest(); 
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest(); 
    }
    
    private static testMethod void test5(){
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Number_of_Payments__c = 5;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Multi_Year_Annual_Pay_v2__c = true;
        q.Subsequent_Uplift_Pct_1__c = 5;
        q.Subsequent_Uplift_Pct_2__c = 5;
        q.Subsequent_Uplift_Pct_3__c = 5;
        q.Subsequent_Uplift_Pct_4__c = 5;
        q.Subsequent_Uplift_Pct_5__c = 5;
        
        insert q;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,Last_Annual_Committed_Payment__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Subsequent_Amount_Date_1__c,Subsequent_Amount_Date_2__c,Subsequent_Amount_Date_3__c,Subsequent_Amount_Date_4__c,Subsequent_Amount_Date_5__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);
     
        Test.startTest(); 
        com.refresh();
        com.init();
        com.MultiYearsChangedPct();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;
        
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        q.Project_Specific_Department__c ='blah';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        com.Save();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.MultiYearsChangedPct();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest();
        
    }
    
    private static testMethod void test6(){
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Number_of_Payments__c = 0;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Renewal_Year_1_Uplift__c =5;
        q.Non_Annual_Payments_Schedule__c = true;
        q.Renewal_Price_Fixing_v2__c = true;
        q.Multi_Year_Annual_Pay_v2__c = true;
        q.Non_Annual_Payments_Schedule__c = true;
        q.Marketing_Material_Type__c = null;
        
        
        insert q;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);
        Test.startTest(); 
        com.year1 = 5;
        com.year2 = 5;
        com.year3 = 5;
        com.year4 = 5;
        com.year5 = 5;
        com.year6 = 5;
        com.year7 = 5;
        com.myear1 = 5;
        com.myear2 = 5;
        com.myear3 = 5;
        com.myear4 = 5;
        com.myear5 = 5;
        com.myear6 = 5;
        com.myear7 = 5;
        com.committedYearsOnOrder = 1;
        com.Name = 'sample';
        list<string> sampleString = new list<string>();
        sampleString.add('sample');
        com.SelectedTypes = sampleString;
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;
        
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MupliftChanged();
        pr = com.MultiYearsChanged();
        pr = com.clearRenewalTerms();
        pr = com.clearAnnualTerms();
        pr = com.clearNonAnnualTerms();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        q.Project_Specific_Department__c ='blah';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        com.Save();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest();
        
    } 
    
    private static testMethod void test7(){
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Number_of_Payments__c = 5;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Renewal_Year_1_Uplift__c =1;
        q.Number_of_Years2__c =0;
        q.Subsequent_Amount_Date_1__c = system.Date.today();
        q.Subsequent_Amount_Date_2__c = system.Date.today() + 1;
        q.Subsequent_Amount_Date_3__c = system.Date.today() + 2;
        q.Subsequent_Amount_Date_4__c = system.Date.today() + 3;
        q.Subsequent_Amount_Date_5__c = system.Date.today() + 4 ;
        q.Non_Annual_Payments_Schedule__c = true;
        q.Last_Annual_Committed_Payment__c = 10;
        
        insert q;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,Last_Annual_Committed_Payment__c,Renewal_Year_1_Uplift__c,Renewal_Year_2_Uplift__c,Renewal_Year_3_Uplift__c,Renewal_Year_4_Uplift__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);

        Test.startTest(); 
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
           com.MupliftChanged();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;
        
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        q.Project_Specific_Department__c ='blah';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        com.Save();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.MultiYearsChangedPct();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest();
    }

    private static testMethod void test8(){
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Number_of_Payments__c = 5;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Renewal_Year_1_Uplift__c =1;
        q.Number_of_Years__c = 5;
        q.Number_of_Years2__c =0;
        q.Subsequent_Amount_Date_1__c = system.Date.today();
        q.Subsequent_Amount_Date_2__c = system.Date.today() - 1;
        q.Subsequent_Amount_Date_3__c = system.Date.today() - 2;
        q.Subsequent_Amount_Date_4__c = system.Date.today() - 3;
        q.Subsequent_Amount_Date_5__c = system.Date.today() - 4 ;
        //added
        
        q.Non_Annual_Payments_Schedule__c = true;
           q.Last_Annual_Committed_Payment__c = 10;
        
        insert q;
        
        List<SBQQ__Quote__c> sbqq = [Select SBQQ__PaymentTerms__c,Number_of_Payments__c,Non_Annual_Payments_Schedule__c,Last_Annual_Committed_Payment__c,Renewal_Year_1_Uplift__c,Renewal_Year_2_Uplift__c,Renewal_Year_3_Uplift__c,Renewal_Year_4_Uplift__c,
                                     Clustering_Entitlement_Clarification_v2__c,Custom_Payment_Schedule__c,Renewal_Price_Fixing_v2__c,Marketing_Material_Type__c,
                                     Number_of_Years2__c,Annual_Uplift2__c,Upgrade_Credit_Terms_v2__c,Marketing_Material_Deadline__c,
                                     Credit_Amount__c,Previous_Order_Number__c,Future_Price_Commitment_v2__c,Year_1_Price__c,Multi_Year_Paid_Up_Front_v2__c,
                                     Price_Lock_Pre_Production_Cores__c,Price_Lock_Expiration__c,Multi_Year_Annual_Pay_v2__c,Number_of_Years__c,Price_Lock_Production_Cores__c,
                                     Amount_Payable_On_Execution__c,Valid_Until_Conditions_Services__c,Project_Specific_v2__c,Services_Expiration_Date__c,
                                     Project_Specific_Application__c,Annual_Uplift__c,Project_Specific_Department__c,
                                     Special_Terms__c,Approved_Special_Terms__c From SBQQ__Quote__c Where Id =: a.Id Limit 1];
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);
        /*set values*/
        /* run test*/
        Test.startTest(); 
        com.clearNonAnnualTerms();
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
           com.MupliftChanged();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =5;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;
        
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        
        q.Annual_Uplift__c = .3;
        q.Annual_Uplift2__c = .3;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = null;
        q.Price_Lock_Expiration__c = Date.today();
        q.Previous_Order_Number__c = 'test';
        q.Project_Specific_Department__c ='blah';
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        com.Save();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.MultiYearsChangedPct();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest();
    }
    
    private static testMethod void test9(){
        Set<String> originalvalues = new Set<String>{'Pr','Cs'};
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
        insert o;
        
        Product2 creditProduct = new Product2(Name = 'Credit',
                ProductCode = 'Credit',
                CurrencyIsoCode = 'USD',
                Family = 'Credit',
                Category__c = 'Credit');
        insert creditProduct;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Opportunity2__c = o.id;
        q.Non_Annual_Payments_Schedule__c = true;
        q.Number_of_Payments__c = 6;
        q.Last_Annual_Committed_Payment__c = 10;
        q.Subsequent_Amount_Date_1__c = system.Date.today() - 2;
        q.Subsequent_Amount_Date_2__c = system.Date.today() - 30;
        q.Subsequent_Amount_Date_3__c = system.Date.today() - 60;
        q.Subsequent_Amount_Date_4__c = system.Date.today() - 90;
        q.Subsequent_Amount_Date_5__c = system.Date.today() - 120;
        //added
        q.Subsequent_Amount_Date_6__c = system.Date.today() - 150;
        q.Subsequent_Amount_Date_7__c = system.Date.today() - 180;
        q.Subsequent_Amount_Date_8__c = system.Date.today() - 210;
        q.Subsequent_Amount_Date_9__c = system.Date.today() - 240;
        q.Subsequent_Amount_Date_10__c = system.Date.today() - 270;
        q.Subsequent_Amount_Date_11__c = system.Date.today() - 300;
        q.Subsequent_Amount_Date_12__c = system.Date.today() - 330;
        q.Subsequent_Amount_Date_13__c = system.Date.today() - 360;
        q.Subsequent_Amount_Date_14__c = system.Date.today() - 390;
        q.Subsequent_Amount_Date_15__c = system.Date.today() - 420;
        q.Subsequent_Amount_Date_16__c = system.Date.today() - 450;
        q.Subsequent_Amount_Date_17__c = system.Date.today() - 480;
        q.Subsequent_Amount_Date_18__c = system.Date.today() - 510;
        q.Subsequent_Amount_Date_19__c = system.Date.today() - 540;
        insert q;
        
        ApexPages.StandardController acc = new ApexPages.StandardController(q);
        
        CommercialTermsExtension com = new CommercialTermsExtension(acc);
        PageReference pr= Page.CommercialTermsPage;
        Test.setCurrentPage(pr);

        Test.startTest(); 
        com.init();
        com.NonAnnualChanged();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        
        q.Previous_Order_Number__c = '1';
        q.Year_1_Price__c = 1;
        q.Annual_Uplift2__c = .2;
        q.Annual_Uplift__c = .3;
        q.Number_of_Years__c =2;
        q.Price_Lock_Pre_Production_Cores__c = 2;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = null;
        q.Credit_Amount__c = null;
        q.Amount_Payable_On_Execution__c =1;
        update q;
        
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr=com.SavePaid();
        
        q.Price_Lock_Pre_Production_Cores__c = null;
        q.Price_Lock_Production_Cores__c = 2;
        q.Price_Lock_Expiration__c = Date.today();
        q.Number_of_Years2__c =2;
        q.Number_of_Years__c =2;
        q.Credit_Amount__c = 2;
        q.Amount_Payable_On_Execution__c = null;
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCores();
        pr= com.SaveCredit();
        pr= com.SavePaid();
        
        update q;
        pr = com.MultiYearsChanged();
        pr = com.YearsChanged();
        pr= com.SaveCredit();
        com.Save();
        
        
        com.refresh();
        com.init();
        com.doMath();
        com.doMultiMath();
        com.MultiYearsChangedPct();
        com.Save();
        com.SaveTerms();
        pr = com.SaveProject();
        pr= com.SavePaid();
        com.SaveTerms();
        pr= com.SaveValid();
        pr = com.SaveCores();
        pr = com.SaveMarketing();
        Test.stopTest();
    }
    
}