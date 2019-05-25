/*** 
* Class: TestDataFactory
* Description: Factory class to generate test data. 
* Author: Sid Sah
* Created on: 01/10/2018
*
**********************************************************************
*
*   Date            Author                 Change
*   06/08/15        Elmar Chen             Initial Creation                          
*   01/10/2018      Sid Sah                Added more Util methods

*
*********************************************************************/

@isTest
public without sharing class TestDataFactory {
    public static List<Vendor__c> createVendors(Integer n, Boolean doInsert,
            Map<String, Object> attributes) {
        List<Vendor__c> records = new List<Vendor__c>();
        for(Integer i=0; i<n; i++){
            records.add(new Vendor__c(Name = 'Test Vendor ' +i));
        }
        return createRecords(records, doInsert, attributes);
    }

    public static List<Account> createAccounts(Integer n, Boolean doInsert,
            Map<String, Object> attributes) {
        List<Account> records = new List<Account>();
        for(Integer i=0; i<n; i++){
            records.add(new Account(Name = 'Test Vendor ' +i, BillingCountry='USA', Type='Distributor',BillingStreet = '77 Geary Street',BillingCity = 'San Francisco',BillingState = 'CA',BillingPostalCode = '94108'));
        }
        return createRecords(records, doInsert, attributes);

    }
    public static List<Contact> createContacts(Integer n, Id acctId, Boolean doInsert,
            Map<String, Object> attributes) {
        List<Contact> records = new List<Contact>();
        for(Integer i=0; i<n; i++){
            records.add(new Contact(AccountId=acctId, LastName='LastName'+i));
        }
        return createRecords(records, doInsert, attributes);
    }
    public static List<Win_Report__c> createWinReport(Integer n, Boolean doInsert,
            Map<String, Object> attributes) {
        List<Win_Report__c> records = new List<Win_Report__c>();
        for(Integer i=0; i<n; i++){
            records.add(new Win_Report__c(
                    Business_Background__c = 'Business_Background__c',
                    Buyer_Name_Role__c = 'Buyer_Name_Role__c',
                    Customer_Reference_Details__c = 'Customer_Reference_Details__c',
                    Compelling_Event__c = 'Compelling_Event__c',
                    Competition_old__c = 'Competition_old__c',
                    Employees__c = 'Employees__c',
                    End_point__c = 'End_point__c',
                    How_Were_We_Introduced_to_the_Account__c = 'How_Were_We_Introduced_to_the_Account__c',
                    Explanation_for_Other_Use_Cases__c = 'Explanation_for_Other_Use_Cases__c',
                    Industry_old__c = 'Agriculture',
                    Initial_Project__c = 'Initial_Project__c',
                    Sales_Cycle_End__c = Date.today().addDays(10),
                    Sales_Cycle_Start__c = Date.today(),
                    Stage_in_SOA_Implementation__c = 'Stage_in_SOA_Implementation__c',
                    Subscription_Level__c = 'Gold',
                    Why_did_the_customer_choose_EE_for_ESB__c = 'Why_did_the_customer_choose_EE_for_ESB__c',
                    What_is_the_use_case_s__c = 'What_is_the_use_case_s__c',
                    Existing_Technology__c = 'None',
                    Opportunity_Team__c = 'Opportunity_Team__c',
                    Why_did_the_customer_choose_MuleSoft__c = 'Why_did_the_customer_choose_MuleSoft__c',
                    What_business_impact_and_ROI__c = 'What_business_impact_and_ROI__c',
                    Products_and_Subscription_Level__c = 'Products_and_Subscription_Level__c',
                    Competition__c = 'Competition__c',
                    Partner_Influence__c = 'Partner_Influence__c',
                    Key_Takeaway_on_Competition__c = 'Key_Takeaway_on_Competition__c',
                    Primary_Solution_Interest__c = 'Primary_Solution_Interest__c',
                    Company_Description__c = 'Company_Description__c',
                    What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c'));
        }
        return createRecords(records, doInsert, attributes);
    }

    //Added by Santoshi(Perficient) 11/18/2016
    public static User createUser(String profileName, String roleName, Boolean saveToDB,String Title) {
        string randomName = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User user = new User();
        user.Alias = 'MrUser';
        user.Email='MrUser@test.com';
        user.LastName = 'MrUser Last Name';
        user.ProfileId = p.Id;
        user.userName = randomName+system.now().millisecond()+'MrUser@test.com';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.Title = Title;
        user.ManagerId =UserInfo.getUserId();
        UserRole role = null;
        if(roleName==null){
            role = [SELECT id, name from userrole limit 1];
        }
        else {
            role = [SELECT id, name, developerName from userrole WHERE name = :roleName];
        }
        user.UserRoleId = role.Id;
        if (saveToDB){
            insert user;
        }
        system.debug('user***'+user);
        return user;
    }
    public static User createUser(String profileName, String roleName, Boolean saveToDB) {
        string randomName = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User user = new User();
        user.Alias = 'MrUser';
        user.Email='MrUser@test.com';
        user.LastName = 'MrUser Last Name';
        user.ProfileId = p.Id;
        user.userName = randomName+system.now().millisecond()+'MrUser@test.com';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.ManagerId =UserInfo.getUserId();
        UserRole role = null;
        if(roleName==null){
            role = [SELECT id, name from userrole limit 1];
        }
        else {
            role = [SELECT id, name from userrole WHERE name = :roleName];
        }
        user.UserRoleId = role.Id;
        if (saveToDB){
            insert user;
        }
        system.debug('user***'+user);
        return user;
    }

    public static List<Opportunity> createOpportunity(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes )
    {
        List<Opportunity> records = new List<Opportunity>();
        for(Integer i = 0; i < numToInsert; i++) {
            Opportunity o = new Opportunity(Name = 'Test Opportunity' + i,
                    StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
                    Forecast__c = 'Forecast',
                    Opportunity_Source__c = 'Other',
                    CloseDate = Date.today());
            records.add(o);
        }

        return createRecords(records, doInsert, attributes);
    }

    public static List<Account> createAccountsWithOpps(Integer numAccts, Integer numOppsPerAcct) {
        List<Account> accts = new List<Account>();

        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i,BillingCountry='USA');
            accts.add(a);
        }
        insert accts;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name = 'Test Opportunity' + k,
                        StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
                        CloseDate = Date.today(),
                        Forecast__c = 'Forecast',
                        Opportunity_Source__c = 'Other',
                        AccountId=acct.Id));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;

        return accts;
    }

    public static List<SBQQ__Quote__c> createQuote(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes )
    {
        Id MulesoftRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        List<SBQQ__Quote__c> records = new List<SBQQ__Quote__c>();
        for(Integer i = 0; i < numToInsert; i++) {
            SBQQ__Quote__c q = new SBQQ__Quote__c(
                    RecordTypeId = MulesoftRecordTypeId,
                    SBQQ__Primary__c = true);
            records.add(q);
        }

        return createRecords(records, doInsert, attributes);
    }

    public static List<Partner_Influence__c> createPartner(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes ) {
        List<Partner_Influence__c> records = new List<Partner_Influence__c>();
        for(Integer i = 0; i < numToInsert; i++) {
            Partner_Influence__c q = new Partner_Influence__c(
                    Sourced__c = true);
            records.add(q);
        }

        return createRecords(records, doInsert, attributes);
    }

    public static List<OpportunityContactRole> createOpportunityContactRole(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes ) {
        List<OpportunityContactRole> records = new List<OpportunityContactRole>();
        for(Integer i = 0; i < numToInsert; i++) {
            OpportunityContactRole q = new OpportunityContactRole(
                    Role='Other',
                    IsPrimary = true);
            records.add(q);
        }
        return createRecords(records, doInsert, attributes);
    }
    public static List<Work_Task__c> createWorkTask(Integer n, Boolean doInsert,
            Map<String, Object> attributes) {
        List<Work_Task__c> records = new List<Work_Task__c>();
        for(Integer i=0; i<n; i++){
            records.add(new Work_Task__c(Name = 'Work Task ' +i));
        }
        return createRecords(records, doInsert, attributes);
    }


    public static List<OpportunityLineItem> createOpportunityLineItem(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes )
    {
        List<OpportunityLineItem> records = new List<OpportunityLineItem>();
        for(Integer i = 0; i < numToInsert; i++) {
            OpportunityLineItem o = new OpportunityLineItem();
            records.add(o);
        }

        return createRecords(records, doInsert, attributes);
    }

    public static List<EntitySubscription> createEntitySubscription(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes )
    {
        List<EntitySubscription> records = new List<EntitySubscription>();
        for(Integer i = 0; i < numToInsert; i++) {
            EntitySubscription o = new EntitySubscription();
            records.add(o);
        }

        return createRecords(records, doInsert, attributes);
    }

    public static List<Project__c> createProject(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes )
    {
        List<Project__c> records = new List<Project__c>();
        for(Integer i = 0; i < numToInsert; i++) {
            Project__c o = new Project__c(Name = 'Test Project ' + i);
            records.add(o);
        }

        return createRecords(records, doInsert, attributes);
    }

    public static List<Milestone__c> createMilestone(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes )
    {
        List<Milestone__c> records = new List<Milestone__c>();
        for(Integer i = 0; i < numToInsert; i++) {
            Milestone__c o = new Milestone__c();
            records.add(o);
        }

        return createRecords(records, doInsert, attributes);
    }
    public static List<OpportunityTeamMember> createOpportunityTeamMember(Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes )
    {
        List<OpportunityTeamMember> records = new List<OpportunityTeamMember>();
        for(Integer i = 0; i < numToInsert; i++) {
            OpportunityTeamMember o = new OpportunityTeamMember();
            records.add(o);
        }

        return createRecords(records, doInsert, attributes);
    }

    public static List<SObject> createObjects(Schema.SObjectType type, Integer numToInsert, Boolean doInsert,
            Map<String, Object> attributes){
        if(attributes==null) attributes = new Map<String, Object>();
        List<SObject> records = new List<SObject>();
        Schema.DescribeSObjectResult typeDesc = type.getDescribe();
        Schema.SObjectField f = typeDesc.Fields.getMap().get('Name');
        if( f != null){
            Boolean nameUpdateable = f.getDescribe().isUpdateable();
            String namePrefix = (String) attributes.get('Name-prefix');
            if(nameUpdateable && !attributes.containsKey('Name') && namePrefix == null){
                attributes.put('Name-prefix', 'Test '+ typeDesc.getLabel());
            }
        }
        for(Integer i = 0; i < numToInsert; i++) {
            records.add(type.newSObject());
        }
        return createRecords(records, doInsert, attributes);
    }
    public static List<SObject> createRecords(List<SObject> records,
            Boolean doInsert, Map<String, Object> attributes)
    {
        if(attributes != null){
            Integer i = 0;
            for (Sobject record : records) {
                String suf = String.valueOf(100+i).subString(1);
                for (String key : attributes.keySet()) {
                    Boolean valueIsPrefix = key.endsWithIgnoreCase('-prefix');
                    Object value = attributes.get(key);
                    if(valueIsPrefix) key = key.removeEndIgnoreCase('-prefix');

                    if (value instanceof List<Object> && value != null) {
                        List<Object> l = (List<Object>) value;
                        value = l[i - i/l.size() * l.size()];
                    }

                    if (value instanceof SObject && value != null) {
                        value = ((SObject)value).Id;
                    }
                    if(valueIsPrefix && value instanceof String) value = value + '_' + suf;
                    record.put(key, value);
                }
                i++;
            }
        }
        if (doInsert) {
            insert records;
        }
        return records;
    }

    //create SBQQ__Subscription__c 
    public static List<SBQQ__Subscription__c> createSBQQSubscription(Integer numToInsert,
            Boolean doInsert,
            Map<String, Object> nameValue) {
        List<SBQQ__Subscription__c> SBQQSubs = new List<SBQQ__Subscription__c>();
        for( Integer i = 0; i < numToInsert; i++ ) {
            SBQQ__Subscription__c a = new SBQQ__Subscription__c();
            for(String key : nameValue.keySet()){
                a.put(key, nameValue.get(key));
            }
            SBQQSubs.add(a);
        }

        if( doInsert ) {
            insert SBQQSubs;
        }
        return SBQQSubs;
    }

    //create Contract
    public static List<Contract> createContracts(Integer numToInsert,
            Boolean doInsert,
            Map<String, Object> nameValue) {
        List<Contract> Contracts = new List<Contract>();
        for( Integer i = 0; i < numToInsert; i++ ) {
            Contract a = new Contract();
            for(String key : nameValue.keySet()){
                a.put(key, nameValue.get(key));
            }
            Contracts.add(a);
        }

        if( doInsert ) {
            insert Contracts;
        }
        return Contracts;
    }

    //create Product2
    public static List<Product2> createProducts(Integer numToInsert,
            Boolean doInsert,
            Map<String, Object> nameValue) {
        List<Product2> Products = new List<Product2>();
        for( Integer i = 0; i < numToInsert; i++ ) {
            Product2 a = new Product2();
            for(String key : nameValue.keySet()){
                a.put(key, nameValue.get(key));
            }
            Products.add(a);
        }

        if( doInsert ) {
            insert Products;
        }
        return Products;
    }

    public static List<CallTypetoOpportunityMapping__c> createCallTypetoOpportunityMappings(){
        List<CallTypetoOpportunityMapping__c> callTypeMappings = new List<CallTypetoOpportunityMapping__c>();
        callTypeMappings.add( new CallTypetoOpportunityMapping__c( Name = '1', Call_Type__c = 'AE Connect Scheduled - Call',
                Field_Name__c = 'AE_Connect_Scheduled__c', Value__c = true ) );
        callTypeMappings.add( new CallTypetoOpportunityMapping__c( Name = '2', Call_Type__c = 'AE Connect Scheduled - Email/LinkedIn',
                Field_Name__c = 'AE_Connect_Scheduled__c', Value__c = true ) );
        callTypeMappings.add( new CallTypetoOpportunityMapping__c( Name = '3', Call_Type__c = 'AE Connect Completed',
                Field_Name__c = 'AE_Connect_Completed__c', Value__c = true ) );
        callTypeMappings.add( new CallTypetoOpportunityMapping__c( Name = '4', Call_Type__c = 'C-level connect scheduled',
                Field_Name__c = 'C_level_Connect_Scheduled__c', Value__c = true ) );
        callTypeMappings.add( new CallTypetoOpportunityMapping__c( Name = '5', Call_Type__c = 'C-level connect completed',
                Field_Name__c = 'C_level_Connect_Completed__c', Value__c = true ) );
        callTypeMappings.add( new CallTypetoOpportunityMapping__c( Name = '6', Call_Type__c = 'Follow-on meeting scheduled',
                Field_Name__c = 'Follow_on_meeting_scheduled__c', Value__c = true ) );
        callTypeMappings.add( new CallTypetoOpportunityMapping__c( Name = '7', Call_Type__c = 'Follow-on meeting completed',
                Field_Name__c = 'Follow_on_Meeting_Completed__c', Value__c = true ) );
        insert callTypeMappings;

        return callTypeMappings;
    }
}