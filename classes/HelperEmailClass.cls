public class HelperEmailClass {
// used by quote trigger emailNotificatoinAfterUpdate so the trigger executes only once
   public static boolean firstRun = true;
   
   public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity ) {
    //  templateId  must be ID of an Email template
    //  targetObjId must be a Contact Id -- also used in merge fields of template recipient.xxxx
    //  whatId      must be an SObject that is used in the merge fields of the template relatedTo.xxxx
    //  fromId      if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
    //  bcc         not permitted when using templates

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    Id templateId;  
    try {templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;}
    catch (Exception e) {
        system.assert(false, 'Unable to locate EmailTemplate using name: ' + templateApiName); 
    }


    email.setToAddresses(toRecipients);
    email.setCcAddresses(ccRecipients);
    email.setTargetObjectId(targetObjId);
    email.setWhatId(whatId);
    email.setorgWideEmailAddressId(orgWideEmailId);
    email.setTemplateId(templateId);
    email.setSaveAsActivity(saveAsActivity);            // save email as activity on the targetObjId (i.e. Contact)

    System.debug('** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + templateId + ' targetObjId:' + targetObjId + 
                                    ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
    system.debug(' email = '+email);
    try {
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        return;
    }
    catch (EmailException e) {
      system.assert(false, 'sendTemplatedEmail error. ' + e.getMessage());

     }
   }

   // return true if val is in stringList, falese otherwise
   public static Boolean listContains(List<String> stringList, String val){
        for(String s : stringList){
            if (s == val)
                return true;
        }
        
        return false;
   }  
}