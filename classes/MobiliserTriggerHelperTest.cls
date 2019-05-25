@isTest
public class MobiliserTriggerHelperTest {
    private static Account acc1;
    private static Opportunity opp;
    private static Integer TEST_SIZE = 1;
    static void prepareTestData(){
        acc1 = new Account(Name='TestAccount', BillingCountry='US', Account_Classification__c  = '2. Strategic', AnnualRevenue = 4100000000.00);
        insert acc1;
        opp = new Opportunity(Name='Oppty_test1',
                AccountID = acc1.ID,
                StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
                CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Engagement_Mode__c = 'Strategic Project';
        insert opp;
        Contact testContact = new Contact(FirstName = 'test',
                LastName = 'test',
                AccountId = acc1.id, Email = 'test@test.com');
        insert testcontact;
    }

    @isTest
    static void testMobiliserCountInsert(){
        prepareTestData();

        List<Mobiliser__c> mobiliserList = new List<Mobiliser__c>();

        for(Integer i = 0; i < TEST_SIZE; i++){
            mobiliserList.add(new Mobiliser__c(Account__c = acc1.Id, Opportunity__c = opp.Id, AE_Approver__c = UserInfo.getUserId(), Lead_Passed_By__c = UserInfo.getUserId()));
        }

        insert mobiliserList;

        Opportunity updatedOpty = [SELECT Mobiliser_Count__c, Count_of_SAL_Audited_Mobilisers__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(TEST_SIZE, updatedOpty.Mobiliser_Count__c);
        system.assertEquals(0, updatedOpty.Count_of_SAL_Audited_Mobilisers__c);
    }

    @isTest
    static void testMobiliserCountUpdate(){
        prepareTestData();
        Opportunity newOpty = new Opportunity(Name='Oppty_test2',
                AccountID = acc1.ID,
                StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
                CloseDate=System.Today());
        newOpty.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        newOpty.Type ='New Business';
        newOpty.Opportunity_Source__c ='Direct';
        newOpty.Primary_Solution_Interest__c = 'SOA';
        newOpty.Engagement_Mode__c = 'Strategic Project';
        insert newOpty;

        List<Mobiliser__c> mobiliserList = new List<Mobiliser__c>();

        for(Integer i = 0; i < TEST_SIZE; i++){
            mobiliserList.add(new Mobiliser__c(Account__c = acc1.Id, Opportunity__c = opp.Id, AE_Approver__c = UserInfo.getUserId(), Lead_Passed_By__c = UserInfo.getUserId()));
        }

        insert mobiliserList;

        Opportunity updatedOpty = [SELECT Mobiliser_Count__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(TEST_SIZE, updatedOpty.Mobiliser_Count__c);

        for(Mobiliser__c m : mobiliserList){
            m.Opportunity__c = newOpty.Id;
        }

        Test.startTest();
        update mobiliserList;
        Test.stopTest();

        Opportunity oldOpty = [SELECT Mobiliser_Count__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(0, oldOpty.Mobiliser_Count__c);

        newOpty = [SELECT Mobiliser_Count__c
        FROM Opportunity
        WHERE Id = :newOpty.Id];
        system.assertEquals(TEST_SIZE, newOpty.Mobiliser_Count__c);

    }

    @isTest
    static void testMobiliserCountDelete(){
        prepareTestData();

        List<Mobiliser__c> mobiliserList = new List<Mobiliser__c>();

        for(Integer i = 0; i < TEST_SIZE; i++){
            mobiliserList.add(new Mobiliser__c(Account__c = acc1.Id, Opportunity__c = opp.Id, AE_Approver__c = UserInfo.getUserId(), Lead_Passed_By__c = UserInfo.getUserId()));
        }

        insert mobiliserList;

        Opportunity updatedOpty = [SELECT Mobiliser_Count__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(TEST_SIZE, updatedOpty.Mobiliser_Count__c);

        Test.startTest();
        delete mobiliserList;
        Test.stopTest();

        updatedOpty = [SELECT Mobiliser_Count__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(0, updatedOpty.Mobiliser_Count__c);

    }

    @isTest
    static void testSALMobiliserCountInsert(){
        prepareTestData();

        List<Mobiliser__c> mobiliserList = new List<Mobiliser__c>();

        for(Integer i = 0; i < TEST_SIZE; i++){
            mobiliserList.add(new Mobiliser__c(Account__c = acc1.Id,
                    Opportunity__c = opp.Id,
                    SAL_Audited__c = true,AE_Approver__c = UserInfo.getUserId(), Lead_Passed_By__c = UserInfo.getUserId()));
        }

        insert mobiliserList;

        Opportunity updatedOpty = [SELECT Mobiliser_Count__c, Count_of_SAL_Audited_Mobilisers__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(TEST_SIZE, updatedOpty.Mobiliser_Count__c);
        system.assertEquals(TEST_SIZE, updatedOpty.Count_of_SAL_Audited_Mobilisers__c);
    }

    @isTest
    static void testSALMobiliserCountUpdate(){
        prepareTestData();
        Opportunity newOpty = new Opportunity(Name='Oppty_test2',
                AccountID = acc1.ID,
                StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
                CloseDate=System.Today());
        newOpty.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        newOpty.Type ='New Business';
        newOpty.Opportunity_Source__c ='Direct';
        newOpty.Primary_Solution_Interest__c = 'SOA';
        newOpty.Engagement_Mode__c = 'Strategic Project';
        insert newOpty;

        List<Mobiliser__c> mobiliserList = new List<Mobiliser__c>();

        for(Integer i = 0; i < TEST_SIZE; i++){
            mobiliserList.add(new Mobiliser__c(Account__c = acc1.Id,
                    Opportunity__c = opp.Id,
                    SAL_Audited__c = true,AE_Approver__c = UserInfo.getUserId(), Lead_Passed_By__c = UserInfo.getUserId()));
        }

        insert mobiliserList;

        Opportunity updatedOpty = [SELECT Mobiliser_Count__c, Count_of_SAL_Audited_Mobilisers__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(TEST_SIZE, updatedOpty.Count_of_SAL_Audited_Mobilisers__c);

        for(Mobiliser__c m : mobiliserList){
            m.Opportunity__c = newOpty.Id;
        }

        Test.startTest();
        update mobiliserList;
        Test.stopTest();

        Opportunity oldOpty = [SELECT Count_of_SAL_Audited_Mobilisers__c
        FROM Opportunity
        WHERE Id = :opp.Id];
        system.assertEquals(0, oldOpty.Count_of_SAL_Audited_Mobilisers__c);

        newOpty = [SELECT Count_of_SAL_Audited_Mobilisers__c
        FROM Opportunity
        WHERE Id = :newOpty.Id];
        system.assertEquals(TEST_SIZE, newOpty.Count_of_SAL_Audited_Mobilisers__c);

    }

    @isTest
    static void testSALMobiliserCountDelete(){
        prepareTestData();

        List<Mobiliser__c> mobiliserList = new List<Mobiliser__c>();

        for(Integer i = 0; i < TEST_SIZE; i++){
            mobiliserList.add(new Mobiliser__c(Account__c = acc1.Id,
                    Opportunity__c = opp.Id,
                    SAL_Audited__c = true,AE_Approver__c = UserInfo.getUserId(), Lead_Passed_By__c = UserInfo.getUserId()));
        }

        insert mobiliserList;

        Opportunity updatedOpty = [SELECT Count_of_SAL_Audited_Mobilisers__c
        FROM Opportunity
        WHERE Id = :opp.Id];

        system.assertEquals(TEST_SIZE, updatedOpty.Count_of_SAL_Audited_Mobilisers__c);

        Test.startTest();
        delete mobiliserList;
        Test.stopTest();

        updatedOpty = [SELECT Count_of_SAL_Audited_Mobilisers__c
        FROM Opportunity
        WHERE Id = :opp.Id];

        system.assertEquals(0, updatedOpty.Count_of_SAL_Audited_Mobilisers__c);
    }
}