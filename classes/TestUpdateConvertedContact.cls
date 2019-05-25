@isTest
private class TestUpdateConvertedContact {
    
    
    
    static testMethod void myUnitTest() {
        
        try{
        
        Lead l = new Lead();
        
        l.firstname = 'Test';
        
        l.lastname= 'Lead Ignore';
        
        l.Company = 'Test Company';
        
        l.lead_source_asset__c = 'Some product asset';
        
        insert l;
        
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.id);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        Id converted = lc.getLeadId();
        
        l = [select id,name,convertedcontactid,lead_source_asset__c from Lead where id =:converted];
        
        
        Contact c = [Select c.Id, c.lead_source_asset__c From Contact c Where c.Id = :l.ConvertedContactId limit 1];
        
        String leadAsset = l.lead_source_asset__c;
        
        String contactAsset = c.lead_source_asset__c;
        
        
        
        System.assertEquals(leadAsset,contactAsset);
        
        }Catch(Exception ex){
        }
        
        
    }
    
    
    
    
    

}