global class CMsOpportunityRollupBatch implements Schedulable, Database.Batchable<sObject>, Database.stateful{    
    
    Set<Id> accountToIncludeSet = new Set<Id>();
    Set<Id> accountToExcludeSet = new Set<Id>();   
    Map<Id, Account> accountMap = new Map<Id, Account>();    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        List<Opportunity> opportunitiesClosedLastOneYear = [ SELECT Id, accountId, stagename,Training_Amount__c, Consulting_Services_Amount__c
                                                             FROM Opportunity 
                                                             WHERE closedate = LAST_N_DAYS:365 
                                                            	   AND (Training_Amount__c > 0 OR Consulting_Services_Amount__c > 0)
                                                            	   AND stagename ='Closed Won'];        
        
        for(Opportunity oppty : opportunitiesClosedLastOneYear){
            accountToIncludeSet.add(oppty.accountId);
        }

        System.debug(LoggingLevel.ERROR, '1-----> accountToIncludeSet.size() --> '+ accountToIncludeSet.size());        

		List<Account> allAccountsWithServices = [ SELECT Id, Training_Sold_Last_1_year__c,Consulting_Sold_Last_1_Year__c  
                                                  FROM Account 
                                                  WHERE Id NOT IN :accountToIncludeSet 
                                                 	    AND (Training_Sold_Last_1_year__c > 0 OR Consulting_Sold_Last_1_Year__c > 0)];        
        System.debug(LoggingLevel.ERROR, '1-----> allAccountsWithServices.size() --> '+ allAccountsWithServices.size());        
        
        for(Account acc: allAccountsWithServices){
            accountToExcludeSet.add(acc.Id);
        }
        System.debug(LoggingLevel.ERROR, '1-----> accountToExcludeSet.size() --> '+ accountToExcludeSet.size());        
        
        //Id testAccId = '0013000000EyaZnAAJ';
		String stageName = 'Closed Won';        
	    String query = 'SELECT Id,Training_Sold_Last_1_year__c, Consulting_Sold_Last_1_Year__c, (SELECT Id, Training_Amount__c, Consulting_Services_Amount__c FROM Opportunities WHERE closedate = LAST_N_DAYS:365 AND (Training_Amount__c > 0 OR Consulting_Services_Amount__c > 0) AND stagename =:stageName) FROM Account WHERE id =:accountToIncludeSet';                
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        System.debug(LoggingLevel.ERROR, '2 -----> Inside EXECUTE -----> ');
        System.debug(LoggingLevel.ERROR, '1-----> accountToIncludeSet.size() --> '+ accountToIncludeSet.size());        
        System.debug(LoggingLevel.ERROR, '1-----> accountToExcludeSet.size() --> '+ accountToExcludeSet.size());        
        if(!scope.isEmpty()){
            for(Account acc: scope){
				Decimal trainingAmt = 0;
    	        Decimal consultingAmt = 0;
                if(acc.Opportunities != null){
                    for(Opportunity opp :  acc.Opportunities ){
                        if(opp.Training_Amount__c != NULL){
                            trainingAmt += opp.Training_Amount__c;
                        }
 						if(opp.Consulting_Services_Amount__c != NULL ){
                            consultingAmt += opp.Consulting_Services_Amount__c;
                        }                        
                    }
                }                
		        System.debug(LoggingLevel.ERROR, '2 -----> trainingAmt --> '+ trainingAmt);   
		        System.debug(LoggingLevel.ERROR, '2 -----> consultingAmt --> '+ consultingAmt);   
                
				if(acc.Training_Sold_Last_1_year__c != trainingAmt){
                	if(accountMap.containsKey(acc.Id)){
                        accountMap.get(acc.Id).Training_Sold_Last_1_year__c = trainingAmt;
                    } else {
                        acc.Training_Sold_Last_1_year__c = trainingAmt;
                        accountMap.put(acc.Id, acc);
                    }
                }
                
				if(acc.Consulting_Sold_Last_1_Year__c != consultingAmt){
                	if(accountMap.containsKey(acc.Id)){
                        accountMap.get(acc.Id).Consulting_Sold_Last_1_Year__c = consultingAmt;
                    } else {
                        acc.Consulting_Sold_Last_1_Year__c = consultingAmt;
                        accountMap.put(acc.Id, acc);
                    }
                }
        	}
        }
        
        if(accountToExcludeSet.size() > 0){
            System.debug(LoggingLevel.ERROR, '2 -------->----->----->----->----->----->----->----->-----> INSIDE NULLIFYING --> ');           
            for(Id accId : accountToExcludeSet){
                if(!accountMap.containsKey(accId)){
 					accountMap.put(accId, new Account(Id = accId, Training_Sold_Last_1_year__c = 0, Consulting_Sold_Last_1_Year__c = 0));                    
                }
            }
        }
        
        if(!accountMap.isEmpty()){
			System.debug(LoggingLevel.ERROR, '2 -----> INSIDE UPDATE --> ');
		    CMsTriggerRunCounter.skipAccountTrigger = true;            
            update accountMap.values();
        }
    }  
    
    global void finish(Database.BatchableContext BC){
    
    }
    
    global void execute(SchedulableContext sc) {
        CMsOpportunityRollupBatch b = new CMsOpportunityRollupBatch(); 
        database.executebatch(b , 100);
    }
}