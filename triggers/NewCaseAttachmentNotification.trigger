trigger NewCaseAttachmentNotification on Attachment (after insert) {
    List<CaseComment> caseCommentList = new List<CaseComment>();
    for (Attachment attachment: Trigger.new) {
        if (attachment.ParentId.getSobjectType() == Case.getSobjectType()) {
            CaseComment newComment = new CaseComment(ParentId = attachment.ParentId, IsPublished = false);
            newComment.CommentBody = UserInfo.getName() + ' has attached file "' + attachment.Name + '" to the case. Please review.';
            caseCommentList.add(newComment);
        }
    }
    insert caseCommentList;
}