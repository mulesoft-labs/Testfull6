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
@isTest (seeAlldata=true)

private class TestLeadOwnerRoleTrigger {

    static testMethod void myUnitTest() {
        
        Id userRoleId = UserInfo.getUserRoleId();
        
        Id userId =  UserInfo.getUserId();
        
        
        
        Lead l = new Lead();
        
        l.firstname = 'Test-' + UserInfo.getName();
        
        l.lastname= 'Lead Ignore';
        
        l.Company = 'Test Company';
        
        l.OwnerId = userId;

        l.Country = 'US';
        
        insert l;
        
        List<UserRole> role = [select id,name from UserRole where id=:userRoleId] ;
        
        if (role.size() >0)
        {
            Lead lead = [select id,name,lead_owner_role__c from Lead where id=:l.id limit 1];
            String roleName = role[0].name;
            
            String leadRoleName = lead.Lead_Owner_Role__c;
            
            //System.assertEquals(leadRoleName,roleName);
        }       
    }
}