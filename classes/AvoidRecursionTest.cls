@isTest
public class AvoidRecursionTest {
	public static testMethod void testAvoidRecursion(){
		System.assert(AvoidRecursion.isFirstRun(), 'Recursion check failed.');
    }
}