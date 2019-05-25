public with sharing class LeadRecordTypeController {

	private final Lead lead;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public LeadRecordTypeController(ApexPages.StandardController stdController) {
        this.lead = (Lead)stdController.getRecord();
    }

    public String getLeadRecordType() {
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Lead.getRecordTypeInfosById();
        String recordTypeName = 'NO_RECORD_TYPE_FOUND';
        System.debug('current lead is ...' + this.lead);
        if(this.lead != null && this.lead.recordTypeId != null) {
            recordTypeName = rtMap.get(this.lead.recordTypeId).getName();
        }
        return recordTypeName;
    }
}