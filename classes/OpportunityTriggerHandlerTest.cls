/*********************************************************************
*
*   File Name: OpportunityTriggerHandlerTest.cls
*
*   File Description:  Test class for the OpportunityTriggerHandler
*   class
*
**********************************************************************
*
*   Date        Author          Change
*   07/23/14    Robert          Added test methods to test functionality
*                               to lock records using approval workflow
*                               when stage is Closed Lost or Submitted 
*                               for Closing
*   02/20/14    Andrew          Initial Creation                             
*
*********************************************************************/

/**
 * Test Class for OpportunityTriggerHandler 
 */
@isTest(seeAllData=true)
private class OpportunityTriggerHandlerTest
{
    static testMethod void testOppTrigger()
    {
        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;

        List<Contract> Contracts = TestDataFactory.createContracts(1, true, new Map<String, Object>{'Status'=>'Draft',
        'StartDate' => date.today(),
        'EndDate' => date.today().addyears(1),
        'AccountId' => Acc1.id});

        Opportunity opp = new Opportunity(Name='Oppty_test1', AccountID = Acc1.ID, StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,Type ='Renewal', CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        opp.forecast__c='Commit';
        //opp.What_is_the_use_case_s__c = 'What_is_the_use_case_s__c';
        opp.What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c';
        opp.Opp_Business_Impact_ROI__c = 'Opp_Business_Impact_ROI__c';
        opp.Company_Description__c = 'Company_Description__c';
        opp.Compelling_Event__c = 'Compelling_Event__c';
        opp.Evaluation_Go_live_Timelines__c = 'Evaluation_Go_live_Timelines__c';
        opp.What_company_integration_strategy__c = 'What_company_integration_strategy__c';
        opp.Who_is_the_competition__c = 'Unknown';
        opp.Existing_ESB_other_technology__c ='None';
        opp.Developer_skills__c = 'JAVA';
        opp.What_did_we_learn_on_the_intro_call__c = 'Some text';
        //opp.Why_does_this_opp_merit_more_investment__c  = 'Some text';
        //opp.if_presal_plan_to_advance_opportunity__c = 'Some text';
        //opp.Support_required_from_AE_sales__c = 'Some text';
        //opp.Pre_SAL_Type__c = 'Other';
        opp.AE_Connect_Completed__c  = true;
        opp.SBQQ__Renewal__c  = true;
        opp.SBQQ__RenewedContract__c  = Contracts[0].Id;
        Opportunity origOpp = opp.clone(false, false, false, false);
        insert origOpp;
        Contracts[0].SBQQ__Opportunity__c = origOpp.Id;
        update Contracts;
        insert opp;
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        Contact testContact = new Contact(FirstName = 'test', LastName = 'test', AccountId = Acc1.id, Email = uniqueName+'test@test.com');
        Test.startTest();
        insert testcontact;

        PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true and Product2.Name like '%Additional Pre-Production vCore%' limit 1];
        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id);
        oli.PriceBookEntryID = pbID.Id;
        oli.Quantity = 100;
        oli.UnitPrice = 20000.00;
        insert oli;

        opp.StageName = 'Discovery';
        try
        {
            update opp;
        }
        catch(Exception ex)
        {

        }
        opp.forecast__c='Commit';
        //opp.StageName = ConstantDeclarations.OPP_STAGE_5_PERCENT;
        opp.StageName = ConstantDeclarations.OPP_STAGE_10_PERCENT;        
        try
        {
            update opp;
            List<Stage_Tracking__c> st=[select id, name from Stage_Tracking__c where Opportunity__c=:opp.Id];
            System.debug(st);
            System.assertEquals(2, st.size());
        }
        catch(Exception ex)
        {

        }

        opp.StageName = ConstantDeclarations.OPP_STAGE_EDUCATE_ON_MULESOFT_VISION;
        try
        {
            update opp;

        }
        catch(Exception ex)
        {

        }

