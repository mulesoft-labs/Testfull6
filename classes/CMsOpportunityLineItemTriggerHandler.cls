public with sharing class CMsOpportunityLineItemTriggerHandler {    

    public static void onBeforeInsert(List<OpportunityLineItem> newList){
        preventEditOnOpportunityInClosing(newList);
    }

    public static void onBeforeUpdate(Map<Id,OpportunityLineItem> newMap, Map<Id,OpportunityLineItem> oldMap){
        preventEditOnOpportunityInClosing(newMap.values());
    }

    public static void onBeforeDelete(Map<Id,OpportunityLineItem> oldMap){
        preventEditOnOpportunityInClosing(oldMap.values());
    }

    public static void preventEditOnOpportunityInClosing(List<OpportunityLineItem> olis){
        if(!Utilities.canUpdateOpportuniytyInClosing() && CMsTriggerRunCounter.bypassOpportunityInClosingEditValidation == false){
            for(OpportunityLineItem oli: olis){
                
                if(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(oli.Opportunity_Record_Type_Developer_Name__c)
                        || ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(oli.Opportunity_Record_Type_Developer_Name__c)){
                    oli.addError(Label.Opportunity_In_Closing_UnAuthorized_Edit);
                }
            }
        }
    }
}