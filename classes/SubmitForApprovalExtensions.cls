public class SubmitForApprovalExtensions {
    
    public Opportunity opp { get; set; }
    public SubmitForApprovalExtensions( Apexpages.StandardController controller){
        opp = ( Opportunity ) controller.getRecord();
        String query = 'SELECT ';
        for( String field : Schema.SObjectType.Opportunity.fields.getMap().keySet() ){
            query += field + ' , ';
        }
        if( query.endsWith(', ')){
            query = query.substring(0, query.length() -2);            
        }
        query += 'FROM Opportunity WHERE Id =\'' + opp.Id + '\'';
        opp = Database.query(query);
    }
    
    public pageReference submitPage(){
        System.savePoint sp = Database.setSavepoint();
        try{
            if( !opp.Custom_Approval_Process__c ){
                opp.Custom_Approval_Process__c = true;
        		update opp;
                submitApprovalProcess();
            }else{
                //opp.Custom_Approval_Process__c = false;
               // update opp;
                List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId 
                                                           FROM ProcessInstanceWorkitem 
                                                           WHERE ProcessInstance.TargetObjectId =: opp.Id ];
                if( !workItems.isEmpty() ){
                    return new PageReference('/'+ workItems[0].Id+'/e?et=REMOVE&retURL=%2F'+opp.Id);
                }
            }        
        }catch( Exception ex ){
            Database.rollback(sp);
            return throwException( ex );
        }
        return new PageReference('/' + opp.Id );
    }
    
    public void submitApprovalProcess(){
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        system.debug(req.getSkipEntryCriteria());
        req.setObjectId(opp.id);
        Approval.ProcessResult processResult = Approval.process( req );
        if( Approval.isLocked(opp.Id)){
            Approval.UnlockResult unlockResult = Approval.Unlock(opp, false);
        }
    }
    public pageReference submitForApproval(){      
        System.savePoint sp = Database.setSavepoint();
        try{
            opp.Custom_Approval_Process__c = true;
            update opp;
            submitApprovalProcess();
            return new PageReference('/' + opp.Id );
        }catch(Exception ex){
            Database.rollback(sp);
            return throwException( ex );
        }
    }
    
    public pageReference throwException( Exception ex ){
        if( ex.getMessage() != null && ex.getMessage().contains('NO_APPLICABLE_PROCESS')){
            String errorMsg = Label.Approval_Process_Error;                
            for( ProcessDefinition process : [SELECT Description,DeveloperName,Id,LockType,Name,State,TableEnumOrId,Type 
                                              FROM ProcessDefinition 
                                              WHERE LockType = 'Workitem' 
                                              AND State = 'Active'
                                              AND TableEnumOrId = 'Opportunity' 
                                              AND Type = 'Approval'] ){	
                                                  if( process.Description != null ){
                                                  	errorMsg += process.Description + '<br/>';
                                                  }
                                              }
            Apexpages.addMessage( new ApexPages.message( Apexpages.Severity.ERROR, errorMsg ) );
            
        }else{
            Apexpages.addMessage( new ApexPages.message( Apexpages.Severity.ERROR, ex.getMessage() ) );
        }
        return null;
    }
    
    public pageReference backToOpportunity(){
        return new PageReference('/' + opp.Id );
    }
    
    public Map<String, List<Schema.FieldSetMember>> getFieldSetNameToFieldsMap(){
		Map<String, List<Schema.FieldSetMember>> fieldSetNameToFieldsMap = new Map<String, List<Schema.FieldSetMember>>();
        Map<String, Schema.FieldSet> fsMap = Schema.SObjectType.Opportunity.fieldSets.getMap();
        system.debug(fsMap);
        for( Schema.FieldSet fs : fsMap.values() ){
            if( !fieldSetNameToFieldsMap.containsKey(fs.label) && fs.name.startsWith('Section') && fsMap.get(fs.name) != null ){
                fieldSetNameToFieldsMap.put( fs.label, fsMap.get(fs.name).getFields() );
            }                    
        }
        return fieldSetNameToFieldsMap;
    }
    
    public PageReference saveOpportunity(){
        try{
            opp.Custom_Approval_Process__c = false;
            update opp;
        }catch( exception ex ){
            Apexpages.addMessage( new ApexPages.message( Apexpages.Severity.ERROR, ex.getMessage() ) );            
        }
        return null;
    }
    	
}