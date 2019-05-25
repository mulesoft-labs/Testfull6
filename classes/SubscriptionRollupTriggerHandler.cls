public with sharing class SubscriptionRollupTriggerHandler {
    private Boolean m_isExecuting = false;
    private Integer BatchSize = 0;

    public SubscriptionRollupTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public static void OnAfterInsert(Map<Id,SBQQ__Subscription__c> newSubscriptions){
        doNewMapWork(newSubscriptions.values());
    }

    public static void OnAfterUpdate(Map<Id,SBQQ__Subscription__c> updateSubscriptions, Map<Id,SBQQ__Subscription__c> updateSubscriptionsOld){
        doTheWork(updateSubscriptions.values(),updateSubscriptionsOld);
    }

    public static void OnAfterDelete(Map<Id,SBQQ__Subscription__c> deletedSubscriptions){
        doTheWork(deletedSubscriptions.values(),deletedSubscriptions);
    }

    public static void OnUndelete(Map<Id,SBQQ__Subscription__c> undeletedSubscriptions){
        doNewMapWork(undeletedSubscriptions.values());
    }

    public static void doNewMapWork(List<SBQQ__Subscription__c> newMaps){
        System.debug(LoggingLevel.ERROR, 'Inside Insert --> newMaps --> '+newMaps);
        Set<id> Ids = new Set<Id>();
        for(SBQQ__Subscription__c sub:newMaps){
            if(sub.SBQQ__Contract__c != null){
                Ids.add(sub.SBQQ__Contract__c);
            }
        }
        computeRollUpSummaryFields(Ids);
    }

    public static void doTheWork(List<SBQQ__Subscription__c> newRecords, Map<Id,SBQQ__Subscription__c> oldMap){
        System.debug(LoggingLevel.ERROR, 'Inside Update --> newRecords  --> '+newRecords +'    oldMap .  ---> '+ oldMap);
        Set<Id> Ids = new Set<Id>();
        for(SBQQ__Subscription__c sub : newRecords) {
            if(oldmap == null && sub.SBQQ__Contract__c != null){
                Ids.add(sub.SBQQ__Contract__c);
            }
            if(oldmap != null && sub.SBQQ__Contract__c != null
                    || (sub.Total_Subscription_Price__c != oldMap.get(sub.Id).Total_Subscription_Price__c
                    || sub.SBQQ__Contract__c != oldMap.get(sub.Id).SBQQ__Contract__c
                    || sub.SBQQ__Quantity__c != oldMap.get(sub.Id).SBQQ__Quantity__c)){
                if(sub.SBQQ__Contract__c != null){
                    Ids.add(sub.SBQQ__Contract__c);
                }
                if(oldMap.get(sub.Id).SBQQ__Contract__c != null){
                    Ids.add(oldMap.get(sub.Id).SBQQ__Contract__c);
                }
            }
        }
        computeRollUpSummaryFields(Ids);
    }

    public static void computeRollUpSummaryFields(Set<Id> Ids){
        System.debug(LoggingLevel.ERROR, 'Inside Update --> Ids  --> '+Ids);
        Set<String> iso = new Set<String>();
        Map<Id, Contract> contractTotalsToUpdate = new Map<Id, Contract>();
        Map<id,Contract> contractMap = New Map<id,Contract>([SELECT Id, Total_of_Subscriptions__c,
                Production_Cores__c, Production_VCores__c,
                Pre_Production_Cores__c ,Pre_Production_VCores__c,
                CurrencyISOCode,Validated_by_Finance_Ops__c
        FROM Contract
        WHERE Id IN:Ids]);
        System.debug(LoggingLevel.ERROR, 'Inside Update --> contractMap  --> '+contractMap);
        List<aggregateResult> subscriptionAggregateTotals = [SELECT SUM(Total_Subscription_Price__c) SubTotal, SBQQ__Contract__c
        FROM SBQQ__Subscription__c
        WHERE SBQQ__Contract__c IN : Ids
        GROUP BY SBQQ__Contract__c];
        System.debug(LoggingLevel.ERROR, 'Inside Update --> subscriptionAggregateTotals  --> '+subscriptionAggregateTotals);

        for(Contract c : contractMap.values()){
            iso.add(c.CurrencyISOCode);
            // Preset to 0 for scenario where no subscriptions in the database, will manipulate in subscription loop
            contractTotalsToUpdate.put(c.Id, new Contract(Id = c.Id, Total_of_Subscriptions__c = 0, Production_Cores__c = 0, Production_VCores__c = 0,
                    Pre_Production_Cores__c =0, Pre_Production_VCores__c = 0));
        }
        System.debug(LoggingLevel.ERROR, ' --> --> --> --> --> --> --> contractTotalsToUpdate  --> '+contractTotalsToUpdate);
        List<CurrencyType> conversionRate = [SELECT ConversionRate,IsoCode FROM CurrencyType WHERE IsoCode IN: iso];
        Map<String,Decimal> conversion =new Map<String,Decimal>();
        for(CurrencyType ct:conversionRate){
            conversion.put(ct.IsoCode,ct.ConversionRate);
        }

        for(aggregateResult ar: subscriptionAggregateTotals){
            Contract c = contractMap.get((Id)ar.get('SBQQ__Contract__c'));
            System.debug(LoggingLEvel.ERROR, '@@@@@@@@@  -->1 --> c . '+c.Total_of_Subscriptions__c);
            System.debug(LoggingLEvel.ERROR, '@@@@@@@@@  -->2 --> c . '+(Decimal)ar.get('SubTotal'));
            //if(c.Total_of_Subscriptions__c != (Decimal)ar.get('SubTotal')) {
            Decimal sTotal = (Decimal)ar.get('Subtotal');
            System.debug(LoggingLEvel.ERROR, '@@@@@@@@@  -->3 --> sTotal '+sTotal);
            contractTotalsToUpdate.put(c.Id, new Contract(Id = c.Id, Total_of_Subscriptions__c = sTotal * conversion.get(c.CurrencyISOCode)));
            //}
        }
        System.debug(LoggingLEvel.ERROR, '#########  --> contractTotalsToUpdate . '+contractTotalsToUpdate);

        List<aggregateResult> coresVcoresAggregateTotals = [SELECT  SUM(SBQQ__Quantity__c) TotalQuantity,
                SBQQ__Contract__c, SBQQ__Product__r.ProductCode
        FROM SBQQ__Subscription__c
        WHERE SBQQ__Contract__c IN : Ids
        GROUP BY SBQQ__Contract__c, SBQQ__Product__r.ProductCode];

        System.debug(LoggingLEvel.ERROR, 'Inside Update --> coresVcoresAggregateTotals  --> '+coresVcoresAggregateTotals);
        Decimal prodCoreQty = 0.0;
        Decimal preProdCoreQty = 0.0;
        Decimal prodVcoreQty = 0.0;
        Decimal preProdVcoreQty = 0.0;
        Map<Id,List<aggregateResult>> contractIdToAggSubscriptions = new Map<Id,List<aggregateResult>>();
        for(aggregateResult aggRes: coresVcoresAggregateTotals){
            if(contractIdToAggSubscriptions.containskey((Id)aggRes.get('SBQQ__Contract__c'))){
                contractIdToAggSubscriptions.get((Id)aggRes.get('SBQQ__Contract__c')).add(aggRes);
            } else{
                List<aggregateResult> subsList=new List<aggregateResult>();
                subsList.add(aggRes);
                contractIdToAggSubscriptions.put((Id)aggRes.get('SBQQ__Contract__c'),subsList);
            }
        }
        System.debug(LoggingLEvel.ERROR, 'SID --> contractIdToAggSubscriptions  --> '+contractIdToAggSubscriptions);
        Map<String, SBQQ__Subscription__c> ProdCodeToSubscriptions = new Map<String, SBQQ__Subscription__c>();
        List<SBQQ__Subscription__c> subscriptionsUnderContract = [SELECT SBQQ__Contract__c, SBQQ__Product__r.ProductCode,SBQQ__Product__r.ELA__c,
                SBQQ__Product__r.Production_Cores__c,SBQQ__Product__r.Production_vCores__c,SBQQ__Product__r.Pre_Production_Cores__c,
                SBQQ__Product__r.Pre_Production_vCores__c
        FROM SBQQ__Subscription__c
        WHERE SBQQ__Contract__c IN : Ids];
        System.debug(LoggingLevel.ERROR, '111111 --> subscriptionsUnderContract  --> '+subscriptionsUnderContract);
        for(SBQQ__Subscription__c s: subscriptionsUnderContract){
            ProdCodeToSubscriptions.put(s.SBQQ__Product__r.ProductCode, s);
        }
        System.debug(LoggingLevel.ERROR, '111111 --> ProdCodeToSubscriptions  --> '+ProdCodeToSubscriptions);


        for(Id conId : contractIdToAggSubscriptions.KeySet()) {
            System.debug(LoggingLevel.ERROR, ' --> conId  --> '+conId);
            Contract con = contractMap.get(conId);
            for(aggregateResult ar : contractIdToAggSubscriptions.get(conId)){
                if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')) != null) {
                    if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Production_Cores__c > 0) {
                        if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.ELA__c == true) {
                            prodCoreQty = 1000000;
                        } else {
                            prodCoreQty += ((Decimal) ar.get('TotalQuantity')) * (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Production_Cores__c);
                            System.debug(LoggingLevel.ERROR, 'HELLO --> INSIDE ELSE  --> ' + prodCoreQty);
                        }
                    }
                    if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Pre_Production_Cores__c > 0) {
                        if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.ELA__c == true) {
                            preProdCoreQty = 1000000;
                        } else {
                            preProdCoreQty += ((Decimal) ar.get('TotalQuantity')) * (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Pre_Production_Cores__c);
                        }
                    }

                    if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Pre_Production_vCores__c > 0) {
                        if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.ELA__c == true) {
                            preProdVcoreQty = 1000000;
                        } else {
                            preProdVcoreQty += ((Decimal) ar.get('TotalQuantity')) * (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Pre_Production_vCores__c);
                        }
                    }

                    if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Production_vCores__c > 0) {
                        if (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.ELA__c == true) {
                            prodVcoreQty = 1000000;
                        } else {
                            prodVcoreQty += ((Decimal) (ar.get('TotalQuantity'))) * (ProdCodeToSubscriptions.get((String) ar.get('ProductCode')).SBQQ__Product__r.Production_vCores__c) ;
                        }
                    }
                }

            }
            System.debug(LoggingLevel.ERROR, '111111 --> prodCoreQty  --> ' + prodCoreQty);
            System.debug(LoggingLevel.ERROR, '111111 --> preProdCoreQty  --> ' + preProdCoreQty);
            System.debug(LoggingLevel.ERROR, '111111 --> preProdVcoreQty  --> ' + preProdVcoreQty);
            System.debug(LoggingLevel.ERROR, '111111 --> prodVcoreQty  --> ' + prodVcoreQty);
            System.debug(LoggingLevel.ERROR, 'con   --> ' + con);
            //con.Validated_by_Finance_Ops__c == false &&
            if ((prodCoreQty == 1000000 || preProdCoreQty == 1000000 || preProdVcoreQty == 1000000 || prodVcoreQty == 1000000 || con.Production_Cores__c != prodCoreQty || con.Production_VCores__c != prodVcoreQty
                    || con.Pre_Production_VCores__c != preProdVcoreQty || con.Pre_Production_Cores__c != preProdCoreQty)) {
                if (contractTotalsToUpdate.get(con.Id) != null) {
                    contractTotalsToUpdate.get(con.Id).put(Schema.Contract.Production_Cores__c, prodCoreQty);
                    contractTotalsToUpdate.get(con.Id).put(Schema.Contract.Production_VCores__c, prodVcoreQty);
                    contractTotalsToUpdate.get(con.Id).put(Schema.Contract.Pre_Production_Cores__c, preProdCoreQty);
                    contractTotalsToUpdate.get(con.Id).put(Schema.Contract.Pre_Production_VCores__c, preProdVcoreQty);
                    if(con.Validated_by_Finance_Ops__c == true && (con.Production_Cores__c != prodCoreQty || con.Production_VCores__c != prodVcoreQty
                    || con.Pre_Production_VCores__c != preProdVcoreQty || con.Pre_Production_Cores__c != preProdCoreQty)){
                        contractTotalsToUpdate.get(con.Id).put(Schema.Contract.Validated_by_Finance_Ops__c, false);
                    }
                    System.debug(LoggingLEvel.ERROR, '---> 1 -->  contractTotalsToUpdate   --> '+ contractTotalsToUpdate );

                }
            }
            //Setting the Count to Zero before looping through each Contract
            prodCoreQty = 0;
            preProdCoreQty = 0;
            preProdVcoreQty = 0;
            prodVcoreQty = 0;
        }
        System.debug(LoggingLEvel.ERROR, '---> 2 -->  contractTotalsToUpdate   --> '+ contractTotalsToUpdate );

        if(!contractTotalsToUpdate.isEmpty()){
            System.debug(LoggingLEvel.ERROR, '2---> $$$$$$ -->  INSIDE   --> ');
            CMsTriggerRunCounter.skipSubscriptionTrigger = true;
            Database.update(contractTotalsToUpdate.values());
        }
    }
}