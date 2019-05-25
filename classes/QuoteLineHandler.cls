public class QuoteLineHandler{
    
    public static void onAfterInsert(List<SBQQ__QuoteLine__c> lstQuoteLineNew){
        updatePlatinumSubscriptionProductListPrice(lstQuoteLineNew);
        
        //Commented out for the changes for Case 9555
        /*Set<Id> setQuoteId = new Set<Id>();
        for(SBQQ__QuoteLine__c objQL : lstQuoteLineNew) setQuoteId.add(objQL.SBQQ__Quote__c);
        
        // Identify platinum subscription records and kick off an update
        
        
        Map<Id, SBQQ__Quote__c> mapQuote= new Map<Id, SBQQ__Quote__c>([SELECT Id, 
                                                                              Name, 
                                                                              SBQQ__StartDate__c, 
                                                                              SBQQ__EndDate__c,
                                                                             SBQQ__Opportunity2__r.SBQQ__RenewedContract__c
                                                                         FROM SBQQ__Quote__c 
                                                                        WHERE Id IN: setQuoteId]);
        List<SBQQ__Quoteline__c> qls = new List<SBQQ__Quoteline__c>();
        for(SBQQ__Quoteline__c ql : lstQuoteLineNew){
            if (ql.sbqq__productcode__c == 'PLATINUMSUB' && mapQuote.get(ql.SBQQ__Quote__c).SBQQ__Opportunity2__r.SBQQ__RenewedContract__c != null)
                qls.add(ql);
        }
        if(!qls.isEmpty())
            ID jobID = System.enqueueJob(new QuoteLineQueueable(qls));*/
    }
    
    public static void onAfterUpdate(List<SBQQ__QuoteLine__c> lstQuoteLineNew){
        updatePlatinumSubscriptionProductListPrice(lstQuoteLineNew);
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT SBQQ__ProductCode__c, SBQQ__ListPrice__c FROM SBQQ__QuoteLine__c WHERE ID IN :lstQuoteLineNew];
        List<SBQQ__QuoteLine__c> quoteLineID = new List<SBQQ__QuoteLine__c>();
        Set<Id> qlID = new Set<Id>();
        
        if(AvoidRecursion.isFirstRun()){
            for(SBQQ__QuoteLine__c ql :quoteLines){
                qlID.add(ql.Id);
            }
            
            if(!qlID.isEmpty()){
                AggregateResult[] groupedResults = [SELECT SUM(X33_of_Net_Price__c)lp FROM SBQQ__QuoteLine__c WHERE ID IN :qlID];
                
                if(!groupedResults.isEmpty()){
                    for(SBQQ__QuoteLine__c quoteline :quoteLines){
                        if(quoteline.SBQQ__ProductCode__c == 'PLATINUMSUB'){
                            quoteline.SBQQ__AdditionalDiscountAmount__c = NULL;
                            quoteline.SBQQ__ListPrice__c = (Decimal)groupedResults[0].get('lp');
                            quoteline.SBQQ__ProratedListPrice__c = quoteline.SBQQ__ListPrice__c;
                            quoteLineID.add(quoteline);
                        }             
                    } 
                }
            }
            if(!quoteLineID.isEmpty()){
                update quotelineID;
            }
        }
        
    }
    
    public static void handleBeforeInsert(List<SBQQ__QuoteLine__c> newQuoteLineList){   
        validateUserIsAllowedToUpdateOpportunityInClosing(newQuoteLineList);
    }
    public  static void handleBeforeUpdate(List<SBQQ__QuoteLine__c> newQuoteLineList, map<Id,SBQQ__QuoteLine__c> oldMapQuoteLine){  
        validateUserIsAllowedToUpdateOpportunityInClosing(newQuoteLineList); 
        validateIfQuoteLineHasModusCodeProduct(newQuoteLineList);
    }
    public static void handleBeforeDelete(List<SBQQ__QuoteLine__c> oldQuoteLineList){  
        validateUserIsAllowedToUpdateOpportunityInClosing(oldQuoteLineList); 
    }
    public static void validateIfQuoteLineHasModusCodeProduct(List<SBQQ__QuoteLine__c> quoteLines){
        System.debug(LoggingLevel.ERROR, 'quoteLines --> '+ quoteLines);
    }
    
    public static void validateUserIsAllowedToUpdateOpportunityInClosing(List<SBQQ__QuoteLine__c> quoteLines){
        if(!Utilities.canUpdateOpportuniytyInClosing()){
            for(SBQQ__QuoteLine__c qli: quoteLines){
                if(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(qli.Opportunity_Record_Type_Developer_Name__c)
                        || ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(qli.Opportunity_Record_Type_Developer_Name__c)){
                    qli.addError(Label.Opportunity_In_Closing_UnAuthorized_Edit);
                }
            }
        }
    }
    
    private static void updatePlatinumSubscriptionProductListPrice(List<SBQQ__QuoteLine__c> lstQuoteLineNew){
        Set<Id> setQuoteId = new Set<Id>();
        Map<String, Decimal> mapQuoteStartDateEndDate_SumListAmount = new Map<String, Decimal>();
        List<SBQQ__QuoteLine__c> lstPlatinumSubscriptionProduct = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> lstPlatSubUpdate = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c objQL : lstQuoteLineNew) setQuoteId.add(objQL.SBQQ__Quote__c);
        Map<Id, SBQQ__Quote__c> mapQuote= new Map<Id, SBQQ__Quote__c>([SELECT Id, 
                                                                       Name, 
                                                                       SBQQ__StartDate__c, 
                                                                       SBQQ__EndDate__c 
                                                                       FROM SBQQ__Quote__c 
                                                                       WHERE Id IN: setQuoteId]);
        for(SBQQ__QuoteLine__c objQL : [SELECT Id,
                                        SBQQ__ProductCode__c,
                                        Category__c,
                                        SBQQ__ListPrice__c,
                                        SBQQ__NetTotal__c,
                                        X33_of_Net_Price__c,
                                        Include_in_Platinum_Support_of_Total__c, 
                                        SBQQ__StartDate__c, 
                                        SBQQ__EndDate__c, 
                                        SBQQ__Quote__c
                                        FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN: setQuoteId]){
                                            
                                            if(objQL.Include_in_Platinum_Support_of_Total__c && 
                                               ((objQL.SBQQ__StartDate__c != null)
                                                || (objQL.SBQQ__EndDate__c != null))){
                                                    if(objQL.SBQQ__ProductCode__c != 'PLATINUMSUB' && objQL.Category__c == 'Subscription'){
                                                        String key = objQL.SBQQ__Quote__c +'_'+String.valueOf(objQL.SBQQ__StartDate__c) +'_' + String.valueOf(objQL.SBQQ__EndDate__c);
                                                        if(!mapQuoteStartDateEndDate_SumListAmount.containsKey(key))mapQuoteStartDateEndDate_SumListAmount.put(key, 0.00);
                                                        mapQuoteStartDateEndDate_SumListAmount.put(key, mapQuoteStartDateEndDate_SumListAmount.get(key) +  
                                                                                                   (objQL.X33_of_Net_Price__c != null ? objQL.X33_of_Net_Price__c : 0.00));
                                                    }
                                                }

                                            if(objQL.SBQQ__ProductCode__c == 'PLATINUMSUB'){
                                                lstPlatinumSubscriptionProduct.add(objQL);
                                            }
                                        }   
        
        for(SBQQ__QuoteLine__c objQL : lstPlatinumSubscriptionProduct){
            String key = objQL.SBQQ__Quote__c +'_'+String.valueOf(objQL.SBQQ__StartDate__c) +'_' + String.valueOf(objQL.SBQQ__EndDate__c);
            if(!mapQuoteStartDateEndDate_SumListAmount.containsKey(key)) continue;
            Decimal platinumSubscriptionListTotal = objQL.SBQQ__ListPrice__c != null ? objQL.SBQQ__ListPrice__c : 0.00;
            Decimal subscriptionListTotal = mapQuoteStartDateEndDate_SumListAmount.get(key);
            if(platinumSubscriptionListTotal != subscriptionListTotal) lstPlatSubUpdate.add(new SBQQ__QuoteLine__c(Id = objQL.Id, SBQQ__ListPrice__c = subscriptionListTotal));
        }
        if(!lstPlatSubUpdate.isEmpty())
            update lstPlatSubUpdate;
    }
}