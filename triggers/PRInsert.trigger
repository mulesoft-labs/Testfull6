trigger PRInsert on Presales_Request__c (before insert) {

     for (Presales_Request__c p:trigger.new){
        Opportunity o = [SELECT OwnerId, Name, Profile_and_Qualifications__c from Opportunity WHERE id=:p.Opportunity__c];
        //Trigger.new[0].OpportunityOwner__c=o.OwnerId;
        User u = [SELECT Name, Email from User WHERE id=:o.OwnerId];
        User pu = [SELECT Name, Email from User WHERE id=:Trigger.new[0].OwnerId];
        Trigger.new[0].Opportunity_Owner_Email__c = u.Email;
        Trigger.new[0].Opportunity_Owner_Name__c=u.Name;
        Trigger.new[0].Presales_Request_Owner_Name__c = pu.Name;
        Trigger.new[0].Opportunity_Name__c =o.Name;
        if(o.Profile_and_Qualifications__c != null)
        {
            Trigger.new[0].Profile_and_Qualifications__c=o.Profile_and_Qualifications__c;
        }
    }

}