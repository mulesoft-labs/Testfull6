public with sharing class QuoteExtController {
    private Id quoteId;
    public SBAA__Approval__c[] approvals {get; set;}

    public QuoteExtController(ApexPages.StandardController stdController) {
        quoteId = stdController.getId();
    }

    public PageReference onSubmit() {
        if (quoteId != null) {
            SBAA.ApprovalAPI.submit(quoteId, SBAA__Approval__c.Quote__c);
        }
        return new PageReference('/' + quoteId);
    }

    public PageReference onRecall() {
        if (quoteId != null) {
            SBAA.ApprovalAPI.recall(quoteId, SBAA__Approval__c.Quote__c);
        }
        return new PageReference('/' + quoteId);
    }

    public PageReference onPreview() {
        if (quoteId != null) {
            approvals = SBAA.ApprovalAPI.preview(quoteId, SBAA__Approval__c.Quote__c);
        }
        return null;
    }
}