/*********************************************************************
*
*   File Name: ActivityCountHandler.cls
*
*   File Description: Class handling business logic for triggers on
*   the Task object: It is ecuted on Task-After Insert Update Delete
*   and Undelete.
*
**********************************************************************
*
*   Date            Author          Change
*   08/29/14        Rob             Added Email to TASKTYPE
* 
*   08/21/14        Rob             Update to count activity for emails
*                                   using the Type field
*   07/29/14        Rob             Initial Creation                          
*
*   03/13/18        Sid             - Removed the Inner query to fix
*                                   production issue when more than 200
*                                   activities are present
*                                   - Code Refactoring
*********************************************************************/
public with sharing class ActivityCountHandler {

    private static final list<string> TASKCALLTYPE= new list<string>{'Connected - Call','AE Connect','E-mail','LinkedIn','On-site Meeting with AE','Call - No Message','Call - LM1','Call - LM2','Call - LM3','Call - LM4'};
    private static final list<string> TASKCALLTYPELIVECONNECTS= new list<string>{'AE Connect','On-site Meeting with AE','Connected - Call','AE Connect Scheduled - Call','Call - Stakeholder Connect Scheduled','Stakeholder connect completed','C-level connect completed','C_level_connect_scheduled_Call'};
    private static final string PREFIXLEAD ='00Q';
    private static final string PREFIXCONTACT ='003';
    private static final set<string>TASKTYPE= new set<string>{'E-mail','Email'};
    private static map<id,Task>taskMap =new  map<id,Task>();

    public static void updateActivityCount(list<Task> taskList) {
        set<id>leadIds=new set<id>();
        set<id>conIds=new set<id>();
        set<id>accountIds =new set<id>();
        Id taskCallLogRTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call Log').getRecordTypeId();
        for (Task t : taskList) {
            if(t.RecordTypeId == taskCallLogRTId) {
                if (t.WhoId != null && String.valueOf(t.WhoId).startsWith(PREFIXLEAD)) {
                    leadIds.add(t.WhoId);
                } else if (t.WhoId != null && String.valueOf(t.WhoId).startsWith(PREFIXCONTACT) ) {
                    conIds.add(t.WhoId);
                    taskMap.put(t.WhoId,t);
                }
            }
        }

        for(contact con :[SELECT accountid FROM contact WHERE Id IN:conIds]){
            if(con.AccountId!=null) {
                accountIds.add(con.accountid);
            }
        }

        if(!leadIds.isEmpty()) {
            updateActivityCountForLead(leadIds);
        }

        if(!conIds.isEmpty()) {
            validateAccount(accountIds);
            updateActivityCountForContact(conIds);
        }
    }

    /**
    * Method to validate Account for Billing Country
    */
    private static void validateAccount(set<id>accIds) {
        if(!accIds.isEmpty()) {
            for(Account acc:[SELECT id ,BillingCountry ,(SELECT Id FROM Contacts) FROM Account WHERE ID IN:accIds]){
                if(acc.BillingCountry=='' || acc.BillingCountry==null) {
                    for(contact c: acc.Contacts) {
                        Task orignalTask= taskMap.get(c.id);
                        orignalTask.addError('Billing Country is Required on the Account');
                    }
                }
            }
        }
    }

    /**
    * Method to update the Activity count on lead
    */
    private static void updateActivityCountForLead(set<id>leadIds) {
        List<Lead> updateLeads = new List<Lead>();
        Map<id,Integer>leadAttemptsCountMap = new Map<id,Integer>();
        Map<id,Integer>leadLiveConnectMap = new Map<id,Integer>();
        list<lead>leadList= new list<lead>();
        map<id,Lead>leadUpdatedMap= new  map<id,Lead>();
        set<id>tIds= new set<id>();
        for(Lead l :[SELECT Id, Attempts__c,Live_Connects__c,Status_Changed_To_Open_Date__c FROM Lead WHERE ID IN:leadIds limit 50000]){
            leadUpdatedMap.put(l.Id,l);
        }
        for(Task t:[SELECT Call_Type__c,CreatedDate, whoid FROM Task WHERE (Call_Type__c IN:TASKCALLTYPE OR Type IN:TASKTYPE) AND whoid IN:leadIds]){
            Lead l=leadUpdatedMap.get(t.whoid);
            datetime defaultTime;
            if(l.Status_Changed_To_Open_Date__c != null){
                defaultTime=l.Status_Changed_To_Open_Date__c;
            } else {
                defaultTime=Datetime.newInstance(1900, 01, 01);
            }
            if(t.CreatedDate > defaultTime){
                tIds.add(t.id);
            }
        }

        List<Task> leadTasksWithCallTypes= [SELECT whoId,Call_Type__c,CreatedDate FROM Task WHERE (Call_Type__c IN:TASKCALLTYPE OR Type IN:TASKTYPE) AND  who.type = 'Lead' AND id IN: tIds];
        Map<Id, List<Task>> leadIdToAllTaskMap = new Map<Id, List<Task>>();
        for(Task t : leadTasksWithCallTypes){
            if(leadIdToAllTaskMap.containsKey(t.WhoId)){
                leadIdToAllTaskMap.get(t.whoId ).add(t);
            }else {
                List<Task> taskList=new List<Task>();
                taskList.add(t);
                leadIdToAllTaskMap.put(t.whoId,taskList);
            }
        }

        for(Lead l :[SELECT id, Attempts__c,Live_Connects__c FROM Lead WHERE ID IN:leadIds limit 50000]) {
            if(leadIdToAllTaskMap.get(l.Id) != null){
                leadAttemptsCountMap.put(l.id,leadIdToAllTaskMap.get(l.Id).size());
                leadList.add(l);
            }
        }
        System.debug(LoggingLevel.ERROR, 'leadAttemptsCountMap  --> '+ leadAttemptsCountMap);
        System.debug(LoggingLevel.ERROR, 'leadList  --> '+ leadList);


        List<Task> leadsWithLiveConnects= [SELECT whoId,Call_Type__c,CreatedDate FROM Task WHERE Call_Type__c IN:TASKCALLTYPELIVECONNECTS AND  who.type = 'Lead' AND id IN: tIds];
        System.debug(LoggingLevel.ERROR, 'leadsWithLiveConnects  --> '+ leadsWithLiveConnects);
        Map<Id, List<Task>> leadIdToAllTaskLiveConnectMap = new Map<Id, List<Task>>();
        for(Task t : leadsWithLiveConnects){
            if(leadIdToAllTaskLiveConnectMap.containsKey(t.WhoId)){
                leadIdToAllTaskLiveConnectMap.get(t.whoId ).add(t);
            }else {
                List<Task> taskList=new List<Task>();
                taskList.add(t);
                leadIdToAllTaskLiveConnectMap.put(t.whoId,taskList);
            }
        }

        System.debug(LoggingLevel.ERROR, 'leadIdToAllTaskLiveConnectMap  --> '+ leadIdToAllTaskLiveConnectMap);
        for(Lead l1 :[SELECT id, Attempts__c,Live_Connects__c FROM Lead WHERE ID IN:leadIds limit 50000]) {
            if(leadIdToAllTaskLiveConnectMap.get(l1.Id) != null){
                leadLiveConnectMap.put(l1.id,leadIdToAllTaskLiveConnectMap.get(l1.Id).size());
            }
        }

        System.debug(LoggingLevel.ERROR, 'leadLiveConnectMap  --> '+ leadLiveConnectMap);

        for(Lead l:leadList) {
            Integer AttemptsCount = leadAttemptsCountMap.get(l.id);
            Integer LiveConnect = leadLiveConnectMap.get(l.id);
            if(AttemptsCount != l.Attempts__c || LiveConnect != l.Live_Connects__c)
            {
                l.Attempts__c = AttemptsCount;
                l.Live_Connects__c = LiveConnect;
                updateLeads.add(l);
            }
        }

        if(!updateLeads.isEmpty()) {
            update updateLeads;
        }
    }

    /**
    * Method to update the Activity count on Contact
    */
    private static void updateActivityCountForContact(set<id>contactIds)
    {
        List<Contact> updateContact = new List<Contact>();
        Map<id,Integer>contactAttemptsCountMap = new Map<id,Integer>();
        Map<id,Integer>contactLiveConnectMap = new Map<id,Integer>();
        map<id,Contact>contactUpdatedMap= new  map<id,Contact>();
        set<id>tIds= new set<id>();
        list<Contact>contactList= new list<Contact>();
        for(Contact con :[SELECT id, AccountId,Attempts__c,Live_Connects__c,Status_Changed_To_Open_Date__c FROM Contact WHERE ID IN:contactIds limit 50000]) {
            contactUpdatedMap.put(con.id,con);
        }
        System.debug(LoggingLevel.ERROR, 'contactUpdatedMap . --> '+ contactUpdatedMap);
        for(Task t:[SELECT Call_Type__c,CreatedDate, whoid FROM Task WHERE  (Call_Type__c IN:TASKCALLTYPE OR Type IN:TASKTYPE) AND whoid IN:contactIds]) {
            Contact Con=contactUpdatedMap.get(t.whoid);
            datetime defaultTime;
            if(Con.Status_Changed_To_Open_Date__c != null) {
                defaultTime=Con.Status_Changed_To_Open_Date__c;
            } else {
                defaultTime=Datetime.newInstance(1900, 01, 01);
            }

            if(t.CreatedDate > defaultTime) {
                tIds.add(t.id);
            }
        }
        System.debug(LoggingLevel.ERROR, 'tIds  --> '+ tIds);

        List<Task> tasksWithTaskCallTypes= [SELECT whoId,Call_Type__c,CreatedDate FROM Task WHERE (Call_Type__c IN:TASKCALLTYPE OR Type IN:TASKTYPE) AND  who.type = 'Contact' AND id IN: tIds];
        System.debug(LoggingLevel.ERROR, 'tasksWithTaskCallTypes  --> '+ tasksWithTaskCallTypes);
        Map<Id, List<Task>> contactIdToAllTaskMap = new Map<Id, List<Task>>();
        for(Task t : tasksWithTaskCallTypes){
            if(contactIdToAllTaskMap.containsKey(t.WhoId)){
                contactIdToAllTaskMap.get(t.whoId ).add(t);
            }else {
                List<Task> taskList=new List<Task>();
                taskList.add(t);
                contactIdToAllTaskMap.put(t.whoId,taskList);
            }
        }

        System.debug(LoggingLevel.ERROR, 'contactIdToAllTaskMap  --> '+ contactIdToAllTaskMap);
        for(Contact con :[SELECT id, AccountId,Attempts__c,Live_Connects__c FROM Contact WHERE ID IN:contactIds LIMIT 50000]) {
            if(contactIdToAllTaskMap.get(con.Id) != null){
                contactAttemptsCountMap.put(con.id,contactIdToAllTaskMap.get(con.Id).size());
                contactList.add(con);
            }
        }
        System.debug(LoggingLevel.ERROR, 'contactList  --> '+ contactList);


        List<Task> tasksWithLiveConnects= [SELECT whoId,Call_Type__c,CreatedDate FROM Task WHERE Call_Type__c IN:TASKCALLTYPELIVECONNECTS AND  who.type = 'Contact' AND Id IN: tIds];
        System.debug(LoggingLevel.ERROR, 'tasksWithLiveConnects  --> '+ tasksWithLiveConnects);
        Map<Id, List<Task>> contactIdToAllTaskLiveConnectMap = new Map<Id, List<Task>>();
        for(Task t : tasksWithLiveConnects){
            if(contactIdToAllTaskLiveConnectMap.containsKey(t.WhoId)){
                contactIdToAllTaskLiveConnectMap.get(t.whoId ).add(t);
            }else {
                List<Task> taskList=new List<Task>();
                taskList.add(t);
                contactIdToAllTaskLiveConnectMap.put(t.whoId,taskList);
            }
        }
        System.debug(LoggingLevel.ERROR, 'contactIdToAllTaskLiveConnectMap  --> '+ contactIdToAllTaskLiveConnectMap);
        for(Contact con1 :[SELECT id, AccountId,Attempts__c,Live_Connects__c FROM Contact WHERE ID IN:contactIds LIMIT 50000]) {
            if(contactIdToAllTaskLiveConnectMap.get(con1.Id) != null){
                contactLiveConnectMap.put(con1.id,contactIdToAllTaskLiveConnectMap.get(con1.Id).size());
            }
        }

        System.debug(LoggingLevel.ERROR, 'contactLiveConnectMap  --> '+ contactLiveConnectMap);

        for(contact con:contactList) {
            Integer AttemptsCount = contactAttemptsCountMap.get(con.id);
            Integer LiveConnect = contactLiveConnectMap.get(con.id);
            if(AttemptsCount != con.Attempts__c || LiveConnect != con.Live_Connects__c) {
                con.Attempts__c = AttemptsCount;
                con.Live_Connects__c = LiveConnect;
                updateContact.add(con);
            }
        }
        if(!updateContact.isEmpty()) {
            update updateContact;
        }
    }

    public static void updateAccountActivity(list<Contact>conList, map<id,Contact>oldContactMap) {
        set<id>accIds= new set<id>();
        for(Contact con: conList) {
            if((con.Attempts__c != null && con.Attempts__c !=oldContactMap.get(con.id).Attempts__c)
                    || (con.Live_Connects__c != null && con.Live_Connects__c != oldContactMap.get(con.id).Live_Connects__c)) {
                if(con.AccountId != null) {
                    accIds.add(con.AccountId);
                }
            }
        }
        if(!accIds.isEmpty()) {
            updateActivityFieldsOnAccount(accIds);
        }
    }

    /**
    * Method to update the Activity count on Account
    */
    private static void updateActivityFieldsOnAccount(set<id>accIds) {
        List<Account> updateAccount = new List<Account>();
        list<Account>accountList=[SELECT id,BillingCountry,Account_Attempts__c,Account_Live_Connects__c,(SELECT id ,Attempts__c,Live_Connects__c FROM Contacts)
                                  FROM Account WHERE ID IN:accIds limit 50000];
        for(Account acc:accountList) {
            acc.Account_Attempts__c = 0.0;
            acc.Account_Live_Connects__c= 0.0;
            for(Contact con : acc.Contacts) {
                decimal attemptsCount = con.Attempts__c;
                decimal liveConnectsCount = con.Live_Connects__c;
                if(attemptsCount!=null) {
                    if (acc.Account_Attempts__c != 0.0) {
                        acc.Account_Attempts__c += attemptsCount;
                    } else {
                        acc.Account_Attempts__c = attemptsCount;
                    }
                }
                if(liveConnectsCount!=null) {
                    if(acc.Account_Live_Connects__c != 0.0) {
                        acc.Account_Live_Connects__c += liveConnectsCount;
                    } else {
                        acc.Account_Live_Connects__c = liveConnectsCount;
                    }
                }
            }
            if(acc.Account_Live_Connects__c != 0.0  || acc.Account_Attempts__c != 0.0) {
                updateAccount.add(acc);
            }
        }
        if(!updateAccount.isEmpty()) {
            update updateAccount;
        }
    }

}