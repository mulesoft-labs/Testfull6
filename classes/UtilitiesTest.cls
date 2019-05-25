@isTest
private class UtilitiesTest {
	
	@isTest 
	static void test_method_one() {
		System.assert(Utilities.currentUser.Id == UserInfo.getUserId());
	}
	
	@isTest 
	static void test_method_two() {
		List<String> accountEditableFields = Utilities.getListOfEditableFields(Account.SobjectType);
		System.assert(accountEditableFields.size() > 0);
	}
	
}