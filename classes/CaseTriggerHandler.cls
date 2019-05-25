/**
 * Description : CaseTriggerHandler is responsible to collect eligible  
 * records based on triggering criteria and perform the actions
 *
 * Author      : Nikhil (Perficient)
 * Date        : 29/10/2015
 * Version     : 1.0
 *
 * Version History : Nikhil 10/29/2015 Initial Development
 */
public with sharing class CaseTriggerHandler {

    public static void beforeinsert(List<Case> newCases){
        setCaseGeo(newCases);
    }

    public static void afterInsert(List<Case> newCases){
        syncLinkedJirasInsert(newCases);
    }

    public static void afterUpdate(List<Case> newCases, List<Case> oldCases){
        syncLinkedJirasUpdate(newCases, oldCases);
    }

    public static void beforeUpdate(List<Case> newCases, List<Case> oldCases){
        updateDispatchTime(newCases, oldCases);
        clearJiraValues(newCases, oldCases);
    }

    private static void clearJiraValues(List<Case> newCases, List<Case> oldCases) {
      for(Case c_new: newCases) {
            if (c_new.RecordTypeId == '012800000002y3wAAA') {
                for(Case c_old: oldCases) {
                    if (String.isBlank(c_new.Defect_ER_Number__c)) {
                        c_new.Defect_ER_Impediment__c = '';
                        c_new.Defect_ER_Status__c = '';
                        c_new.Defect_ER_Subject__c = '';
                        c_new.Defect_ER_target_timeframe__c = '';
                        c_new.Defect_ER_Type__c = '';
                    } else {
                        c_new.Defect_ER_Number__c = c_new.Defect_ER_Number__c.toUpperCase();
                        String oldDefect = c_old.Defect_ER_Number__c;
                        if (oldDefect != null && oldDefect.toUpperCase() !=  c_new.Defect_ER_Number__c) {
                            c_new.Defect_ER_Impediment__c = '';
                            c_new.Defect_ER_Status__c = '';
                            c_new.Defect_ER_Subject__c = '';
                            c_new.Defect_ER_target_timeframe__c = '';
                            c_new.Defect_ER_Type__c = '';
                        }
                    }
                    if (String.isBlank(c_new.Escalation_JIRA__c)) {
                        c_new.Escalation_JIRA_Impediment__c = '';
                        c_new.Escalation_JIRA_Status__c = '';
                        c_new.Escalation_JIRA_Subject__c = '';
                        c_new.Escalation_JIRA_Target_Timeframe__c = '';
                        c_new.Escalation_JIRA_Type__c = '';
                    } else {
                        c_new.Escalation_JIRA__c = c_new.Escalation_JIRA__c.toUpperCase();
                        String oldEscalation = c_old.Escalation_JIRA__c;
                        if (oldEscalation != null && oldEscalation.toUpperCase() !=  c_new.Escalation_JIRA__c) {
                            c_new.Escalation_JIRA_Impediment__c = '';
                            c_new.Escalation_JIRA_Status__c = '';
                            c_new.Escalation_JIRA_Subject__c = '';
                            c_new.Escalation_JIRA_Target_Timeframe__c = '';
                            c_new.Escalation_JIRA_Type__c = '';
                        }
                    }
                }
            }
        }
    }

    private static void syncLinkedJirasInsert(List<Case> newCases) {
        Map<String, List<Case>> attachToJira = new Map<String, List<Case>>();
        for (Case c_new: newCases) {
            if (c_new.RecordTypeId == '012800000002y3wAAA') {
                if (String.isNotBlank(c_new.Defect_ER_Number__c))
                    addCaseToMap(attachToJira, c_new.Defect_ER_Number__c.toLowerCase(), c_new);
                if (String.isNotBlank(c_new.Escalation_JIRA__c) && !c_new.Escalation_JIRA__c.equalsIgnoreCase(c_new.Defect_ER_Number__c))
                    addCaseToMap(attachToJira, c_new.Escalation_JIRA__c.toLowerCase(), c_new);
            }
        }
        if (!attachToJira.isEmpty()) CMsJiraUpdater.createJiraLink(JSON.serialize(attachToJira));
    }

    private static void syncLinkedJirasUpdate(List<Case> newCases, List<Case> oldCases) {
        Map<String, List<Case>> attachToJira = new Map<String, List<Case>>();
        Map<String, List<Case>> dettachFromJira = new Map<String, List<Case>>();
        Map<String, List<Case>> updateToJira = new Map<String, List<Case>>();
        for(Case c_new: newCases) {
            if (c_new.RecordTypeId == '012800000002y3wAAA') {
                for(Case c_old: oldCases) {
                    if (c_new.Defect_ER_Number__c != c_old.Defect_ER_Number__c) {
                        if (String.isNotBlank(c_new.Defect_ER_Number__c) && !c_new.Defect_ER_Number__c.equalsIgnoreCase(c_old.Escalation_JIRA__c)) {
                            addCaseToMap(attachToJira, c_new.Defect_ER_Number__c.toLowerCase(), c_new);
                        }
                        if (String.isNotBlank(c_old.Defect_ER_Number__c) && !c_old.Defect_ER_Number__c.equalsIgnoreCase(c_new.Escalation_JIRA__c)) {
                            addCaseToMap(dettachFromJira, c_old.Defect_ER_Number__c.toLowerCase(), c_old);
                        }
                    }
                    
                    // Detect escalation number change
                    if (c_new.Escalation_JIRA__c != c_old.Escalation_JIRA__c) {
                        if (String.isNotBlank(c_new.Escalation_JIRA__c) && !c_new.Escalation_JIRA__c.equalsIgnoreCase(c_old.Defect_ER_Number__c)) {
                            addCaseToMap(attachToJira, c_new.Escalation_JIRA__c.toLowerCase(), c_new);
                        }
                          
                        if (String.isNotBlank(c_old.Escalation_JIRA__c) && !c_old.Escalation_JIRA__c.equalsIgnoreCase(c_new.Defect_ER_Number__c)){
                            addCaseToMap(dettachFromJira, c_old.Escalation_JIRA__c.toLowerCase(), c_old);
                        }
                    }
                    
                    // Detect Priority or Status change
                    if ((c_new.Status != c_old.Status) || (c_new.Priority != c_old.Priority) || (c_new.AccountId != c_old.AccountId)) {
                      String defect = c_new.Defect_ER_Number__c, escalation = c_new.Escalation_JIRA__c;
                      if (String.isNotBlank(defect) && !attachToJira.containsKey(defect) && !dettachFromJira.containsKey(defect))
                        addCaseToMap(updateToJira, defect, c_new);
                        
                      if (String.isNotBlank(escalation) && !attachToJira.containsKey(escalation) && !dettachFromJira.containsKey(escalation))
                        addCaseToMap(updateToJira, escalation, c_new);
                    }
                }
            }
        }
        // Call APEX future class to update Jira system
        if (!dettachFromJira.isEmpty()) CMsJiraUpdater.destroyJiraLink(JSON.serialize(dettachFromJira));
        if (!attachToJira.isEmpty()) CMsJiraUpdater.createJiraLink(JSON.serialize(attachToJira));
        if (!updateToJira.isEmpty()) CMsJiraUpdater.updateJiraLink(JSON.serialize(updateToJira));
    }

    private static void addCaseToMap(Map<String, List<Case> > workingMap, String JiraId, Case caseToAdd) {
      if (!workingMap.containsKey(JiraId)) {
        workingMap.put(JiraId, new List<Case>());
      }
      workingMap.get(JiraID).add(caseToAdd);
    }
    
    private static void updateDispatchTime(List<Case> newCases, List<Case> oldCases) {
      for(Case c_new: newCases) {
        for(Case c_old: oldCases) {
            if (c_new.RecordTypeId == '012800000002y3wAAA') {
                if(c_old.Status == 'Work in Progress' && c_old.Dispatch_Completed__c == false) {
                  if (c_new.MsDispatching_Time__c == null) c_new.MsDispatching_Time__c = 0;
                  if ((c_new.MsDispatching_Time__c + ((Datetime.now().getTime() - c_old.LastModifiedDate.getTime()))  * 0.000016) > 9999) {
                      c_new.MsDispatching_Time__c = 9999;
                  } else {
                      c_new.MsDispatching_Time__c += ((Datetime.now().getTime() - c_old.LastModifiedDate.getTime())  * 0.000016);
                  }
                }
            }
        }
      }
    }

    //populate the Case.Geo__c with the User.UserRole on before insert
    private static void setCaseGeo(List<Case> newCases){
        Map<String,Id> caseRecTypeId =getRecordTypesByDeveloperName('Case');
        Map<String,String> userEmailRoleMap=new  Map<String,String>();
        id RecTypeId;
        if(!caseRecTypeId.IsEmpty() && caseRecTypeId.containsKey('Sales_Operations_Case')){
            RecTypeId=caseRecTypeId.get('Sales_Operations_Case');
        }
        set<string> CaseWebEmailSet = new set<string>();
        for(Case c : newCases){
            if( String.isNotBlank(c.origin) && 
                c.origin.equalsIgnoreCase('Email') &&
                String.isNotBlank(RecTypeId) && 
                c.RecordTypeId == RecTypeId &&
                String.isNotBlank(c.SuppliedEmail)){
                    CaseWebEmailSet.add(c.SuppliedEmail);
            }
        }
        
        if(!CaseWebEmailSet.IsEmpty()){
            for(user u : [SELECT UserRole.Name,Email,UserRoleId,Id 
                           FROM User 
                           WHERE Email IN :CaseWebEmailSet and IsActive=true]){
                if(String.isNotBlank(u.UserRole.Name)){
                userEmailRoleMap.put(u.Email,u.UserRole.Name);
                }else{
                userEmailRoleMap.put(u.Email,'None');
                }
            }
        }
        
        for(Case c : newCases){
            if( String.isNotBlank(c.origin) && 
                c.origin.equalsIgnoreCase('Email') &&
                String.isNotBlank(RecTypeId) && 
                c.RecordTypeId == RecTypeId &&
                String.isNotBlank(c.SuppliedEmail)){
                    if(userEmailRoleMap.containsKey(c.SuppliedEmail)){
                        if(userEmailRoleMap.get(c.SuppliedEmail).startsWithIgnoreCase('NA')){
                            c.Geo__c ='NA';
                        }else if(userEmailRoleMap.get(c.SuppliedEmail).startsWithIgnoreCase('EMEA')){
                            c.Geo__c ='EMEA';
                        }else if(userEmailRoleMap.get(c.SuppliedEmail).startsWithIgnoreCase('APAC')){
                            c.Geo__c ='APAC';
                        }else if(userEmailRoleMap.get(c.SuppliedEmail).startsWithIgnoreCase('LATAM')){
                            c.Geo__c ='LATAM';
                        }else if(userEmailRoleMap.get(c.SuppliedEmail).startsWithIgnoreCase('OEM')){
                            c.Geo__c ='OEM';
                        }else{
                            c.Geo__c ='None';
                        }
                    }                    
                }
            }
        }
    
    //Get recordtypeId by developer name
    public static Map<String,Id> getRecordTypesByDeveloperName(String objectName){
        Map<String,Id> recordTypesMap = new Map<String,Id>();
        for(RecordType rt : [SELECT Id, DeveloperName 
                                FROM RecordType
                                WHERE SObjectType = :objectName ]){
            recordTypesMap.put(rt.DeveloperName,rt.Id);
        }
        return recordTypesMap;
    }
}