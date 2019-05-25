/**
*  Author:-     Andrew (Mondaycall)
*  Created:-    2/24/2014
*  Description:-  Generic class to handle all Trigger event on SC_Action__c object
*  Revision:-  
**/
public with sharing class SCActionTriggerHandler {
     static boolean m_IsExecuting = false;
    
    //After Insert event implementation
    //Requirmeent:- 
    //Submit Record for Approval AfterInsert to the SCActionApproval Process for the below Record Types:
    //    a.  RFI/RFP
    //    b.  POV
    //    c.  Event
    //    d.  Request SC/Resource
    public void onAfterInsert(Map<Id,SC_Action__c> newMap, Map<Id,SC_Action__c> oldMap){
        system.debug (' m_IsExecuting---' + m_IsExecuting);
        //Avoiding recursive call 
        if(m_IsExecuting != true){
            m_IsExecuting = true;
            
            for(SC_Action__c scAct : newMap.values()){
            system.debug('----scAct.recordTypeId ' + scAct.recordTypeId);
                        system.debug('----scAct.getRecordTypeId ' + getRecordTypeId('RFI/RFP').id);
                if( scAct.recordTypeId == getRecordTypeId('RFI/RFP').id 
                            ||  scAct.recordTypeId == getRecordTypeId('POV').id
                            || scAct.recordTypeId == getRecordTypeId('Event').id
                            || scAct.recordTypeId == getRecordTypeId('Request SC/Resource').id ){
                       system.debug('----scAct submitting request for approval - submitter ' + scAct.createdById);
                       // Create an approval request for the SC_Action__c
                       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                       req1.setComments('Submitting request for approval.');
                       req1.setObjectId(scAct.id); 
                       req1.setSubmitterId(scAct.ownerId);      
                       // Submit the approval request for the SC_Action__c
                       Approval.ProcessResult result = Approval.process(req1);     
                }            
            }
            
            m_IsExecuting = false;
        }
    }
    
    
    //Get record type information based on record Type name
    //Static method is created to avoid Round-trip calls
    static Map<String,RecordType> recordTypeMap;    
    public static RecordType getRecordTypeId(String recordTypeName){
        if(recordTypeMap == null){
            recordTypeMap = new Map<String,RecordType>();
             for(RecordType rt :  [SELECT id, DeveloperName,Name,SobjectType FROM RecordType WHERE SobjectType = 'SC_Action__c']){
                recordTypeMap.put(rt.Name, rt);
             }
        }
        return recordTypeMap.get(recordTypeName);
    }
}