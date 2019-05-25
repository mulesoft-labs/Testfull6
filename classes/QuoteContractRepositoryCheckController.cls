//public with sharing class QuoteCheckController{
global without sharing class QuoteContractRepositoryCheckController{
    Public Id objQuoteId {get;set;}
    public static final string STR_RESOLVE_QUOTE_EVENT = 'Please resolve to proceed sending Quote for approval.';
    private static Set<String> setValidationFields = new Set<String>();
    private static Map<String, Quote_Check__c> mapQc = new Map<String, Quote_Check__c>();
    public static String strResult;
    public static String appCustList ='';
    public static String appCountryList = '';
    
    
    public QuoteContractRepositoryCheckController(ApexPages.StandardController controller) {
        objQuoteId = controller.getId();
    }

    public PageReference checkQuote(){
        String strResult = QuoteContractRepositoryCheckController.checkQuote(objQuoteId);
        if(strResult <> null) {
            //strResult += '<br/>' +'<font color="black">'+ STR_RESOLVE_QUOTE_EVENT;
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.WARNING, strResult);
            ApexPages.addMessage(myMsg);
        }        
        return null;
    }    
      
    webservice static String checkQuote(Id objQuoteId){
        SBQQ__Quote__c quote = [Select Id, Total_Subscription_Amount__c, SBQQ__Account__c,SBQQ__Distributor__c,SBQQ__Partner__c, Deal_Type__c,
                                                 Subscription_Amount__c, Num_of_Subscription_Products__c,
                                                   Total_Subscription_Amount_Credit__c,
                                                       Subscription_Amount_with_Credit__c,
                                                           SBQQ__PrimaryContact__c,Marketing_Material_Clarification_v2__c ,
                                                               Opportunity_Sales_Channel__c,
                                                                   SBQQ__StartDate__c,Num_Of_Products_Requires_Cloud__c, Num_Of_Prof_Services_Products__c, Num_of_Training_Products__c,
                                                                       SBQQ__EndDate__c,
                                                                           Multi_Year_Annual_Pay_v2__c,
                                                                               Non_Annual_Payments_Schedule__c, Applicable_Customer_List__c,
                                                                                   Partner_Account__c,Has_Cloud_and_Anypoint_Products__c,
                                                                                       SBQQ__BillingCity__c, SBQQ__BillingCountry__c, SBQQ__BillingName__c, SBQQ__BillingPostalCode__c, SBQQ__BillingState__c, SBQQ__BillingStreet__c,
                                                                                           Template_Invoice_To_Billing_City__c, Template_Invoice_To_Billing_Country__c , Template_Invoice_To_Billing_Postal_Code__c, Template_Invoice_To_Billing_State__c,Template_Invoice_To_Billing_Street__c,
                                                                                               SBQQ__ShippingCity__c, SBQQ__ShippingCountry__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingState__c, SBQQ__ShippingStreet__c,
                                                                                                   MSA_Lookup__c,MSA_Lookup__r.Agreement_Status__c,MSA_Lookup__r.Ability_to_Purchase_Cloud__c, 
                                                                                                       MSA_Lookup__r.Ability_to_Purchase_Software__c, MSA_Lookup__r.Ability_to_Purchase_Services__c, MSA_Lookup__r.Ability_to_Purchase_Training__c, MSA_Lookup__r.Use_Customer_name_logo__c,
                                                                                                           MPA_Lookup__c, MPA_Lookup__r.Applicable_Countries__c, MPA_Lookup__r.Ability_to_Resell_Services__c, 
                                                                                                               MPA_Lookup__r.Ability_to_Resell_Software__c, MPA_Lookup__r.Ability_to_Resell_Training__c, MPA_Lookup__r.Partner_Reseller_Exhibit__c, MPA_Lookup__r.Pass_Through_Terms__c, MPA_Lookup__r.Agreement_Status__c
                                                                                     
                                      From   SBQQ__Quote__c
                                      Where  Id=:objQuoteId 
                                      limit   1][0];
         Set<Id> acctId = new Set<Id>();
         if(quote.SBQQ__Account__c != null){
             acctId.add(quote.SBQQ__Account__c);         
         }
         if(quote.SBQQ__Distributor__c != null){
             acctId.add(quote.SBQQ__Distributor__c);  
         }
         if(quote.SBQQ__Partner__c != null){
             acctId.add(quote.SBQQ__Partner__c); 
         }
        
        List<Id> listAgreement = new List<Id>();
        if(quote.MSA_Lookup__c!=null){
            listAgreement.add(quote.MSA_Lookup__c);
        }
        if(quote.MPA_Lookup__c!=null){
            listAgreement.add(quote.MPA_Lookup__c);
        }
         
        Map<Id,Agreement__c> mapAgreement = new Map<Id,Agreement__c>([SELECT Id,Applicable_Countries__c, (SELECT Id, Account__c,Account__r.Name, Distributor_Agreement__c FROM Distributor_Applicable_End_Customers__r ) FROM Agreement__c WHERE Id IN : listAgreement]);
                    
        Boolean hasCloud = false;
        for(Quote_Check__c qc : Quote_Check__c.getall().values()){
            mapQc.put(qc.Name, qc);
        }   
        
        
        if(quote.Deal_Type__c == 'Direct' && quote.MSA_Lookup__c!= null){
            if(quote.MSA_Lookup__c != null){
                if(quote.MSA_Lookup__r.Ability_to_Purchase_Cloud__c != 'Yes' && quote.Num_Of_Products_Requires_Cloud__c > 0)
                   setValidationFields.add(mapQc.get('QC Cloud Term').Name);
                if(quote.MSA_Lookup__r.Agreement_Status__c.toUpperCase() == 'LAPSED' )
                   setValidationFields.add(mapQc.get('QC Direct Deal: Status Check').Name);
                if(quote.MSA_Lookup__r.Ability_to_Purchase_Software__c != 'Yes' &&  quote.Num_of_Subscription_Products__c > 0)
                   setValidationFields.add(mapQc.get('QC Direct Deal: Subscription Check').Name);
                if(quote.MSA_Lookup__r.Ability_to_Purchase_Services__c != 'Yes' &&  quote.Num_Of_Prof_Services_Products__c > 0)
                   setValidationFields.add(mapQc.get('QC Direct Deal: Services Check').Name);
                if(quote.MSA_Lookup__r.Ability_to_Purchase_Training__c != 'Yes' &&  quote.Num_of_Training_Products__c > 0)
                   setValidationFields.add(mapQc.get('QC Direct Deal: Training Check').Name);
                if(quote.MSA_Lookup__r.Use_Customer_name_logo__c != 'Yes' &&  quote.Marketing_Material_Clarification_v2__c)
                   setValidationFields.add(mapQc.get('QC Direct Deal: Customer Logo').Name);
            }
        }
        
        //appCustList = 'Applicable Customer List: ';
        
        if(mapAgreement.get(quote.MPA_Lookup__c)!= null  && quote.Deal_Type__c == 'Distributor'){
            Agreement__c mpa = mapAgreement.get(quote.MPA_Lookup__c);
            Boolean isDistributor = false;
            
            if(mpa.Distributor_Applicable_End_Customers__r != null){
                for(Distributor_Applicable_End_Customer__c dAEC : mpa.Distributor_Applicable_End_Customers__r ){
                    if(dAEC.Account__c == quote.SBQQ__Account__c){
                        isDistributor = true;
                    }
                    appCustList += String.valueof(dAEC.Account__r.Name) + ',';
                }
            }
            if(!isDistributor){
                setValidationFields.add(mapQc.get('QC Distributor End').Name);
            }
        }
       
        if(quote.Deal_Type__c == 'Resell' || quote.Deal_Type__c == 'Distributor'  && quote.MPA_Lookup__c!= null) {
            if(quote.MPA_Lookup__c != null){
               if(quote.MPA_Lookup__r.Agreement_Status__c.toUpperCase() == 'LAPSED' )
                   setValidationFields.add(mapQc.get('QC Resell Deal: Status Check').Name);
               if(quote.MPA_Lookup__r.Ability_to_Resell_Services__c != 'Yes' && quote.Num_Of_Prof_Services_Products__c > 0 )
                   setValidationFields.add(mapQc.get('QC Service Check').Name);
               if(quote.MPA_Lookup__r.Ability_to_Resell_Software__c != 'Yes' && quote.Num_of_Subscription_Products__c > 0 )
                   setValidationFields.add(mapQc.get('QC Resell Deal: Software Check').Name);
               if(quote.MPA_Lookup__r.Ability_to_Resell_Training__c != 'Yes' && quote.Num_of_Training_Products__c > 0 )
                   setValidationFields.add(mapQc.get('QC Resell Deal: Training Check').Name);
               if(!quote.MPA_Lookup__r.Partner_Reseller_Exhibit__c && quote.Deal_Type__c == 'Resell')
                   setValidationFields.add(mapQc.get('QC Resell Deal: Exhibit').Name);
               if(quote.MPA_Lookup__r.Pass_Through_Terms__c == 'MSA'){
                   if(quote.MSA_Lookup__c != null){
                        if(quote.MSA_Lookup__r.Ability_to_Purchase_Cloud__c != 'Yes' && quote.Num_Of_Products_Requires_Cloud__c > 0)
                           setValidationFields.add(mapQc.get('QC Cloud Term').Name);
                        if(quote.MSA_Lookup__r.Ability_to_Purchase_Software__c != 'Yes' &&  quote.Num_of_Subscription_Products__c > 0)
                           setValidationFields.add(mapQc.get('QC Direct Deal: Subscription Check').Name);
                        if(quote.MSA_Lookup__r.Ability_to_Purchase_Services__c != 'Yes' &&  quote.Num_Of_Prof_Services_Products__c > 0)
                           setValidationFields.add(mapQc.get('QC Direct Deal: Services Check').Name);
                        if(quote.MSA_Lookup__r.Ability_to_Purchase_Training__c != 'Yes' &&  quote.Num_of_Training_Products__c > 0)
                           setValidationFields.add(mapQc.get('QC Direct Deal: Training Check').Name);
                    }
               } else if (quote.MPA_Lookup__r.Pass_Through_Terms__c == 'EULA'){
                   //Clarify
               }
               if(quote.MPA_Lookup__r.Applicable_Countries__c != null && quote.Deal_Type__c == 'Resell'){
                   appCountryList = quote.MPA_Lookup__r.Applicable_Countries__c;
                   if(quote.SBQQ__ShippingCountry__c != null && !appCountryList.contains(quote.SBQQ__ShippingCountry__c)){
                        setValidationFields.add(mapQc.get('QC MPA Country').Name);
                   }
               }
           }
               
        }
        
        if(quote.MSA_Lookup__c == null && quote.MPA_Lookup__c == null){            
            setValidationFields.add(mapQc.get('QC No Agreement').Name);
        }
       
        if(!setValidationFields.IsEmpty() ){
            strResult = '<br/>';
            for(String strFieldName: setValidationFields) {
                if(mapQc.containsKey(strFieldName) && mapQc.get(strFieldName).Error__c && mapQc.get(strFieldName).Active__c){
                   strResult += '<li class="errmsg"><font color="red">' + mapQc.get(strFieldName).Error_Message__c+'</li>';
                }else{
                   strResult += '<li><font color="black">' + mapQc.get(strFieldName).Error_Message__c+'</li>';                
                }
            }
        }
         
        if(!String.isBlank(appCustList) && quote.Deal_Type__c == 'Distributor' ){
            if(strResult == null){
                strResult = '<br/>';
            } 
            strResult = '<li><font color="black">' + 'Distributor Applicable End Customers: ';
            strResult += appCustList+'</li>';
        } else if(String.isBlank(appCustList) && quote.Deal_Type__c == 'Distributor'){
            if(strResult == null){
                strResult = '<br/>';
            } 
            strResult += '<li><font color="black">' + 'Distributor Applicable End Customers: ';
            strResult +=  'None listed'+'</li>';
        }
        
        if(!String.isBlank(appCountryList) &&  quote.Deal_Type__c == 'Resell'){
            if(strResult == null){
                strResult = '<br/>';
            } 
            strResult += '<li><font color="black">' + 'MPA Applicable Countries: ';
            strResult += appCountryList+'</li>';
        } else if(String.isBlank(appCountryList ) && quote.Deal_Type__c == 'Resell'){
            if(strResult == null){
                strResult = '<br/>';
            }
            strResult += '<li><font color="black">' + 'MPA Applicable Countries: ';
            strResult +=  'None listed'+'</li>';
        }
        
        
        System.Debug('QuoteDetails >>>'+ quote  );
        return strResult;
    }
    
}