global class CMsNPSAlertBatch implements Schedulable, Database.Batchable<sObject>, Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext bc){
        //String npsId = 'aCM34000000TNWJGA4';
        //String query = 'SELECT Id, Account_Region__c, CSM_Email__c, Category__c, Account__r.OwnerId, Account__r.Customer_Success_Manager_new__c, Roles_and_Users__c,Processed__c,Account__r.Engagement_Manager__r.ManagerId, Account__r.Partner_Enablement_Manager__r.ManagerId, CSM__c, CSM_Direct_Manager__c, CS_Ops__c,CS_Regional_Lead__c,CS_Theater_Lead__c,CS_Global_Lead__c, AE__c, AE_Direct_Manager_RSD__c, AE_Regional_Lead_RVP__c, AE_Theater_Lead__c, AE_Global_Lead__c, Services_Regional_Lead__c,Services_Theater_Lead__c, Services_Global_Lead__c,Channels_Theater_Lead__c, Channels_Global_Lead__c, Marketing__c, Product__c, Support__c, NPS_Score__c  FROM NPS_Response__c WHERE Processed__c = False AND NPS_Score__c <5 ORDER BY CreatedDate LIMIT 10';
        String query = 'SELECT Id, Account_Region__c, CSM_Email__c, Category__c, Account__r.OwnerId, Account__r.Customer_Success_Manager_new__c, Roles_and_Users__c,Processed__c,Account__r.Engagement_Manager__r.ManagerId, Account__r.Partner_Enablement_Manager__r.ManagerId, CSM__c, CSM_Direct_Manager__c, CS_Ops__c,CS_Regional_Lead__c,CS_Theater_Lead__c,CS_Global_Lead__c, AE__c, AE_Direct_Manager_RSD__c, AE_Regional_Lead_RVP__c, AE_Theater_Lead__c, AE_Global_Lead__c, Services_Regional_Lead__c,Services_Theater_Lead__c, Services_Global_Lead__c,Channels_Theater_Lead__c, Channels_Global_Lead__c, Marketing__c, Product__c, Support__c, NPS_Score__c  FROM NPS_Response__c WHERE Processed__c = False';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<NPS_Response__c> scope){
        CMsNPSAlertsToSend npsEmailsToSend = new CMsNPSAlertsToSend();
        List<Messaging.SingleEmailMessage> npsEmails = npsEmailsToSend.getNPSEmails(scope);
        List<Messaging.SendEmailResult> resultEmail = new List<Messaging.SendEmailResult>();
        Set<Id> errors = new Set<Id>();
        try{
            resultEmail = Messaging.sendEmail(npsEmails);
            update npsEmailsToSend.unpNPS;
            update scope;
        } catch (EmailException e){
            system.assert(false, 'sendNPSAlert error. ' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
 	global void execute(SchedulableContext sc) {
        CMsNPSAlertBatch b = new CMsNPSAlertBatch(); 
        database.executebatch(b, 1);
    }    
}