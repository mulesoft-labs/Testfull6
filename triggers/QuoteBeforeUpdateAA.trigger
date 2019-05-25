trigger QuoteBeforeUpdateAA on SBQQ__Quote__c (before update) {
    SBQQ__Quote__c[] changedBatch = new SBQQ__Quote__c[0];
    for (SBQQ__Quote__c nq : Trigger.new) {
        SBQQ__Quote__c oq = (SBQQ__Quote__c)Trigger.oldMap.get(nq.Id);
        if (
            (nq.StepApproved__c != oq.StepApproved__c) ||
            (nq.Requires_Tier_1_Sales_Approval__c != oq.Requires_Tier_1_Sales_Approval__c) ||
            (nq.Requires_Tier_2_Sales_Approval__c != oq.Requires_Tier_2_Sales_Approval__c) ||
            (nq.Requires_Tier_3_Sales_Approval__c != oq.Requires_Tier_3_Sales_Approval__c) ||
            (nq.Requires_Tier_1_Services_Approval__c != oq.Requires_Tier_1_Services_Approval__c) ||
            (nq.Requires_Tier_2_Services_Approval__c != oq.Requires_Tier_2_Services_Approval__c) ||
            (nq.Requires_Finance_Approval__c != oq.Requires_Finance_Approval__c) ||
            (nq.Requires_Legal_Approval__c != oq.Requires_Legal_Approval__c) ||
            (nq.SBQQ__NetAmount__c != oq.SBQQ__NetAmount__c) ||
            (nq.SBQQ__ListAmount__c != oq.SBQQ__ListAmount__c) ||
            (nq.SBQQ__LineItemCount__c != oq.SBQQ__LineItemCount__c) ||
            (nq.Special_Commercial_Terms__c != oq.Special_Commercial_Terms__c) ||
            (nq.Annual_Uplift__c != oq.Annual_Uplift__c) ||
            (nq.Year_1_Price__c != oq.Year_1_Price__c) ||
            (nq.Number_of_Years2__c != oq.Number_of_Years2__c) ||
            (nq.Credit_Amount__c != oq.Credit_Amount__c) ||
            (nq.Previous_Order_Number__c != oq.Previous_Order_Number__c) ||
            (nq.Price_Lock_Pre_Production_Cores__c != oq.Price_Lock_Pre_Production_Cores__c) ||
            (nq.Price_Lock_Production_Cores__c != oq.Price_Lock_Production_Cores__c) ||
            (nq.Price_Lock_Expiration__c != oq.Price_Lock_Expiration__c) ||
            (nq.Special_Non_Commercial_Terms__c != oq.Special_Non_Commercial_Terms__c) ||
            (nq.Services_Expiration_Date__c != oq.Services_Expiration_Date__c) ||
            (nq.Project_Specific_Department__c != oq.Project_Specific_Department__c) ||
            (nq.Project_Specific_Application__c != oq.Project_Specific_Application__c) ||
            (nq.Special_Terms__c != oq.Special_Terms__c) ||
            (nq.SBQQ__Status__c != oq.SBQQ__Status__c) ||
            (nq.Quote_Lines_Requiring_Legal_Approval__c != oq.Quote_Lines_Requiring_Legal_Approval__c)
            
        ) {
            if ((nq.Requires_Tier_1_Sales_Approval__c != oq.Requires_Tier_1_Sales_Approval__c) ||
                (nq.Requires_Tier_2_Sales_Approval__c != oq.Requires_Tier_2_Sales_Approval__c) ||
                (nq.Requires_Tier_3_Sales_Approval__c != oq.Requires_Tier_3_Sales_Approval__c) ||
                (nq.Requires_Tier_1_Services_Approval__c != oq.Requires_Tier_1_Services_Approval__c) ||
                (nq.Requires_Tier_2_Services_Approval__c != oq.Requires_Tier_2_Services_Approval__c) ||
                (nq.Requires_Finance_Approval__c != oq.Requires_Finance_Approval__c) ||
                (nq.Requires_Legal_Approval__c != oq.Requires_Legal_Approval__c) ||
                (nq.SBQQ__NetAmount__c != oq.SBQQ__NetAmount__c) ||
                (nq.SBQQ__ListAmount__c != oq.SBQQ__ListAmount__c) ||
                (nq.SBQQ__LineItemCount__c != oq.SBQQ__LineItemCount__c) ||
                (nq.Special_Commercial_Terms__c != oq.Special_Commercial_Terms__c) ||
                (nq.Annual_Uplift__c != oq.Annual_Uplift__c) ||
                (nq.Year_1_Price__c != oq.Year_1_Price__c) ||
                (nq.Number_of_Years2__c != oq.Number_of_Years2__c) ||
                (nq.Credit_Amount__c != oq.Credit_Amount__c) ||
                (nq.Previous_Order_Number__c != oq.Previous_Order_Number__c) ||
                (nq.Price_Lock_Pre_Production_Cores__c != oq.Price_Lock_Pre_Production_Cores__c) ||
                (nq.Price_Lock_Production_Cores__c != oq.Price_Lock_Production_Cores__c) ||
                (nq.Price_Lock_Expiration__c != oq.Price_Lock_Expiration__c) ||
                (nq.Special_Non_Commercial_Terms__c != oq.Special_Non_Commercial_Terms__c) ||
                (nq.Services_Expiration_Date__c != oq.Services_Expiration_Date__c) ||
                (nq.Project_Specific_Department__c != oq.Project_Specific_Department__c) ||
                (nq.Project_Specific_Application__c != oq.Project_Specific_Application__c) ||
                (nq.Special_Terms__c != oq.Special_Terms__c) ||
                (nq.SBQQ__Status__c != oq.SBQQ__Status__c)||
                (nq.Quote_Lines_Requiring_Legal_Approval__c != oq.Quote_Lines_Requiring_Legal_Approval__c)) {
                nq.Approver__c = null;
                nq.Approver2__c = null;
                nq.Approver3__c = null;
                nq.Approver4__c = null;
                nq.Approver5__c = null;
                nq.Approver6__c = null;
                nq.Approver7__c = null;
                nq.Approver8__c = null;
                nq.Approver9__c = null;
                nq.ApprovalStep__c = null;
            }
            changedBatch.add(nq);
        }
    }
    if (!changedBatch.isEmpty()) {
        SBAA.ApprovalAPI.processRecords(changedBatch, Trigger.oldMap);
    }
}