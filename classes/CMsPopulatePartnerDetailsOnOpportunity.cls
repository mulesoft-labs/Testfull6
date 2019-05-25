global class CMsPopulatePartnerDetailsOnOpportunity implements Schedulable, Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        Set<Id> oppIds = new Set<Id>();
        List<Partner_Influence__c> partnerDetailsList = [SELECT Opportunity__c, Opportunity__r.stageName, Opportunity__r.type, Opportunity__r.closeDate FROM Partner_Influence__c WHERE Opportunity__r.stageName IN ('1. ID Business Initiative','2. Educate on MuleSoft Vision','3. Confirm Need & Impact','4. Validate Solution','5. Negotiate & Close','6. Submitted for Closing','7. Booking','Closed Won','Closed Lost') AND Opportunity__r.type IN ('New Business','Add-On Business','Add-On Business - Renewal Price Uplift','Add-On Business - Historical Future Dated Order') AND Opportunity__r.closeDate >= 2019-02-01 AND Opportunity__r.SI_Partner_Account_1__c = null];
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@----> Size --> '+ partnerDetailsList.size());
        
        for(Partner_Influence__c p: partnerDetailsList ){
            oppIds.add(p.Opportunity__c);
        }
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@ ----> oppIds. Size --> '+ oppIds.size());
        String query = 'SELECT id FROM Opportunity WHERE Id IN :oppIds';      
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@ ----> Inside EXECUTE --> scope size --> '+ scope.size());
        Set<Id> opptyIds = new Set<Id>();
        for(Opportunity opp: scope) {
 	    	opptyIds.add(opp.Id);
        }
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@ ----> Inside EXECUTE --> opptyIds --> '+ opptyIds);

 		Map<Id, Opportunity> OppMap  = new Map<Id, Opportunity>([SELECT id, Name,SI_Partner_Account_1__c,Org62_Lead_Sales_Partner_Role__c,App_Partner_Account_1__c,SI_Partner_Account_2__c,(SELECT Id, createddate, delivery__c, sourced__c, reseller__c, influence__c,Account__r.ParentId FROM Opp_Partner_Influence__r order by createddate asc)
                                                                 FROM Opportunity WHERE Id IN :opptyIds]);
        
        List<String> characteristics = new List<String>{'Sourced', 'Influence', 'Delivery', 'Reseller'};
        Map<String, List<Partner_Influence__c>> mapCharacteristicsTrack = new Map<String, List<Partner_Influence__c>>();
  
        for (Opportunity opp : OppMap.values()){
            System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@----> ----> Inside EXECUTE --> opp --> '+ opp);
            for(Partner_Influence__c p : opp.Opp_Partner_Influence__r){
                System.debug(LoggingLevel.ERROR, '-------> '+ p);
                for(String str : characteristics){
                    if(str == 'Sourced' && p.sourced__c == true) {
                        if(!mapCharacteristicsTrack.containsKey(str)){
                            List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
                            pList.add(p);
                            mapCharacteristicsTrack.put(str, pList);
                        } else if(mapCharacteristicsTrack.get(str) != null)
                            mapCharacteristicsTrack.get(str).add(p);
                    }
                    
                    if(str == 'Influence' && p.influence__c == true) {
                        if(!mapCharacteristicsTrack.containsKey(str)){
                            List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
                            pList.add(p);
                            mapCharacteristicsTrack.put(str, pList);
                        } else if(mapCharacteristicsTrack.get(str) != null)
                            mapCharacteristicsTrack.get(str).add(p);
                    }
                    
                    if(str == 'Delivery' && p.delivery__c == true) {
                        if(!mapCharacteristicsTrack.containsKey(str)){
                            List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
                            pList.add(p);
                            mapCharacteristicsTrack.put(str, pList);
                        } else if(mapCharacteristicsTrack.get(str) != null)
                            mapCharacteristicsTrack.get(str).add(p);
                    }
                    
                    if(str == 'Reseller' && p.Reseller__c == true) {
                        if(!mapCharacteristicsTrack.containsKey(str)){
                            List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
                            pList.add(p);
                            mapCharacteristicsTrack.put(str, pList);
                        } else if(mapCharacteristicsTrack.get(str) != null)
                            mapCharacteristicsTrack.get(str).add(p);
                    }
                }
            }           
        }        

        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@ ---->  Inside EXECUTE --> mapCharacteristicsTrack --> '+ mapCharacteristicsTrack);                                                     

        List<Partner_Influence__c> partnerDetails = [SELECT Id, Opportunity__c,Sourced__c,Influence__c,Delivery__c,Reseller__c 
                                                     FROM Partner_Influence__c 
                                                     WHERE Opportunity__c = :opptyIds];
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@ ---->  Inside EXECUTE ----> mapCharacteristicsTrack --> '+ mapCharacteristicsTrack);                                                     
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@ ---->  Inside EXECUTE ----> partnerDetails --> '+ partnerDetails);

        for(Partner_Influence__c p : partnerDetails){
            System.debug(LoggingLevel.ERROR, '2 ---> @@@@@@@@@@@@@@@@@@@@@@----> p --> '+ p);
            Opportunity opp = OppMap.get(p.Opportunity__c);
            System.debug(LoggingLevel.ERROR, '2 ---> @@@@@@@@@@@@@@@@@@@@@@----> opp --->'+ opp);            
            if(p.Sourced__c == true && mapCharacteristicsTrack.get('Sourced') != null) {
                if((mapCharacteristicsTrack.get('Sourced')[0]).Account__r.ParentId != null){
                    opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Sourced')[0]).Account__r.ParentId;
                } else {
                    opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Sourced')[0]).Account__c;
                }
                opp.Org62_Lead_Sales_Partner_Role__c = 'Sourced Lead';
            } 
            
            if(p.Sourced__c == false && p.Influence__c == true && mapCharacteristicsTrack.get('Influence') != null 
               && mapCharacteristicsTrack.get('Sourced') == null) {
                if((mapCharacteristicsTrack.get('Influence')[0]).Account__r.ParentId != null){
                    opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Influence')[0]).Account__r.ParentId;
                } else {
                    opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Influence')[0]).Account__c;
                }
                opp.Org62_Lead_Sales_Partner_Role__c = 'Joint Sales';
            } 
            if(p.Delivery__c == true && mapCharacteristicsTrack.get('Delivery') != null) {
                if((mapCharacteristicsTrack.get('Delivery')[0]).Account__r.ParentId != null){
                    opp.SI_Partner_Account_2__c = (mapCharacteristicsTrack.get('Delivery')[0]).Account__r.ParentId;
                } else {
                    opp.SI_Partner_Account_2__c = (mapCharacteristicsTrack.get('Delivery')[0]).Account__c;
                }
            } 
            if(p.Reseller__c == true && mapCharacteristicsTrack.get('Reseller') != null) {
                if((mapCharacteristicsTrack.get('Reseller')[0]).Account__r.ParentId != null){
                    opp.App_Partner_Account_1__c = (mapCharacteristicsTrack.get('Reseller')[0]).Account__r.ParentId;
                } else {
                    opp.App_Partner_Account_1__c = (mapCharacteristicsTrack.get('Reseller')[0]).Account__c;
                }
            }
        }
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ---> @@@@@@@@@@@@@@@@@@@@@@----> OppMap.values() --->'+ OppMap.values());
        if(!OppMap.isEmpty()){
            CMsTriggerRunCounter.skipOppTrigger = true;            
            update OppMap.values();
        }         
    }

    global void finish(Database.BatchableContext BC)
    {
    }
    
    global void execute(SchedulableContext sc) {
        CMsPopulatePartnerDetailsOnOpportunity b = new CMsPopulatePartnerDetailsOnOpportunity(); 
        database.executebatch(b , 1);
    }
    
}