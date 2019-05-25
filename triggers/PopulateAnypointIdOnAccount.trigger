trigger PopulateAnypointIdOnAccount on Account (before insert, before update) {
	
	 if(checkRecursive.runOnce()){
		
	    Account[] accounts = Trigger.new;
	    
	    // if an account is inserted, find the matching org based on the Core services ID
	    Set<String> csIDs = new Set<String>();
	    for (Account a : accounts) {
	        csIDs.add(a.AnypointPlatformOrganizationId__c);
	    }
	    
	    List<AnypointOrganization__c> results = 
	           [SELECT Id, CSId__c from AnypointOrganization__c where CSId__c in :csIDs];
	
	    for (Account a : accounts) {
	        for (AnypointOrganization__c org : results) {
	            if (org.CSId__c == a.AnypointPlatformOrganizationId__c) {
	                a.Anypoint_Organization__c = org.Id;
	            }
	        }
	    }
    
	 }
}