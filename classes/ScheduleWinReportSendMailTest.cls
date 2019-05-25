/*** 
* Class: ScheduleWinReportSendMailTest
* Description: Unit test for ScheduleWinReportSendMail
* Author: Elmar Chen
* Create Time: 06/11/2015 15:27:53
*
**********************************************************************
*
*   Date            Author                 Change
*   06/11/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class ScheduleWinReportSendMailTest {
	private static void initTestData(Boolean validSendTo){
		Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{
			'Amount' => 100000
		})[0];
		Lead l = new Lead(LastName='LeadName', Company = 'Lead Company', Email='abc@def.com');
		insert l;
		KeyValueSetting__c kv = new KeyValueSetting__c(
			Name = 'Win Report Email Recipient',
			Value__c = validSendTo ? l.Id : opp.Id);
		insert kv;

		List<Win_Report__c> wrs = TestDataFactory.createWinReport(20, true, new Map<String, Object>{
			'Opportunity__c' => opp.Id,
			'Schedule_For_Combined_Email__c' => true
	    });
		
	}
	@isTest static void test_ScheduleWinReportSendMail() {
		initTestData(true);
	Test.startTest();
			new ScheduleWinReportSendMail().execute(null);
	Test.stopTest();

		//No Validation can be made because the result is configuation related.

		
		//List<EmailMessage> msgs = [SELECT Status, HtmlBody FROM EmailMessage];
		//System.debug(msgs);
		//List<Win_Report__c> wrs = [SELECT Schedule_For_Combined_Email__c FROM Win_Report__c];
		//for(Win_Report__c wr : wrs) { 
		//	System.assertEquals(msgs.size()>0 ? false : true, wr.Schedule_For_Combined_Email__c);
		//} 
	}
	
	@isTest static void test_ScheduleWinReportSendMailError() {
		initTestData(false);
	Test.startTest();
			new ScheduleWinReportSendMail().execute(null);
	Test.stopTest();
		List<EmailMessage> msgs = [SELECT Status, HtmlBody FROM EmailMessage];
		System.assertEquals(0, msgs.size());
		List<Win_Report__c> wrs = [SELECT Schedule_For_Combined_Email__c FROM Win_Report__c];
		for(Win_Report__c wr : wrs) {
			System.assertEquals(true, wr.Schedule_For_Combined_Email__c);
		} 
	}
}