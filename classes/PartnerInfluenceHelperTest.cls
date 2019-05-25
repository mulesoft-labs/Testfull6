/*** 
* Class: PartnerInfluenceHelperTest
* Description: Unit test for PartnerInfluenceHelperTest
* Author: Elmar Chen
* Create Time: 06/29/2015 10:21:49
*
**********************************************************************
*
*   Date            Author                 Change
*   06/29/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class PartnerInfluenceHelperTest {
    
    @isTest static void test_PartnerInfluenceHelperTest() {

        User u = TestDataFactory.createUser('2_18 Sales Hybrid', Label.TestClassRoleName, true);
        System.runAs(u){
            List<Account> accts = TestDataFactory.createAccounts(20, true, null);
            List<Opportunity> opps = TestDataFactory.createOpportunity(20, true, new Map<String, Object>{
                'Opportunity_Source__c' => OpportunitySettings.sOpptySource_Indirect_Channel_SI_VAR
            });

            List<Partner_Influence__c> pis = TestDataFactory.createObjects(Partner_Influence__c.SObjectType, 20, false, new Map<String, Object>{
                'Opportunity__c' => opps,
                'Account__c' => accts
            });
            for(Partner_Influence__c pi: pis){
                pi.Sourced__c = true;
            }
            insert pis; 

            Test.startTest();
                new PartnerInfluenceHelper().addAccountOwnerAsOpptyTeamMember(new Map<Id, Partner_Influence__c>(pis));
            Test.stopTest();
        }
        List<OpportunityTeamMember> ots = [SELECT Id FROM OpportunityTeamMember where TeamMemberRole =: OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_PARTNER_MGR];
        System.assertEquals(20, ots.size());

    }
    
}