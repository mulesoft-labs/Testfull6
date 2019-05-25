/*********************************************************************
*
*   File Name: OpportunityTeamMemberManager_Test.cls
*
*   File Description:  Test class for the OpportunityTeamMemberManager
*   class
*
**********************************************************************
*
*   Date        Author              Change
*   07/24/14    Robert              Included setting forecast field
*   03/05/14    Unknown             Initial Creation                             
*
*********************************************************************/   

@isTest
private class OpportunityTeamMemberManager_Test
{
    static testMethod void testOpportunityTeamMember()
    {
        Account acc = new Account(
                                     Name = 'Test Account',
                                     BillingCountry = 'US'
                                 );
        insert acc;
        
        Account acc2 = new Account(
                                      Name = 'Test Account',
                                      BillingCountry = 'US'
                                  );
        insert acc2;
        
        Account_Team__c accTeam = new Account_Team__c(
                                                        Account__c = acc.Id,
                                                        SC_Role_Details__c = 'Primary',
                                                        User__c = UserInfo.getUserId()
                                                     );
        insert accTeam;
        
        Test.startTest();
        
        Opportunity opp = new Opportunity(
                                            Name = 'Test Opp',
                                            CloseDate = System.Today().addMonths(1),
                                            StageName = 'Discovery',
                                            AccountId = acc.Id,
                                            Forecast__c = 'Likely',
                                            Primary_Solution_Interest__c = 'SOA'
                                         );
        insert opp;
        opp.AccountId = acc2.Id;
        update opp;
        
        Test.stopTest();
    }
}