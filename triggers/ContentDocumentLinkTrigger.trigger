trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
	String enablementActivityIdPrefix = Enablement_Activity__c.sobjecttype.getDescribe().getKeyPrefix();
	for(ContentDocumentLink cdl: Trigger.New){
		if(String.valueof(cdl.LinkedEntityId).startswith(enablementActivityIdPrefix))
		{
			ContentDocumentLinkTriggerHandler.processcEnablementActivityFile(cdl);
			break;
		}
	}
}