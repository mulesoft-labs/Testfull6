@isTest
private class CSVReader_Test {

	private static string sampleCSVString;
	
	static{
		sampleCSVString = 'First Name,Last Name,Account Id,Email\r\n"Test First",Test Last,001,test@test.com\r\nFirst Name2,Last Name2,002,test2@test.com';
	}

    static testMethod void myUnitTest() {

		Test.startTest();

		List<List<String>> data = CSVReader.Parse(sampleCSVString);

		Test.stopTest();

		//Validate
		System.assertEquals(3, data.size());
		System.assertEquals('First Name', data[0][0]);
		System.assertEquals('Test First', data[1][0]);
		System.AssertEquals('test2@test.com', data[2][3]);		
	}		
}