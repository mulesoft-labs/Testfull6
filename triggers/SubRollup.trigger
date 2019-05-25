trigger SubRollup on SBQQ__Subscription__c (after insert, after update, after delete, after undelete) {
    SBQQ__Subscription__c[] allSubs = new List<SBQQ__Subscription__c>();
    
    if (Trigger.isDelete) {
        for (SBQQ__Subscription__c s : Trigger.old){
            allSubs.add(s);
        }
    } else {
        for (SBQQ__Subscription__c s : Trigger.new){
            allSubs.add(s);
        }
    }
    
     LREngine.Context platinumfCtx = new LREngine.Context(Account.SobjectType, // parent object
                                            SBQQ__Subscription__c.SobjectType,  // child object
                                            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Account__c, // relationship field name
                                            'ProductMetalLevel__c = \'Platinum\''  // Field to rollup
                                            );
                                            
    LREngine.Context goldfCtx = new LREngine.Context(Account.SobjectType, // parent object
                                            SBQQ__Subscription__c.SobjectType,  // child object
                                            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Account__c, // relationship field name
                                            'ProductMetalLevel__c = \'Gold\''  // Field to rollup
                                            );     
                                            
    LREngine.Context silverfCtx = new LREngine.Context(Account.SobjectType, // parent object
                                            SBQQ__Subscription__c.SobjectType,  // child object
                                            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Account__c, // relationship field name
                                            'ProductMetalLevel__c = \'Silver\''  // Field to rollup
                                            );                                                                            
    
    LREngine.Context profCtx = new LREngine.Context(Account.SobjectType, // parent object
                                            SBQQ__Subscription__c.SobjectType,  // child object
                                            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Account__c, // relationship field name
                                            'Product_Tier__c = \'Professional\''
                                            );
    
    LREngine.Context entCtx = new LREngine.Context(Account.SobjectType, // parent object
                                            SBQQ__Subscription__c.SobjectType,  // child object
                                            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Account__c, // relationship field name
                                            'Product_Tier__c = \'Enterprise\''
                                            );
                                            
    platinumfCtx.add(
        new LREngine.RollupSummaryField(
            Schema.SObjectType.Account.fields.Platinum_Tier_Subscriptions__c,
            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Quantity__c,
            LREngine.RollupOperation.Count 
        )); 
                                                   
    goldfCtx.add(
        new LREngine.RollupSummaryField(
            Schema.SObjectType.Account.fields.Gold_Tier_Subscriptions__c,
            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Quantity__c,
            LREngine.RollupOperation.Count 
        )); 

    silverfCtx.add(
        new LREngine.RollupSummaryField(
            Schema.SObjectType.Account.fields.Silver_Tier_Subscriptions__c,
            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Quantity__c,
            LREngine.RollupOperation.Count 
        )); 
        
    profCtx.add(
        new LREngine.RollupSummaryField(
            Schema.SObjectType.Account.fields.Professional_Tier_Subscriptions__c,
            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Quantity__c,
            LREngine.RollupOperation.Count 
        )); 
    entCtx.add(
        new LREngine.RollupSummaryField(
            Schema.SObjectType.Account.fields.Enterprise_Tier_Subscriptions__c,
            Schema.SObjectType.SBQQ__Subscription__c.fields.SBQQ__Quantity__c,
            LREngine.RollupOperation.Count
        )); 
            
    Sobject[] platinumMasters = LREngine.rollUp(platinumfCtx, allSubs);
    Sobject[] goldMasters = LREngine.rollUp(goldfCtx, allSubs);
    Sobject[] silverMasters = LREngine.rollUp(silverfCtx, allSubs);
    Sobject[] profMasters = LREngine.rollUp(profCtx, allSubs);
    Sobject[] entMasters = LREngine.rollUp(entCtx, allSubs);
    
    // These lists may contain some of the same accounts.  
    update platinumMasters; 
    update goldMasters;
    update silverMasters;
    update profMasters;
    update entMasters;
}