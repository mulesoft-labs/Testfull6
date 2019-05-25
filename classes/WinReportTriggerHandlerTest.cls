/*** 
* Class: WinReportTriggerHandlerTest
* Description: Unit test for WinReportTriggerHandlerTest
* Author: Elmar Chen
* Create Time: 06/25/2015 15:02:47
*
**********************************************************************
*
*   Date            Author                 Change
*   06/25/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class WinReportTriggerHandlerTest {
    
    @isTest static void test_WinReportTriggerHandlerTest() {
        Win_Report__c wr = new Win_Report__c(Win_Report_Complete_2__c = 'Yes',
            Opportunity__c = TestDataFactory.createOpportunity(1, true, null)[0].Id
        );
    Test.startTest();
    System.debug(wr.Opportunity_Team__c);
        Boolean r = new WinReportTriggerHandler().validateForComplete(wr);
    Test.stopTest();
        //System.assertEquals(true, r);
        try{
            insert wr;
            //System.assert(false, 'insertion must be failed.');
        }catch(Exception e){
            System.debug(e);
        }
    }
    
}