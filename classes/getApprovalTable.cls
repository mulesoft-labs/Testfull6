public without sharing class getApprovalTable {
    
    public Id quoteId {get;
                       set{
                           quoteId = value; getApprovalTable();
                       }}
    public string field_set_name {get;
                                  set{
                                      field_set_name = value; getApprovalTable();
                                  }}
    public List<sbaa__Approval__c> Approvals {get;set;}
    Public Schema.FieldSet Fs {get;set;}
    public List<Schema.FieldSetMember> getFields() {
        if(Fs == null) return new List<Schema.FieldSetMember>();
        return Fs.getFields();
    }

    
    public void getApprovalTable(){
        system.debug('component ctrl quoteId: ' + quoteId);
        system.debug('component ctrl field_set_name: ' + field_set_name);
        
        if(quoteId != null){
            string query = ' Select Id, sbaa__Approver__r.Name, sbaa__Approver__c, sbaa__AssignedTo__r.Name  ';
            if(field_set_name != null){
                try{
                    //set the field set for page to have access to
                    Fs = Schema.SObjectType.sbaa__Approval__c.fieldSets.getMap().get(field_set_name);
                    
                    //loop through fields on given field set for the approval object
                    for(Schema.FieldSetMember fsm : Fs.getFields()/*Schema.SObjectType.sbaa__Approval__c.fieldSets.getMap().get(field_set_name).getFields()*/ ){
                        //filter out fields already selected
                        if(fsm.getFieldPath() != 'sbaa__Approver__c' && fsm.getFieldPath() != 'Id'){
                            query += ' , ' + fsm.getFieldPath();
                        }
                    }
                } Catch(Exception ex){
                    system.debug('problem fetching fields: ' + ex);
                }
                
            }
            
            
            query += ' From sbaa__Approval__c Where Quote__c = \'' + quoteId + '\' AND sbaa__Archived__c = false ORDER BY sbaa__ApprovalStep__c, sbaa__AssignedTo__r.Name ASC';
            
            Approvals = Database.query(query);
        }
        system.debug('component ctrl Approvals: ' + Approvals);
    }
}