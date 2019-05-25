trigger emailNotificatoinAfterUpdate on SBQQ__Quote__c (after update) {
/*
*  If the quote status is now approved and previously it was not, see if email notificatoins need to be sent to all approvers.
*  If checked, then send an email using the selected template.
*/  
   if(HelperEmailClass.firstRun){
     HelperEmailClass.firstRun=false; // prevent this from firing twice which will happen (before and after workflow).
     for (SBQQ__Quote__c updatedQuote : Trigger.new) {
        if ( updatedQuote.ApprovalStatus__c == 'Approved') {
            // check previous status value, has it changed?
            if (Trigger.oldMap.get(updatedQuote.Id).ApprovalStatus__c != updatedQuote.ApprovalStatus__c){ 
                system.debug('emailNotificatoinAfterUpdate:  Send out email notificatoin!');
                // get a list of approvers for the email to be sent to
                List<sbaa__Approval__c> approvalList = [Select id,sbaa__Approver__c From sbaa__Approval__c
                                                            Where Quote__c = :updatedQuote.id];
                // build a list of toRecipients
                List<String> toRecipients = new List<String>(); // recipients will be a lsit of user Id's
                List<sbaa__Approver__c> approvers= new  List<sbaa__Approver__c>();
                // the user Id will be used for the targetObjId in sendEmail
                Id userForTarget;
                for (sbaa__Approval__c al : approvalList){
                    // pull approvers out of approval list
                   approvers= [SELECT sbaa__User__c From sbaa__Approver__c Where Id = :al.sbaa__Approver__c Limit 1];
                    // sbaa__Approver__c:{sbaa__User__c=00580000006NYVuAAO, Id=a5C800000008ThlEAE})
                   if (approvers.size()>0) {
                       system.debug('emailNotificatoinAfterUpdate: approvers = '+approvers);
                       User approvedUser = [Select Id,Email From User Where Id =:approvers[0].sbaa__User__c];
                       if (approvedUser != null){
                        String s;
                         // filter out emails that should not be sent. Caroline may have others.
                         // don't duplicate emails so if same person approved previously don't add again
                         if ((approvedUser.Email != 'salesops@mulesoft.com') && 
                             (!HelperEmailClass.listContains(toRecipients,approvedUser.Email))){
                             toRecipients.add(approvedUser.Email);
                             userForTarget = approvedUser.Id;
                         }
                       }
                       else {
                         // no approvers so go to next in approvalList
                         system.debug('emailNotificatoinAfterUpdate: no approvers');
                       }      
                   }
                }   
        // we have built our list of recipients now send them the template
         // Note: We can't use mass email because VF templates are not supported for thoose
                if (toRecipients.size()>0){
                  String[] ccRecipients; // empty
                  String templateApiName = 'Advanced_Approvals_Quote_Approved2'; // VF email template 
                  // Since we are not using {!recipient.xxx}in the template use a dummy contact 
                  // need to limit the query, so filter on mulesoft
             //     Contact c = [select id, Email from Contact WHERE Email = null  limit 1];
                  Id whatId = approvalList[0].Id; // by default use the first  'a5Bn0000000JXgc';  // needs to be id of an approval
                  Boolean saveAsActivity  = false;
                  OrgWideEmailAddress orgWideId = [SELECT Id FROM OrgWideEmailAddress Where DisplayName = 'Sales Ops' Limit 1];
                  system.debug('toRecipients = '+toRecipients); 
                  HelperEmailClass.sendTemplatedEmail(toRecipients, ccRecipients,templateApiName,userForTarget,whatId,orgWideId.Id ,saveAsActivity );          
                 
               }
               else {
                  system.debug('emailNotificatoinAfterUpdate:  No email notificatoin!');
               }
            }
        } 
    }
  }
 }