/*********************************************************************
*
*   File Name: MuleSoftInf_TestDataUtility
*
*   File Description: Class used to create test data for test methods
*
**********************************************************************
*
*   Date        Author            Change
*   08/01/14    Rob               Initial Creation                          
*
*********************************************************************/
@isTest
public with sharing class MuleSoftInf_TestDataUtility
{

    /**
     * Method to build test Account records
     */
    public static Account buildAccountRecord()
    {
        Account newAccount = new Account();
        newAccount.Name = 'Test Account';
        newAccount.BillingCountry = 'US';
        newAccount.BillingStreet = '77 Geary Street';
        newAccount.BillingCity = 'San Francisco';
        newAccount.BillingState = 'CA';
        newAccount.BillingPostalCode = '94108';
        return newAccount;
    }

    /**
     * Method to build test Opportunity records
     */
    public static Opportunity buildOpportunityRecord(Id accountId, String stage, String type, Decimal amount, Date closeDate, String forecast)
    {
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity';
        newOpportunity.AccountId = accountId;
        newOpportunity.Type = type;
        newOpportunity.StageName = stage;
        newOpportunity.Amount = amount;
        newOpportunity.CloseDate = closeDate;
        newOpportunity.Forecast__c = forecast;
        newOpportunity.Opportunity_Source__c = 'Other';
        newOpportunity.Primary_Solution_Interest__c = 'SOA';

        return newOpportunity;
    }

    /**
     * Method to build test Contact records
     */
    public static Contact buildContactRecord(Id accountId, String leadSource)
    {
        Contact newContact = new Contact();
        newContact.LastName = 'Test Contact';
        newContact.AccountId = accountId;
        newContact.LeadSource = leadSource;

        return newContact;
    }

    /**
     * Method to build test OpportunityContactRole records
     */
    public static OpportunityContactRole buildOpportunityContactRoleRecord(Id opportunityId, Id contactId, Boolean isPrimary)
    {
        OpportunityContactRole newContactRole = new OpportunityContactRole();
        newContactRole.OpportunityId = opportunityId;
        newContactRole.ContactId = contactId;
        newContactRole.IsPrimary = isPrimary;

        return newContactRole;
    }

    /**
     * Method to build test OpportunityTeamMember records
     */
    public static OpportunityTeamMember buildOpportunityTeamMember(Id userId, Id opportunityId, String teamRole, String SCRoleDetails )
    {
        OpportunityTeamMember newTeamMember = new OpportunityTeamMember();
        newTeamMember.UserId = userId;
        newTeamMember.OpportunityId = opportunityId;
        newTeamMember.TeamMemberRole = teamRole;
        newTeamMember.SC_Role_Details__c = SCRoleDetails;
        return newTeamMember;
    }

    /**
     * Method to build test user
     */
    public static User buildUser(String roleName, String profileName, String username)
    {
        Profile p = [select Id from Profile where Name =: profileName];
        UserRole r = [select Id from UserRole where Name =: roleName];

        User testUser = new User();
        testUser.Alias               = 'testuser';
        testUser.Email               = 'testemail@testmulesoft.doesnotwork.com';
        testUser.EmailEncodingKey    = 'UTF-8';
        testUser.LastName            = 'TestUser';
        testUser.LanguageLocaleKey   = 'en_US';
        testUser.LocaleSidKey        = 'en_US';
        testUser.ProfileId           = p.Id;
        testUser.TimeZoneSidKey      = 'America/Los_Angeles';
        testUser.UserRoleId          = r.Id;
        testUser.UserName            = username;

        return testUser;
    }
}