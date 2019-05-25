trigger ApprovalAfterUpdate on sbaa__Approval__c (before insert, before update) {
    
    if(Trigger.IsBefore && Trigger.IsUpdate){
        for (sbaa__Approval__c na : Trigger.new) {
            sbaa__Approval__c oa = Trigger.oldMap.get(na.Id);
            if(oa.sbaa__CommentsLong__c == null && na.sbaa__CommentsLong__c != null && !na.sbaa__CommentsLong__c.Contains(system.now().format('MM/dd/YYYY')) ){
                // need newline to seperate comments when viewing in salesforce. Must have char at end or \n gets stripped
                String newComment = system.now().format('MM/dd/YYYY') +' - ' + na.sbaa__CommentsLong__c + '\r\n';
                na.sbaa__CommentsLong__c = newComment;
                
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        /* This trigger checks for applicable archived approval comments and adds them to the comment history field.
         * This trigger will execute when new approval records are created, this will be when a quote is submitted for approval.
         */ 
        Set<Id> approvalIds = new Set<Id>();
        system.debug('ApprovalAfterUpdate executing');
         
        Set<Id> currQuote = new Set<Id>();
        
        // we will see only one approval record created (in my testing)
        for (sbaa__Approval__c na : Trigger.new) {
            currQuote.add(na.Quote__c);
        }
        system.debug('currQuote size = '+currQuote.size());
        /* query for approval records and check for archived comments.  */
        sbaa__Approval__c[] approval = [Select Name,Id,sbaa__Approver__c,sbaa__Archived__c,Formatted_Comment_History__c,sbaa__CommentsLong__c,Quote__c,sbaa__Rule__c,Rule2__c  
                                        from  sbaa__Approval__c Where Quote__c in :currQuote ];
        
        //In case of multiple approvals being updated on various quotes
        map<Id,List<sbaa__Approval__c>> quoteIdToListApprovals = new map<Id,List<sbaa__Approval__c>>();
        for(sbaa__Approval__c a : approval){
            if(quoteIdToListApprovals.containsKey(a.Quote__c)){
                quoteIdToListApprovals.get(a.Quote__c).add(a);
            } else {
                quoteIdToListApprovals.put(a.Quote__c,new List<sbaa__Approval__c>{a});
            }
        }
        
        system.debug(' Num approval records = '+approval.size());
        system.debug('approval = '+approval);
       // we are making an assumption that all the approvals belong to the same quote. 
       // This is a safe assumption because quotes can not be mass approved.
       // TODO: perform a sanity check and if multiple
        Map<Id,String> ruleCommentMap = new Map<Id,String>();
        Map<Id,String> ruleFormattedCommentMap = new Map<Id,String>();
        // map looks like [rule1_id,comment1 & comment2]],[rule2_id,comment1]],
        
        for(Id myId : quoteIdToListApprovals.keySet()){
            List<sbaa__Approval__c> Approvals = quoteIdToListApprovals.get(myId);
            
            if(Approvals.size()>0){
                for (sbaa__Approval__c a : Approvals){
                   /* test the approval record, are there archived comments?  
                    * For each archived approval comment, concatenate the comment to the comment from the previous matching approval rule.
                    * Note: adding system.debug causes visual force approval page to crash for some unkown reason.    
                    */
                    // if no comment then sbaa__CommentsLong__c is null. Otherwise, put it in our map
                    // note: sbaa__Archived__c is not valid at this point so don't test it. 
                      if (a.sbaa__CommentsLong__c != null) {
                        //check for having multiple comments archived
                        if(ruleCommentMap.containsKey(a.sbaa__Rule__c)){
                            string s = ruleCommentMap.remove(a.sbaa__Rule__c);
                            string fs = ruleFormattedCommentMap.remove(a.sbaa__Rule__c);
                            s += '\n\r  ' + a.sbaa__CommentsLong__c;
                            fs += '<br/> ' + a.sbaa__CommentsLong__c;
                            ruleCommentMap.put(a.sbaa__Rule__c,s);
                            ruleFormattedCommentMap.put(a.sbaa__Rule__c,fs);
                        } else {
                            ruleCommentMap.put(a.sbaa__Rule__c,a.sbaa__CommentsLong__c);
                            ruleFormattedCommentMap.put(a.sbaa__Rule__c,a.sbaa__CommentsLong__c);
                         }  
                      }   
                    // we have all the archived comments now paired with rules. 
                    // Need to take these comments and add them to the non-archived approval records
                }//end loop related approvals - create string of comments
                
                system.debug('ruleCommentMap= '+ruleFormattedCommentMap);
                
                //update Comment history field on new approvals
                for (sbaa__Approval__c a : Trigger.new){
                    
                    //make sure approval is on the same quote
                    if(a.Quote__c != Approvals[0].Quote__c) continue;
                    
                    // for each non-archived approval record see if an archived comment needs to be added to the comment history
                    if ((a.sbaa__Archived__c == False) && (ruleCommentMap.get(a.sbaa__Rule__c) != null)){
                        String archComment = ruleCommentMap.get(a.sbaa__Rule__c);
                        String fArchComment = ruleFormattedCommentMap.get(a.sbaa__Rule__c);
                        // viewing in HTML so new line is <br/> otherwise \n\r is needed. 
                        if(a.sbaa__CommentsLong__c != null) {
                            archComment += a.sbaa__CommentsLong__c;
                            fArchComment += a.sbaa__CommentsLong__c;
                        }
                        //ruleCommentMap.put(a.sbaa__Rule__c,archComment);
                       // a.Comment_History__c = archComment + '\n' + ' - ';
                        a.Comment_History__c = archComment;
                        
                 
                        a.Formatted_Comment_History__c = fArchComment;
                    }
                }//end Trigger.new update fields
                
            }//end if Approvals.size > 0
        }//end loop all Ids From quoteIdToListApprovals
        
        
        system.debug('exit ApprovalAfterUpdate - context=before insert - map= '+ruleCommentMap);
    }//end if before insert context
}