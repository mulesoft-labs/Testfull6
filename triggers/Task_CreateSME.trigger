trigger Task_CreateSME on Task (after insert) {
/*
    Map <string,Id> recordTypeMap = new Map<string,Id>();

    List<Request_SME__c> smeList = new List<Request_SME__c>();   
     
    List<RecordType> recTypes = [Select Id, Name From RecordType Where sObjectType = 'Task' and isActive = true ]; 
     
    for(RecordType rt : recTypes){
        System.debug('Task - Creating SME object');
        recordTypeMap.put(rt.Name, rt.Id);        
    }
    for (Task t : Trigger.new)
    {
           if(t.recordTypeId == recordTypeMap.get('Request SME')) {
               System.debug ('Task Trigger : In going to insert');
               Request_SME__c newSMERequest = new Request_SME__c();
               newSMERequest.Agenda__c = t.Agenda__c;
              
               newSMERequest.Subject__c = t.Subject;
               newSMERequest.Status__c = t.Status;
               newSMERequest.Due_Date__c = t.ActivityDate;
               newSMERequest.Submitter__c = t.CreatedById;
               newSMERequest.SubmitterManager__c = t.CreatedByManager__c;
               newSMERequest.OwnerId = t.CreatedByManager__c;
               
               newSMERequest.Request_SME_Name__c = t.Requested_SME__c;
               //newSMERequest.Owner_Manager__c = t.Manager__c;
               //newSMERequest.OwnerId = t.Manager__c;
               smeList.add(newSMERequest);
           }
                   
     }
    
    if(smeList.size() > 0){
        System.debug ('Task Trigger : In going to insert');
        insert smeList;
    }
    */
}