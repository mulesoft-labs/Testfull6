/*** 
* Class: testTimeLineconTrivialTest
* Description: Trivial Unit test for testTimeLinecon 
*              (Both testing and tested classes shall be deleted later)
* Author: Elmar Chen
* Create Time: 06/18/2015 13:43:06
*
**********************************************************************
*
*   Date            Author                 Change
*   06/18/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class testTimeLineconTrivialTest {
	
	@isTest static void test_testTimeLineconTrivialTest() {
		testTimeLinecon c = new testTimeLinecon();
		c.Test1 = '';
		c.Test2 = '';
		c.getTod_ay();
		c.Submit();
		c.getTomorr_ow();
   }
	
}