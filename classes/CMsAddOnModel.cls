public with sharing class CMsAddOnModel {

    public List<Account> accounts {get;set;}

    public CMsAddOnModel(ApexPages.StandardController stdController) {
        accounts = [SELECT  Account_Plan__c, Executive_Customer_Engagement__c, Business_Outcomes_Platform_Benefits__c,
                Delivery_Capability__c, Promoter__c, Success_Plan__c,
                OBD_Buy_In__c,Mobilizer__c,
                Strategic_Importance_of_Mulesoft__c,
                No_Product_Challenges__c,C4E__c,
                Strategic_Architect__c,Evangelism__c,
                In_Prod__c,Reuse_Exchange__c,
                First_Proof_of_Success__c,Internal_Support__c,
                IT_Roadmap__c,Training__c,
                Current_Health_Status__c,Risk_Mitigation_Plan_Owner__c, If_there_s_risk_what_is_the_issue__c,If_risk_what_is_the_plan_to_mitigate__c,
                Customer_Expansion_Score__c , Customer_Health_Score__c, Key_Risk_Category__c, API_Maturity__c 
        FROM Account
        WHERE id =:((Account)stdController.getRecord()).Id];
    }

    public void Save() {
        update accounts[0];
    }
}