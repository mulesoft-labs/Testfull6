/*** 
* Class: Opp_RelatedFieldsAfterUpdateTest
* Description: Unit test for trigger Opp_RelatedFieldsAfterUpdate
* Author: Elmar Chen
* Create Time: 06/10/2015 10:13:33
*
**********************************************************************
*
*   Date            Author                 Change
*   06/10/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class Opp_RelatedFieldsAfterUpdateTest {
    
    /*@isTest static void test_Opp_RelatedFieldsAfterUpdate() {
        Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{
            'Amount'  => 100,
            'StageName' => ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED,
            'CloseDate' => date.Today(),
            'Is_Opp_Name_Changed__c' => false,
            'Type' => 'New Business'
        })[0];

        Profile_Qualification__c pq = new Profile_Qualification__c(
            Opportunity__c = opp.Id);
        insert pq;
    Test.startTest();
        opp.Tech_Assessment__c = pq.Id;
        
        opp.Name = 'Another Name';
        opp.What_is_the_use_case_s__c = 'What_is_the_use_case_s__c';
        opp.What_business_problem_are_they_solving__c = 'What_business_problem_are_they_solving__c';
        opp.Opp_Business_Impact_ROI__c = 'Opp_Business_Impact_ROI__c';
        opp.Company_Description__c = 'Company_Description__c';
        opp.Compelling_Event__c = 'Compelling_Event__c';
        opp.Evaluation_Go_live_Timelines__c = 'Evaluation_Go_live_Timelines__c';
        opp.What_company_integration_strategy__c = 'What_company_integration_strategy__c';
        opp.Who_is_the_competition__c = 'Unknown';
        opp.Existing_ESB_other_technology__c ='None';
        opp.Developer_skills__c = 'JAVA';
        update opp;
    Test.stopTest();
        pq = [SELECT Name, What_is_the_use_case_s__c, What_business_problem_are_they_solving__c, 
            What_is_the_business_impact_AND_ROI__c, What_is_the_compelling_event__c, 
            Evaluation_Go_live_Timelines__c, Current_or_Past_Integration_Strategy__c, 
            Competition__c, Existing_ESB_or_other_technology__c, Describe_Developer_Skillset__c 
            FROM Profile_Qualification__c];

        //System.debug('pq.Name is: ' + pq.Name);
        //System.debug('pq.What_is_the_use_case_s__c is: ' + pq.What_is_the_use_case_s__c);
        //System.debug('pq.What_business_problem_are_they_solving__c is: ' + pq.What_business_problem_are_they_solving__c);
        //System.debug('pq.What_is_the_business_impact_AND_ROI__c is: ' + pq.What_is_the_business_impact_AND_ROI__c);
        //System.debug('pq.What_is_the_compelling_event__c is: ' + pq.What_is_the_compelling_event__c);
        //System.debug('pq.Evaluation_Go_live_Timelines__c is: ' + pq.Evaluation_Go_live_Timelines__c);
        //System.debug('pq.Current_or_Past_Integration_Strategy__c is: ' + pq.Current_or_Past_Integration_Strategy__c);
        //System.debug('pq.Competition__c is: ' + pq.Competition__c);
        //System.debug('pq.Existing_ESB_or_other_technology__c is: ' + pq.Existing_ESB_or_other_technology__c);
        //System.debug('pq.Describe_Developer_Skillset__c is: ' + pq.Describe_Developer_Skillset__c);

        System.assertEquals(opp.Name+'-'+'Solution Assessment', pq.Name);
        System.assertEquals(opp.What_is_the_use_case_s__c, pq.What_is_the_use_case_s__c);
        System.assertEquals(opp.What_business_problem_are_they_solving__c, pq.What_business_problem_are_they_solving__c);
        System.assertEquals(opp.Opp_Business_Impact_ROI__c, pq.What_is_the_business_impact_AND_ROI__c);
        System.assertEquals(opp.Compelling_Event__c, pq.What_is_the_compelling_event__c);
        System.assertEquals(opp.Evaluation_Go_live_Timelines__c, pq.Evaluation_Go_live_Timelines__c);
        System.assertEquals(opp.What_company_integration_strategy__c, pq.Current_or_Past_Integration_Strategy__c);
        System.assertEquals(opp.Who_is_the_competition__c, pq.Competition__c);
        System.assertEquals(opp.Existing_ESB_other_technology__c, pq.Existing_ESB_or_other_technology__c);
        System.assertEquals(opp.Developer_skills__c, pq.Describe_Developer_Skillset__c);

        opp = [SELECT Is_Opp_Name_Changed__c FROM Opportunity];
        System.assertEquals(false, opp.Is_Opp_Name_Changed__c);
    }*/
    
}