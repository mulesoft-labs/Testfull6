trigger UpdateConvertedContact on Lead (after update) {
    /*
    public Integer numberofContacts {get; set;}
    // no bulk processing; will only run from the UI
    if (Trigger.new.size() == 1) {
 
        if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true) {
          // if a new contact was created
          if (Trigger.new[0].ConvertedContactId != null) {
     
            // update the converted contact with some text from the lead
            Contact c = [Select c.Id, c.Description, c.Name From Contact c Where c.Id = :Trigger.new[0].ConvertedContactId];
            c.lead_source_asset__c = Trigger.new[0].Lead_Source_Asset__c;
            c.lead_source_detail__c = Trigger.new[0].Lead_Source_Detail__c;
            
            //If the account has only 1 contact then this is the primary contact
            numberofContacts = [SELECT count() FROM Contact WHERE AccountId =:Trigger.new[0].ConvertedAccountId];
            if(numberofContacts == 1){
                c.Primary_Contact__c = true;            
            }
            update c;
     
          }
     
        }
 
    }*/
}