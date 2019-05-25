trigger TMsTemporaryEntitlementTrigger on Temporary_Entitlements__c (after update) {
	if(Trigger.isAfter && Trigger.isUpdate){
		CMsTemporaryEntitlementTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
	}
}