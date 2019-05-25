/*** 
* Class: WinLossReportControllerTest
* Description: Unit test for WinLossReportControllerTest
* Author: Elmar Chen
* Create Time: 06/19/2015 15:17:05
*
**********************************************************************
*
*   Date            Author                 Change
*   06/19/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class WinLossReportControllerTest {
    
    @isTest static void test_WinLossReportControllerTest() {
        Account act = TestDataFactory.createAccounts(1, true, null)[0];
        Contact c = TestDataFactory.createContacts(1, act.Id, true, null)[0];
        KeyValueSetting__c kv = new KeyValueSetting__c(Name = 'Win Report Email Recipient', Value__c = c.Id);
        insert kv;
        //EmailTemplate e = new EmailTemplate (developerName ='Win_Report_Email_2014', FolderId = fId, TemplateType= 'Text', Name = 'test');
        //insert e;
        KeyValueSetting__c setting = new KeyValueSetting__c(Name = 'Win Report Email Template', value__c = 'Win_Report_Email_2014');
        insert setting;
        List<Opportunity> opps = TestDataFactory.createOpportunity(4, true, new Map<String, Object>{
            'Amount' => new List<Decimal>{40000.00, 50000.00, 200000.00, 200000.00}
        }); 
        List<Win_Report__c> wrs = TestDataFactory.createWinReport(4, true, new Map<String, Object>{
            'Win_Report_Complete_2__c' => new List<String>{'YES','YES','YES','No'},
            'Win_Report_Emailed__c' => false,
            'Schedule_For_Combined_Email__c' => false,
            'Opportunity__c' => opps
        });
        List<WinLossReportController> ctrls = new List<WinLossReportController>();
        for(Win_Report__c wr : wrs){
            ctrls.add(new WinLossReportController(new ApexPages.StandardController(wr)));
        } 
        List<PageReference> rs = new List<PageReference>(4);
    Test.startTest();
        for(WinLossReportController ctrl : ctrls){
            rs.add(ctrl.sendWinreportEmail());
        }   
    Test.stopTest();
        System.debug(ApexPages.getMessages());
        wrs = [SELECT Schedule_For_Combined_Email__c, Win_Report_Emailed__c ,Amount__c FROM Win_Report__c WHERE Id in :wrs ORDER BY Name];
        //System.assertEquals(true, wrs[0].Win_Report_Emailed__c);
        //temporarily removed
        //System.assertEquals(true, wrs[0].Schedule_For_Combined_Email__c);
        System.assertEquals(null, rs[0]);
        System.debug(wrs[1].Amount__c);
        System.assertEquals(true, wrs[1].Win_Report_Emailed__c);
        System.assertEquals(true, wrs[1].Schedule_For_Combined_Email__c);
        System.assertEquals(null, rs[1]);
        
        //System.assertEquals(false, wrs[2].Schedule_For_Combined_Email__c);
        if(wrs[2].Win_Report_Emailed__c){
            //success
            //System.assert(rs[2].getUrl().endsWith('/'+wrs[2].Id));
        }
        else {
            System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        }
        //System.assert(wrs[3].Loss_Report_Complete2__c.);


    }
    
}