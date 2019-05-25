public without sharing class CMsTemporaryEntitlementTriggerHandler {
	public static void onAfterUpdate(Map<Id,Temporary_Entitlements__c> newMap, Map<Id,Temporary_Entitlements__c> oldMap){
		createHistoryRecords(newMap,  oldMap);
	}

	private static void createHistoryRecords(Map<Id,Temporary_Entitlements__c> newMap, Map<Id,Temporary_Entitlements__c> oldMap){
		List<Temporary_Entitlement_History__c> recordsToCreate = new List<Temporary_Entitlement_History__c>();

		for(Temporary_Entitlements__c te: newMap.values()){
			Temporary_Entitlements__c oldRecord = oldMap.get(te.Id);
            if(te.Last_Approved_Days__c != oldRecord.Last_Approved_Days__c){
				Temporary_Entitlement_History__c historyRecord = new Temporary_Entitlement_History__c();
				historyRecord.Temporary_Entitlements__c = te.Id;
				historyRecord.Business_Justification__c = te.Business_Justification__c;
				historyRecord.Days_Requested__c = te.Last_Approved_Days__c - oldRecord.Last_Approved_Days__c;
				historyRecord.Start_Date__c = te.Start_Date__c.addDays(Integer.valueof(oldRecord.Last_Approved_Days__c));
				recordsToCreate.add(historyRecord);
			}			
		}

		if(!recordsToCreate.isEmpty()){
			insert recordsToCreate;
		}
	}	
}