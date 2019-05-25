/*** 
* Class: InvoiceRecipientSelectControllerTest
* Description: Unit test for InvoiceRecipientSelectControllerTest
* Author: Elmar Chen
* Create Time: 06/24/2015 15:44:46
*
**********************************************************************
*
*   Date            Author                 Change
*   06/24/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class InvoiceRecipientSelectControllerTest {
	
	@isTest static void test_InvoiceRecipientSelectControllerTest() {
		Account act = TestDataFactory.createAccounts(1, true, null)[0];
		List<Contact> cnts = TestDataFactory.createContacts(5, act.Id, true, new Map<String, Object>{
			'Email' => 'xxx@abc.com',
			'email_selected__c' => new List<Boolean>{true, true, true, false, false},
			'accounts_receivable_contact__c' => true
		});
		Project__c prj = TestDataFactory.createProject(1, true, new Map<String, Object>{
			'Account__c' => act.Id
		})[0];
		List<Invoice__c> invs = TestDataFactory.createObjects(
			Invoice__c.SObjectType, 2, true, new Map<String, Object>{
				'Project__c' =>prj.Id,
				'Is_Finalized__c' => new List<Boolean>{true, false}
		});
		Invoice__c inv =invs[0];
		TestDataFactory.createObjects(Task_Create_Template__c.SObjectType, 20, true, new Map<String, Object>{
			'task_subject__c' => '{!accountname} {!invoicenumber}',
			'user__c' => UserInfo.getUserId(),
			'related_object_name__c' => new List<String>{'Invoice__c', 'Account'},
			'due_date_days__c' => 10,
			'private_task__c' => true
		});
	Test.startTest();

		InvoiceRecipientSelectController ic = 
			new InvoiceRecipientSelectController(new ApexPages.StandardController(inv));
		InvoiceRecipientSelectController ic2 = 
			new InvoiceRecipientSelectController(new ApexPages.StandardController(invs[1]));

		ic.setBlob(Blob.valueof('Some Content'));
		ic.emailSelectedContacts();
	Test.stopTest();
		//no side affect so no meaningful assertion can be done.
		System.assertEquals(null, ic.createTasks);
		System.assertEquals(5, ic.getAccountContacts().size());
		System.assertEquals(true, ic.getIsInvoiceFinalized());
		System.assertEquals(false, ic2.getIsInvoiceFinalized());
	}
	
}