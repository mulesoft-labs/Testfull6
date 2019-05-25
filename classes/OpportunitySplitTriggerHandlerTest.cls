@isTest
private class OpportunitySplitTriggerHandlerTest {

    @testSetup
    public static void testSetupInfo()
    {
        //add user to exempted list
        User userIncontext = utilities.currentUser;
        Profiles_With_Closing_Opp_Edit_Access__c editAccess = new Profiles_With_Closing_Opp_Edit_Access__c();
        editAccess.name = userIncontext.profile.name;
        editAccess.Profile_Name__c = userIncontext.profile.name;
        insert editAccess;

        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;

        Opportunity opp = new Opportunity();
        opp.Name='Oppty_test1';
        opp.AccountID = Acc1.ID;
        opp.StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        opp.Type ='New Business';
        opp.CloseDate=System.Today();
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Opportunity in Closing').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        opp.forecast__c='Commit';
        //opp.Pre_SAL_Type__c = 'Other';
        opp.AE_Connect_Completed__c  = true;
        insert opp;

    }

    @isTest
    static void testSplitUpdateOnClosingOppFailure() {

        Boolean cantUpdateSplitsOnOpportunityInClosing = false;

        List<OpportunitySplit> splits = [Select Id from OpportunitySplit];

        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
            update splits;
        }
        catch(Exception ex){
            cantUpdateSplitsOnOpportunityInClosing  = true;
        }
        System.assert(cantUpdateSplitsOnOpportunityInClosing , 'Should have failed to update splits on Opportunity in closing');
    }

    @isTest
    static void testSplitDeleteOnClosingOppFailure() {

        Boolean cantUDeleteSplitsOnOpportunityInClosing = false;

        List<OpportunitySplit> splits = [Select Id from OpportunitySplit];

        //remove edit access
        List<Profiles_With_Closing_Opp_Edit_Access__c> profilesWithEditAccess = Profiles_With_Closing_Opp_Edit_Access__c.getall().values();
        delete profilesWithEditAccess;

        try{
            delete splits;
        }
        catch(Exception ex){
            cantUDeleteSplitsOnOpportunityInClosing  = true;
        }
        System.assert(cantUDeleteSplitsOnOpportunityInClosing , 'Should have failed to delete splits on Opportunity in closing');
    }

    @isTest
    static void testSplitUpdatesWithSolutionManager() {
        Profile soultionManagerProfile= [Select Id,Name from Profile where Name =:OpportunitySettings.SOLUTION_MANAGER_PROFILE_NAME];
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        //Insert account as current user
        System.runAs (thisUser) {

            Profiles_With_Closing_Opp_Edit_Access__c editAccess = new Profiles_With_Closing_Opp_Edit_Access__c();
            editAccess.name = soultionManagerProfile.name;
            editAccess.Profile_Name__c = soultionManagerProfile.name;
            insert editAccess;

            User testUser = new User(Username='mulesofttest001abcxyz@testtest.com',LastName='test',Alias='tal',CommunityNickname= 'cname', Email='junk@junk.com');
            testUser.TimeZoneSidKey = 'America/Chicago';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'ISO-8859-1';
            testUser.ProfileId = soultionManagerProfile.Id;
            testUser.LanguageLocaleKey = 'en_US';
            List<OpportunitySplit> splits = [Select Id, OpportunityId,SplitOwnerId  from OpportunitySplit];
            splits[0].splitnote = 'some note';

            boolean updateFailed = false;
            System.runAs(testUser){
                try{
                    update splits;
                }
                Catch(Exception ex){
                    updateFailed = true;
                }
            }
            System.assert(updateFailed);
        }
    }

}