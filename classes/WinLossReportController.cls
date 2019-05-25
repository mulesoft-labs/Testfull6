/**
*   Author:-        Andrew (Mondaycall)
*   Created:-       2/24/2014
*   Description:-   Controller class for WinReportEmail and LossReportEmail
*                       , this class is written to send email notification from Loss/Win Report details page
*   Revision:-  
**/
public with sharing class WinLossReportController {
    public String recordId {get;set;}
    
    
    public WinLossReportController(ApexPages.StandardController stdCon){
        recordId = stdCon.getId();
    }
    
    //Action method to send Email for Win report
    public Pagereference sendWinreportEmail(){
        Boolean isError=false;
        Pagereference pg;
        Win_Report__c winReport = [Select id, Amount__c,Win_Report_Complete_2__c, Win_Report_Emailed__c from Win_Report__c where id = :recordId limit 1];
         /*
         if(winReport.Win_Report_Complete_2__c != 'Yes')
         {
             winReport.Win_Report_Complete_2__c.addError(Label.Win_Report_Completion_Required_Field_Error);          
         }
         else
         {   
            if(winReport.Amount__c != null)
            { */
                winReport.Win_Report_Emailed__c = true;
                winReport.Schedule_For_Combined_Email__c = true;
                update winReport;
                // Don't actually send the email
            //}
            
            /*
            else if(winReport.Amount__c >= 50000)
            {
                winReport.Win_Report_Emailed__c = true;
                winReport.Schedule_For_Combined_Email__c = true;
                update winReport;
                // Handle using schedule class
            }
            else if(winReport.Amount__c >= 200000)
            {
                isError = sendEmail('Win Report Email Template', 'Win Report Email Recipient');
                if(isError==false)
                {
                    pg = new Pagereference('/' + recordId);
                    winReport.Win_Report_Emailed__c = true;
                    update winReport;
                }
            }
            */
        //}
        return pg;
    }
    
    //Action method to send Email for Loss report
    public Pagereference sendLossreportEmail(){
        Pagereference pg;
        Loss_Report__c lossReport = [Select id, Loss_Report_Complete2__c from Loss_Report__c where id = :recordId limit 1];
        if(lossReport.Loss_Report_Complete2__c != 'Yes'){
            lossReport.Loss_Report_Complete2__c.addError(Label.Win_Report_Completion_Required_Field_Error);         
        }else if(sendEmail('Loss Report Email Template', 'Loss Report Email Recipient') == false){
            pg = new Pagereference('/' + recordId);
        }
        return pg;
    }
    
    //Generic method Send Email, This method accept key name fo email template & recipient and send email to contact 
    public boolean sendEmail(String emailTemplateKey, String recipientKey){
        boolean hasError = false;
        try{
            EmailTemplate et = [Select id from EmailTemplate where developerName =:KeyValueSetting__c.getInstance(emailTemplateKey).value__c limit 1];
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTemplateId(et.id);
            msg.setTargetObjectId(KeyValueSetting__c.getInstance(recipientKey).value__c);
            msg.setWhatId(recordId);
            msg.setSaveAsActivity(true);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email has been sent.'));
        }catch(Exception ex){
            Apexpages.addMessages(ex);
            hasError = true;
        }
        return hasError;
    }
    
    
    
}