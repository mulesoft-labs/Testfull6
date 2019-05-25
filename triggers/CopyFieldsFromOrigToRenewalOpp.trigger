trigger CopyFieldsFromOrigToRenewalOpp on Opportunity (before insert) {
    //commented by Teddy Zemedie, Trigger logic consolidated and trigger ready to be removed once testing is complete
    /*List<Id> relevantContractIds = new List<Id>();
    List<Opportunity> renewalOpps = new List<Opportunity>();
    for(Opportunity o : trigger.new){
        if (o.SBQQ__Renewal__c == TRUE && o.SBQQ__RenewedContract__c != NULL){
            relevantContractIds.add(o.SBQQ__RenewedContract__c);
            renewalOpps.add(o);
        }
    }
    
    if (relevantContractIds.size() > 0){
        List<Contract> origContracts = [SELECT Id, EndDate, SBQQ__Opportunity__c FROM Contract WHERE Id IN: relevantContractIds];
        Map<Id,Contract> contractMap = new Map<Id,Contract>();
        Map<Id,Id> contractToOrigOppMap = new Map<Id,Id>();
        for(Contract c : origContracts){
            contractMap.put(c.Id,c);
            contractToOrigOppMap.put(c.Id,c.SBQQ__Opportunity__c);
        }
        
        List<Opportunity> origOpps = [SELECT Id,Sales_Channel__c,Opportunity_Source__c,Billing_Contact_Email__c,Primary_Solution_Interest__c,
                                  Payment_Terms__c,Reference_PO__c,Intacct_Message__c,Parent_Opportunity__c,
                                  Foreign_Currency__c,Foreign_Currency_Exchange_Rate__c,Shipping_Address_Override__c,Billing_Address_Override__c,
                                  ContractEndDate__c,Renewal_Contact__c,Auto_Renew__c,Renewal_Pricing_Restrictions__c,
                                  Renewal_Special_Terms__c,Multi_Year_Deal__c,If_yes_Year_X_of_Total_Years__c,Push_to_Intacct__c
                                 FROM Opportunity WHERE Id IN: contractToOrigOppMap.values()];
        System.debug(origOpps.size());
        Map<Id,Opportunity> origOppMap = new Map<Id,Opportunity>();
        for(Opportunity o: origOpps){
            origOppMap.put(o.Id,o);
        }
        
        for(Opportunity renewalOpp: renewalOpps){
            Opportunity origOpp = origOppMap.get(contractToOrigOppMap.get(renewalOpp.SBQQ__RenewedContract__c));
            Contract origContract = contractMap.get(renewalOpp.SBQQ__RenewedContract__c);
            if (origContract != NULL && origOpp != NULL){
                if (origContract.EndDate != NULL){
                    renewalOpp.CloseDate = origContract.EndDate;
                }
                renewalOpp.forecast__c = 'Likely';
                renewalOpp.Sales_Channel__c = origOpp.Sales_Channel__c;
                renewalOpp.Opportunity_Source__c = origOpp.Opportunity_Source__c;
                renewalOpp.Billing_Contact_Email__c = origOpp.Billing_Contact_Email__c;
                renewalOpp.Payment_Terms__c = origOpp.Payment_Terms__c;
                renewalOpp.Intacct_Message__c = origOpp.Intacct_Message__c;
                renewalOpp.Parent_Opportunity__c = origOpp.Parent_Opportunity__c;
                renewalOpp.Foreign_Currency__c = origOpp.Foreign_Currency__c;
                renewalOpp.Foreign_Currency_Exchange_Rate__c = origOpp.Foreign_Currency_Exchange_Rate__c;
                renewalOpp.Shipping_Address_Override__c = origOpp.Shipping_Address_Override__c;
                renewalOpp.Billing_Address_Override__c = origOpp.Billing_Address_Override__c;
                renewalOpp.ContractEndDate__c = origOpp.ContractEndDate__c;
                renewalOpp.Renewal_Contact__c = origOpp.Renewal_Contact__c;
                renewalOpp.Auto_Renew__c = origOpp.Auto_Renew__c;
                renewalOpp.Renewal_Pricing_Restrictions__c = origOpp.Renewal_Pricing_Restrictions__c;
                renewalOpp.Renewal_Special_Terms__c = origOpp.Renewal_Special_Terms__c;
                renewalOpp.Multi_Year_Deal__c = origOpp.Multi_Year_Deal__c;
                if (origOpp.If_yes_Year_X_of_Total_Years__c != NULL){
                    renewalOpp.If_yes_Year_X_of_Total_Years__c = (origOpp.If_yes_Year_X_of_Total_Years__c.isNumeric()) ? string.valueof(integer.valueof(origOpp.If_yes_Year_X_of_Total_Years__c) + 1) : NULL;
                }
                renewalOpp.Push_to_Intacct__c = origOpp.Push_to_Intacct__c;
                renewalOpp.Primary_Solution_Interest__c = origOpp.Primary_Solution_Interest__c;
            }
        }
    }*/
}