        opp.StageName = ConstantDeclarations.OPP_STAGE_VALIDATE_SOLUTION ;
        opp.Who_cares_about_it__c = 'test';
        try
        {
            update opp;
        }
        catch(Exception ex)
        {

        }
        Test.stopTest();
    }

    static testMethod void testcopyPartnerDetialsForNewRenewalOpportunities()
    {
        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;

        List<Contract> Contracts = TestDataFactory.createContracts(1, true, new Map<String, Object>{'Status'=>'Draft',
        'StartDate' => date.today(),
        'EndDate' => date.today().addyears(1),
        'AccountId' => Acc1.id});

        Opportunity opp = new Opportunity(Name='Oppty_test1', AccountID = Acc1.ID, StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,Type ='Renewal', CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type ='Renewal';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        opp.forecast__c='Commit';
        //opp.What_is_the_use_case_s__c = 'What_is_the_use_case_s__c';
        opp.What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c';
        opp.Opp_Business_Impact_ROI__c = 'Opp_Business_Impact_ROI__c';
        opp.Company_Description__c = 'Company_Description__c';
        opp.Compelling_Event__c = 'Compelling_Event__c';
        opp.Evaluation_Go_live_Timelines__c = 'Evaluation_Go_live_Timelines__c';
        opp.What_company_integration_strategy__c = 'What_company_integration_strategy__c';
        opp.Who_is_the_competition__c = 'Unknown';
        opp.Existing_ESB_other_technology__c ='None';
        opp.Developer_skills__c = 'JAVA';
        opp.What_did_we_learn_on_the_intro_call__c = 'Some text';
        //opp.Why_does_this_opp_merit_more_investment__c  = 'Some text';
        //opp.if_presal_plan_to_advance_opportunity__c = 'Some text';
        //opp.Support_required_from_AE_sales__c = 'Some text';
        //opp.Pre_SAL_Type__c = 'Other';
        opp.AE_Connect_Completed__c  = true;
        opp.SBQQ__Renewal__c  = true;
        opp.SBQQ__RenewedContract__c  = Contracts[0].Id;
        Opportunity origOpp = opp.clone(false, false, false, false);
        insert origOpp;

        Id MulesoftRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Mulesoft').getRecordTypeId();
        SBQQ__Quote__c objQuote = new SBQQ__Quote__c(RecordTypeId = MulesoftRecordTypeId, SBQQ__Opportunity2__c = origOpp.Id,
                Legal_Link_or_MSA__c = 'Legal Link', SBQQ__Primary__c = true);
        insert objQuote;

        Contracts[0].SBQQ__Opportunity__c = origOpp.Id;
        Contracts[0].SBQQ__Quote__c = objQuote.Id;
        update Contracts;

        Test.startTest();
        insert opp;
        Test.stopTest();
    }

    private static testMethod void testStartApprovalForClosingOpportunities()
    {
        // Create test data
        Account testAccount = createTestAccount();
        Opportunity testOpportunity = createTestOpportunity(testAccount);

        Test.startTest();
        testOpportunity.forecast__c = 'Closed';
        testOpportunity.StageName = 'Closed Lost';
        testOpportunity.If_Closed_Lost_Primary_Reason__c = 'Test';
        testOpportunity.forecast__c='Commit';
        update testOpportunity;
        Test.stopTest();
    }


    static testmethod void testUpdateOpportunityStage()
    {
        // Create test data
        Account testAccount = createTestAccount();
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = 'Oppty_test1';
        testOpportunity.AccountID = testAccount.ID;
        testOpportunity.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        testOpportunity.Type = 'Renewal';
        testOpportunity.CloseDate = System.Today();
        testOpportunity.Primary_Solution_Interest__c = 'SOA';
        //testOpportunity.StageName = ConstantDeclarations.OPP_STAGE_5_PERCENT;
        testOpportunity.StageName = ConstantDeclarations.OPP_STAGE_10_PERCENT;        
        testOpportunity.forecast__c = 'Likely';        

        testOpportunity.Lead_Passed_By__c = Userinfo.getUserId();
        //testOpportunity.What_is_the_business_need_initiative__c = 'test';
        testOpportunity.Follow_on_meeting_scheduled__c = true;
        testOpportunity.Custom_Approval_Process__c = true;
        testOpportunity.What_did_we_learn_on_the_intro_call__c = 'Some text';
        //testOpportunity.Why_does_this_opp_merit_more_investment__c  = 'Some text';
        //testOpportunity.if_presal_plan_to_advance_opportunity__c = 'Some text';
        //testOpportunity.Support_required_from_AE_sales__c = 'Some text';
        //testOpportunity.Pre_SAL_Type__c = 'Other';
        //testOpportunity.Attendees_for_follow_on_meeting__c = 'Other';
        testOpportunity.AE_Connect_Completed__c  = true;

        insert testOpportunity;
        Apexpages.StandardController stdController = new Apexpages.StandardController( testOpportunity );
        SubmitForApprovalExtensions controller = new SubmitForApprovalExtensions( stdController );
        controller.submitPage();
        Test.startTest();
        List<ProcessInstance> processInstances = [SELECT Id,Status,TargetObjectId
        FROM ProcessInstance WHERE Status='Pending' AND TargetObjectId =: testOpportunity.Id];
        List<ProcessInstanceWorkitem> workItems = [SELECT Id,ProcessInstanceId
        FROM ProcessInstanceWorkitem
        WHERE ProcessInstanceId IN :processInstances];
        Approval.ProcessWorkitemRequest[] allReq = New Approval.ProcessWorkitemRequest[]{};
        for( ProcessInstanceWorkitem piw : workItems ){
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments(Label.MOVE_TO_5_PERCENT);
            req2.setAction('Approve'); //to approve use 'Approve'
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(piw.Id);
            allReq.add(req2);
        }
        Approval.ProcessResult[] result2 =  Approval.process(allReq);
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        oppMap.put(testOpportunity.id, testOpportunity);
        //OpportunityTriggerHandler.updateOpportunityStage( oppMap, new Set<Id>{testOpportunity.Id});
        Test.stopTest();
    }

    @isTest
    static void testStageTrackingSkipped()
    {
        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;
        Opportunity opp = new Opportunity(Name='Oppty_test1', AccountID = Acc1.ID, StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        insert opp;
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        Contact testContact = new Contact(FirstName = 'test', LastName = 'test', AccountId = Acc1.id, Email = uniqueName+'test@test.com');
        insert testcontact;

        PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true and Product2.Name like '%Additional Pre-Production vCore%' limit 1];
        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id);
        oli.PriceBookEntryID = pbID.Id;
        oli.Quantity = 100;
        oli.UnitPrice = 20000.00;
        insert oli;
        opp.StageName = ConstantDeclarations.OPP_STAGE_VALIDATE_SOLUTION;
        opp.forecast__c='Commit';

        try
        {
            Test.startTest();
            update opp;

            Test.stopTest();
        }catch(Exception ex)
        {

        }
    }



    private static Account createTestAccount()
    {
        Account testAccount = new Account();
        testAccount.Name = 'TestAccount';
        testAccount.BillingCountry = 'US';
        insert testAccount;

        return testAccount;
    }

    private static Opportunity createTestOpportunity(Account testAccount)
    {
        Opportunity opp = new Opportunity();
        opp.Name = 'Oppty_test1';
        opp.AccountID = testAccount.ID;
        opp.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        opp.Type = 'Renewal';
        opp.CloseDate = System.Today();
        opp.Primary_Solution_Interest__c = 'SOA';
        insert opp;

        return opp;
    }

    @isTest
    static void testoppProcessrules()
    {
        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;

        Account Acc2 = new Account(Name='TestAccount', BillingCountry='US',Type='Enterprise Partner (OEM)');
        insert Acc2;

        Opportunity opp = new Opportunity(Name='Oppty_test1', AccountID = Acc1.ID, StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        opp.forecast__c='Commit';
        //opp.What_is_the_use_case_s__c = 'What_is_the_use_case_s__c';
        opp.What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c';
        opp.Opp_Business_Impact_ROI__c = 'Opp_Business_Impact_ROI__c';
        opp.Company_Description__c = 'Company_Description__c';
        opp.Compelling_Event__c = 'Compelling_Event__c';
        opp.Evaluation_Go_live_Timelines__c = 'Evaluation_Go_live_Timelines__c';
        opp.What_company_integration_strategy__c = 'What_company_integration_strategy__c';
        opp.Who_is_the_competition__c = 'Unknown';
        opp.Existing_ESB_other_technology__c ='None';
        opp.Developer_skills__c = 'JAVA';
        opp.What_are_biz_objectives_of_initiative__c = 'Bucket 1: Increase IT operational efficiency';
        opp.What_initiatives_will_we_support__c = '360-degree customer view';
        opp.Sales_Channel__c = 'Enterprise Direct';
        insert opp;

        Partner_Influence__c pis = new Partner_Influence__c(Opportunity__c= opp.id,Account__c=Acc2.ID,Partner_Role__c='Referral');
        insert pis;
        Extension__c es = new Extension__c(Name= 'Test Connector');
        insert es;
        Extension_Opportunity__c eos = new Extension_Opportunity__c(Extension__c=es.id,Critical__c=true,Opportunity__c=opp.id);
        Extension_Opportunity__c eos2 = new Extension_Opportunity__c(Extension__c=es.id,Critical__c=true,Opportunity__c=opp.id);
        insert eos;
        insert eos2;
        Contact newContact = MuleSoftInf_TestDataUtility.buildContactRecord(Acc1.Id, 'Inbound - Email');
        insert newContact;

        OpportunityContactRole newContactRole = MuleSoftInf_TestDataUtility.buildOpportunityContactRoleRecord(opp.Id, newContact.Id, true);
        newContactRole.role='Financial Decision Maker';
        insert newContactRole;

        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(Name = 'Anti-infectives 2007 mule esb', Family = 'Best Practices', IsActive = true);
        insert prod;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10, IsActive = true, UseStandardPrice = false);
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 10, Description = '2007 CMR #4 - Anti-Infectives');
        insert oli;

        opp.StageName = ConstantDeclarations.OPP_STAGE_CONFIRM_NEED_AND_IMPACT ;
        opp.Who_cares_about_it__c='test';
        opp.What_did_we_learn_on_the_intro_call__c = 'Some text';
        //opp.Why_does_this_opp_merit_more_investment__c  = 'Some text';
        //opp.if_presal_plan_to_advance_opportunity__c = 'Some text';
        //opp.Support_required_from_AE_sales__c = 'Some text';
        //opp.Pre_SAL_Type__c = 'Other';
        opp.Follow_on_meeting_scheduled__c = true;
        //opp.Attendees_for_follow_on_meeting__c = 'Other';
        //opp.What_is_the_business_need_initiative__c = 'Other';


        Test.startTest();
        update opp;

        Test.stopTest();

    }

    @isTest
    static void testprocessOppCreateOrder()
    {
        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;
        Opportunity opp = new Opportunity(Name='Oppty_test1 - Dataloader -', AccountID = Acc1.ID, StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        opp.What_are_biz_objectives_of_initiative__c = 'Bucket 1: Increase IT operational efficiency';
        opp.What_initiatives_will_we_support__c = '360-degree customer view';

        insert opp;

        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', IsActive = true,ProductCode='Test DLIOPro');
        insert prod;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 100002, IsActive = true, UseStandardPrice = false);
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 100002, Description = '2007 CMR #4 - Anti-Infectives');
        insert oli;
        system.debug('*************beforeInsert'+opp);

        opp.StageName = ConstantDeclarations.OPP_STAGE_CONFIRM_NEED_AND_IMPACT ;
        opp.forecast__c='Commit';
        opp.Intacct_Message__c = 'Test Message';
        opp.amount = 100002.00;
        opp.Sales_Channel__c = 'Self-Service';
        //opp.What_is_the_use_case_s__c = 'What_is_the_use_case_s__c';
        opp.What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c';
        opp.Opp_Business_Impact_ROI__c = 'Opp_Business_Impact_ROI__c';
        opp.Company_Description__c = 'Company_Description__c';
        opp.Compelling_Event__c = 'Compelling_Event__c';
        opp.Evaluation_Go_live_Timelines__c = 'Evaluation_Go_live_Timelines__c';
        opp.What_company_integration_strategy__c = 'What_company_integration_strategy__c';
        opp.Who_is_the_competition__c = 'Unknown';
        opp.Existing_ESB_other_technology__c ='None';
        opp.Developer_skills__c = 'JAVA';

        opp.What_did_we_learn_on_the_intro_call__c = 'Some text';
        //opp.Why_does_this_opp_merit_more_investment__c  = 'Some text';
        //opp.if_presal_plan_to_advance_opportunity__c = 'Some text';
        //opp.Support_required_from_AE_sales__c = 'Some text';
        //opp.Pre_SAL_Type__c = 'Other';
        opp.Follow_on_meeting_scheduled__c = true;
        //opp.Attendees_for_follow_on_meeting__c = 'Other';
        //opp.What_is_the_business_need_initiative__c = 'Other';

        update opp;
        Test.startTest();
        system.debug('*************'+opp);
        OpportunityTriggerHandler oHandler = new OpportunityTriggerHandler();
        oHandler.processOppCreateOrder(new set<id>{opp.Id});
        oHandler.createWonReport(new list<Opportunity>{opp});
        Test.stopTest();

    }

    @isTest
    static void testoppclosedLost()
    {
        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;
        Opportunity opp = new Opportunity(Name='Oppty_test1 - Dataloader -', AccountID = Acc1.ID, StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type ='New Business';
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';

        insert opp;

        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', IsActive = true,ProductCode='Test DLIOPro');
        insert prod;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 7500, Description = '2007 CMR #4 - Anti-Infectives');
        insert oli;

        system.debug('*************beforeInsert'+opp);
        opp.StageName = 'Rejected Lead' ;
        opp.forecast__c='Commit';
        opp.Intacct_Message__c = 'Test Message';
        opp.amount = 10.00;
        opp.Sales_Channel__c = 'Self-Service';
        //opp.What_is_the_use_case_s__c = 'What_is_the_use_case_s__c';
        opp.What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c';
        opp.Opp_Business_Impact_ROI__c = 'Opp_Business_Impact_ROI__c';
        opp.Company_Description__c = 'Company_Description__c';
        opp.Compelling_Event__c = 'Compelling_Event__c';
        opp.Evaluation_Go_live_Timelines__c = 'Evaluation_Go_live_Timelines__c';
        opp.What_company_integration_strategy__c = 'What_company_integration_strategy__c';
        opp.Who_is_the_competition__c = 'Unknown';
        opp.Existing_ESB_other_technology__c ='None';
        opp.Developer_skills__c = 'JAVA';
        opp.If_Closed_Lost_Primary_Reason__c = 'reason';
        update opp;
        Test.startTest();
        system.debug('*************'+opp);
        OpportunityTriggerHandler oHandler = new OpportunityTriggerHandler();
        oHandler.processOppCreateOrder(new set<id>{opp.Id});
        oHandler.createLossReport(new list<Opportunity>{opp});
        Test.stopTest();

    }

    @isTest
    static void testOpportunityPrimaryContactRoleValidation()
    {
        //create test accont
        Account Acc1 = new Account(Name='TestAccount', BillingCountry='US');
        insert Acc1;

        //create test opportunity
        Opportunity opp = new Opportunity(Name='Oppty_test1', AccountID = Acc1.ID, StageName=ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,Type ='Renewal', CloseDate=System.Today());
        opp.RecordTypeId = OpportunityTriggerHandler.getRecordTypeId('Standard / New Business').id;
        opp.Type =ConstantDeclarations.OPP_TYPE_NEW_BUSINESS;
        opp.Opportunity_Source__c ='Direct';
        opp.Primary_Solution_Interest__c = 'SOA';
        opp.Lead_Passed_By__c = Userinfo.getUserId();
        opp.Lead_Passed_By_Group__c='NA-ADR';
        opp.forecast__c='Commit';
        //opp.What_is_the_use_case_s__c = 'What_is_the_use_case_s__c';
        opp.What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c';
        opp.Opp_Business_Impact_ROI__c = 'Opp_Business_Impact_ROI__c';
        opp.Company_Description__c = 'Company_Description__c';
        opp.Compelling_Event__c = 'Compelling_Event__c';
        opp.Evaluation_Go_live_Timelines__c = 'Evaluation_Go_live_Timelines__c';
        opp.What_company_integration_strategy__c = 'What_company_integration_strategy__c';
        opp.Who_is_the_competition__c = 'Unknown';
        opp.Existing_ESB_other_technology__c ='None';
        opp.Developer_skills__c = 'JAVA';
        opp.What_did_we_learn_on_the_intro_call__c = 'Some text';
        //opp.Why_does_this_opp_merit_more_investment__c  = 'Some text';
        //opp.if_presal_plan_to_advance_opportunity__c = 'Some text';
        //opp.Support_required_from_AE_sales__c = 'Some text';
        //opp.Pre_SAL_Type__c = 'Other';
        opp.AE_Connect_Completed__c  = true;
        insert opp;

        System.debug('@@@@***@@@ Opp id: ' + opp.Id);

        //create test contact
        Contact testContact = new Contact(FirstName = 'test', LastName = 'test', AccountId = Acc1.id, Email = DateTime.now().getTime()+'test@test.com',
                LeadSource = 'Deal Registration', Lead_Source_Detail__c ='source detail', Lead_Source_Asset__c = 'source asset');
        insert testContact;
        System.debug('@@@@***@@@ testContact id: ' + testContact.Id);

        //set a negative wait time so that cut of is in the  future
        OpportunityTriggerHandler.minutesToWaitBeforeValidatingOpportunityPrimaryCotactRole = -1;
        Boolean hasErrors = false;
        try{
            update opp;
        }
        Catch(Exception ex){
            hasErrors = true;
        }
        //System.assert(hasErrors, 'Update should have failed without primary contact role');

        //create a primary contact role
        OpportunityContactRole oppConRole = new OpportunityContactRole(OpportunityId = opp.Id, ContactId = testContact.Id, Role='Other', IsPrimary = true);
        insert oppConRole;

        System.debug('@@@@***@@@  conrolestest'+ [Select Id, OpportunityId,ContactId, Role, IsPrimary, Opportunity.Type from OpportunityContactRole Where Id =: oppConRole.Id]);

        //reset opportunity contact role map
        OpportunityTriggerHandler.opportunityContactRoleMap = new Map<Id, List<OpportunityContactRole>>();
        update opp;
    }

    @isTest
    static void testOpportunityCloseDateChangeAndSubmitForApprovalInTHeSameTransaction(){
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>
        {'Type' => ConstantDeclarations.OPP_TYPE_RENEWAL
        })[0];
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', IsActive = true,ProductCode='Test DLIOPro');
        insert prod;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 100002, IsActive = true, UseStandardPrice = false);
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 100002, Description = '2007 CMR #4 - Anti-Infectives');
        insert oli;

        Test.startTest();
        //change opportunity stage and close date at the same time
        opp.stageName = ConstantDeclarations.OPP_STAGE_SUBMIT_CLOSING;
        opp.CloseDate = Date.today().adddays(5);
        update opp;

        Test.stoptest();

        Id opportunityInClosingRenewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_LABEL).getRecordTypeId();
        opp = [Select Id, RecordTYpeId, CloseDate from Opportunity where Id =: opp.Id];
        oli = [Select Id, ServiceDate from OpportunityLineItem where Id =: oli.Id];

        System.assert(opp.RecordTypeId == opportunityInClosingRenewalRecordTypeId, 'Opportunity Record Type should have been updated');
        System.assert(opp.closeDate == oli.ServiceDate, 'Opportunity Line Item service date should have been updated');
    }

    @isTest
    static void testInitiativeAndObjectiveRollupsToAccount(){

        //create test account
        Map<String, Object> testAccountAttributes = new Map<String, Object>();
        testAccountAttributes.put(String.valueOf(Account.Customer_Initiative__c), 'Benefits Management');
        testAccountAttributes.put(String.valueOf(Account.What_are_biz_objectives_of_initiative__c), 'Bucket 1: Increase IT operational efficiency');
        List<Account> testAccounts = TestDataFactory.createAccounts(1, true, testAccountAttributes);

        //create test opportunities
        Map<String, Object> testOpportunityAttributes = new Map<String, Object>();
        testOpportunityAttributes.put(String.valueOf(Opportunity.Type), ConstantDeclarations.OPP_TYPE_RENEWAL);
        testOpportunityAttributes.put(String.valueOf(Opportunity.What_initiatives_will_we_support__c), 'Customer onboarding;Ecommerce');
        testOpportunityAttributes.put(String.valueOf(Opportunity.What_are_biz_objectives_of_initiative__c), 'Bucket 2: Improve customer experience');
        testOpportunityAttributes.put(String.valueOf(Opportunity.AccountId), testAccounts[0].Id);

        List<Opportunity> testOpportunities = TestDataFactory.createOpportunity(5, true, testOpportunityAttributes);

        //set up test product
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', IsActive = true,ProductCode='Test DLIOPro');
        insert prod;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 100002, IsActive = true, UseStandardPrice = false);
        insert pbe;

        //set opportunity line items
        List<OpportunityLineItem> testLineItems = new List<OpportunityLineItem>();
        for(Opportunity opp: testOpportunities){
            OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 100002, Description = '2007 CMR #4 - Anti-Infectives');
            testLineItems.add(oli);
        }
        insert testLineItems;

        Test.startTest();
        //set opportunity as closed won
        Id opportunityInClosingRenewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_LABEL).getRecordTypeId();
        for(Opportunity opp: testOpportunities){
            opp.stageName = ConstantDeclarations.OPP_STAGE_CLOSED_WON;
            opp.CloseDate = Date.today().adddays(5);
            opp.RecordTypeId = opportunityInClosingRenewalRecordTypeId;
            opp.Multi_Year_Deal__c = 'yes';
            opp.If_yes_Year_X_of_Total_Years__c = '1';
        }
        update testOpportunities;
        Test.stopTest();

        //assert objectives and Initiatives are rolled up to the account level
        Account accountAfterRollup = [Select Id, Customer_Initiative__c, What_are_biz_objectives_of_initiative__c
        from Account
        where Id =: testAccounts[0].Id];
        //assert account initiative was kept
        System.assert(accountAfterRollup.Customer_Initiative__c.contains('Benefits Management'));
        //assert initiatives from opportunities were rolled up
        System.assert(accountAfterRollup.Customer_Initiative__c.contains('Customer onboarding'));
        System.assert(accountAfterRollup.Customer_Initiative__c.contains('Ecommerce'));

        //assert account objectives were kept
        System.assert(accountAfterRollup.What_are_biz_objectives_of_initiative__c.contains('Bucket 1: Increase IT operational efficiency'));
        //assert objectives from opportunities were rolled up
        System.assert(accountAfterRollup.What_are_biz_objectives_of_initiative__c.contains('Bucket 2: Improve customer experience'));

    }

    private static testMethod void testCopyScActionsToDuplicateOpp(){
        // Create test data
        Account testAccount = createTestAccount();
        List<Opportunity> opps = TestDataFactory.createOpportunity(2, true, new Map<String, Object>{
                'AccountId' => testAccount.Id,
                'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
                'CloseDate' => date.Today(),
                'Type'=>'Renewal'
        });
        Opportunity testOpp1 = opps[0];
        Opportunity testOpp2 = opps[1];

        SC_Action__c sca = new SC_Action__c ();
        sca.RecordTypeId = SCActionTriggerHandler.getRecordTypeId('PoC/PoV/custom demo').id;
        sca.Opportunity__c = testOpp1.Id;
        sca.On_site1__c = 'No';
        insert sca;

        testOpp1.forecast__c = 'Closed';
        testOpp1.StageName = 'Closed Lost';
        testOpp1.If_Closed_Lost_Primary_Reason__c = 'Duplicate';
        testOpp1.forecast__c='Commit';
        testOpp1.Duplicate_Opportunity_if_exists__c = testOpp2.Id;

        List<SC_Action__c> scActions1 = [SELECT Id FROM SC_Action__c WHERE Opportunity__c = :testOpp1.ID];
        System.assert(scActions1.size() == 1, '1 SC action is linked to this Opp');

        Test.startTest();
        update testOpp1;
        Test.stopTest();
        //Validate that the SC Actions are copied to the Duplicate Opportunity
        List<SC_Action__c> scActions2 = [SELECT Id FROM SC_Action__c WHERE Opportunity__c = :testOpp2.ID];
        System.assert(scActions2.size() == 1, 'SC actions should have been copied');
        List<SC_Action__c> scActions3 = [SELECT Id FROM SC_Action__c WHERE Opportunity__c = :testOpp1.ID];
        System.assert(scActions3.size() == 0, 'No SC action is linked to this Opp');
    }
}