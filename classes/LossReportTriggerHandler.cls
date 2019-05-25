/**
*   Author:-        Andrew (Mondaycall)
*   Created:-       2/24/2014
*   Description:-   Generic class to handle all Trigger event on Loss_Report__c  object
*   Revision:-  
**/
public with sharing class LossReportTriggerHandler {
    static boolean m_IsExecuting = false;
    
    //Before Insert Event Handler
    public void onBeforeInsert(List<Loss_Report__c> newList){
        for(Loss_Report__c lr : newList){
            validateForComplete(lr);
        }
    }
    
    //Before Update Event Handler
    public void onBeforeUpdate(List<Loss_Report__c> newList){
        for(Loss_Report__c lr : newList){
            validateForComplete(lr);
        }
    }
    
    
    
    //Validate Loss_Report__c for required field
    //If Win_Report_Complete2__c  =='Yes' then validate that below fields should not be NULL
    public Boolean validateForComplete(Loss_Report__c lr){
        Boolean hasError = false;
        if(lr.Loss_Report_Complete2__c == 'Yes'){
            if(lr.Opportunity_Team__c == null){
                lr.Opportunity_Team__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
            }
            if(lr.Company_Description__c == null){
                lr.Company_Description__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Products_and_Subscription_Level__c == null){
                lr.Products_and_Subscription_Level__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Sales_Cycle_Start__c == null){
                lr.Sales_Cycle_Start__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Sales_Cycle_End__c == null){
                lr.Sales_Cycle_End__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Compelling_Event__c == null){
                lr.Compelling_Event__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            
            if(lr.Buyer_Name_Role__c == null){
                lr.Buyer_Name_Role__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Primary_Solution_Interest__c == null){
                lr.Primary_Solution_Interest__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.What_business_problem_are_they_solving__c == null){
                lr.What_business_problem_are_they_solving__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
             if(lr.What_business_impact_and_ROI__c == null){
                lr.What_business_impact_and_ROI__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Existing_Technology__c == null){
                lr.Existing_Technology__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
             if(lr.Competition__c == null){
                lr.Competition__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Key_Takeaway_on_Competition__c == null){
                lr.Key_Takeaway_on_Competition__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.What_is_the_use_case_s__c == null){
                lr.What_is_the_use_case_s__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.End_point__c == null){
                lr.End_point__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Partner_Influence__c == null){
                lr.Partner_Influence__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
             }
            if(lr.Why_did_the_customer_not_choose_MuleSoft__c == null){
                lr.Why_did_the_customer_not_choose_MuleSoft__c.addError(Label.Loss_Report_Completion_Required_Field_Error);
                hasError = true;
            }
            //Added by Shuba
            if(lr.Chosen_Vendor__c == null){
                lr.Chosen_Vendor__c.addError(Label.Loss_Report_Completion_Required_Field_Error);
                hasError = true;
            }
            
        }
        return hasError;
    }
}