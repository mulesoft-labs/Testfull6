/*** 
* Class: SolutionAssessmentCustomCreateTest
* Description: Unit test for SolutionAssessmentCustomCreateTest
* Author: Elmar Chen
* Create Time: 06/18/2015 10:20:05
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class SolutionAssessmentCustomCreateTest {
    
    @isTest static void test_withoutTechAssessment() {
        Account act = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{                
                'What_business_problem_are_they_solving__c' => 'What_business_problem_are_they_solving__c',
                'Opp_Business_Impact_ROI__c' => 'Opp_Business_Impact_ROI__c',
                'Compelling_Event__c' => 'Compelling_Event__c', 
                'Evaluation_Go_live_Timelines__c' => 'Evaluation_Go_live_Timelines__c',
                'What_company_integration_strategy__c' => 'What_company_integration_strategy__c',
                'Who_is_the_competition__c' => 'Who_is_the_competition__c',
                'Existing_ESB_other_technology__c' => 'Existing_ESB_other_technology__c',
                'Developer_skills__c' => 'Developer_skills__c',
                'AccountId' => act.Id
        })[0];
    Test.startTest();
        SolutionAssessmentCustomCreate ctrl = new SolutionAssessmentCustomCreate(new ApexPages.StandardController(opp));
        PageReference r = ctrl.NewSolutionAssessment();

        List<Profile_Qualification__c> pqs = [SELECT Name, Opportunity__c, 
            What_business_problem_are_they_solving__c, What_is_the_business_impact_AND_ROI__c,
            What_is_the_compelling_event__c, Evaluation_Go_live_Timelines__c, Current_or_Past_Integration_Strategy__c,
            Competition__c, Existing_ESB_or_other_technology__c, Describe_Developer_Skillset__c, Account__c 
            FROM Profile_Qualification__c WHERE Opportunity__c = :opp.Id];

        Profile_Qualification__c pq = pqs[0];   
        System.assert(r.getUrl().endsWith('/e?retURL=%2F' + pq.Id));

        System.assertEquals(opp.Name + '-' + 'Solution Assessment', pq.Name);
        System.assertEquals(opp.Id, pq.Opportunity__c);
        //System.assertEquals(opp.What_is_the_use_case_s__c, pq.What_is_the_use_case_s__c);
        System.assertEquals(opp.What_business_problem_are_they_solving__c, pq.What_business_problem_are_they_solving__c);
        System.assertEquals(opp.Opp_Business_Impact_ROI__c, pq.What_is_the_business_impact_AND_ROI__c);
        System.assertEquals(opp.Compelling_Event__c, pq.What_is_the_compelling_event__c);
        System.assertEquals(opp.Evaluation_Go_live_Timelines__c, pq.Evaluation_Go_live_Timelines__c);
        System.assertEquals(opp.What_company_integration_strategy__c, pq.Current_or_Past_Integration_Strategy__c);
        System.assertEquals(opp.Who_is_the_competition__c, pq.Competition__c);
        System.assertEquals(opp.Existing_ESB_other_technology__c, pq.Existing_ESB_or_other_technology__c);
        System.assertEquals(opp.Developer_skills__c, pq.Describe_Developer_Skillset__c);
        System.assertEquals(opp.AccountId, pq.Account__c);
    }
    
    @isTest static void test_withTechAssessment() {
        Account act = TestDataFactory.createAccounts(1, true, null)[0];
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{
                
        })[0];
        Profile_Qualification__c ta = (Profile_Qualification__c) TestDataFactory.createObjects(
            Profile_Qualification__c.SObjectType, 1, true, new Map<String, Object>{
                'Opportunity__c'=> opp.Id
        })[0];
        opp.Tech_Assessment__c = ta.Id;
    Test.startTest();
        SolutionAssessmentCustomCreate ctrl = new SolutionAssessmentCustomCreate(new ApexPages.StandardController(opp));
        PageReference r = ctrl.NewSolutionAssessment();

        System.assert(r.getUrl().endsWith('/e?retURL=%2F' + ta.Id));

    }
}