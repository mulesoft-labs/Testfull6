public class QuoteHandler {
/*
    public static void onAfterInsert(Map<Id, SBQQ__Quote__c> mapQuote){
        List<String> lstQuoteId = new List<String>();
        List<String> lstRenewedContractQuote = new List<String>();
        for(SBQQ__Quote__c objQuote : [SELECT Id,
                SBQQ__Opportunity2__c,
                SBQQ__Opportunity2__r.SBQQ__RenewedContract__c,
                SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.SBQQ__Quote__c,
                SBQQ__OriginalQuote__c,
                RenewalRecalculated__c
        FROM SBQQ__Quote__c
        WHERE Id IN: mapQuote.keySet()
        AND SBQQ__Opportunity2__r.SBQQ__RenewedContract__c != null ]){
            if(!objQuote.RenewalRecalculated__c)lstRenewedContractQuote.add(objQuote.Id);
            //if(!objQuote.Training_Product_Added__c) lstQuoteId.add(objQuote.Id); //Comment on 27/june/2016 by Ganesh
        }
        if(!lstRenewedContractQuote.isEmpty()) updateQuoteRenewedContract(lstRenewedContractQuote);
        if(lstQuoteId.isEmpty()) return;
        // Comment on 27/june/2016 by Ganesh as currently this functionality is not required but this will be re-enabled at a later date.
        /*createTrainingQuoteLine(lstQuoteId);*/

    //}

    /*
    public static void isAfterUpdate(Map<Id, SBQQ__Quote__c> mapQuoteNew, Map<Id, SBQQ__Quote__c> mapQuoteOld){
        Set<Id> setOpportunityId = new Set<Id>();
        Map<String, Decimal> mapOpportnityID_NetTotal = new Map<String, Decimal>();
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        for(SBQQ__Quote__c objQuote : mapQuoteNew.values()){
            if(objQuote.RenewalRecalculated__c && mapQuoteOld.get(objQuote.Id).RenewalRecalculated__c != objQuote.RenewalRecalculated__c){
                setOpportunityId.add(objQuote.SBQQ__Opportunity2__c);
            }
            for (AggregateResult ar : [SELECT SBQQ__Quote__r.SBQQ__Opportunity2__c oppId,
                    SUM(SBQQ__NetTotal__c) netTotal
            FROM SBQQ__QuoteLine__c
            WHERE SBQQ__Quote__r.SBQQ__Opportunity2__c IN: setOpportunityId
            GROUP BY SBQQ__Quote__r.SBQQ__Opportunity2__c]){
                if(ar.get('netTotal') != null &&  ar.get('oppId') != null){
                    mapOpportnityID_NetTotal.put(String.valueOf( ar.get('oppId')), (Decimal)(ar.get('netTotal')));
                }
            }
            for(Opportunity objOpportunity : [SELECT Id,
                    Original_Renewal_Opportunity_Amount__c
            FROM Opportunity
            WHERE Id IN: mapOpportnityID_NetTotal.keySet()]){
                if(mapOpportnityID_NetTotal.get(objOpportunity.Id) != objOpportunity.Original_Renewal_Opportunity_Amount__c){
                    lstOpportunity.add(new Opportunity(Id = objOpportunity.Id, Original_Renewal_Opportunity_Amount__c = mapOpportnityID_NetTotal.get(objOpportunity.Id)));
                }
            }
            // update lstOpportunity;
        }
    }
    @future
    private static void updateQuoteRenewedContract(List<String> lstQuoteIds){
        List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
        for(String strQuoteId : lstQuoteIds){
            lstQuote.add(new SBQQ__Quote__c(Id = strQuoteId, RenewalRecalculated__c = true));
        }
        // update lstQuote;
    }
*/
    public static void isAfterUpdate(Map<Id, SBQQ__Quote__c> mapQuoteNew, Map<Id, SBQQ__Quote__c> mapQuoteOld){
        checkCreditAutomation(mapQuoteNew.values(), mapQuoteOld,false);
    } 

    // Comment on 27/june/2016 by Ganesh as currently this functionality is not required but this will be re-enabled at a later date.
    /*@future
    private static void createTrainingQuoteLine(List<String> lstQuoteIds){
        List<Product2> lstProduct = [SELECT Id, Name FROM Product2 WHERE Name = 'TRAINING: Flexible Training Credit Bundle']; 
        if(lstProduct.isEmpty()) return;
        Map<Id, Decimal> mapQuoteIdToSumQuoteLineSalesPrice = new Map<Id, Decimal>();
        List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
        for (AggregateResult ar : [SELECT SBQQ__Quote__c quoteId, 
                                          SUM(SBQQ__ListTotal__c) totalSP
                                     FROM SBQQ__QuoteLine__c   
                                    WHERE Category__c = 'Subscription' 
                                      AND SBQQ__ProductFamily__c != 'Program Fees' 
                                      AND SBQQ__Quote__c IN: lstQuoteIds
                                 GROUP BY SBQQ__Quote__c])  {
            mapQuoteIdToSumQuoteLineSalesPrice.put((Id)ar.get('quoteId'), (Decimal) ar.get('totalSP')); 
        }
        for(Id quoteId : mapQuoteIdToSumQuoteLineSalesPrice.keySet()){
            if(mapQuoteIdToSumQuoteLineSalesPrice.get(quoteId) == 0) continue;
            lstQuote.add(new SBQQ__Quote__c(Id = quoteId, Training_Product_Added__c = true));
            Decimal salesPriceSum = mapQuoteIdToSumQuoteLineSalesPrice.get(quoteId);
            Integer quantity = salesPriceSum < 250000 ? 40 : (salesPriceSum > 250000 && salesPriceSum < 1000000) ? 80 : 150;
            lstQuoteLine.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteId, SBQQ__Product__c = lstProduct[0].Id, SBQQ__Quantity__c = quantity));
        }
        insert lstQuoteLine;
        update lstQuote;
    }*/

    public static void handleBeforeInsert(List<SBQQ__Quote__c> newQuoteList){
        validateUserIsAllowedToUpdateOpportunityInClosing(newQuoteList);
        /*Commenting this code to avoid Too Many SOQL error
          We should re-visit this later
        */
        //populateGoverningAgreements(newQuoteList);
    }
    public  static void handleBeforeUpdate(List<SBQQ__Quote__c> newQuoteList, map<Id,SBQQ__Quote__c> oldMapQuote){
        validateUserIsAllowedToUpdateOpportunityInClosing(newQuoteList);
        /*Commenting this code to avoid Too Many SOQL error
          We should re-visit this later
        */
        //quoteAgreementPopulate(newQuoteList);
        populateQuoteNumberInOpportunity(newQuoteList,oldMapQuote);
        removeQuoteTerms(newQuoteList,oldMapQuote);
        checkAddedCredit(newQuoteList, oldMapQuote);
    }
    public static void handleBeforeDelete(List<SBQQ__Quote__c> oldQuoteList){
        validateUserIsAllowedToUpdateOpportunityInClosing(oldQuoteList);
    }
    
    public static void removeQuoteTerms(List<SBQQ__Quote__c> newQuoteList, map<Id,SBQQ__Quote__c> oldMapQuote){
        Set<Id> quoteIds = new Set<Id>();
        for(SBQQ__Quote__c q : newQuoteList){
            if(oldMapQuote.get(q.id).Legal_Link_or_MSA__c == 'SFDC uMSA'
                    && (q.Legal_Link_or_MSA__c == 'ESG Legal Link' || q.Legal_Link_or_MSA__c == 'Legal Link' || q.Legal_Link_or_MSA__c == 'MSA')
                    && q.Legal_Link_or_MSA__c  != oldMapQuote.get(q.id).Legal_Link_or_MSA__c){
                quoteIds.add(q.Id);
            }
        }
        if(quoteIds.size() > 0) {
            //Calling Future method to remove the Quote Terms
            removeQuoteTermsFuture(quoteIds);
        }
    }
    /*
    * future Method to remove the QuoteTerms
    */
    @future
    public static void removeQuoteTermsFuture(Set<Id> quoteIds) {
        System.debug(LoggingLevel.ERROR, '1----> removeQuoteTermsFuture --> '+quoteIds);
        List<SBQQ__QuoteTerm__c> quoteTermsToDelete = new List<SBQQ__QuoteTerm__c>();
        
        if(quoteIds.size() > 0){
            for(SBQQ__QuoteTerm__c qt : [SELECT SBQQ__Quote__c, Standard_Term_is_uMSA__c
                                         FROM SBQQ__QuoteTerm__c
                                         WHERE SBQQ__Quote__c IN :quoteIds AND Standard_Term_is_uMSA__c = true]){
                System.debug(LoggingLevel.ERROR, '1----> removeQuoteTermsFuture --> qt --> '+qt);
                quoteTermsToDelete.add(qt);
                System.debug(LoggingLevel.ERROR, '1----> removeQuoteTermsFuture --> quoteTermsToDelete --> '+quoteTermsToDelete);
            }
        }
        if(quoteTermsToDelete.size() >0 ){
            delete quoteTermsToDelete;
        }
    }

    public static void populateQuoteNumberInOpportunity(List<SBQQ__Quote__c> newQuoteList, map<Id,SBQQ__Quote__c> oldMapQuote){
        map<Id, Id> oppIdToQuoteId = new map<Id,Id>();
        for(SBQQ__Quote__c q : newQuoteList){
            System.debug(LoggingLevel.ERROR, '1----> q --> '+q);
            if(q.Push_to_NetSuite__c == true && q.Push_to_NetSuite__c != oldMapQuote.get(q.id).Push_to_NetSuite__c){
                oppIdToQuoteId.put(q.SBQQ__Opportunity2__c,q.Id);
                q.SBQQ__MasterContract__c = null;
            }
        }
        List<Opportunity> oppToUpdate = new List<Opportunity>();

        if(!oppIdToQuoteId.isEmpty()){
            for(Opportunity opp : [SELECT Id, Quote_Pushed_to_Netsuite__c FROM Opportunity WHERE id IN :oppIdToQuoteId.keyset()]){
                System.debug(LoggingLevel.ERROR, '1----> oppIdToQuoteId.get(opp.Id) --> '+oppIdToQuoteId.get(opp.Id));
                opp.Quote_Pushed_to_Netsuite__c = String.valueOf(oppIdToQuoteId.get(opp.Id)).substring(0,15);
                System.debug(LoggingLevel.ERROR, '1----> opp.Quote_Pushed_to_Netsuite__c --> '+opp.Quote_Pushed_to_Netsuite__c);
                oppToUpdate.add(opp);
            }
        }
        update oppToUpdate;

    }
    
    public static void validateUserIsAllowedToUpdateOpportunityInClosing(List<SBQQ__Quote__c> quotes){
        if(!Utilities.canUpdateOpportuniytyInClosing()){
            for(SBQQ__Quote__c q: quotes){
                if(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(q.Opportunity_Record_Type_Developer_Name__c)
                        || ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(q.Opportunity_Record_Type_Developer_Name__c)){
                    q.addError(Label.Opportunity_In_Closing_UnAuthorized_Edit);
                }
            }
            
        }
    }
    
    public static void checkAddedCredit(List<SBQQ__Quote__c> quotes, map<Id,SBQQ__Quote__c> oldMapQuote){
        Map<Id,SBQQ__Quote__c> mapQuoteFilter = new Map<Id,SBQQ__Quote__c>();
        for(SBQQ__Quote__c q: quotes){
              if(!q.Credit_Added__c){
                  mapQuoteFilter.put(q.Id, q);
              }         
        }
        System.debug(LoggingLevel.ERROR, '0 ---> mapQuoteFilter --> '+mapQuoteFilter);
        if(!mapQuoteFilter.isEmpty()){
        Map<Id,SBQQ__Quote__c> mapQuoteWLines = new Map<Id,SBQQ__Quote__c>([SELECT Id, (SELECT Id, SBQQ__Product__c  FROM SBQQ__LineItems__r) FROM SBQQ__Quote__c WHERE Id IN: mapQuoteFilter.keySet()]);
        System.debug(LoggingLevel.ERROR, '0 ---> mapQuoteWLines --> '+mapQuoteWLines);
            for(SBQQ__Quote__c q: quotes){
                if(mapQuoteWLines != null && mapQuoteWLines.get(q.Id) != null){
                    SBQQ__Quote__c quoteR = mapQuoteWLines.get(q.Id);
                    if( quoteR.SBQQ__LineItems__r != null){
                        for(SBQQ__QuoteLine__c ql: quoteR.SBQQ__LineItems__r){
                            if(ql.SBQQ__Product__c == System.Label.Credit ){  //change ID to label -> IMPORTANT
                                q.Credit_Added__c = true;
                                System.debug(LoggingLevel.ERROR, '0 ---> q --> '+q);
                            }
                        }
                    }
                }
            }
        }
                
    }
    
    public static void checkCreditAutomation(List<SBQQ__Quote__c> quotes, map<Id,SBQQ__Quote__c> oldMapQuote, Boolean isInsert ){
            List<SBQQ__QuoteLine__c> newCreditLines = new List<SBQQ__QuoteLine__c>();
            List<SBQQ__QuoteLine__c> updateCreditLines = new List<SBQQ__QuoteLine__c>();
            Map<Id,SBQQ__Quote__c> mapQuoteWLines = new Map<Id,SBQQ__Quote__c>([SELECT Id, (SELECT Id, SBQQ__Product__c  FROM SBQQ__LineItems__r) FROM SBQQ__Quote__c WHERE Id IN: quotes ]);
            System.debug(LoggingLevel.ERROR, '1 ---> mapQuoteWLines --> '+mapQuoteWLines);
            Id creditProductId;
            /*if(Test.isRunningTest()) {
                creditProductId = [SELECT Id FROM Product2 WHERE ProductCode = 'Credit'][0].Id;
            }*/

            for(SBQQ__Quote__c q: quotes){
                    if(q.Upgrade_Credit_Terms_v2__c && q.Credit_Amount__c != null ){
                        if(!q.Credit_Added__c && q.CreatedDate >= DateTime.newInstance(2016, 7, 1, 0, 0, 0)){
                        
                            SBQQ__QuoteLine__c quotelineCredit = new SBQQ__QuoteLine__c();
                            quotelineCredit.SBQQ__Quote__c = q.Id;
                            quotelineCredit.SBQQ__AdditionalDiscountAmount__c = q.Credit_Amount__c;
                            quotelineCredit.SBQQ__ListPrice__c = 0;
                            quotelineCredit.SBQQ__Quantity__c = 1;
                            //quotelineCredit.SBQQ__Product__c = Test.isRunningTest() ? creditProductId : System.Label.Credit; 
                            quotelineCredit.SBQQ__Product__c = System.Label.Credit; 
                            
                            newCreditLines.add(quotelineCredit);
                        
                        } else if(q.Credit_Added__c && q.Credit_Amount__c != oldMapQuote.get(q.id).Credit_Amount__c){
                            if(mapQuoteWLines != null){
                                SBQQ__Quote__c quoteR = mapQuoteWLines.get(q.Id);
                                    if( quoteR.SBQQ__LineItems__r != null){
                                        for(SBQQ__QuoteLine__c ql: quoteR.SBQQ__LineItems__r){
                                            if(ql.SBQQ__Product__c ==  System.Label.Credit ){ 
                                                ql.SBQQ__AdditionalDiscountAmount__c = q.Credit_Amount__c;
                                                updateCreditLines.add(ql);
                                            }
                                        }
                                }
                            }
                        }
                    }
                
                
            }
            System.debug(LoggingLevel.ERROR, '1 ---> newCreditLines --> '+newCreditLines);
            if(!newCreditLines.isEmpty()){
                insert newCreditLines;
            }
            System.debug(LoggingLevel.ERROR, '1 ---> newCreditLines --> '+newCreditLines);
            if(!updateCreditLines.isEmpty()){
                update updateCreditLines;
            }
        
    }

    /*Commenting this code to avoid Too Many SOQL error
          We should re-visit this later
        */
    /*
    public static void quoteAgreementPopulate(List<SBQQ__Quote__c> quotes){
        List<SBQQ__Quote__c> quoteAgreementList = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c quote: quotes){
            if(quote.SBQQ__Status__c == 'Draft'){
                quoteAgreementList.add(quote);
            }
        }
        if(!quoteAgreementList.isEmpty()){
            populateGoverningAgreements(quoteAgreementList);
        }
    }
*/
    /*Commenting this code to avoid Too Many SOQL error
      We should re-visit this later
    */
    /*
    public static void populateGoverningAgreements(List<SBQQ__Quote__c> quotes){
        Set<Id> acctId = new Set<Id>();
        Set<Id> oppId = new Set<Id>();
        for(SBQQ__Quote__c quote: quotes ){
            if(quote.Partner_Account__c != null)
                acctId.add(quote.Partner_Account__c);
            if(quote.SBQQ__Account__c != null)
                acctId.add(quote.SBQQ__Account__c);
            if(quote.SBQQ__Opportunity2__c != null)
                oppId.add(quote.SBQQ__Opportunity2__c);
        }
        //List<Agreement__c> legalLink = [SELECT ID FROM Agreement__c where Name = 'Legal Link']; 
        Map<Id,Account> mapAccount = new Map<Id,Account>([SELECT Id, MSA_Lookup__c, MPA_Lookup__c, PSA_Lookup__c, MPA_Lookup__r.MSA_or_EULA__c, MPA_Lookup__r.Pass_Through_Terms__c FROM Account WHERE Id IN: acctId]);
        Map<Id,Opportunity> mapOpportunity = new Map<Id,Opportunity>([SELECT Id,Sales_Channel__c  FROM Opportunity WHERE Id IN: oppId]);
        Map<Id,Agreement__c> mapAgreement = new Map<Id,Agreement__c>([SELECT Id, (SELECT Id, Account__c, Account__r.Name, Distributor_Agreement__c FROM Distributor_Applicable_End_Customers__r ) FROM Agreement__c WHERE Account__c IN : acctId]);
        for(SBQQ__Quote__c quote: quotes){
            if(mapOpportunity.get(quote.SBQQ__Opportunity2__c).Sales_Channel__c == 'Enterprise Direct'  ){
                if(mapAccount.get(quote.SBQQ__Account__c) != null){
                    if(mapAccount.get(quote.SBQQ__Account__c).MSA_Lookup__c != null)
                        quote.MSA_Lookup__c = mapAccount.get(quote.SBQQ__Account__c).MSA_Lookup__c;
                } else {
                    if(System.Label.Legal_Link_Record!=null){
                        quote.MSA_Lookup__c = System.Label.Legal_Link_Record;
                    }
                }
                if(mapAccount.get(quote.SBQQ__Account__c) != null){
                    if(mapAccount.get(quote.SBQQ__Account__c).MPA_Lookup__c != null)
                        quote.MPA_Lookup__c = mapAccount.get(quote.SBQQ__Account__c).MPA_Lookup__c;
                    if(mapAccount.get(quote.SBQQ__Account__c).PSA_Lookup__c != null)
                        quote.PSA_Lookup__c = mapAccount.get(quote.SBQQ__Account__c).PSA_Lookup__c;
                }
            }
            else if(mapOpportunity.get(quote.SBQQ__Opportunity2__c).Sales_Channel__c == 'Enterprise Partner (VAR)' || mapOpportunity.get(quote.SBQQ__Opportunity2__c).Sales_Channel__c == 'Enterprise Partner (SI)' || mapOpportunity.get(quote.SBQQ__Opportunity2__c).Sales_Channel__c == 'Enterprise Partner (OEM)'  ){
                if(mapAccount.get(quote.Partner_Account__c) != null){
                    if(mapAccount.get(quote.Partner_Account__c).MPA_Lookup__c != null)
                        quote.MPA_Lookup__c = mapAccount.get(quote.Partner_Account__c).MPA_Lookup__c;
                }
                if(mapAccount.get(quote.Partner_Account__c) != null){
                    if(mapAccount.get(quote.Partner_Account__c).MPA_Lookup__c != null){
                        if(mapAccount.get(quote.Partner_Account__c).MPA_Lookup__r.Pass_Through_Terms__c == 'MSA'){
                            if(mapAccount.get(quote.SBQQ__Account__c) != null){
                                if(mapAccount.get(quote.SBQQ__Account__c).MSA_Lookup__c != null)
                                    quote.MSA_Lookup__c = mapAccount.get(quote.SBQQ__Account__c).MSA_Lookup__c;
                            }
                        } else if (mapAccount.get(quote.Partner_Account__c).MPA_Lookup__r.Pass_Through_Terms__c == 'EULA'){
                            //Put EULA in the Order form. No Code needed and Clear the MSA Lookup in Quote;
                            quote.MSA_Lookup__c = null;
                        }
                    }
                }
            }
            else if(mapOpportunity.get(quote.SBQQ__Opportunity2__c).Sales_Channel__c == 'Distributor' ){
                if(mapAccount.get(quote.Partner_Account__c) != null){
                    if(mapAccount.get(quote.Partner_Account__c).MPA_Lookup__c != null)
                        quote.MPA_Lookup__c = mapAccount.get(quote.Partner_Account__c).MPA_Lookup__c;
                }
                if(mapAccount.get(quote.Partner_Account__c) != null){
                    if(mapAccount.get(quote.Partner_Account__c).MPA_Lookup__c != null){
                        if(mapAccount.get(quote.Partner_Account__c).MPA_Lookup__r.Pass_Through_Terms__c == 'MSA'){
                            if(mapAccount.get(quote.SBQQ__Account__c) != null){
                                if(mapAccount.get(quote.SBQQ__Account__c).MSA_Lookup__c != null)
                                    quote.MSA_Lookup__c = mapAccount.get(quote.SBQQ__Account__c).MSA_Lookup__c;
                            }
                        } else if (mapAccount.get(quote.Partner_Account__c).MPA_Lookup__r.Pass_Through_Terms__c == 'EULA'){
                            //Put EULA in the Order form. No Code needed and Clear the MSA Lookup in Quote;
                            quote.MSA_Lookup__c = null;
                        }
                    }
                }
                if(mapAgreement.get(quote.MPA_Lookup__c)!= null){
                    Agreement__c mpa = new Agreement__c();
                    if(mapAgreement.get(quote.MPA_Lookup__c) != null){
                        mpa = mapAgreement.get(quote.MPA_Lookup__c);
                    }
                    String appCustList = '';
                    if(mpa.Distributor_Applicable_End_Customers__r != null){
                        for(Distributor_Applicable_End_Customer__c dAEC : mpa.Distributor_Applicable_End_Customers__r ){
                            appCustList += String.valueof(dAEC.Account__r.Name) + ',';
                        }
                    }
                    quote.Applicable_Customer_List__c = appCustList;
                } else{
                    quote.Applicable_Customer_List__c = '';
                }
            }
        }
    */
    
    

}