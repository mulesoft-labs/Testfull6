/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestNewTimeLogWithMilestone {

    static testMethod void myUnitTest() {
    	
    	Project__c p = new Project__c();
    	p.name =  'Testing project';
    	p.Project_Limit__c  = 10000;
    	p.Projected_Completion_Date__c = Date.today();
    	
    	insert p;
    	
    	Milestone__c m = new Milestone__c();
    	m.name = 'My Milestone';
    	
    	m.Project__c = p.id;
    	
    	insert m;
    	
    	
    	  PageReference pageRef = Page.NewTimeLog;
        
        pageRef.getParameters().put('phaseID', String.valueOf(m.Id));
        
        Test.setCurrentPage(pageRef);
        
    	
       ApexPages.StandardController sc = new ApexPages.StandardController(m);
        NewTimeLogController ntlc = new NewTimeLogController(sc);
        
        
        
        System.assertEquals(true,ntlc.gethasMilestone());
        
        
    }
}