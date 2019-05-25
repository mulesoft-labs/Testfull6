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
private class TestNewResourceAllocation {

    static testMethod void myUnitTest() {
    	
    	Project__c proj = new Project__c();
    	proj.name = 'First Project';
    	proj.Project_Limit__c  = 10000;
    	proj.Projected_Completion_Date__c = Date.today();
    	
    	insert proj;
    	
    	Milestone__c milestone = new Milestone__c();
    	milestone.name = 'First Milestone';
    	
    	milestone.project__c = proj.id;
    	
    	insert milestone;
    	
    	Pricing_Sheets__c pricingSheet = new Pricing_Sheets__c();
    	pricingSheet.name = 'Project Manager';
    	pricingSheet.principal_consultant_rate__c = 150;
    	pricingSheet.project__c = proj.id;
    	
    	insert pricingSheet;
    	
    	String milestoneId = milestone.id;
    	NewResourceAllocationController rac = new NewResourceAllocationController(milestoneId);
    	
    	
    	List<SelectOption> options = rac.getRoles();
    	
    	boolean found = false;
    	
    	for (SelectOption option:options) {
    		String name = option.getLabel();
    		
    		if (name.equals('Project Manager')) {
    			found  = true;
    		}	
    		
    	}
    	
    	System.assertEquals(true, found);
    	
    	rac.setRoleId(pricingSheet.id);
    	
    	rac.saveRa();
    	
    	Resource_Allocation__c[] ras = [select id,name,role__c from Resource_Allocation__c where milestone__c=:milestone.id];
    	
    	Resource_Allocation__c alloc = ras[0];
    	
    	System.assertEquals(pricingsheet.id, alloc.Role__c);
    	
    	
    	
        
        
        
        
    }
}