/*** 
* Class: ProjectSearchControllerTest
* Description: Unit test for ProjectSearchControllerTest
* Author: Elmar Chen
* Create Time: 06/25/2015 10:12:49
*
**********************************************************************
*
*   Date            Author                 Change
*   06/25/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class ProjectSearchControllerTest {
	
	private class TestJSONObject{
		public String id;
		public String text;
		public String href;
		public String extra;
	}

	@isTest static void test_Search() {
		List<Project__c> prjs = TestDataFactory.createProject(20, false, null);
		for(Integer i=0; i<prjs.size(); i++){
			prjs[i].Project_Status__c = 'Active';
			prjs[i].Projected_Completion_Date__c = Date.today().addDays(i);
			prjs[i].Project_Limit__c = 60;
			prjs[i].Name = (i<10 ? 'Project With Key' : 'Project No Key') + i;
		}
		insert prjs;
	Test.startTest();
		ApexPages.currentPage().getParameters().put('name','With Key');
		ProjectSearchController ctrl = new ProjectSearchController();
		String jsonText = ctrl.getJsonList();
	Test.stopTest();
		jsonText = jsonText.replaceAll('([A-Za-z]+):', '"$1":');//Salesforce JSON parser requires field names quoted by "'"
		System.debug(jsonText);
		List<TestJSONObject> l = (List<TestJSONObject>) 
			JSON.deserialize(jsonText, List<TestJSONObject>.class);
		System.assertEquals(0, l.size());

		//for(Integer i=0; i<10; i++){
		//	System.assertEquals(prjs[19-i].Id, l[i].id);
		//	System.assertEquals(prjs[19-i].Name, l[i].text);
		//	System.assertEquals('/'+prjs[19-i].Id, l[i].href);
		//	System.assertEquals(prjs[19-i].Projected_Completion_Date__c + '', l[i].extra);
		//}
	}	
	@isTest static void test_SearchWithNoTerm() {
	Test.startTest();
		ProjectSearchController ctrl = new ProjectSearchController();
		String jsonText = ctrl.getJsonList();
	Test.stopTest();
		jsonText = jsonText.replaceAll('([A-Za-z]+):', '"$1":');//Salesforce JSON parser requires field names quoted by "'"
		System.debug(jsonText);
		List<TestJSONObject> l = (List<TestJSONObject>) 
			JSON.deserialize(jsonText, List<TestJSONObject>.class);
		System.assertEquals(0, l.size());
		
		//for(Integer i=0; i<10; i++){
		//	System.assertEquals(prjs[19-i].Id, l[i].id);
		//	System.assertEquals(prjs[19-i].Name, l[i].text);
		//	System.assertEquals('/'+prjs[19-i].Id, l[i].href);
		//	System.assertEquals(prjs[19-i].Projected_Completion_Date__c + '', l[i].extra);
		//}
	}	

	
	@isTest static void test_parseName() {
		Map<String, String> names = new Map<String, String>{
			'John, Smith' => 'Smith John',
			'John,Smith' => 'Smith John',
			'John Smith' => 'John Smith',
			'John, Persie von' => 'Persie John',
			'John von Smith' => 'John von Smith'
		};
		for(String before : names.keySet()){
			System.assertEquals(names.get(before), ProjectSearchController.parseName(before));
		}
	}

	@isTest static void test_createC4CUser() {
		User user1 = ProjectSearchController.createC4CUser();
		UserRole role = [SELECT id, name from userrole WHERE name = 'NA-SC Lead'];	
        user1.UserRoleId = role.Id;
		insert user1;
		System.assertNotEquals(null, user1.Id);
	}
}