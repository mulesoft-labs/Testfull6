trigger PopulateAnypointUserDataFromContact on Contact (after insert, after update) {
	
    if(CMsTriggerRunCounter.skipContactTrigger) {
        return;
    }    
    
    Contact[] leads = Trigger.new;    
    // if a user is inserted/updated, find the matching lead based on the email
    Set<String> emails = new Set<String>();
    for (Contact l : leads) {
        emails.add(l.Email);
    }
    
    List<AnypointUser__c> results = 
           [SELECT Id, Email__c from AnypointUser__c where Email__c in :emails];
	List<AnypointUser__c> toUpdate = new List<AnypointUser__c>();
    
    for (AnypointUser__c user : results) {
        for (Contact l : leads) {
            if (user.Email__c == l.Email) {
                user.Contact__c = l.Id;
                
                boolean addToUpdate = true;
                for (AnypointUser__c updateUser : toUpdate) {
                    if (user.Id == updateUser.Id) {
                        addToUpdate = false;
                    }
                }
                
				if (addToUpdate) toUpdate.add(user);
            }
        }
    }
    
    Database.update(toUpdate);
}