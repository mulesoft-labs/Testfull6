/*** 
* Class: timelineworkitemcontTest
* Description: Unit test for timelineworkitemcont
* Author: Elmar Chen
* Create Time: 06/11/2015 10:55:09
*
**********************************************************************
*
*   Date            Author                 Change
*   06/11/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************
*
* Potential bugs of the tested class:
* 	1. Status__c is checked against 'Closed', which is not a possible picklist value. It shall be 'Completed'
*/

@isTest
private class timelineworkitemcontTest {
	
	@isTest static void test_timelineworkitemcont() {
		List<Work_Task__c> wts = TestDataFactory.createWorkTask(20, false, new Map<String, Object>{
			'Name' => '<Name>',
			'Description__c' => 'Desc 1 & 2'
			});
		for(Integer i=0; i<20; i++){
			wts[i].Due_Date__c = Date.Today().AddDays(i);
			wts[i].Status__c = i<=9 ? 'In Progress' : 'Completed';
		}
		insert wts;
	Test.startTest();
		
		ApexPages.currentPage().getParameters().put('Test1', 'workitem');
   		ApexPages.currentPage().getParameters().put('Test2', 'completed date' );
   		timelineworkitemcont c1 = new timelineworkitemcont();
   		ApexPages.currentPage().getParameters().put('Test2', 'start date' );
   		timelineworkitemcont c2 = new timelineworkitemcont();
   		ApexPages.currentPage().getParameters().put('Test2', 'due date' );
   		timelineworkitemcont c3 = new timelineworkitemcont();
   		ApexPages.currentPage().getParameters().put('Test2', 'completed date' );
   	Test.stopTest();
   		List<Work_Task__c> lsttask1 = c1.getlsttask();
   		List<Work_Task__c> lsttask2 = c2.getlsttask();
   		List<Work_Task__c> lsttask3 = c3.getlsttask();

   		System.assertEquals(0, lsttask1.size());
		System.assertEquals(20, lsttask2.size());
		System.assertEquals(20, lsttask3.size());

   		List<Work_Task__c> cleanedtask1 = c1.getcleanedtask();
   		List<Work_Task__c> cleanedtask2 = c2.getcleanedtask();
   		List<Work_Task__c> cleanedtask3 = c3.getcleanedtask();
		
		System.assertEquals(0, cleanedtask1.size());
		System.assertEquals(20, cleanedtask2.size());
		System.assertEquals(20, cleanedtask3.size());
		
   		
   		List<Work_Task__c> cleanedtaskAll = new List<Work_Task__c>();
   		cleanedtaskAll.addAll(cleanedtask1);
   		cleanedtaskAll.addAll(cleanedtask2);
		cleanedtaskAll.addAll(cleanedtask3);

		for(Work_Task__c wt : cleanedtaskAll){
			System.assertEquals('&lt;Name&gt;', wt.Name);
			System.assertEquals('Desc 1 &amp; 2', wt.Description__c);
		}
	}

	
}