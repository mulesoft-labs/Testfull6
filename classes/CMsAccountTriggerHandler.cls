public class CMsAccountTriggerHandler extends CMsBaseTriggerHandler {
	Account[] newAccounts = Trigger.New;
	Map<Id, Account> newMap = (Map<Id, Account>)Trigger.newMap;
	Map<Id, Account> oldMap = (Map<Id, Account>)Trigger.oldMap;
	public static Map<String, Industry__c> AccIndustryNameToIndustry = new Map<String, Industry__c>();
	public static Id validatedRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Validated End Customer').getRecordTypeId();

	public override void beforeInsert() {
		populateAccIndustryNameToIndustry(newAccounts);
		updateSALClassification(newAccounts);
        populateCustomerTier(newAccounts, oldMap);        
		for(Account acc : newAccounts){
			if(acc.RecordTypeId == validatedRecordTypeId){
				acc.Validated_Date__c = system.today();
				acc.Validated_By__c = UserInfo.getName();
			}
			//Compute the Potential ARR
			if(acc.Type == 'End Customer' && acc.AnnualRevenue != null && acc.AnnualRevenue > 0
					&& AccIndustryNameToIndustry != null && !AccIndustryNameToIndustry.isEmpty()){
				System.debug(LoggingLevel.ERROR, '---> AccIndustryNameToIndustry.get(acc.Industry) --> '+AccIndustryNameToIndustry.get(acc.Industry));
				System.debug(LoggingLevel.ERROR, '---> acc.AnnualRevenue --> '+acc.AnnualRevenue);
				acc.ARR_potential_Not_Indexed__c  = (Math.exp((AccIndustryNameToIndustry.get(acc.Industry).m__c) * Math.log(acc.AnnualRevenue) + (AccIndustryNameToIndustry.get(acc.Industry).b__c)));
			}
		}
	}

	public override void beforeUpdate() {
		populateAccIndustryNameToIndustry(newAccounts);
		updateSALClassification(newAccounts);
        populateCustomerTier(newAccounts, oldMap);        
		for(Account acc : newMap.values()){
			if(acc.RecordTypeId != oldMap.get(acc.id).RecordTypeId && acc.RecordTypeId == validatedRecordTypeId){
				acc.Validated_Date__c = system.today();
				acc.Validated_By__c = UserInfo.getName();
			}
			//Compute ARR Potential only when revenue/industry changes
			if(acc.Type == 'End Customer' && acc.AnnualRevenue != null && acc.AnnualRevenue > 0
					&& (acc.AnnualRevenue != oldMap.get(acc.id).AnnualRevenue || acc.Industry != oldMap.get(acc.id).Industry)
					&& AccIndustryNameToIndustry != null && !AccIndustryNameToIndustry.isEmpty()){
				System.debug(LoggingLevel.ERROR, '---> AccIndustryNameToIndustry.get(acc.Industry) --> '+AccIndustryNameToIndustry.get(acc.Industry));
				System.debug(LoggingLevel.ERROR, '---> acc.AnnualRevenue --> '+acc.AnnualRevenue);
				acc.ARR_potential_Not_Indexed__c  = (Math.exp((AccIndustryNameToIndustry.get(acc.Industry).m__c) * Math.log(acc.AnnualRevenue) + (AccIndustryNameToIndustry.get(acc.Industry).b__c)));
			}

			//When a prospect becomes a customer, the Account Classification should stay the same but Expansion Readiness should change to "Low"
			if(acc.Type == 'End Customer' && acc.Status__c != oldMap.get(acc.id).Status__c && acc.Status__c == 'Current'){
				System.debug(LoggingLevel.ERROR, 'UPDATE --> 1 ---> prospect becomes a customer  --> ');
				acc.Expansion_Readiness__c = 'Low';
			} 
		}
	}

	private static void populateAccIndustryNameToIndustry(List<Account> newAccounts){
		Set<String> accIndustryNames = new Set<String>();
		for(Account acc: newAccounts) {
			accIndustryNames.add(acc.Industry);
		}
		List<Industry__c> Industries = [SELECT MuleSoft_Industry__c,Industry__c,Industry_Group__c, m__c, b__c
		FROM Industry__c WHERE Industry__c IN :accIndustryNames];

		for(Industry__c industry: Industries) {
			AccIndustryNameToIndustry.put(industry.Industry__c, industry);
		}
		System.debug(LoggingLevel.ERROR, '---> AccIndustryNameToIndustry --> '+AccIndustryNameToIndustry);
	}

	private static void updateSalClassification(List<Account> newAccounts){
		for( Account acct: newAccounts ) {
			if( acct.AnnualRevenue >= 4000000000.00 ) {
				acct.SAL_Classification__c = 'Strategic';
			} else if(acct.AnnualRevenue <= 3999999999.99 && acct.AnnualRevenue >= 1000000000.00) {
				acct.SAL_Classification__c = 'Enterprise';
			} else if(acct.AnnualRevenue <= 999999999.99 && acct.AnnualRevenue >= 400000000.00) {
				acct.SAL_Classification__c = 'Mid-Market';
			} else {
				acct.SAL_Classification__c = 'Commercial';
			}
		}
	}
    
    private static void populateCustomerTier(List<Account> newAccounts,  Map<Id,Account> triggerOldMap){
        System.debug(LoggingLevel.ERROR, '---> Inside Populate Customer Tier --> ');
        for( Account acc: newAccounts ) {
            //New account
            if(triggerOldMap == null){
            	populateCustomerTier(acc);
            } //Updated account
			else if(!String.isblank(acc.Account_Classification__c) && acc.Account_Classification__c != triggerOldMap.get(acc.Id).Account_Classification__c
                  || !String.isblank(acc.Territory__c) && acc.Territory__c != triggerOldMap.get(acc.Id).Territory__c
                  || !String.isblank(acc.Territory__c) && acc.ARR__c != triggerOldMap.get(acc.Id).ARR__c
                ){
                    populateCustomerTier(acc);
                }
            }			
        }
    
    private static void populateCustomerTier(Account acc){
		System.debug(LoggingLevel.ERROR, 'populateCustomerTier --> '+acc);
        Integer userSegment;
        Integer arrSegment;
        Integer custTierTemp;
        if(acc.CAM__c == true){
            acc.Customer_Tier__c = 'D';
        } else {
            if(acc.Account_Classification__c == '1. Strategic' && (acc.Territory__c == 'NA' || acc.Territory__c == 'EMEA'|| acc.Territory__c == 'APAC')){
                userSegment = 3;//A
            } else if(acc.Account_Classification__c == '2. Key' && (acc.Territory__c == 'NA' || acc.Territory__c == 'EMEA')){
                userSegment = 2;//B
            } else if(acc.Account_Classification__c == '2. Key' && acc.Territory__c == 'APAC'){
                userSegment = 3;//A
            } else if(acc.Account_Classification__c == '3. Enterprise' && (acc.Territory__c == 'NA' || acc.Territory__c == 'EMEA'|| acc.Territory__c == 'APAC')){
                userSegment = 2;//B
            } else if(acc.Account_Classification__c == '4. Mid Market' && (acc.Territory__c == 'NA' || acc.Territory__c == 'EMEA' || acc.Territory__c == 'APAC')){
                userSegment = 1;//C
            } else if(acc.Account_Classification__c == '5. Commercial' && (acc.Territory__c == 'NA' || acc.Territory__c == 'EMEA' || acc.Territory__c == 'APAC')){
                userSegment = 1;//C
            }
            if(acc.Territory__c == 'NA') {
                if(acc.ARR__c >= 750000) arrSegment = 3; //A
                else if(acc.ARR__c >= 500000) arrSegment = 2;//B
                else if(acc.ARR__c < 500000) arrSegment = 1;//C
            } else if(acc.Territory__c == 'EMEA') {
                if(acc.ARR__c >= 500000) arrSegment = 3; //A
                else if(acc.ARR__c >= 350000) arrSegment = 2; //B
                else if(acc.ARR__c < 350000) arrSegment = 1; //C
            } else if(acc.Territory__c == 'APAC') {
                if(acc.ARR__c >= 400000) arrSegment = 3; //A
                else if(acc.ARR__c >= 200000) arrSegment = 2; //B
                else if(acc.ARR__c < 200000) arrSegment = 1; //C
            }
            System.debug(LoggingLevel.ERROR, 'userSegment --> '+userSegment);
            System.debug(LoggingLevel.ERROR, 'arrSegment --> '+arrSegment);
            //If ARR segment is higher than User segment, promote account
            if(arrSegment > userSegment){
                custTierTemp = arrSegment;
            } else {
                acc.Customer_Tier__c = userSegment == 3 ? 'A' : userSegment == 2 ? 'B' : userSegment == 1 ? 'C': null;
            }
            
            if(custTierTemp == 2){ //Only applies to "B" accounts
                if((acc.Territory__c == 'NA' || acc.Territory__c == 'EMEA' ||acc.Territory__c == 'APAC') && acc.Open_ACV__c >= 500000) {                
                    acc.Customer_Tier__c = 'A';
                }
            }
        }        
        
    }
    
}