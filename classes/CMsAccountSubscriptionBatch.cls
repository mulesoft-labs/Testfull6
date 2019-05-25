global class CMsAccountSubscriptionBatch implements Schedulable, Database.Batchable<sObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        Set<Id> accountSet = new Set<Id>();
        List<SBQQ__Subscription__c> subList = [SELECT ID, SBQQ__Account__c FROM SBQQ__Subscription__c where Active_Subscription__c = TRUE OR SBQQ__EndDate__c = YESTERDAY];
        
        for(SBQQ__Subscription__c sub: subList ){
            accountSet.add(sub.SBQQ__Account__c);
        }
        
        String query = 'SELECT Id, Active_Subscription_Count__c, Control_Plane_Cloud__c, Control_Plane_On_Prem__c, Current_Packaging__c, Legacy_Packaging__c, Packaging__c, Runtime_Plane_Cloud__c, Runtime_Plane_On_Prem__c, Last_Subscription_End_Date__c, (SELECT ID, EndDate FROM Contracts WHERE SBQQ__ActiveContract__c = 1 ORDER BY EndDate DESC), (SELECT ID, SBQQ__Account__c, SBQQ__Product__r.Control_Plane__c, SBQQ__Product__r.Packaging__c, SBQQ__Product__r.Runtime_Plane__c, SBQQ__Contract__c, Active_Subscription__c FROM SBQQ__Subscriptions__r WHERE Active_Subscription__c = TRUE OR SBQQ__EndDate__c = YESTERDAY) FROM Account where Id=:accountSet';
      
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
    
        Map<Id,Integer> accountContractMap = new Map<Id,Integer>();        
        Map<Id, Account> accountMap = new Map<Id, Account>();
        
        List<Account> accountList = new List<Account>();
        if(!scope.isEmpty()){
            for(Account acc: scope){
                if(acc.Contracts != null){
                    accountContractMap.put(acc.Id, acc.Contracts.size());
                    for(Contract c : acc.Contracts){
                        if(c.EndDate != null && acc.Last_Subscription_End_Date__c != c.EndDate){
                            acc.Last_Subscription_End_Date__c = c.EndDate;
                            accountMap.put(acc.Id, acc);
                            break;
                        }
                    }
                       
                }
                
                    Integer cpCloud = 0;
                    Integer cpOnPrem = 0;
                    Integer packagingCurrent = 0;
                    Integer packagingLegacy = 0;
                    Integer rpCloud = 0;
                    Integer rpOnPrem = 0;
                
                if(acc.SBQQ__Subscriptions__r != null){
                
                    
                
                    for(SBQQ__Subscription__c sub :  acc.SBQQ__Subscriptions__r ){
                        if(sub.SBQQ__Product__r.Control_Plane__c == 'Cloud' && sub.Active_Subscription__c ){
                            cpCloud++;
                        }
                        else if(sub.SBQQ__Product__r.Control_Plane__c == 'On-Premise' && sub.Active_Subscription__c){
                            cpOnPrem++;
                        }
                        if(sub.SBQQ__Product__r.Runtime_Plane__c== 'Cloud' && sub.Active_Subscription__c){
                            rpCloud++;
                        }
                        else if(sub.SBQQ__Product__r.Runtime_Plane__c == 'On-Premise' && sub.Active_Subscription__c){
                            rpOnPrem++;
                        }
                        if(sub.SBQQ__Product__r.Packaging__c == 'Current' && sub.Active_Subscription__c){
                            packagingCurrent++;
                        }
                        else if(sub.SBQQ__Product__r.Packaging__c == 'Legacy' && sub.Active_Subscription__c){
                            packagingLegacy++;
                        }
                    }
                }
                
                    if(accountContractMap.get(acc.Id) != null){
                        if(acc.Active_Subscription_Count__c != accountContractMap.get(acc.Id)){
                            acc.Active_Subscription_Count__c  = accountContractMap.get(acc.Id);
                            accountMap.put(acc.Id, acc);
                        }
                    }
                
                    if(acc.Control_Plane_Cloud__c != cpCloud){
                        if(accountMap.containsKey(acc.Id)){
                            accountMap.get(acc.Id).Control_Plane_Cloud__c = cpCloud;
                        } else {
                            acc.Control_Plane_Cloud__c = cpCloud;
                            accountMap.put(acc.Id, acc);
                        }
                    }
                    
                    if(acc.Control_Plane_On_Prem__c != cpOnPrem){
                        if(accountMap.containsKey(acc.Id)){
                            accountMap.get(acc.Id).Control_Plane_On_Prem__c= cpOnPrem;
                        } else {
                            acc.Control_Plane_On_Prem__c= cpOnPrem;
                            accountMap.put(acc.Id, acc);
                        }
                    }
                    
                    if(acc.Current_Packaging__c != packagingCurrent){
                        if(accountMap.containsKey(acc.Id)){
                            accountMap.get(acc.Id).Current_Packaging__c = packagingCurrent;
                        } else {
                            acc.Current_Packaging__c = packagingCurrent;
                            accountMap.put(acc.Id, acc);
                        }
                    }
                    
                    if(acc.Legacy_Packaging__c != packagingLegacy){
                        if(accountMap.containsKey(acc.Id)){
                            accountMap.get(acc.Id).Legacy_Packaging__c = packagingLegacy;
                        } else {
                            acc.Legacy_Packaging__c = packagingLegacy;
                            accountMap.put(acc.Id, acc);
                        }
                    }
                    
                    if(acc.Runtime_Plane_Cloud__c != rpCloud){
                        if(accountMap.containsKey(acc.Id)){
                            accountMap.get(acc.Id).Runtime_Plane_Cloud__c = rpCloud;
                        } else {
                            acc.Runtime_Plane_Cloud__c = rpCloud;
                            accountMap.put(acc.Id, acc);
                        }
                    }
                    
                    if(acc.Runtime_Plane_On_Prem__c != rpOnPrem){
                        if(accountMap.containsKey(acc.Id)){
                            accountMap.get(acc.Id).Runtime_Plane_On_Prem__c = rpOnPrem;
                        } else {
                            acc.Runtime_Plane_On_Prem__c = rpOnPrem;
                            accountMap.put(acc.Id, acc);
                        }
                    }
                
            }
        }
        
        if(!accountMap.isEmpty()){
            update accountMap.values();
        }
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
    
    global void execute(SchedulableContext sc) {
        CMsAccountSubscriptionBatch b = new CMsAccountSubscriptionBatch(); 
        database.executebatch(b);
    }
    
}