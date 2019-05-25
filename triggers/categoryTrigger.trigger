trigger categoryTrigger on OpportunityLineItem (before insert, before update) {
    for (OpportunityLineItem l: Trigger.new)
        l.Rollup_Category__c = l.Category__c;
}