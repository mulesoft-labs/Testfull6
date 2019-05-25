trigger PopulateAnypointUserData on AnypointUser__c (before update, before insert) {
    AnypointUser__c[] users = Trigger.new;
    
    // if a user is inserted/updated, find the matching lead based on the email
    Set<String> emails = new Set<String>();
    for (AnypointUser__c user : users) {
        emails.add(user.Email__c);
    }
    
    List<Lead> results = 
           [SELECT Id, Email, IsConverted from Lead where Email in :emails];

    for (Lead l : results) {
        for (AnypointUser__c user : users) {
            if (user.Email__c == l.Email && !l.IsConverted) {
                user.Lead__c = l.Id;
            }
        }
    }
    
    // now do the same for contacts
    
    Contact[] contacts = 
           [SELECT Id,Email,Contact.Account.Anypoint_Organization__c from Contact 
                where Email in :emails];
    
    for (AnypointUser__c user : users) {
        // Find the best match contact. First try for a contact inside the Account,
        // but if it doesn't exist just find another contact somewhere
        Contact bestMatch = null;
        for (Contact c : contacts) {
            if (c.Account.Anypoint_Organization__c == user.Anypoint_Organization_Id__c &&
               	c.Email == user.Email__c) {
                bestMatch = c;
                break;
            }
        }
        
        if (bestMatch == null && contacts.size() > 0) {
			 for (Contact c : contacts) {
                 if (c.Email == user.Email__c) {
                     bestMatch = c;
                 }   
             }
        }
        
        if (bestMatch != null) {
            user.Contact__c = bestMatch.Id;
        }

    }
}