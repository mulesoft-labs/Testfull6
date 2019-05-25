trigger CommentOnFileLinkedToCase on ContentDocumentLink (after insert) {
    List<CaseComment> caseCommentList = new List<CaseComment>();
    for (ContentDocumentLink cdl: Trigger.new) {
        // get parent object Id
        String parentId = cdl.LinkedEntityId;
        // If parent Object is "Case"
        if (parentId.substring(0,3) == '500') {
            String docId = cdl.ContentDocumentId;
            String fileName;
            ContentVersion attachment = [SELECT Title,FileExtension from ContentVersion where ContentDocumentId = :docId].get(0);
            CaseComment newComment = new CaseComment(ParentId = parentId, IsPublished = false);
            if (attachment.FileExtension == null) {
                fileName = attachment.Title;
            } else {
                fileName = attachment.Title + '.' + attachment.FileExtension;
            }
            newComment.CommentBody = UserInfo.getName() + ' has attached file "' + fileName + '" to the case. Please review.';
            caseCommentList.add(newComment);
        }
    }
    insert caseCommentList;
}