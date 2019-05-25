/*** 
* Class: AutoCompleteControllerTest
* Description: Test case for AutoCompleteController
* Author: Elmar Chen
* Date: 06/08/2015 12:51:51
***/

@isTest
private class AutoCompleteControllerTest {
	
	
	
	@isTest static void test_searchSuggestions_byVendor() {
			System.currentPageReference().getParameters().put('objectname', 'Vendor');
			System.currentPageReference().getParameters().put('aname', 'Has A Key');
			List<Vendor__c> vendors = TestDataFactory.createVendors(20, false, null);
			for(Integer i=0; i<12; i++){
				vendors[i].Name = 'Has A Key '+i;
			}
			insert vendors;
			AutoCompleteController ctrl = new AutoCompleteController();

		Test.startTest();		
			PageReference r = ctrl.searchSuggestions();
		Test.stopTest();
			List<String> resultNames = ctrl.getResultsname();
			System.debug(resultNames);
			System.assertEquals(12, resultNames.size());
			System.assert(!ctrl.getHasparams());
			for(Integer i=0; i<12; i++){
				System.assert(resultNames[i].startsWith('Has A Key '));
			}
			System.assertEquals(null, r);
	}
	
	@isTest static void test_searchSuggestions_byVendorNoResult() {
			System.currentPageReference().getParameters().put('objectname', 'Vendor');
			System.currentPageReference().getParameters().put('aname', 'Has A Key');
			List<Vendor__c> vendors = TestDataFactory.createVendors(20, true, null);
			AutoCompleteController ctrl = new AutoCompleteController();

		Test.startTest();		
			PageReference r = ctrl.searchSuggestions();
		Test.stopTest();
			List<String> resultNames = ctrl.getResultsname();
			System.debug(resultNames);
			System.assertEquals(1, resultNames.size());
			System.assertEquals('No Results', resultNames[0]);
			System.assert(ctrl.getHasnoresults());
			System.assertEquals(null, r);
	}

	@isTest static void test_searchSuggestions_byAccount() {
			System.currentPageReference().getParameters().put('objectname', 'Account');
			System.currentPageReference().getParameters().put('aname', 'Has A Key');
			List<Account> accts = TestDataFactory.createAccounts(20, false, null);
			for(Integer i=0; i<12; i++){
				accts[i].Name = 'Has A Key '+i;
			}
			insert accts;
			AutoCompleteController ctrl = new AutoCompleteController();

		Test.startTest();		
			PageReference r = ctrl.searchSuggestions();
		Test.stopTest();
			List<String> resultNames = ctrl.getResultsname();
			System.debug(resultNames);
			System.assertEquals(10, resultNames.size());
			for(Integer i=0; i<10; i++){
				System.assert(resultNames[i].startsWith('Has A Key '));
			}
			System.assertEquals(null, r);
	}

	@isTest static void test_searchSuggestions_byWrongKeyword() {
				System.currentPageReference().getParameters().put('objectname', 'BadObjectName');
				System.currentPageReference().getParameters().put('aname', '\'Has A Key');
				AutoCompleteController ctrl = new AutoCompleteController();

			Test.startTest();		
				PageReference r = ctrl.searchSuggestions();
			Test.stopTest();
				List<String> resultNames = ctrl.getResultsname();
				System.debug(resultNames);
				System.assertEquals(1, resultNames.size());
				System.assert(resultNames[0].contains('Unexpected Error'));
				System.assertEquals(null, r);
		}

	@isTest static void test_searchSuggestions_byTooFewLetters() {
			System.currentPageReference().getParameters().put('objectname', 'Account');
			System.currentPageReference().getParameters().put('aname', 'H');
			AutoCompleteController ctrl = new AutoCompleteController();

		Test.startTest();		
			PageReference r = ctrl.searchSuggestions();
		Test.stopTest();
			List<String> resultNames = ctrl.getResultsname();
			System.debug(resultNames);
			System.assertEquals(1, resultNames.size());
			System.assertEquals('Please type additional letters', resultNames[0]);
			System.assertEquals(null, r);
	}

	@isTest static void test_trialMethod() {
		AutoCompleteController ctrl = new AutoCompleteController(null);
		System.assertEquals(null, ctrl.checkUniqueInRegistered(''));
		ctrl.avoidRefresh();
	}
}