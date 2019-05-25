trigger TMsAnypointOrganization on AnypointOrganization__c (before insert,before update,after insert,after update, before delete, after delete) {
    
    //Skip this trigger if the static variable CMsTriggerRunCounter.skipAnypointOrgTrigger == true
    if(CMsTriggerRunCounter.skipAnypointOrgTrigger){
        return;
    }
    
    new CMsAnypointOrganizationTriggerHandler().handle();
}