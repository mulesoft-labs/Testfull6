/*********************************************************************
*
*   File Name: SCTeamMemberRestrictionsTest.cls
*
*   File Description: Test class for the SCTeamMemberRestrictions
*   class
*
**********************************************************************
*
*   Date        Author              Change
*   10/04/14    Rob                 Commenting out Accoun Team tests
*                                   as custom Account Team Member object
*                                   is no longer being used
*   08/22/14    Rob                 Initial Creation                             
*
*********************************************************************/

@isTest
private class SCTeamMemberRestrictionsTest
{
    private static testMethod void testOpportunityTeamRestrictions()
    {
        // Create SC User
        User u = createTestUser('1', 'APAC-SC');

        // Create SC Lead User In Different Region
        User scLead = createTestUser('2', 'EMEA-SC Lead');

        System.runAs(scLead)
        {
            // custom setting data
            createCustomSettings('APAC-SC','APAC-SC Lead');
            createCustomSettings('NA-SC','NA-SC Lead');
            createCustomSettings('EMEA-SC','EMEA-SC Lead');
            createCustomSettings('LATAM-SC','LATAM-SC Lead');

            // Create other test data
            Account acc = createTestAccount('Test Account');
            Opportunity opp = createTestOpportunity('Test Opportunity', acc.Id);

            Test.startTest();

            // ========== Insert Test =============            
            try
            {
                OpportunityTeamMember otm = new OpportunityTeamMember();
                otm.OpportunityId = opp.Id;
                otm.UserId = u.Id;
                insert otm;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage().contains('Only SC Leads can add, change, and remove SCs'));
            }

            // Update role to successfully save test record for further testing            
            scLead.UserRoleId = [SELECT Id FROM UserRole WHERE name = 'APAC-SC Lead' LIMIT 1].Id;
            update scLead;

            // successfully creat test opportunity team member
            OpportunityTeamMember otm2 = new OpportunityTeamMember();
            otm2.OpportunityId = opp.Id;
            otm2.UserId = u.Id;
            insert otm2;

            // Update role back to original role
            scLead.UserRoleId = [SELECT Id FROM UserRole WHERE name = 'EMEA-SC Lead' LIMIT 1].Id;
            update scLead;

            // ========== Update Test ==========
            try
            {
                otm2.TeamMemberRole = 'Partner';
                update otm2;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage().contains('Only SC Leads can add, change, and remove SCs'));
            }

            // ========== Delete Test ============
            try
            {
                delete otm2;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage().contains('Only SC Leads can add, change, and remove SCs'));
            }

            Test.stopTest();
        }
    }

    /*
    private static testMethod void testAccountTeamRestrictions()
    {
        // Create SC User
        User u = createTestUser('1', 'APAC-SC');         

        // Create SC Lead User In Different Region
        User scLead = createTestUser('2', 'EMEA-SC Lead');

        System.runAs(scLead)
        {           
            // custom setting data
            createCustomSettings('APAC-SC','APAC-SC Lead');
            createCustomSettings('NA-SC','NA-SC Lead');
            createCustomSettings('EMEA-SC','EMEA-SC Lead');
            createCustomSettings('LATAM-SC','LATAM-SC Lead');

            // Create other test data
            Account acc = createTestAccount('Test Account');
            Opportunity opp = createTestOpportunity('Test Opportunity', acc.Id);

            Test.startTest();
            
            // ========== Insert Test ===========            
            try
            {                
                Account_Team__c  at = new Account_Team__c();       
                at.Account__c = acc.Id;
                at.User__c = u.Id;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage() == 'Only SC Leads can add, change, and remove SCs');
            }

            // Update role to successfully save test record for further testing            
            scLead.UserRoleId = [SELECT Id FROM UserRole WHERE name = 'APAC-SC Lead' LIMIT 1].Id;
            update scLead;

            // successfully creat test account team member
            Account_Team__c  at = new Account_Team__c();       
            at.Account__c = acc.Id;
            at.User__c = u.Id;      
            insert at;      

            // Update role back to original role
            scLead.UserRoleId = [SELECT Id FROM UserRole WHERE name = 'EMEA-SC Lead' LIMIT 1].Id;
            update scLead;

            // ========= Update Test ==========
            try
            {                
                at.SC_Role_Details__c = 'Primary';
                update at;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage() == 'Only SC Leads can add, change, and remove SCs');
            }

            // ========= Delete Test ===========
            try
            {                
                delete at;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage() == 'Only SC Leads can add, change, and remove SCs');
            }
            
            Test.stopTest();                 
        }
    }
    */

    private static User createTestUser(String userNumber, String roleName)
    {
        Profile p = [SELECT Id FROM profile WHERE name = '2_18 Analytics' LIMIT 1];
        UserRole ur = [SELECT Id FROM UserRole WHERE name =: roleName LIMIT 1];

        User u = new user();
        u.Username = 'testSCTEAM' + userNumber + '@test.com';
        u.Email = 'test12345@test.com';
        u.LastName = 'data';
        u.FirstName = 'test';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.Localesidkey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.Languagelocalekey = 'en_US';
        u.Alias = 'tuser' + userNumber;
        u.ProfileId = p.Id;
        u.UserRoleId = ur.Id;
        insert u;

        return u;
    }

    private static Team_Member_Settings__c createCustomSettings(String childRoleName, String parentRoleName)
    {
        Team_Member_Settings__c pu = new Team_Member_Settings__c();
        pu.Name = childRoleName;
        pu.Parent_Role_Name__c = parentRoleName;
        pu.Child_Role_Name__c = childRoleName;
        insert pu;

        return pu;
    }

    private static Account createTestAccount(String accountName)
    {
        // creating test account
        Account acc = new Account();
        acc.Name = accountName;
        acc.BillingCountry = 'US';
        insert acc;

        return acc;
    }

    private static Opportunity createTestOpportunity(String opportunityName, Id accountId)
    {
        // creating test Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = opportunityName;
        opp.CloseDate = System.today();
        opp.StageName = 'Present Value';
        opp.AccountId = accountId;
        opp.Primary_Solution_Interest__c = 'test';
        opp.forecast__c = 'closed';
        insert opp;

        return opp;
    }
}