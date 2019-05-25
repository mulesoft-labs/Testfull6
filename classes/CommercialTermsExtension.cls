public with sharing class CommercialTermsExtension {
    //public  List<SBQQ__Quote__c> sbqq {get;set;}
    public List<SBQQ__Quote__c> sbqq {get;set;}
    public  Id sbqqId {get;set;}
    private final SBQQ__Quote__c acct;
    public  Boolean showYear1 {get;set;}
    public  Boolean showYear2 {get;set;}
    public  Boolean showYear3 {get;set;}
    public  Boolean showYear4 {get;set;}
    public  Boolean showYear5 {get;set;}
    public  Boolean showYear6 {get;set;}
    public  Boolean showYear7 {get;set;}
    public  Boolean showYear8 {get;set;}
    public  Boolean showYear9 {get;set;}
    public  Boolean showYear10 {get;set;}
    public  Boolean showYear11 {get;set;}
    public  Boolean showYear12 {get;set;}
    public  Boolean showYear13 {get;set;}
    public  Boolean showYear14 {get;set;}
    public  Boolean showYear15 {get;set;}
    public  Boolean showYear16 {get;set;}
    public  Boolean showYear17 {get;set;}
    public  Boolean showYear18 {get;set;}
    public  Boolean showYear19 {get;set;}
    public  Boolean mshowYear1 {get;set;}
    public  Boolean mshowYear2 {get;set;}
    public  Boolean mshowYear3 {get;set;}
    public  Boolean mshowYear4 {get;set;}
    public  Boolean mshowYear5 {get;set;}
    public  Boolean mshowYear6 {get;set;}
    public  Boolean mshowYear7 {get;set;}
    public  Boolean mshowYear8 {get;set;}
    public  Boolean mshowYear9 {get;set;}
    public  Boolean mshowYear10 {get;set;}
    public  Boolean mshowYear11 {get;set;}
    public  Boolean mshowYear12 {get;set;}
    public  Boolean mshowYear13 {get;set;}
    public  Boolean mshowYear14 {get;set;}
    public  Boolean mshowYear15 {get;set;}
    public  Boolean mshowYear16 {get;set;}
    public  Boolean mshowYear17 {get;set;}
    public  Boolean mshowYear18 {get;set;}
    public  Boolean mshowYear19 {get;set;}
    public  Boolean showNonAnn1 {get;set;}
    public  Boolean showNonAnn2 {get;set;}
    public  Boolean showNonAnn3 {get;set;}
    public  Boolean showNonAnn4 {get;set;}
    public  Boolean showNonAnn5 {get;set;}
    public  Boolean showNonAnn6 {get;set;}
    public  Boolean showNonAnn7 {get;set;}
    public  Boolean showNonAnn8 {get;set;}
    public  Boolean showNonAnn9 {get;set;}
    public  Boolean showNonAnn10 {get;set;}
    public  Boolean showNonAnn11 {get;set;}
    public  Boolean showNonAnn12 {get;set;}
    public  Boolean showNonAnn13 {get;set;}
    public  Boolean showNonAnn14 {get;set;}
    public  Boolean showNonAnn15 {get;set;}
    public  Boolean showNonAnn16 {get;set;}
    public  Boolean showNonAnn17 {get;set;}
    public  Boolean showNonAnn18 {get;set;}
    public  Boolean showNonAnn19 {get;set;}
    public  Boolean ychanged {get;set;}
    public  Decimal year1 {get;set;}
    public  Decimal year2 {get;set;}
    public  Decimal year3 {get;set;}
    public  Decimal year4 {get;set;}
    public  Decimal year5 {get;set;}
    public  Decimal year6 {get;set;}
    public  Decimal year7 {get;set;}
    public  Decimal myear1 {get;set;}
    public  Decimal myear2 {get;set;}
    public  Decimal myear3 {get;set;}
    public  Decimal myear4 {get;set;}
    public  Decimal myear5 {get;set;}
    public  Decimal myear6 {get;set;}
    public  Decimal myear7 {get;set;}
    public  Double year1price {get;set;}
    public  Decimal totalSubscriptionAmount {get;set;}
    public  Decimal totalSubscriptionAmountCredit {get;set;}
    public  Decimal totalRenewalPrice {get;set;}
    public  Decimal renewalPrice1 {get;set;}
    public  Decimal renewalPrice2 {get;set;}
    public  Decimal renewalPrice3 {get;set;}
    public  Decimal renewalPrice4 {get;set;}
    public  Integer committedYearsOnOrder {get;set;}
    public  Double myear1price {get;set;}
    public  Double myear1price1 {get;set;}
    public  Decimal upliftTemp {get;set;}
    public  Decimal uplift {get;set;}
    public  Decimal upliftMulti {get;set;}
    public  Decimal years {get;set;}
    public List<String> SelectedTypes {get;set;}
    public String Name {get;set;}
    public String serviceExp{ get; set; }
    public String priceLockExpirationDate{ get; set; }
    public String isoCode{ get; set; }
    

    public CommercialTermsExtension(ApexPages.StandardController stdController) {
        showYear1 = false;
        showYear2 = false;
        showYear3 = false;
        showYear4 = false;
        showYear5 = false;
        showYear6 = false;
        showYear7 = false;
        mshowYear1 = false;
        mshowYear2 = false;
        mshowYear3 = false;
        mshowYear4 = false;
        mshowYear5 = false;
        mshowYear6 = false;
        mshowYear7 = false;
        ychanged = false;
        isoCode=null;
        uplift = 0;
        upliftMulti = 0;
        year1price = 0;
        myear1price = 0;
        myear1price1 = 0;
        upliftTemp=0;
        years=0;
        serviceExp = null;
        priceLockExpirationDate=null;
        
        this.acct = (SBQQ__Quote__c)stdController.getRecord();
        System.debug(this.acct +', '+acct.Id );

        sbqq = [Select SBQQ__PaymentTerms__c,
                    CurrencyIsoCode,
                    Clustering_Entitlement_Clarification_v2__c,
                    If_credit_is_this_MY__c,
                    Show_Credit__c,
                    Custom_Payment_Schedule__c,
                    Renewal_Price_Fixing_v2__c,
                    Marketing_Material_Type__c,
                    Number_of_Years2__c,
                    Annual_Uplift2__c,
                    Upgrade_Credit_Terms_v2__c,
                    Marketing_Material_Deadline__c,
                    Marketing_Material_Clarification_v2__c,
                    Credit_Amount__c,
                    Previous_Order_Number__c,
                    Future_Price_Commitment_v2__c,
                    Year_1_Price__c,
                    Multi_Year_Paid_Up_Front_v2__c,
                    Number_of_Payments__c,
                    Non_Annual_Payments_Schedule__c,
                    Subsequent_Amount_Date_1__c,
                    Subsequent_Amount_Date_2__c,
                    Subsequent_Amount_Date_3__c,
                    Subsequent_Amount_Date_4__c,
                    Subsequent_Amount_Date_5__c,
                    Subsequent_Amount_Date_6__c,
                    Subsequent_Amount_Date_7__c,
                    Subsequent_Amount_Date_8__c,
                    Subsequent_Amount_Date_9__c,
                    Subsequent_Amount_Date_10__c,
                    Subsequent_Amount_Date_11__c,
                    Subsequent_Amount_Date_12__c,
                    Subsequent_Amount_Date_13__c,
                    Subsequent_Amount_Date_14__c,
                    Subsequent_Amount_Date_15__c,
                    Subsequent_Amount_Date_16__c,
                    Subsequent_Amount_Date_17__c,
                    Subsequent_Amount_Date_18__c,
                    Subsequent_Amount_Date_19__c,
                    Price_Lock_Pre_Production_Cores__c,
                    Price_Lock_Expiration__c,
                    Price_Lock_API_Manager__c,
                    Multi_Year_Annual_Pay_v2__c,
                    Subsequent_Amount_1__c,
                    Subsequent_Amount_2__c,
                    Subsequent_Amount_3__c,
                    Subsequent_Amount_4__c,
                    Subsequent_Amount_5__c,
                    Subsequent_Amount_6__c,
                    Subsequent_Amount_7__c,
                    Subsequent_Amount_8__c,
                    Subsequent_Amount_9__c,
                    Subsequent_Amount_10__c,
                    Subsequent_Amount_11__c,
                    Subsequent_Amount_12__c,
                    Subsequent_Amount_13__c,
                    Subsequent_Amount_14__c,
                    Subsequent_Amount_15__c,
                    Subsequent_Amount_16__c,
                    Subsequent_Amount_17__c,
                    Subsequent_Amount_18__c,
                    Subsequent_Amount_19__c,
                    Number_of_Years__c,
                    Price_Lock_Production_Cores__c,
                    Subsequent_Uplift_Pct_1__c,
                    Subsequent_Uplift_Pct_2__c,
                    Subsequent_Uplift_Pct_3__c,
                    Subsequent_Uplift_Pct_4__c,
                    Subsequent_Uplift_Pct_5__c,
                    Last_Annual_Committed_Payment__c ,
                    Renewal_Year_1_Uplift__c,
                    Renewal_Year_2_Uplift__c,
                    Committed_Years_on_Order_Form__c,
                    Renewal_Year_3_Uplift__c,
                    Renewal_Year_4_Uplift__c,
                    Amount_Payable_On_Execution__c,
                    Valid_Until_Conditions_Services__c,
                    Project_Specific_v2__c,
                    Services_Expiration_Date__c,
                    Renewal_Year_1_Price__c,
                    Renewal_Year_2_Price__c,
                    Renewal_Year_3_Price__c,
                    Renewal_Year_4_Price__c,
                    Amount_Payable_On_Execution_With_Credit__c,
                    Total_Subscription_Amount__c,
                    Total_Subscription_Amount_Credit__c,
                    Project_Specific_Application__c,
                    Annual_Uplift__c,
                    Project_Specific_Department__c,
                    Special_Terms__c,
                    Approved_Special_Terms__c,
                    SBQQ__StartDate__c
                From SBQQ__Quote__c
                Where Id =: acct.Id
                Limit 1];
        
        if(sbqq[0].CurrencyIsoCode != null)isoCode = sbqq[0].CurrencyIsoCode;
        if(sbqq[0].Amount_Payable_On_Execution__c == null)sbqq[0].Amount_Payable_On_Execution__c=0;
        if(sbqq[0].Year_1_Price__c != null)year1price = sbqq[0].Year_1_Price__c;
        if(sbqq[0].Year_1_Price__c == null)year1price = 0;
        if(sbqq[0].Number_of_Years__c != null)years= sbqq[0].Number_of_Years__c;
        if(sbqq[0].Amount_Payable_On_Execution__c != null)myear1price = sbqq[0].Amount_Payable_On_Execution__c;
        if(sbqq[0].Amount_Payable_On_Execution__c != null)myear1price1 = sbqq[0].Amount_Payable_On_Execution__c;

        if(sbqq[0].Annual_Uplift2__c != null){upliftMulti = sbqq[0].Annual_Uplift2__c;}
            if(sbqq[0].Annual_Uplift__c != null){uplift = sbqq[0].Annual_Uplift__c;}
            if(sbqq[0].Annual_Uplift2__c == null){upliftMulti = 0;}
            if(sbqq[0].Annual_Uplift__c == null){uplift = 0;}
            if(sbqq[0].Number_of_Years2__c == null)sbqq[0].Number_of_Years2__c =0;
            if(sbqq[0].Number_of_Years__c == null)sbqq[0].Number_of_Years__c =0;
        if(sbqq[0].Services_Expiration_Date__c !=null)serviceExp = sbqq[0].Services_Expiration_Date__c.month() +'/'+sbqq[0].Services_Expiration_Date__c.day()+'/'+sbqq[0].Services_Expiration_Date__c.year();
        if(sbqq[0].Price_Lock_Expiration__c !=null)priceLockExpirationDate = sbqq[0].Price_Lock_Expiration__c.month() +'/'+sbqq[0].Price_Lock_Expiration__c.day()+'/'+sbqq[0].Price_Lock_Expiration__c.year();

    }
    public void init(){
        YearsChanged();
        MultiYearsChanged();
        NonAnnualChanged();
    }

    public void refresh(){
       sbqq = [Select SBQQ__PaymentTerms__c,
                    CurrencyIsoCode,
                    Clustering_Entitlement_Clarification_v2__c,
                    If_credit_is_this_MY__c,Show_Credit__c,
                    Custom_Payment_Schedule__c,
                    Renewal_Price_Fixing_v2__c,
                    Marketing_Material_Type__c,
                    Number_of_Years2__c,
                    Annual_Uplift2__c,
                    Upgrade_Credit_Terms_v2__c,
                    Marketing_Material_Deadline__c,
                    Marketing_Material_Clarification_v2__c,
                    Credit_Amount__c,
                    Previous_Order_Number__c,
                    Future_Price_Commitment_v2__c,
                    Year_1_Price__c,
                    Multi_Year_Paid_Up_Front_v2__c,
                    Number_of_Payments__c,
                    Non_Annual_Payments_Schedule__c,
                    Subsequent_Amount_Date_1__c,
                    Subsequent_Amount_Date_2__c,
                    Subsequent_Amount_Date_3__c,
                    Subsequent_Amount_Date_4__c,
                    Subsequent_Amount_Date_5__c,
                    Subsequent_Amount_Date_6__c,
                    Subsequent_Amount_Date_7__c,
                    Subsequent_Amount_Date_8__c,
                    Subsequent_Amount_Date_9__c,
                    Subsequent_Amount_Date_10__c,
                    Subsequent_Amount_Date_11__c,
                    Subsequent_Amount_Date_12__c,
                    Subsequent_Amount_Date_13__c,
                    Subsequent_Amount_Date_14__c,
                    Subsequent_Amount_Date_15__c,
                    Subsequent_Amount_Date_16__c,
                    Subsequent_Amount_Date_17__c,
                    Subsequent_Amount_Date_18__c,
                    Subsequent_Amount_Date_19__c,
                    Price_Lock_Pre_Production_Cores__c,
                    Price_Lock_API_Manager__c,
                    Price_Lock_Expiration__c,
                    Multi_Year_Annual_Pay_v2__c,
                    Subsequent_Amount_1__c, 
                    Subsequent_Amount_2__c,
                    Subsequent_Amount_3__c,
                    Subsequent_Amount_4__c,
                    Subsequent_Amount_5__c,
                    Subsequent_Amount_6__c,
                    Subsequent_Amount_7__c,
                    Subsequent_Amount_8__c,
                    Subsequent_Amount_9__c,
                    Subsequent_Amount_10__c,
                    Subsequent_Amount_11__c,
                    Subsequent_Amount_12__c,
                    Subsequent_Amount_13__c,
                    Subsequent_Amount_14__c,
                    Subsequent_Amount_15__c,
                    Subsequent_Amount_16__c,
                    Subsequent_Amount_17__c,
                    Subsequent_Amount_18__c,
                    Subsequent_Amount_19__c,
                    Number_of_Years__c,
                    Price_Lock_Production_Cores__c,
                    Subsequent_Uplift_Pct_1__c,
                    Subsequent_Uplift_Pct_2__c,
                    Subsequent_Uplift_Pct_3__c,
                    Subsequent_Uplift_Pct_4__c,
                    Subsequent_Uplift_Pct_5__c,
                    Last_Annual_Committed_Payment__c,
                    Renewal_Year_1_Uplift__c,
                    Renewal_Year_2_Uplift__c,
                    Committed_Years_on_Order_Form__c,
                    Renewal_Year_3_Uplift__c,
                    Renewal_Year_4_Uplift__c,
                    Amount_Payable_On_Execution__c,
                    Valid_Until_Conditions_Services__c,
                    Project_Specific_v2__c,
                    Services_Expiration_Date__c,
                    Renewal_Year_1_Price__c,
                    Renewal_Year_2_Price__c,
                    Renewal_Year_3_Price__c,
                    Renewal_Year_4_Price__c,
                    Amount_Payable_On_Execution_With_Credit__c,
                    Total_Subscription_Amount__c,
                    Total_Subscription_Amount_Credit__c,
                    Project_Specific_Application__c,
                    Annual_Uplift__c,
                    Project_Specific_Department__c,
                    Special_Terms__c,
                    Approved_Special_Terms__c,
                    SBQQ__StartDate__c
            From SBQQ__Quote__c
            Where Id =: acct.Id 
            Limit 1];

    }

public PageReference upliftChanged(){
        PageReference pr = YearsChanged();
        return pr;
    }
    public PageReference YearsChanged(){
        if(uplift==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Uplift % is Required'));
             return null;
        }
        if(sbqq[0].Number_of_Years2__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Number of Years is Required'));
             return null;
        }
        
        showYear1 = false;
        showYear2 = false;
        showYear3 = false;
        showYear4 = false;
        ychanged = false;
         system.debug(sbqq[0].Number_of_Years2__c);
        if(sbqq.size() == 1){
            if(sbqq[0].Number_of_Years2__c >= 1) showYear1 = true;
            if(sbqq[0].Number_of_Years2__c >= 2) showYear2 = true;
            if(sbqq[0].Number_of_Years2__c >= 3) showYear3 = true;
            if(sbqq[0].Number_of_Years2__c >= 4) showYear4 = true;
            //added
            if(sbqq[0].Number_of_Years2__c >= 5) showYear5 = true;
            if(sbqq[0].Number_of_Years2__c >= 6) showYear6 = true;
            if(sbqq[0].Number_of_Years2__c >= 7) showYear7 = true;
            if(sbqq[0].Number_of_Years2__c >= 8) showYear8 = true;
            if(sbqq[0].Number_of_Years2__c >= 9) showYear9 = true;
            if(sbqq[0].Number_of_Years2__c >= 10) showYear10 = true;
            if(sbqq[0].Number_of_Years2__c >= 11) showYear11 = true;
            if(sbqq[0].Number_of_Years2__c >= 12) showYear12 = true;
            if(sbqq[0].Number_of_Years2__c >= 13) showYear13 = true;
            if(sbqq[0].Number_of_Years2__c >= 14) showYear14 = true;
            if(sbqq[0].Number_of_Years2__c >= 15) showYear15 = true;
            if(sbqq[0].Number_of_Years2__c >= 16) showYear16 = true;
            if(sbqq[0].Number_of_Years2__c >= 17) showYear17 = true;
            if(sbqq[0].Number_of_Years2__c >= 18) showYear18 = true;
            if(sbqq[0].Number_of_Years2__c >= 19) showYear19 = true;

            doMath();
        }
        ychanged = true;
         return null;
    }

    public PageReference MupliftChanged(){
        PageReference pr = MultiYearsChanged();
       return pr;
    }
    public PageReference MultiYearsChanged(){

        if(upliftMulti==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Annual Uplift % is Required'));
             return null;
        }
        system.debug(upliftMulti);
        if(myear1price == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Year 1 Price is Required'));
             return null;
        }
        if(sbqq[0].Number_of_Years__c > 5){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The maximum allowable number of years should be 5'));
             return null;
        }
        
        mshowYear1 = false;
        mshowYear2 = false;
        mshowYear3 = false;
        mshowYear4 = false;
        ychanged = false;
        if(sbqq.size() == 1){
            if(sbqq[0].Number_of_Years__c > 1) mshowYear1 = true;
            if(sbqq[0].Number_of_Years__c > 2) mshowYear2 = true;
            if(sbqq[0].Number_of_Years__c > 3) mshowYear3 = true;
            if(sbqq[0].Number_of_Years__c > 4) mshowYear4 = true;
            
            if(sbqq[0].Multi_Year_Annual_Pay_v2__c)
            doMultiMath();
        }
        ychanged = true;
        system.debug(upliftMulti);
         return null;
    }

    public void doMath(){/*
        upliftTemp = uplift;
        if(upliftTemp>=1.00){upliftTemp= upliftTemp * .01;}
        year1 = year1price;
        year2 = year1price * (1+ upliftTemp);
        year2 = year2.setScale(2);
        year3 = year1price * ((1+ upliftTemp).pow(2));
        year3 = year3.setScale(2);
        year4 = year1price * ((1+ upliftTemp).pow(3));
        year4 = year4.setScale(2);
        year5 = year1price * ((1+ upliftTemp).pow(4));
        year5 = year5.setScale(2);
        year6 = year1price * ((1+ upliftTemp).pow(5));
        year6 = year6.setScale(2);
        year7 = year1price * ((1+ upliftTemp).pow(6));
        year7 = year7.setScale(2);
        sbqq[0].Annual_Uplift__c = uplift ;
        sbqq[0].Year_1_Price__c = year1price;
        update sbqq;*/
        
        if(!showYear1){
            sbqq[0].Renewal_Year_1_Uplift__c = 0;
        } 
        if(!showYear2){
            sbqq[0].Renewal_Year_2_Uplift__c = 0;
        } 
        if(!showYear3){
            sbqq[0].Renewal_Year_3_Uplift__c = 0;
        } 
        if(!showYear4){
            sbqq[0].Renewal_Year_4_Uplift__c = 0;
        }
        
    
        renewalPrice1 = 0.00;
        renewalPrice2 = 0.00;
        renewalPrice3 = 0.00;
        renewalPrice4 = 0.00;
        
       if(sbqq[0].Last_Annual_Committed_Payment__c != null){
        if(sbqq[0].Renewal_Year_1_Uplift__c != null){
            renewalPrice1 =  ((sbqq[0].Renewal_Year_1_Uplift__c/100) *  sbqq[0].Last_Annual_Committed_Payment__c) + sbqq[0].Last_Annual_Committed_Payment__c;
        }
        if(sbqq[0].Renewal_Year_2_Uplift__c != null){
            renewalPrice2  = ((sbqq[0].Renewal_Year_2_Uplift__c/100) *  renewalPrice1) + renewalPrice1;
        }
        if(sbqq[0].Renewal_Year_3_Uplift__c != null){
            renewalPrice3  = ((sbqq[0].Renewal_Year_3_Uplift__c/100) *  renewalPrice2) + renewalPrice2;
        }
        if(sbqq[0].Renewal_Year_4_Uplift__c != null){
            renewalPrice4  = ((sbqq[0].Renewal_Year_4_Uplift__c/100) *  renewalPrice3) + renewalPrice3;
        }
       }
       
       totalRenewalPrice = renewalPrice1 + renewalPrice2+renewalPrice3+renewalPrice4;
    }
    public void doMultiMath(){
        
        if(!mshowYear1){
            sbqq[0].Subsequent_Amount_1__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_1__c = null ;
        } 
        
        if(!mshowYear2){
            sbqq[0].Subsequent_Amount_2__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_2__c = null ;
        } 
        
        if(!mshowYear3){
            sbqq[0].Subsequent_Amount_3__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_3__c = null ;
        } 
        
        if(!mshowYear4){
            sbqq[0].Subsequent_Amount_4__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_4__c = null ;
        } 
        
        if(!mshowYear5){
            sbqq[0].Subsequent_Amount_5__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_5__c = null ;
        }
        
        if(sbqq[0].Subsequent_Amount_1__c== null)
        sbqq[0].Subsequent_Amount_1__c = 0;
        if(sbqq[0].Subsequent_Amount_2__c== null)
        sbqq[0].Subsequent_Amount_2__c= 0;
        if(sbqq[0].Subsequent_Amount_3__c== null)
        sbqq[0].Subsequent_Amount_3__c= 0;
        if(sbqq[0].Subsequent_Amount_4__c== null)
        sbqq[0].Subsequent_Amount_4__c= 0;
        if(sbqq[0].Subsequent_Amount_5__c== null)
        sbqq[0].Subsequent_Amount_5__c= 0;
        
        if(sbqq[0].Amount_Payable_on_Execution__c == null)
        sbqq[0].Amount_Payable_on_Execution__c = 0;
        if(sbqq[0].Credit_Amount__c== null)
        sbqq[0].Credit_Amount__c= 0;
       
        if(sbqq[0].Subsequent_Amount_1__c != 0 && (sbqq[0].Subsequent_Uplift_Pct_1__c == null || sbqq[0].Subsequent_Uplift_Pct_1__c == 0 ) ){
        sbqq[0].Subsequent_Uplift_Pct_1__c = ((sbqq[0].Subsequent_Amount_1__c - sbqq[0].Amount_Payable_on_Execution__c) /  sbqq[0].Amount_Payable_on_Execution__c)*100; 
        }
        if((sbqq[0].Subsequent_Amount_1__c == 0 || sbqq[0].Subsequent_Amount_1__c == null) && sbqq[0].Subsequent_Uplift_Pct_1__c != null ){
        sbqq[0].Subsequent_Amount_1__c  = ((sbqq[0].Subsequent_Uplift_Pct_1__c/100) *  sbqq[0].Amount_Payable_on_Execution__c) + sbqq[0].Amount_Payable_on_Execution__c;
        }
        if(sbqq[0].Subsequent_Amount_2__c != 0 && (sbqq[0].Subsequent_Uplift_Pct_2__c == null || sbqq[0].Subsequent_Uplift_Pct_2__c == 0 ) ){
        sbqq[0].Subsequent_Uplift_Pct_2__c = ((sbqq[0].Subsequent_Amount_2__c - sbqq[0].Subsequent_Amount_1__c) /  sbqq[0].Subsequent_Amount_1__c)*100; 
        }
        if((sbqq[0].Subsequent_Amount_2__c == 0 || sbqq[0].Subsequent_Amount_2__c == null) && sbqq[0].Subsequent_Uplift_Pct_2__c != null ){
        sbqq[0].Subsequent_Amount_2__c  = ((sbqq[0].Subsequent_Uplift_Pct_2__c/100) *  sbqq[0].Subsequent_Amount_1__c) + sbqq[0].Subsequent_Amount_1__c;
        }
        if(sbqq[0].Subsequent_Amount_3__c != 0 && (sbqq[0].Subsequent_Uplift_Pct_3__c == null || sbqq[0].Subsequent_Uplift_Pct_3__c == 0 ) ){
        sbqq[0].Subsequent_Uplift_Pct_3__c = ((sbqq[0].Subsequent_Amount_3__c - sbqq[0].Subsequent_Amount_2__c) /  sbqq[0].Subsequent_Amount_2__c)*100; 
        }
        if((sbqq[0].Subsequent_Amount_3__c == 0 || sbqq[0].Subsequent_Amount_3__c == null) && sbqq[0].Subsequent_Uplift_Pct_3__c != null ){
        sbqq[0].Subsequent_Amount_3__c  = ((sbqq[0].Subsequent_Uplift_Pct_3__c/100) *  sbqq[0].Subsequent_Amount_2__c) + sbqq[0].Subsequent_Amount_2__c;
        }
        if(sbqq[0].Subsequent_Amount_4__c != 0 && (sbqq[0].Subsequent_Uplift_Pct_4__c == null || sbqq[0].Subsequent_Uplift_Pct_4__c == 0 ) ){
        sbqq[0].Subsequent_Uplift_Pct_4__c = ((sbqq[0].Subsequent_Amount_4__c - sbqq[0].Subsequent_Amount_3__c) /  sbqq[0].Subsequent_Amount_3__c)*100; 
        }
        if((sbqq[0].Subsequent_Amount_4__c == 0 || sbqq[0].Subsequent_Amount_4__c == null) && sbqq[0].Subsequent_Uplift_Pct_4__c != null ){
        sbqq[0].Subsequent_Amount_4__c  = ((sbqq[0].Subsequent_Uplift_Pct_4__c/100) *  sbqq[0].Subsequent_Amount_3__c) + sbqq[0].Subsequent_Amount_3__c;
        }
        if(sbqq[0].Subsequent_Amount_5__c != 0 && (sbqq[0].Subsequent_Uplift_Pct_5__c == null || sbqq[0].Subsequent_Uplift_Pct_5__c == 0 ) ){
        sbqq[0].Subsequent_Uplift_Pct_5__c = ((sbqq[0].Subsequent_Amount_5__c - sbqq[0].Subsequent_Amount_4__c) /  sbqq[0].Subsequent_Amount_4__c)*100; 
        }
        if((sbqq[0].Subsequent_Amount_5__c == 0 || sbqq[0].Subsequent_Amount_5__c == null) && sbqq[0].Subsequent_Uplift_Pct_5__c != null ){
        sbqq[0].Subsequent_Amount_5__c  = ((sbqq[0].Subsequent_Uplift_Pct_5__c/100) *  sbqq[0].Subsequent_Amount_4__c) + sbqq[0].Subsequent_Amount_4__c;
        }
        
        
        totalSubscriptionAmount = sbqq[0].Amount_Payable_on_Execution__c +sbqq[0].Subsequent_Amount_1__c + sbqq[0].Subsequent_Amount_2__c + sbqq[0].Subsequent_Amount_3__c + sbqq[0].Subsequent_Amount_4__c + sbqq[0].Subsequent_Amount_5__c.setScale(2);
        totalSubscriptionAmount = totalSubscriptionAmount.setScale(2);
        totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        //Sandra's request totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        totalSubscriptionAmountCredit = totalSubscriptionAmountCredit.setScale(2);
        //update sbqq;
        
    }
   public PageReference MultiYearsChangedAmount(){
        if(sbqq[0].Number_of_Years2__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Number of Years is Required'));
             return null;
        }
        if(sbqq[0].Amount_Payable_on_Execution__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Initial Fee is Required'));
             return null;
        }
        
        mshowYear1 = false;
        mshowYear2 = false;
        mshowYear3 = false;
        mshowYear4 = false;
        mshowYear5 = false;
        mshowYear6 = false;
        mshowYear7 = false; 
        ychanged = false;
        if(sbqq.size() == 1){
            if(sbqq[0].Number_of_Years__c > 1) mshowYear1 = true;
            if(sbqq[0].Number_of_Years__c > 2) mshowYear2 = true;
            if(sbqq[0].Number_of_Years__c > 3) mshowYear3 = true;
            if(sbqq[0].Number_of_Years__c > 4) mshowYear4 = true;
            if(sbqq[0].Number_of_Years__c > 5) mshowYear5 = true;
            if(sbqq[0].Number_of_Years__c > 6) mshowYear6 = true;

            doMultiMathAmount();
        }
        ychanged = true;
        system.debug(upliftMulti);
         return null;
    }
    
    public void doMultiMathAmount(){
        if(sbqq[0].Subsequent_Amount_1__c== null)
        sbqq[0].Subsequent_Amount_1__c = 0;
        if(sbqq[0].Subsequent_Amount_2__c== null)
        sbqq[0].Subsequent_Amount_2__c= 0;
        if(sbqq[0].Subsequent_Amount_3__c== null)
        sbqq[0].Subsequent_Amount_3__c= 0;
        if(sbqq[0].Subsequent_Amount_4__c== null)
        sbqq[0].Subsequent_Amount_4__c= 0;
        if(sbqq[0].Subsequent_Amount_5__c== null)
        sbqq[0].Subsequent_Amount_5__c= 0;
        if(sbqq[0].Amount_Payable_on_Execution__c == null)
        sbqq[0].Amount_Payable_on_Execution__c = 0;
        if(sbqq[0].Credit_Amount__c== null)
        sbqq[0].Credit_Amount__c= 0;
        
        if(sbqq[0].Subsequent_Amount_1__c != 0 && sbqq[0].Amount_Payable_on_Execution__c != 0 ){
        sbqq[0].Subsequent_Uplift_Pct_1__c = ((sbqq[0].Subsequent_Amount_1__c - sbqq[0].Amount_Payable_on_Execution__c) /  sbqq[0].Amount_Payable_on_Execution__c)*100; 
        }
        
        if(sbqq[0].Subsequent_Amount_2__c != 0 && sbqq[0].Subsequent_Amount_1__c != 0){
        sbqq[0].Subsequent_Uplift_Pct_2__c = ((sbqq[0].Subsequent_Amount_2__c - sbqq[0].Subsequent_Amount_1__c) /  sbqq[0].Subsequent_Amount_1__c)*100; 
        }
       
        if(sbqq[0].Subsequent_Amount_3__c != 0 && sbqq[0].Subsequent_Amount_2__c != 0){
        sbqq[0].Subsequent_Uplift_Pct_3__c = ((sbqq[0].Subsequent_Amount_3__c - sbqq[0].Subsequent_Amount_2__c) /  sbqq[0].Subsequent_Amount_2__c)*100; 
        }
       
        if(sbqq[0].Subsequent_Amount_4__c != 0 && sbqq[0].Subsequent_Amount_3__c != 0){
        sbqq[0].Subsequent_Uplift_Pct_4__c = ((sbqq[0].Subsequent_Amount_4__c - sbqq[0].Subsequent_Amount_3__c) /  sbqq[0].Subsequent_Amount_3__c)*100; 
        }
        
        if(sbqq[0].Subsequent_Amount_5__c != 0 && sbqq[0].Subsequent_Amount_4__c != 0){
        sbqq[0].Subsequent_Uplift_Pct_5__c = ((sbqq[0].Subsequent_Amount_5__c - sbqq[0].Subsequent_Amount_4__c) /  sbqq[0].Subsequent_Amount_4__c)*100; 
        }
        
        totalSubscriptionAmount = sbqq[0].Amount_Payable_on_Execution__c +sbqq[0].Subsequent_Amount_1__c + sbqq[0].Subsequent_Amount_2__c + sbqq[0].Subsequent_Amount_3__c + sbqq[0].Subsequent_Amount_4__c + sbqq[0].Subsequent_Amount_5__c.setScale(2);
        totalSubscriptionAmount = totalSubscriptionAmount.setScale(2);
        totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        //Sandra's request totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        totalSubscriptionAmountCredit = totalSubscriptionAmountCredit.setScale(2);
        //update sbqq;
        
    }
    
    public PageReference MultiYearsChangedPct(){
        if(sbqq[0].Number_of_Years2__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Number of Years is Required'));
             return null;
        }
        if(sbqq[0].Amount_Payable_on_Execution__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Initial Fee is Required'));
             return null;
        }
        
        mshowYear1 = false;
        mshowYear2 = false;
        mshowYear3 = false;
        mshowYear4 = false;
        mshowYear5 = false;
        mshowYear6 = false;
        mshowYear7 = false; 
        ychanged = false;
        if(sbqq.size() == 1){
            if(sbqq[0].Number_of_Years__c > 1) mshowYear1 = true;
            if(sbqq[0].Number_of_Years__c > 2) mshowYear2 = true;
            if(sbqq[0].Number_of_Years__c > 3) mshowYear3 = true;
            if(sbqq[0].Number_of_Years__c > 4) mshowYear4 = true;
            if(sbqq[0].Number_of_Years__c > 5) mshowYear5 = true;
            if(sbqq[0].Number_of_Years__c > 6) mshowYear6 = true;

            doMultiMathPct();
        }
        ychanged = true;
        system.debug(upliftMulti);
         return null;
    }
    
    public void doMultiMathPct(){
        
        if(sbqq[0].Credit_Amount__c== null)
        sbqq[0].Credit_Amount__c= 0;

        if(sbqq[0].Subsequent_Uplift_Pct_1__c != null){
        sbqq[0].Subsequent_Amount_1__c  = ((sbqq[0].Subsequent_Uplift_Pct_1__c/100) *  sbqq[0].Amount_Payable_on_Execution__c) + sbqq[0].Amount_Payable_on_Execution__c;
        }
        if(sbqq[0].Subsequent_Uplift_Pct_2__c != null){
        sbqq[0].Subsequent_Amount_2__c  = ((sbqq[0].Subsequent_Uplift_Pct_2__c/100) *  sbqq[0].Subsequent_Amount_1__c) + sbqq[0].Subsequent_Amount_1__c;
        }
        if(sbqq[0].Subsequent_Uplift_Pct_3__c != null){
        sbqq[0].Subsequent_Amount_3__c  = ((sbqq[0].Subsequent_Uplift_Pct_3__c/100) *  sbqq[0].Subsequent_Amount_2__c) + sbqq[0].Subsequent_Amount_2__c;
        }
        if(sbqq[0].Subsequent_Uplift_Pct_4__c != null){
        sbqq[0].Subsequent_Amount_4__c  = ((sbqq[0].Subsequent_Uplift_Pct_4__c/100) *  sbqq[0].Subsequent_Amount_3__c) + sbqq[0].Subsequent_Amount_3__c;
        }
        if(sbqq[0].Subsequent_Uplift_Pct_5__c != null){
        sbqq[0].Subsequent_Amount_5__c  = ((sbqq[0].Subsequent_Uplift_Pct_5__c/100) *  sbqq[0].Subsequent_Amount_4__c) + sbqq[0].Subsequent_Amount_4__c;
        }
        
        
        totalSubscriptionAmount = sbqq[0].Amount_Payable_on_Execution__c +sbqq[0].Subsequent_Amount_1__c + sbqq[0].Subsequent_Amount_2__c + sbqq[0].Subsequent_Amount_3__c + sbqq[0].Subsequent_Amount_4__c + sbqq[0].Subsequent_Amount_5__c.setScale(2);
        totalSubscriptionAmount = totalSubscriptionAmount.setScale(2);
        totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        //Sandra's request totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        totalSubscriptionAmountCredit = totalSubscriptionAmountCredit.setScale(2);
       // update sbqq;
        
    }
    
    public PageReference NonAnnualChanged(){
        
        if(sbqq[0].Number_of_Payments__c == null && sbqq[0].Non_Annual_Payments_Schedule__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Number of Years is Required'));
             return null;
        }
        if(sbqq[0].Amount_Payable_on_Execution__c == null && sbqq[0].Non_Annual_Payments_Schedule__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Initial Fee is Required'));
             return null;
        }
        
        showNonAnn1 = false;
        showNonAnn2 = false;
        showNonAnn3 = false;
        showNonAnn4 = false;
        showNonAnn5 = false;
        showNonAnn6 = false;
        showNonAnn7 = false;
        showNonAnn8 = false;
        showNonAnn9 = false;
        showNonAnn10 = false;
        showNonAnn11 = false;
        showNonAnn12 = false;
        showNonAnn13 = false;
        showNonAnn14 = false;
        showNonAnn15 = false;
        showNonAnn16 = false;
        showNonAnn17 = false;
        showNonAnn18 = false;
        showNonAnn19 = false;
        ychanged = false;
        if(sbqq.size() == 1){
            if(sbqq[0].Number_of_Payments__c > 1) showNonAnn1 = true;
            if(sbqq[0].Number_of_Payments__c > 2) showNonAnn2 = true;
            if(sbqq[0].Number_of_Payments__c > 3) showNonAnn3 = true;
            if(sbqq[0].Number_of_Payments__c > 4) showNonAnn4 = true;
            if(sbqq[0].Number_of_Payments__c > 5) showNonAnn5 = true;
            if(sbqq[0].Number_of_Payments__c > 6) showNonAnn6 = true;
            if(sbqq[0].Number_of_Payments__c > 7) showNonAnn7 = true;
            if(sbqq[0].Number_of_Payments__c > 8) showNonAnn8 = true;
            if(sbqq[0].Number_of_Payments__c > 9) showNonAnn9 = true;
            if(sbqq[0].Number_of_Payments__c > 10) showNonAnn10 = true;
            if(sbqq[0].Number_of_Payments__c > 11) showNonAnn11 = true;
            if(sbqq[0].Number_of_Payments__c > 12) showNonAnn12 = true;
            if(sbqq[0].Number_of_Payments__c > 13) showNonAnn13 = true;
            if(sbqq[0].Number_of_Payments__c > 14) showNonAnn14 = true;
            if(sbqq[0].Number_of_Payments__c > 15) showNonAnn15 = true;
            if(sbqq[0].Number_of_Payments__c > 16) showNonAnn16 = true;
            if(sbqq[0].Number_of_Payments__c > 17) showNonAnn17 = true;
            if(sbqq[0].Number_of_Payments__c > 18) showNonAnn18 = true;
            if(sbqq[0].Number_of_Payments__c > 19) showNonAnn19 = true;


            if(sbqq[0].Non_Annual_Payments_Schedule__c)    
            doAnnualMath();
        }
        ychanged = true;
        system.debug(upliftMulti);
         return null;
    }
    
    public void doAnnualMath(){
        /*
        if(!showNonAnn1){
            sbqq[0].Subsequent_Amount_1__c = 0;
            sbqq[0].Subsequent_Amount_Date_1__c = null ;
        } 
        
        if(!showNonAnn2){
            sbqq[0].Subsequent_Amount_2__c = 0;
            sbqq[0].Subsequent_Amount_Date_2__c  = null ;
        } 
        
        if(!showNonAnn3){
            sbqq[0].Subsequent_Amount_3__c = 0;
            sbqq[0].Subsequent_Amount_Date_3__c = null ;
        } 
        
        if(!showNonAnn4){
            sbqq[0].Subsequent_Amount_4__c = 0;
            sbqq[0].Subsequent_Amount_Date_4__c = null ;
        } 
        
        if(!showNonAnn5){
            sbqq[0].Subsequent_Amount_5__c = 0;
            sbqq[0].Subsequent_Amount_Date_5__c = null ;
        } 
    
        if(sbqq[0].Subsequent_Amount_1__c== null)
        sbqq[0].Subsequent_Amount_1__c = 0;
        if(sbqq[0].Subsequent_Amount_2__c== null)
        sbqq[0].Subsequent_Amount_2__c= 0;
        if(sbqq[0].Subsequent_Amount_3__c== null)
        sbqq[0].Subsequent_Amount_3__c= 0;
        if(sbqq[0].Subsequent_Amount_4__c== null)
        sbqq[0].Subsequent_Amount_4__c= 0;
        if(sbqq[0].Subsequent_Amount_5__c== null)
        sbqq[0].Subsequent_Amount_5__c= 0;
        if(sbqq[0].Amount_Payable_on_Execution__c == null)
        sbqq[0].Amount_Payable_on_Execution__c = 0;
        if(sbqq[0].Credit_Amount__c== null)
        sbqq[0].Credit_Amount__c= 0;
        */
        
        if(!showNonAnn1){
            sbqq[0].Subsequent_Amount_1__c = 0;
          //sbqq[0].Subsequent_Amount_Date_1__c = null ;
        } 
        
        if(!showNonAnn2){
            sbqq[0].Subsequent_Amount_2__c = 0;
          //sbqq[0].Subsequent_Amount_Date_2__c  = null ;
        } 
        
        if(!showNonAnn3){
            sbqq[0].Subsequent_Amount_3__c = 0;
          //sbqq[0].Subsequent_Amount_Date_3__c = null ;
        } 
        
        if(!showNonAnn4){
            sbqq[0].Subsequent_Amount_4__c = 0;
          //sbqq[0].Subsequent_Amount_Date_4__c = null ;
        } 
        
        if(!showNonAnn5){
            sbqq[0].Subsequent_Amount_5__c = 0;
          //sbqq[0].Subsequent_Amount_Date_5__c = null ;
        }
        
        if(!showNonAnn6){
            sbqq[0].Subsequent_Amount_6__c = 0;
          //sbqq[0].Subsequent_Amount_Date_6__c  = null ;
        } 
        
        if(!showNonAnn7){
            sbqq[0].Subsequent_Amount_7__c = 0;
          //sbqq[0].Subsequent_Amount_Date_7__c = null ;
        } 
        
        if(!showNonAnn8){
            sbqq[0].Subsequent_Amount_8__c = 0;
          //sbqq[0].Subsequent_Amount_Date_8__c = null ;
        } 
        
        if(!showNonAnn9){
            sbqq[0].Subsequent_Amount_9__c = 0;
          //sbqq[0].Subsequent_Amount_Date_9__c = null ;
        }
        if(!showNonAnn10){
            sbqq[0].Subsequent_Amount_10__c = 0;
          //sbqq[0].Subsequent_Amount_Date_10__c = null ;
        }
        
        if(!showNonAnn11){
            sbqq[0].Subsequent_Amount_11__c = 0;
          //sbqq[0].Subsequent_Amount_Date_11__c  = null ;
        } 
        
        if(!showNonAnn12){
            sbqq[0].Subsequent_Amount_12__c = 0;
          //sbqq[0].Subsequent_Amount_Date_12__c = null ;
        } 
        
        if(!showNonAnn13){
            sbqq[0].Subsequent_Amount_13__c = 0;
          //sbqq[0].Subsequent_Amount_Date_13__c = null ;
        } 
        
        if(!showNonAnn14){
            sbqq[0].Subsequent_Amount_14__c = 0;
          //sbqq[0].Subsequent_Amount_Date_14__c = null ;
        }
        
        if(!showNonAnn15){
            sbqq[0].Subsequent_Amount_15__c = 0;
          //sbqq[0].Subsequent_Amount_Date_15__c  = null ;
        } 
        
        if(!showNonAnn16){
            sbqq[0].Subsequent_Amount_16__c = 0;
          //sbqq[0].Subsequent_Amount_Date_16__c = null ;
        } 
        
        if(!showNonAnn17){
            sbqq[0].Subsequent_Amount_17__c = 0;
          //sbqq[0].Subsequent_Amount_Date_17__c = null ;
        } 
        
        if(!showNonAnn18){
            sbqq[0].Subsequent_Amount_18__c = 0;
          //sbqq[0].Subsequent_Amount_Date_18__c = null ;
        }
        if(!showNonAnn19){
            sbqq[0].Subsequent_Amount_19__c = 0;
          //sbqq[0].Subsequent_Amount_Date_19__c = null ;
        }
        
        if(sbqq[0].Subsequent_Amount_1__c== null)
        sbqq[0].Subsequent_Amount_1__c = 0;
        if(sbqq[0].Subsequent_Amount_2__c== null)
        sbqq[0].Subsequent_Amount_2__c= 0;
        if(sbqq[0].Subsequent_Amount_3__c== null)
        sbqq[0].Subsequent_Amount_3__c= 0;
        if(sbqq[0].Subsequent_Amount_4__c== null)
        sbqq[0].Subsequent_Amount_4__c= 0;
        if(sbqq[0].Subsequent_Amount_5__c== null)
        sbqq[0].Subsequent_Amount_5__c= 0;
        if(sbqq[0].Subsequent_Amount_6__c== null)
        sbqq[0].Subsequent_Amount_6__c = 0;
        if(sbqq[0].Subsequent_Amount_7__c== null)
        sbqq[0].Subsequent_Amount_7__c= 0;
        if(sbqq[0].Subsequent_Amount_8__c== null)
        sbqq[0].Subsequent_Amount_8__c= 0;
        if(sbqq[0].Subsequent_Amount_9__c== null)
        sbqq[0].Subsequent_Amount_9__c= 0;
        if(sbqq[0].Subsequent_Amount_10__c== null)
        sbqq[0].Subsequent_Amount_10__c= 0;
        if(sbqq[0].Subsequent_Amount_11__c== null)
        sbqq[0].Subsequent_Amount_11__c = 0;
        if(sbqq[0].Subsequent_Amount_12__c== null)
        sbqq[0].Subsequent_Amount_12__c= 0;
        if(sbqq[0].Subsequent_Amount_13__c== null)
        sbqq[0].Subsequent_Amount_13__c= 0;
        if(sbqq[0].Subsequent_Amount_14__c== null)
        sbqq[0].Subsequent_Amount_14__c= 0;
        if(sbqq[0].Subsequent_Amount_15__c== null)
        sbqq[0].Subsequent_Amount_15__c= 0;
        if(sbqq[0].Subsequent_Amount_16__c== null)
        sbqq[0].Subsequent_Amount_16__c = 0;
        if(sbqq[0].Subsequent_Amount_17__c== null)
        sbqq[0].Subsequent_Amount_17__c= 0;
        if(sbqq[0].Subsequent_Amount_18__c== null)
        sbqq[0].Subsequent_Amount_18__c= 0;
        if(sbqq[0].Subsequent_Amount_19__c== null)
        sbqq[0].Subsequent_Amount_19__c= 0;
    
        if(sbqq[0].Amount_Payable_on_Execution__c == null)
        sbqq[0].Amount_Payable_on_Execution__c = 0;
        if(sbqq[0].Credit_Amount__c== null)
        sbqq[0].Credit_Amount__c= 0;

        
        if(sbqq[0].Subsequent_Amount_Date_1__c != null) {
    if(sbqq[0].Subsequent_Amount_Date_2__c != null){
        if(sbqq[0].Subsequent_Amount_Date_3__c != null){
            if(sbqq[0].Subsequent_Amount_Date_4__c != null){
                if(sbqq[0].Subsequent_Amount_Date_5__c != null){
                    if(sbqq[0].Subsequent_Amount_Date_6__c != null){
                        if(sbqq[0].Subsequent_Amount_Date_7__c != null){
                            if(sbqq[0].Subsequent_Amount_Date_8__c != null){
                                if(sbqq[0].Subsequent_Amount_Date_9__c != null){
                                    if(sbqq[0].Subsequent_Amount_Date_10__c != null){
                                        if(sbqq[0].Subsequent_Amount_Date_11__c != null){
                                            if(sbqq[0].Subsequent_Amount_Date_12__c != null){
                                                if(sbqq[0].Subsequent_Amount_Date_13__c != null){
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c != null){
                                                        if(sbqq[0].Subsequent_Amount_Date_15__c != null){
                                                            if(sbqq[0].Subsequent_Amount_Date_16__c != null){
                                                                if(sbqq[0].Subsequent_Amount_Date_17__c != null){
                                                                    if(sbqq[0].Subsequent_Amount_Date_18__c != null){
                                                                        if(sbqq[0].Subsequent_Amount_Date_19__c != null){
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_18__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_18__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_17__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_17__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_16__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_16__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_15__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_15__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_14__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_14__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_13__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_13__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_12__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_12__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_19__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_19__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_17__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_17__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_16__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_16__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_15__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_15__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_14__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_14__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_13__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_13__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_12__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_12__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_18__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_18__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_16__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_16__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_15__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_15__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_14__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_14__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_13__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_13__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_12__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_12__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_17__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_17__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_15__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_15__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_14__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_14__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_13__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_13__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_12__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_12__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_4__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_4__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_16__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_16__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_14__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_14__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_13__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_13__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_12__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_12__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_15__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_15__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_13__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_13__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_12__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_12__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_14__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_14__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_12__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_12__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_13__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_13__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_11__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_11__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_12__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_12__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_10__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_10__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_11__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_11__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_9__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_9__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_10__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_10__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_8__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_8__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_9__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_9__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_8__c <  sbqq[0].Subsequent_Amount_Date_7__c){
                                                    sbqq[0].Subsequent_Amount_Date_8__c = sbqq[0].Subsequent_Amount_Date_7__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_8__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_8__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_8__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_8__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_8__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_8__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_8__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_8__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_8__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_8__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_8__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_8__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_7__c <  sbqq[0].Subsequent_Amount_Date_6__c){
                                                    sbqq[0].Subsequent_Amount_Date_7__c = sbqq[0].Subsequent_Amount_Date_6__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_7__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_7__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_7__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_7__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_7__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_7__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_7__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_7__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_7__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_7__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_6__c <  sbqq[0].Subsequent_Amount_Date_5__c){
                                                    sbqq[0].Subsequent_Amount_Date_6__c = sbqq[0].Subsequent_Amount_Date_5__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_6__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_6__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_6__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_6__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_6__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_6__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_6__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_6__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                                    sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_4__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                                    sbqq[0].Subsequent_Amount_Date_4__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_4__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_4__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_4__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_4__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_3__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                                    sbqq[0].Subsequent_Amount_Date_3__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                    if(sbqq[0].Subsequent_Amount_Date_3__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_3__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_2__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                                    sbqq[0].Subsequent_Amount_Date_2__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date.'));
                                                    }
                                                }
                                                    if(sbqq[0].Subsequent_Amount_Date_1__c < System.TODAY()){
                                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Date cannot be earlier than today.'));
                                                    }
                                                }
        /*if(sbqq[0].Subsequent_Amount_Date_1__c != null){
            if(sbqq[0].Subsequent_Amount_Date_2__c != null){
                if(sbqq[0].Subsequent_Amount_Date_3__c != null){
                    if(sbqq[0].Subsequent_Amount_Date_4__c != null){
                        if(sbqq[0].Subsequent_Amount_Date_5__c != null){
                            if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_4__c){
                                sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_4__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
            
                            }
                            if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                            if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                            if(sbqq[0].Subsequent_Amount_Date_5__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                sbqq[0].Subsequent_Amount_Date_5__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                        }
                    
                            if(sbqq[0].Subsequent_Amount_Date_4__c <  sbqq[0].Subsequent_Amount_Date_3__c){
                                sbqq[0].Subsequent_Amount_Date_4__c = sbqq[0].Subsequent_Amount_Date_3__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                            if(sbqq[0].Subsequent_Amount_Date_4__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                sbqq[0].Subsequent_Amount_Date_4__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                            if(sbqq[0].Subsequent_Amount_Date_4__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                sbqq[0].Subsequent_Amount_Date_4__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                    
                    }
                            if(sbqq[0].Subsequent_Amount_Date_3__c <  sbqq[0].Subsequent_Amount_Date_2__c){
                                sbqq[0].Subsequent_Amount_Date_3__c = sbqq[0].Subsequent_Amount_Date_2__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                            if(sbqq[0].Subsequent_Amount_Date_3__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                sbqq[0].Subsequent_Amount_Date_3__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                
                    }
                            if(sbqq[0].Subsequent_Amount_Date_2__c <  sbqq[0].Subsequent_Amount_Date_1__c){
                                sbqq[0].Subsequent_Amount_Date_2__c = sbqq[0].Subsequent_Amount_Date_1__c;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please update to a future date'));
                            }
                    }
                            if(sbqq[0].Subsequent_Amount_Date_1__c < System.TODAY()){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Date cannot be earlier than today'));
                            }
                    }*/
        
        totalSubscriptionAmount = sbqq[0].Amount_Payable_on_Execution__c +sbqq[0].Subsequent_Amount_1__c + sbqq[0].Subsequent_Amount_2__c + sbqq[0].Subsequent_Amount_3__c + sbqq[0].Subsequent_Amount_4__c + sbqq[0].Subsequent_Amount_5__c + sbqq[0].Subsequent_Amount_6__c + sbqq[0].Subsequent_Amount_7__c + sbqq[0].Subsequent_Amount_8__c + sbqq[0].Subsequent_Amount_9__c + sbqq[0].Subsequent_Amount_10__c + sbqq[0].Subsequent_Amount_11__c + sbqq[0].Subsequent_Amount_12__c + sbqq[0].Subsequent_Amount_13__c + sbqq[0].Subsequent_Amount_14__c + sbqq[0].Subsequent_Amount_15__c + sbqq[0].Subsequent_Amount_16__c + sbqq[0].Subsequent_Amount_17__c + sbqq[0].Subsequent_Amount_18__c + sbqq[0].Subsequent_Amount_19__c.setScale(2);
        totalSubscriptionAmount.format();
        totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        //Sandra's request totalSubscriptionAmountCredit = totalSubscriptionAmount - sbqq[0].Credit_Amount__c.setScale(2);
        totalSubscriptionAmountCredit.format();
       // update sbqq;
    }



    public void Save()
    {
        update sbqq;
    }

    public void SavePTerms()
    {
        update sbqq;
    }
    
    public PageReference clearRenewalTerms()
    {
        if(sbqq[0].Renewal_Price_Fixing_v2__c){
            sbqq[0].Committed_Years_on_Order_Form__c = 0;
            sbqq[0].Number_of_Years2__c  = 0;
            sbqq[0].Last_Annual_Committed_Payment__c = 0;
            sbqq[0].Renewal_Year_1_Uplift__c = 0;
            sbqq[0].Renewal_Year_2_Uplift__c = 0;
            sbqq[0].Renewal_Year_3_Uplift__c = 0;
            sbqq[0].Renewal_Year_4_Uplift__c = 0;
            renewalPrice1 = 0;
            renewalPrice2 = 0;
            renewalPrice3 = 0;
            renewalPrice4 = 0;
            totalRenewalPrice = 0;
         }   
        
        return null;
    }
    
    public PageReference clearAnnualTerms()
    {
        if(sbqq[0].Multi_Year_Annual_Pay_v2__c){
            sbqq[0].Number_of_Years__c = 0;
            sbqq[0].Amount_Payable_on_Execution__c = 0;
            sbqq[0].Subsequent_Amount_1__c = 0;
            sbqq[0].Subsequent_Amount_2__c = 0;
            sbqq[0].Subsequent_Amount_3__c = 0;
            sbqq[0].Subsequent_Amount_4__c = 0;
            sbqq[0].Subsequent_Amount_5__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_1__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_2__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_3__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_4__c = 0;
            sbqq[0].Subsequent_Uplift_Pct_5__c = 0;
            totalSubscriptionAmount = 0;
            totalSubscriptionAmountCredit = 0;
         }   
        
        return null;
    }
    public PageReference clearNonAnnualTerms()
    {
        if(sbqq[0].Non_Annual_Payments_Schedule__c){
            sbqq[0].Number_of_Payments__c = 0;
            sbqq[0].Amount_Payable_on_Execution__c = 0;
            sbqq[0].Subsequent_Amount_1__c = 0;
            sbqq[0].Subsequent_Amount_2__c = 0;
            sbqq[0].Subsequent_Amount_3__c = 0;
            sbqq[0].Subsequent_Amount_4__c = 0;
            sbqq[0].Subsequent_Amount_5__c = 0;
            //
            sbqq[0].Subsequent_Amount_6__c = 0;
            sbqq[0].Subsequent_Amount_7__c = 0;
            sbqq[0].Subsequent_Amount_8__c = 0;
            sbqq[0].Subsequent_Amount_9__c = 0;
            sbqq[0].Subsequent_Amount_10__c = 0;
            sbqq[0].Subsequent_Amount_11__c = 0;
            sbqq[0].Subsequent_Amount_12__c = 0;
            sbqq[0].Subsequent_Amount_13__c = 0;
            sbqq[0].Subsequent_Amount_14__c = 0;
            sbqq[0].Subsequent_Amount_15__c = 0;
            sbqq[0].Subsequent_Amount_16__c = 0;
            sbqq[0].Subsequent_Amount_17__c = 0;
            sbqq[0].Subsequent_Amount_18__c = 0;
            sbqq[0].Subsequent_Amount_19__c = 0;
            sbqq[0].Subsequent_Amount_Date_1__c = null;
            sbqq[0].Subsequent_Amount_Date_2__c = null;
            sbqq[0].Subsequent_Amount_Date_3__c = null;
            sbqq[0].Subsequent_Amount_Date_4__c = null;
            sbqq[0].Subsequent_Amount_Date_5__c = null;
            //
            sbqq[0].Subsequent_Amount_Date_6__c = null;
            sbqq[0].Subsequent_Amount_Date_7__c = null;
            sbqq[0].Subsequent_Amount_Date_8__c = null;
            sbqq[0].Subsequent_Amount_Date_9__c = null;
            sbqq[0].Subsequent_Amount_Date_10__c = null;
            sbqq[0].Subsequent_Amount_Date_11__c = null;
            sbqq[0].Subsequent_Amount_Date_12__c = null;
            sbqq[0].Subsequent_Amount_Date_13__c = null;
            sbqq[0].Subsequent_Amount_Date_14__c = null;
            sbqq[0].Subsequent_Amount_Date_15__c = null;
            sbqq[0].Subsequent_Amount_Date_16__c = null;
            sbqq[0].Subsequent_Amount_Date_17__c = null;
            sbqq[0].Subsequent_Amount_Date_18__c = null;
            sbqq[0].Subsequent_Amount_Date_19__c = null;
            totalSubscriptionAmount = 0;
            totalSubscriptionAmountCredit = 0;
         }
        
        return null;
    }
    
    public PageReference SaveCores()
    {
        /*if(sbqq[0].Price_Lock_Pre_Production_Cores__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Pre-Production Cores/vCores is Required'));
             return null;
        }
        if(sbqq[0].Price_Lock_Production_Cores__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Production Cores/vCores is Required'));
             return null;

        }
        if(sbqq[0].Price_Lock_Expiration__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Expiration Date is Required'));
             return null;

        }*/
        
        if(sbqq[0].Price_Lock_Production_Cores__c == null && sbqq[0].Price_Lock_Pre_Production_Cores__c == null && sbqq[0].Price_Lock_API_Manager__c == null){      
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'At least one (Pre-Prod, Prod, API Manager) must be populated'));     
             return null;       
        }
        
        update sbqq;   
        return null;
    }
    public PageReference SaveCredit()
    {
        if(sbqq[0].Credit_Amount__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Credit Amount is Required'));
             return null;
        }
        if(sbqq[0].Previous_Order_Number__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Previous Order Number is Required'));
             return null;
        }
        update sbqq;
        return null;
    }
    public PageReference  SavePaid()
    {
        if(years == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Number of Years is Required'));
         return null;
        }
        if(myear1price1== null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Amount Payable On Execution is Required'));
         return null;
        }
        sbqq[0].Amount_Payable_On_Execution__c = myear1price1;
        sbqq[0].Number_of_Years__c = years;
        update sbqq;
        return null;
    }
    public void SaveTerms()
    {
        sbqq[0].Approved_Special_Terms__c ='---THE TERMS BELOW HAVE NOT YET BEEN APPROVED---' + ' \r\n'+ ' \r\n' + sbqq[0].Special_Terms__c + ' \r\n'+ ' \r\n' + '---END OF UNAPPROVED TERMS---';
        
        update sbqq;
    }
    public void SaveApprovedTerms()
    {
        update sbqq;
    }
    public PageReference  SaveMarketing()
    {
        if(sbqq[0].Marketing_Material_Deadline__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Deadline is Required'));
         return null;
        }
        if(sbqq[0].Marketing_Material_Type__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Type is Required'));
         return null;
        }
        update sbqq;
        return null;
    }
     public PageReference  SaveValid()
    {
        if(sbqq[0].Services_Expiration_Date__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Services Expiration Date is Required'));
         return null;
        }
        update sbqq;
        return null;
    }
    public PageReference SaveProject()
    {
        if(sbqq[0].Project_Specific_Application__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Project Specific Services is Required'));
         return null;
        }
        if(sbqq[0].Project_Specific_Department__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Project Specific Cores/vCores is Required'));
         return null;
        }
        update sbqq;
        return null;
    }
}