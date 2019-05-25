trigger PopulateAnypointOrganizationData on AnypointOrganization__c (after update, after insert) {
    AnypointOrganization__c[] orgs = Trigger.new;
    
    Set<String> csIDs = new Set<String>();
    for (AnypointOrganization__c org : orgs) {
        system.debug('AP organization id ' + org.CSId__c);
        if (org.CSId__c != null &&
            org.CSId__c != '') 
			csIDs.add(org.CSId__c);
    }
    
    List<Account> results = 
           [SELECT Id,AnypointPlatformOrganizationId__c from Account where AnypointPlatformOrganizationId__c in :csIDs];
    
    List<Account> toUpdate = new List<Account>();
    for (AnypointOrganization__c org : orgs) {
        if (org.CSId__c == null ||
            org.CSId__c == '') 
            continue;
        
        for (Account a : results) {
            if (a.AnypointPlatformOrganizationId__c == org.CSId__c) {
	            a.Anypoint_Organization__c = org.Id;
                toUpdate.add(a);
            }
        }
    }
    
	Database.update(toUpdate);
}