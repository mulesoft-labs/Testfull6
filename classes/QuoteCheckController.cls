global without sharing class QuoteCheckController{
    Public Id objQuoteId {get;set;}
    public static final string STR_RESOLVE_QUOTE_EVENT = 'Please fix the data issues in red before submitting for approval.';
    private static Set<String> setValidationFields = new Set<String>();
    private static Map<String, Quote_Check__c> mapQc = new Map<String, Quote_Check__c>();
    public static String strResult;
    
    
    public QuoteCheckController(ApexPages.StandardController controller) {
        objQuoteId = controller.getId();
    }

    public PageReference checkQuote(){
        String strResult = QuoteCheckController.checkQuote(objQuoteId);
        if(strResult <> null) {
            strResult += '<br/>' +'<font color="black">'+ STR_RESOLVE_QUOTE_EVENT;
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.WARNING, strResult);
            ApexPages.addMessage(myMsg);
        }        
        return null;
    }    
      
    webservice static String checkQuote(Id objQuoteId){
        SBQQ__Quote__c quote = [Select Id, Total_Subscription_Amount__c, SBQQ__Account__c, SBQQ__Account__r.BillingCountry,SBQQ__Account__r.Territory__c,
                                                 Subscription_Amount__c, Credit_Amount__c,
                                                   Total_Subscription_Amount_Credit__c,
                                                       Subscription_Amount_with_Credit__c,
                                                           SBQQ__PrimaryContact__c,
                                                               Opportunity_Sales_Channel__c,
                                                                   SBQQ__StartDate__c,
                                                                       SBQQ__EndDate__c,
                                                                         Multi_Year_Annual_Pay_v2__c,
                                                                          Non_Annual_Payments_Schedule__c,
                                                                              Partner_Account__c,
                                                                              SBQQ__BillingCity__c, SBQQ__BillingCountry__c, SBQQ__BillingName__c, SBQQ__BillingPostalCode__c, SBQQ__BillingState__c, SBQQ__BillingStreet__c,
                                                                                Template_Invoice_To_Billing_City__c, Template_Invoice_To_Billing_Country__c , Template_Invoice_To_Billing_Postal_Code__c, Template_Invoice_To_Billing_State__c,Template_Invoice_To_Billing_Street__c,
                                                                                    SBQQ__ShippingCity__c, SBQQ__ShippingCountry__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingState__c, SBQQ__ShippingStreet__c                                               
                                      From   SBQQ__Quote__c
                                      Where  Id=:objQuoteId 
                                      limit   1][0];    
                                  
        system.debug('QuoteCheck' + quote);
        for(Quote_Check__c qc : Quote_Check__c.getall().values()){
            mapQc.put(qc.Name, qc);
        }   
        
        Decimal creditAmount = (quote.Credit_Amount__c == null) ? 0 : quote.Credit_Amount__c;
        if((quote.Multi_Year_Annual_Pay_v2__c || quote.Non_Annual_Payments_Schedule__c) && quote.Total_Subscription_Amount__c != (quote.Subscription_Amount__c + creditAmount )){            
            if(mapQc.containsKey('QC Subscription Amount') && mapQc.get('QC Subscription Amount').Active__c){
               setValidationFields.add(mapQc.get('QC Subscription Amount').Name);
            }
        }
        
        /*if((quote.Multi_Year_Annual_Pay_v2__c || quote.Non_Annual_Payments_Schedule__c) && quote.Total_Subscription_Amount_Credit__c != quote.Subscription_Amount_with_Credit__c){
            if(mapQc.containsKey('QC Subscription Amount Credit') && mapQc.get('QC Subscription Amount Credit').Active__c){
               setValidationFields.add(mapQc.get('QC Subscription Amount Credit').Name);
            }             
             //setValidationFields.add(System.Label.QC_Subscription_Amount_Credit);
        }*/
        
        if(quote.SBQQ__PrimaryContact__c == NULL){
            if(mapQc.containsKey('QC Primary Contact') && mapQc.get('QC Primary Contact').Active__c){
               setValidationFields.add(mapQc.get('QC Primary Contact').Name);
            }       
        }
        
        if(quote.Opportunity_Sales_Channel__c == NULL){
            if(mapQc.containsKey('QC Opportunity Sales Channel') && mapQc.get('QC Opportunity Sales Channel').Active__c){
               setValidationFields.add(mapQc.get('QC Opportunity Sales Channel').Name);
            }        
        }
        
        if(quote.Opportunity_Sales_Channel__c != null){
            if(quote.Partner_Account__c == null && ( quote.Opportunity_Sales_Channel__c == 'Distributor' || quote.Opportunity_Sales_Channel__c == 'Enterprise Partner (VAR)' || quote.Opportunity_Sales_Channel__c == 'Enterprise Partner (SI)' || quote.Opportunity_Sales_Channel__c == 'Enterprise Partner (OEM)')  ){ 
                if(mapQc.containsKey('QC Opportunity Sales Channel Indirect') && mapQc.get('QC Opportunity Sales Channel Indirect').Active__c){
                   setValidationFields.add(mapQc.get('QC Opportunity Sales Channel Indirect').Name);
                }             
            }
        }
        
        if(quote.Subscription_Amount__c > 0 && (quote.SBQQ__EndDate__c == null || quote.SBQQ__StartDate__c == null) ){
            if(mapQc.containsKey('QC Subscription Amount Date') && mapQc.get('QC Subscription Amount Date').Active__c){
               setValidationFields.add(mapQc.get('QC Subscription Amount Date').Name);
            }         
        }
        if( (quote.SBQQ__BillingCity__c == null && quote.SBQQ__BillingCountry__c != 'Singapore') || quote.SBQQ__BillingCountry__c == null || quote.SBQQ__BillingName__c == null || (quote.SBQQ__BillingPostalCode__c == null && quote.SBQQ__BillingCountry__c != 'Hong Kong') || ( quote.SBQQ__BillingState__c == null && quote.SBQQ__BillingCountry__c != 'New Zealand' && quote.SBQQ__BillingCountry__c != 'Singapore')|| quote.SBQQ__BillingStreet__c == null){
            if(mapQc.containsKey('QC Bill To Address') && mapQc.get('QC Bill To Address').Active__c){
               setValidationFields.add(mapQc.get('QC Bill To Address').Name);
            }            
        }
        if( (quote.Template_Invoice_To_Billing_City__c == null && quote.Template_Invoice_To_Billing_Country__c != 'Singapore') || quote.Template_Invoice_To_Billing_Country__c == null || (quote.Template_Invoice_To_Billing_Postal_Code__c == null && quote.Template_Invoice_To_Billing_Country__c != 'Hong Kong')|| (quote.Template_Invoice_To_Billing_State__c == null && quote.Template_Invoice_To_Billing_Country__c != 'New Zealand' && quote.Template_Invoice_To_Billing_Country__c != 'Singapore') || quote.Template_Invoice_To_Billing_Street__c == null){
            if(mapQc.containsKey('QC Invoice To') && mapQc.get('QC Invoice To').Active__c){
               setValidationFields.add(mapQc.get('QC Invoice To').Name);
            }             
        }
        if((quote.SBQQ__ShippingCity__c == null && quote.SBQQ__ShippingCountry__c != 'Singapore') || quote.SBQQ__ShippingCountry__c== null || (quote.SBQQ__ShippingPostalCode__c== null && quote.SBQQ__ShippingCountry__c != 'Hong Kong' ) || (quote.SBQQ__ShippingState__c== null && quote.SBQQ__ShippingCountry__c != 'New Zealand'  && quote.SBQQ__ShippingCountry__c != 'Singapore' ) || quote.SBQQ__ShippingStreet__c == null){
            if(mapQc.containsKey('QC End Customer Address') && mapQc.get('QC End Customer Address').Active__c){
               setValidationFields.add(mapQc.get('QC End Customer Address').Name);
            }            
        }
        
        
        if(!setValidationFields.IsEmpty()){
            strResult = '<br/>';
            for(String strFieldName: setValidationFields) {
                if(mapQc.containsKey(strFieldName) && mapQc.get(strFieldName).Error__c){
                   strResult += '<li class="errmsg"><font color="red">' + mapQc.get(strFieldName).Error_Message__c+'</li>';
                }else{
                   strResult += '<li><font color="black">' + mapQc.get(strFieldName).Error_Message__c+'</li>';                
                }
            }
        }
        
        System.Debug('QuoteDetails >>>'+ quote  );
        return strResult;
    }
    
}