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
private class TestAutoGenMilestones {

    static testMethod void myUnitTest() {
        Project__c proj = new Project__c();
        proj.Project_Limit__c  = 10000;
    	proj.Projected_Completion_Date__c = Date.today();
    	
    	//insert proj;
        
        PageReference pageRef = Page.NewProject;
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(proj);
        
        NewProjectController npc = new NewProjectController(sc);
        
        Milestone_Template__c template = new Milestone_Template__c();
        
        template.name = 'First Milestone';
        
        insert template;
        
        proj.Generate_Default_Milestones__c = true;
        
        proj.Generate_Default_Work_Tasks__c = true;
        
        
        npc.saveProject();
        
        
        Milestone__c[] milestones = [select id,name from Milestone__c where name='First Milestone' and project__c=:proj.id];
        
        Integer size = milestones.size();
        
        System.assertEquals(1,size);
        
        Work_Task__c[] tasks = [select id,name from Work_Task__c where name='Complete First Milestone' and project__c=:proj.id];
        
        size = tasks.size();
        
        System.assertEquals(1,size);
        
        
        
        
    }
}