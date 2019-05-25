/**
 * Test Class for WinLossReport 
 */
@isTest
private class WinLossReportTest {
    static Opportunity opp;
    static Contact testContact;
    static{
        Account Acc1 = new Account(Name='TestAccount',BillingCountry='US');
        insert Acc1;
        opp = new Opportunity(Name='Oppty_test1', AccountID = Acc1.ID, StageName='Sales Qualified Lead',Type ='Renewal', CloseDate=System.Today(), Opportunity_Source__c ='Direct', Primary_Solution_Interest__c = 'SOA');  
        insert opp;
        testContact = new Contact(FirstName = 'test', LastName = 'test', AccountId = Acc1.id, Email = 'test@test.com');
        insert testcontact;
    }
    
    static testMethod void testLossReport() {
        Loss_Report__c lr = new Loss_Report__c();
        lr.Opportunity__c = opp.id;
        lr.What_business_impact_and_ROI__c = 'test';
        lr.Sales_Cycle_End__c = Date.today();
        lr.Sales_Cycle_Start__c = date.today();
        lr.Loss_Report_Complete2__c = 'No';
        lr.Competition__c = 'IBM';
        lr.Compelling_Event__c = 'test';
        insert lr;
        
        try{
            lr.Loss_Report_Complete2__c = 'Yes';
            update lr;
        }catch(Exception ex){
            
        }
        
        WinLossReportController con = new WinLossReportController(new ApexPages.Standardcontroller(lr));
        con.sendLossreportEmail();
    }
    
    static testMethod void testWinReport() {
        Win_Report__c winReport = new Win_Report__c();
        winReport.Opportunity__c = opp.id;
        winReport.What_business_impact_and_ROI__c = 'test';
        winReport.Customer_Reference_Calls_Used_to_Win__c = 'No';
        winReport.Employees__c = '20';
        winReport.End_point__c  = 'Na';
        winReport.How_Were_We_Introduced_to_the_Account__c  = 'NA';
        winReport.Explanation_for_Other_Use_Cases__c  = 'NA';
//        winReport.Industry__c = 'Na';
winReport.Initial_Project__c  = 'NA';
winReport.Stage_in_SOA_Implementation__c  = 'Na';
winReport.Subscription_Level__c  = 'NA';
winReport.Why_did_the_customer_choose_EE_for_ESB__c  = 'Na';
winReport.Customer_Reference_Details__c = 'Na';
        winReport.Sales_Cycle_End__c = Date.today();
        winReport.Sales_Cycle_Start__c = date.today();
        winReport.Win_Report_Complete_2__c = 'No';
        winReport.Business_Background__c = 'NA';
        winReport.Competition__c = 'IBM';
        winReport.Compelling_Event__c = 'test';
        winReport.Buyer_Name_Role__c = 'NA';
        insert winReport;
        
        try{
            winReport.Win_Report_Complete_2__c = 'Yes';
            update winReport;
        }catch(Exception ex){
            
        }
        
        
        WinLossReportController con = new WinLossReportController(new ApexPages.Standardcontroller(winReport));
        con.sendWinreportEmail();
        KeyValueSetting__c setting = new KeyValueSetting__c(Name = 'Win Report Email Template', value__c = 'Win_Report_Email_2014');
        insert setting;
        setting = new KeyValueSetting__c(Name = 'Win Report Email Recipient', value__c = testContact.id);
        insert setting;
        con.sendEmail('Win Report Email Template', 'Win Report Email Recipient');
    }
    
    
}