/******
 * Test class for Account Trigger Helper
 * Author :- Santoshi(Perficient)
 */
@isTest
private class AccountTriggerHelperTest {
  
    @isTest
    static void test_InsertMemberRole() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSR = TestDataFactory.createUser('2_18 Sales Hybrid', 'APAC-CS-TD', true,'Director');
        System.runas(sysAdmin){
            test.startTest();
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Manager_new__c'=>CSR.Id,'Account_Classification__c'=>'Strategic'});
            test.stopTest();
        }

        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Manager (CSM)'];
        System.assertequals(false,accTeam.isEmpty(),'There was error in adding account team role');
    }

    @isTest
    static void test_deleteMemberRole() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSR = TestDataFactory.createUser('2_18 Sales Hybrid', 'APAC-CS-TD', true,'Director');

        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Manager_new__c'=>CSR.Id,'Account_Classification__c'=>'Strategic'});
            test.startTest();
            acc[0].Customer_Success_Manager_new__c = null;
            update acc[0];
            test.stopTest();

        }
        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Manager (CSM)'];
        System.assertequals(true,accTeam.isEmpty(),'There was error in deleting account team role');
    }

    @isTest
    static void test_changeMemberRole() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSR = TestDataFactory.createUser('2_18 Sales Hybrid', 'APAC-CS-TD', true,'Director');
        User Associate = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-South-SrCSM', true,'Associate');
        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Manager_new__c'=>CSR.Id,'Account_Classification__c'=>'Strategic'});
            test.startTest();
            acc[0].Customer_Success_Manager_new__c = Associate.Id;
            update acc[0];
            test.stopTest();

        }
        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Manager (CSM)'];
        System.assertequals(true,!accTeam.isEmpty(),'There was error in changing account team role');
    }

    @isTest
    static void testOpportunityRoleUpdateWithAccountCSMUpdate() {

        List<Account> acc;
        Opportunity opp;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSR = TestDataFactory.createUser('2_18 Sales Hybrid', 'APAC-CS-TD', true,'Director');
        User Associate = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-South-SrCSM', true,'Associate');
        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Manager_new__c'=>CSR.Id,'Account_Classification__c'=>'Strategic'});
            opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>
            { 'AccountId' => acc[0].Id ,
            'Type' => ConstantDeclarations.OPP_TYPE_RENEWAL
            })[0];
            test.startTest();
            acc[0].Customer_Success_Manager_new__c = Associate.Id;
            update acc[0];
            test.stopTest();

        }

        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Manager (CSM)' and UserId =: Associate.Id];
        List<OpportunityTeamMember> oppTeams = [Select Id
        FROM OpportunityTeamMember
        WHERE OpportunityId =:opp.Id
        and UserId =: Associate.Id];

        System.assertequals(true,!accTeam.isEmpty(),'Account Team should have reflected the new CSM');
        System.assertequals(true,!oppTeams.isEmpty(),'Account Team should have reflected the new CSM');
    }

    @isTest
    static void test_InsertEngagementMgrMemberRole() {
        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User engagementMgr = TestDataFactory.createUser('2_18 Services', 'EMEA-Services-UK-Engagement Manager', true,'Engagement Manager');
        System.runas(sysAdmin){
            test.startTest();
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Engagement_Manager__c'=> engagementMgr.Id});
            test.stopTest();
        }

        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Engagement Manager'];
        System.assertequals(false,accTeam.isEmpty(),'There was error in adding account team role');
    }

    @isTest
    static void test_deleteEngagementMgrMemberRole() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User engagementMgr = TestDataFactory.createUser('2_18 Services', 'EMEA-Services-UK-Engagement Manager', true,'Engagement Manager');

        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Engagement_Manager__c'=>engagementMgr.Id});
            test.startTest();
            acc[0].Engagement_Manager__c = null;
            update acc[0];
            test.stopTest();

        }
        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Engagement Manager'];
        System.assertequals(true,accTeam.isEmpty(),'There was error in deleting account team role');
    }

    @isTest
    static void testOpportunityTeamMemberNotCreatedAccountEngagementMgr() {

        List<Account> acc;
        Opportunity opp;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User engagementMgr = TestDataFactory.createUser('2_18 Services', 'EMEA-Services-UK-Engagement Manager', true,'Engagement Manager');
        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Account_Classification__c'=>'Strategic'});
            opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>
            { 'AccountId' => acc[0].Id ,
            'Type' => ConstantDeclarations.OPP_TYPE_RENEWAL
            })[0];
            test.startTest();
            acc[0].Engagement_Manager__c = engagementMgr.Id;
            update acc[0];
            test.stopTest();

        }

        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Engagement Manager'];
        List<OpportunityTeamMember> oppTeams = [Select Id
        FROM OpportunityTeamMember
        WHERE OpportunityId =:opp.Id
        and UserId =: engagementMgr.Id];

        System.assertequals(1,accTeam.size());
        System.assertequals(0,oppTeams.size());
    }
    
    @isTest
    static void testCustomerSuccessArchitectInsert() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSA = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-CSA', true,'Director');
        System.runas(sysAdmin){
            test.startTest();
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Architect__c'=>CSA.Id,'Account_Classification__c'=>'Strategic'});
            test.stopTest();
        }

        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Architect'];
        System.assertequals(false,accTeam.isEmpty(),'There was error in adding Customer Success Architect to the Account team role');
    }

    @isTest
    static void testCustomerSuccessArchitectDelete() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSA = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-CSA', true,'Director');

        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Architect__c'=>CSA.Id,'Account_Classification__c'=>'Strategic'});
            test.startTest();
            acc[0].Customer_Success_Architect__c  = null;
            update acc[0];
            test.stopTest();

        }
        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Architect'];
        System.assertequals(true,accTeam.isEmpty(),'There was error in deleting Customer Success Architect from account team');
    }

    @isTest
    static void testCustomerSuccessArchitectUpdate() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSA1 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-CSA', true,'Director');
        User CSA2 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-CSA', true,'Associate');
        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Architect__c'=>CSA1.Id,'Account_Classification__c'=>'Strategic'});
            test.startTest();
            acc[0].Customer_Success_Architect__c = CSA2.Id;
            update acc[0];
            test.stopTest();

        }
        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Architect'];
        System.assertequals(true,!accTeam.isEmpty(),'There was error in changing account team member role to Customer Success Architect');
    }    

	@isTest
    static void testCustomerSuccessEngineerInsert() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSE = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-West-CSE', true,'Director');
        System.runas(sysAdmin){
            test.startTest();
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Engineer__c'=>CSE.Id,'Account_Classification__c'=>'Strategic'});
            test.stopTest();
        }

        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Engineer'];
        System.assertequals(false,accTeam.isEmpty(),'There was error in adding Customer Success Engineer to the Account team role');
    }

    @isTest
    static void testCustomerSuccessEngineerDelete() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSE = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-West-CSE', true,'Director');

        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Engineer__c'=>CSE.Id,'Account_Classification__c'=>'Strategic'});
            test.startTest();
            acc[0].Customer_Success_Engineer__c  = null;
            update acc[0];
            test.stopTest();

        }
        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Engineer'];
        System.assertequals(true,accTeam.isEmpty(),'There was error in deleting Customer Success Engineer from account team');
    }

    @isTest
    static void testCustomerSuccessEngineerUpdate() {

        List<Account> acc;
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        User CSE1 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-West-CSE', true,'Director');
        User CSE2 = TestDataFactory.createUser('2_18 Sales Hybrid', 'NA-CS-West-CSE', true,'Associate');
        System.runas(sysAdmin){
            acc = TestDataFactory.createAccounts(1,true,new  Map<String, Object>{'Name'=>'Test Acc','Customer_Success_Engineer__c'=>CSE1.Id,'Account_Classification__c'=>'Strategic'});
            test.startTest();
            acc[0].Customer_Success_Engineer__c = CSE2.Id;
            update acc[0];
            test.stopTest();

        }
        List<AccountTeamMember> accTeam = [Select Id FROM AccountTeamMember WHERE AccountId = :acc[0].Id and TeamMemberRole = 'Customer Success Engineer'];
        System.assertequals(true,!accTeam.isEmpty(),'There was error in changing account team member role to Customer Success Engineer');
    }        
}