/**
*	Author:- 		Andrew (Mondaycall)
*	Created:-		2/24/2014
*	Description:-	Generic class to handle all Trigger event on Win_Report__c  object
*	Revision:-	
**/
public with sharing class WinReportTriggerHandler {
	static boolean m_IsExecuting = false;
	
	//Before Insert Event Handler
	public void onBeforeInsert(List<Win_Report__c> newList){
		for(Win_Report__c wr : newList){
			validateForComplete(wr);
		}
	}
	
	//Before Update Event Handler
	public void onBeforeUpdate(List<Win_Report__c> newList){
		for(Win_Report__c wr : newList){
			validateForComplete(wr);
		}
	}
	
	
	
	//Validate Win_report__c for required field
	//If Win_Report_Complete2__c  =='Yes' then validate that below fields should not be NULL
	public Boolean validateForComplete(Win_Report__c wr){
		Boolean hasError = false;
		if(wr.Win_Report_Complete_2__c == 'Yes'){
			if(wr.Opportunity_Team__c == null){
                wr.Opportunity_Team__c.addError(Label.Win_Report_Completion_Required_Field_Error);
                hasError = true;
            }
			if(wr.Company_Description__c == null){
			 	wr.Company_Description__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Products_and_Subscription_Level__c == null){
			 	wr.Products_and_Subscription_Level__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Sales_Cycle_Start__c == null){
			 	wr.Sales_Cycle_Start__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Sales_Cycle_End__c == null){
			 	wr.Sales_Cycle_End__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Compelling_Event__c == null){
			 	wr.Compelling_Event__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Buyer_Name_Role__c == null){
			 	wr.Buyer_Name_Role__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Primary_Solution_Interest__c == null){
			 	wr.Primary_Solution_Interest__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.What_business_problem_are_they_solving__c == null){
			 	wr.What_business_problem_are_they_solving__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			 if(wr.What_business_impact_and_ROI__c == null){
			 	wr.What_business_impact_and_ROI__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Existing_Technology__c == null){
			 	wr.Existing_Technology__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			 if(wr.Competition__c == null){
			 	wr.Competition__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Key_Takeaway_on_Competition__c == null){
			 	wr.Key_Takeaway_on_Competition__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.What_is_the_use_case_s__c == null){
			 	wr.What_is_the_use_case_s__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.End_point__c == null){
			 	wr.End_point__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Partner_Influence__c == null){
			 	wr.Partner_Influence__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			if(wr.Why_did_the_customer_choose_MuleSoft__c == null){
			 	wr.Why_did_the_customer_choose_MuleSoft__c.addError(Label.Win_Report_Completion_Required_Field_Error);
			 	hasError = true;
			 }
			
		}
		return hasError;
	}
}