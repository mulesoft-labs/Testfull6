trigger setSalesAcceptedDate on Opportunity (before update) {

    /*Opportunity oppty = trigger.new[0];
    if (oppty.StageName != 'Rejected Lead' && oppty.StageName != ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED && oppty.StageName != ConstantDeclarations.OPP_STAGE_5_PERCENT && (trigger.old[0].StageName == ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED || trigger.old[0].StageName == ConstantDeclarations.OPP_STAGE_5_PERCENT)) {
        oppty.Sales_Accepted_Lead_Date__c = System.today();        
    }*/
}