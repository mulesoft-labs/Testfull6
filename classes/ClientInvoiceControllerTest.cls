/*** 
* Class: ClientInvoiceControllerTest
* Description: Unit test for ClientInvoiceControllerTest
* Author: Elmar Chen
* Create Time: 06/28/2015 22:02:28
*
**********************************************************************
*
*   Date            Author                 Change
*   06/28/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class ClientInvoiceControllerTest {
	
	@isTest static void test_ClientInvoiceControllerTest() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		Invoice__c iv = (Invoice__c)TestDataFactory.createObjects(Invoice__c.SObjectType, 1, true, new Map<String, Object>{
			'Project__c' => prj.Id,
			'invoice_date__c' => Date.today(),
			'invoice_style__c' => 'Time and Materials'
		})[0];
		List<Pricing_Sheets__c> pss = TestDataFactory.createObjects(
			Pricing_Sheets__c.SObjectType, 10, true, new Map<String, Object>{
				'principal_consultant_rate__c' => 100,
				'Project__c' => prj.Id
		});

		List<Invoice_Item__c> iis = TestDataFactory.createObjects(
			Invoice_Item__c.SObjectType, 10, true, new Map<String, Object>{
				'Invoice__c' => iv.id,
				'Hours__c' => 5,
				'Bill_As__c' => pss,
				'Date__c' => Date.today()
		});

		List<Invoice_Expense__c> ies = TestDataFactory.createObjects(
			Invoice_Expense__c.SObjectType, 10, true, new Map<String, Object>{
				'Invoice__c' => iv.id,
				'Amount__c' => 100,
				'Date__c' => Date.today()	
		});
		List<Invoice_Credit__c> ics = TestDataFactory.createObjects(
			Invoice_Credit__c.SObjectType, 10, true, new Map<String, Object>{
				'Invoice__c' => iv.id,
				'Amount__c' => 100,
				'Date__c' => Date.today()
		});

		Employee__c employee = (Employee__c)TestDataFactory.createObjects(
			Employee__c.SObjectType, 1, true, new Map<String, Object>{
				'Name' => 'Karl Kasai'
		})[0];


		List<Time_Log__c> tls = TestDataFactory.createObjects(
			Time_Log__c.SObjectType, 10, true, new Map<String, Object>{
				'Project__c' => prj.Id,
				'Hours__c' => 5,
				'Pricing_Sheet__c' => pss,
				'Employee__c' => employee,
    			'Billed_Status__c' => 'Incurred',
    			'Date__c' => Date.today()
		});
    	List<Fixed_Fee_Log__c> ffls = TestDataFactory.createObjects(
			Fixed_Fee_Log__c.SObjectType, 10, true, new Map<String, Object>{
				'Invoice__c' => iv.id,
				'Amount__c' => 100,
				'Date__c' => Date.today()
		});

    	System.currentPagereference().getParameters().put('id', iv.Id);
	Test.startTest();
		ClientInvoiceController cic = new ClientInvoiceController(
			new ApexPages.StandardController(iv));
	Test.stopTest();
		System.assertEquals(10, cic.getFFLogs().size());
		System.assertEquals(10, cic.getInvoiceItems().size());
		System.assertEquals(500.0, cic.getAmountForInvoiceItem(pss, iis[0]));
		System.assertEquals(iv.invoice_date__c, cic.getTodaysDate());
		System.assertEquals(null, cic.getOpportunity());
		System.assertEquals(true, cic.getRenderTimeLogs());
		System.assertEquals(10, cic.getInvoiceExpenses().size());
		System.assertEquals(10, cic.getInvoiceCredits().size());
	}



	@isTest
	static void test_getterSetters() {
		Project__c prj = TestDataFactory.createProject(1, true, null)[0];
		List<Invoice__c> ivs = TestDataFactory.createObjects(
			Invoice__c.SObjectType, 6, true, new Map<String, Object>{
				'Project__c' => prj.Id,
				'invoice_date__c' => Date.today(),
				'invoice_style__c' => 'Fixed Fee',
				'Payment_Terms__c' => new List<String>{
					null,'Payable on Receipt','Net 30','Net 45','Net 75','Net 90'}
		});
	Test.startTest();
		List<ClientInvoiceController> cics = new List<ClientInvoiceController>();
		for(Integer i=0; i<ivs.size(); i++){
			cics.add(new ClientInvoiceController(ivs[i]));
		}
	Test.stopTest();
		System.assertEquals(false, cics[0].getRenderTimeLogs());
		System.assertEquals(Date.today(), cics[0].calculateDueDate());
		System.assertEquals(Date.today(), cics[1].calculateDueDate());
		System.assertEquals(Date.today().addDays(30), cics[2].calculateDueDate());
		System.assertEquals(Date.today().addDays(45), cics[3].calculateDueDate());
		System.assertEquals(Date.today().addDays(75), cics[4].calculateDueDate());
		System.assertEquals(Date.today().addDays(90), cics[5].calculateDueDate());
	}
	
}