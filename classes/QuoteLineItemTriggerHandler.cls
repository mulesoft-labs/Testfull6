public without sharing class QuoteLineItemTriggerHandler {
	public void handleBeforeInsert(List<QuoteLineItem> newQuoteLineItemList){   
		validateUserIsAllowedToUpdateOpportunityInClosing(newQuoteLineItemList);
	}
	public void handleBeforeUpdate(List<QuoteLineItem> newQuoteLineItemList, map<Id,QuoteLineItem> oldMapQuoteLineItem){  
		validateUserIsAllowedToUpdateOpportunityInClosing(newQuoteLineItemList); 
	}
	public void handleBeforeDelete(List<QuoteLineItem> oldQuoteLineItemList){  
		validateUserIsAllowedToUpdateOpportunityInClosing(oldQuoteLineItemList); 
	}
	public void validateUserIsAllowedToUpdateOpportunityInClosing(List<QuoteLineItem> quotes){
		if(!Utilities.canUpdateOpportuniytyInClosing()){
			for(QuoteLineItem qli: quotes){
				if(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(qli.Opportunity_Record_Type_Developer_Name__c)
						|| ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(qli.Opportunity_Record_Type_Developer_Name__c)){
					qli.addError(Label.Opportunity_In_Closing_UnAuthorized_Edit);
				}
			}
		}
	}
}