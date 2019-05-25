public with sharing class CategoriesAssigneeCtrl {
    public IdeasCategoriesAssignment__c[] records { get; private set; }
    public List<SelectOption> categoryOptions { get; private set; }
    public String rId { get; set; }
    public String createUsername { get; set; }
    public String createCategoriesString { get; set; }
    public String[] createCategories { get; set; }

    public CategoriesAssigneeCtrl(){
        categoryOptions = new List<SelectOption>();
        Schema.DescribeFieldResult categoriesFieldDescribe = Schema.Idea.Categories.getDescribe();
        List<Schema.PicklistEntry> picklistValues = categoriesFieldDescribe.getPicklistValues();

        for (Schema.PicklistEntry picklistItem : picklistValues) {
            categoryOptions.add(new SelectOption(picklistItem.getValue(), picklistItem.getLabel()));
        }

        this.loadRecords();
    }

    public PageReference edit() {
        createCategories = createCategoriesString.split(';');

        return null;
    }

    public PageReference remove() {
        if (!Schema.sObjectType.IdeasCategoriesAssignment__c.isDeletable()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have permissions'));
            return null;
        }

        try {
            IdeasCategoriesAssignment__c assignment = [
                    SELECT Id
                    FROM IdeasCategoriesAssignment__c
                    WHERE Id = :rId
            ];

            delete assignment;

            this.loadRecords();

        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                    ex.getMessage() + ' (recordId:' + rId + ')'));
        }

        return null;
    }

    public PageReference save() {
        User usr;

        try {
            usr = [SELECT Id FROM User WHERE Username = :createUsername];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'User does not exist'));
            return null;
        }

        IdeasCategoriesAssignment__c assi;

        try {
            assi = [SELECT Categories__c FROM IdeasCategoriesAssignment__c
            WHERE User__c = :usr.Id];

            if (Schema.sObjectType.IdeasCategoriesAssignment__c.fields.Categories__c.isUpdateable()) {
                assi.Categories__c = String.join(createCategories, ';');
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have permissions to update categories field'));
                return null;
            }
        } catch (Exception ex) {
            if (!Schema.sObjectType.IdeasCategoriesAssignment__c.isCreateable()
                    || !Schema.sObjectType.IdeasCategoriesAssignment__c.fields.User__c.isUpdateable()
                    || !Schema.sObjectType.IdeasCategoriesAssignment__c.fields.Categories__c.isUpdateable()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have permissions to create records'));
                return null;
            }

            assi = new IdeasCategoriesAssignment__c(
                    User__c = usr.Id,
                    Categories__c = String.join(createCategories, ';')
            );
        }

        upsert assi;

        return ApexPages.currentPage().setRedirect(TRUE);
    }

    private void loadRecords(){
        if (!Schema.sObjectType.IdeasCategoriesAssignment__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have permissions'));
            return;
        }

        records = [SELECT Id, User__r.Username, Categories__c
        FROM IdeasCategoriesAssignment__c
        ORDER BY CreatedDate ASC LIMIT 1000];
    }
}