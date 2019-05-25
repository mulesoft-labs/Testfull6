@isTest
public class PopulateAnypointUserDataTest {
    
    static testMethod void populateLead_InsertLeadFirst() 
    { 
        Lead lead = new Lead(LastName='Test', 
                             Email='test@test.com',
                             Company='Mulesoft');
        insert lead;
        
        AnypointOrganization__c org = new AnypointOrganization__c(Name='Test',
                                                                  CSId__c='123');
        insert org;
        
        AnypointUser__c user = new AnypointUser__c(Anypoint_Organization_Id__c=org.Id,
                                                   Name='test',
                                                   CSId__c='123',
                                                   Email__c='test@test.com');     
        insert user; 
        
        AnypointUser__c user2 = [SELECT Id, Lead__c from AnypointUser__C where Id = :user.Id LIMIT 1];
        System.assertEquals(lead.Id, user2.Lead__c);
    } 
    
        
    static testMethod void populateLead_InsertUserFirst() 
    { 
        AnypointOrganization__c org = new AnypointOrganization__c(Name='Test',
                                                                  CSId__c='123');
        insert org;
        
        AnypointUser__c user = new AnypointUser__c(Anypoint_Organization_Id__c=org.Id,
                                                   Name='test',
                                                   CSId__c='123',
                                                   Email__c='test@test.com');     
        insert user; 
        
        Lead lead = new Lead(LastName='Test', 
                             Email='test@test.com',
                             Company='Mulesoft');
        insert lead;
        
        AnypointUser__c user2 = [SELECT Id, Lead__c from AnypointUser__C where Id = :user.Id LIMIT 1];
        System.assertEquals(lead.Id, user2.Lead__c);
    } 
    
    static testMethod void deletedLeadAndTrigger() 
    { 
        Lead lead = new Lead(LastName='Test', 
                             Email='test@test.com',
                             Company='Mulesoft');
        insert lead;
        delete lead;
        
        AnypointOrganization__c org = new AnypointOrganization__c(Name='Test',
                                                                  CSId__c='123');
        insert org;
        
        AnypointUser__c user = new AnypointUser__c(Anypoint_Organization_Id__c=org.Id,
                                                   Name='test',
                                                   CSId__c='123',
                                                   Email__c='test@test.com');     
        insert user; 
        
        AnypointUser__c user2 = [SELECT Id, Lead__c from AnypointUser__C where Id = :user.Id LIMIT 1];
        System.assert(user2.Lead__c == null);
    }

    static testMethod void populateContactTest() 
    { 
        Account acct1 = new Account(Name='Mulesoft', 
                                   AnypointPlatformOrganizationId__c='123',
                                   BillingCountry='USA');
        insert acct1;
        
		string orgId = UserInfo.getOrganizationId();
	    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
	    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
      	String uniqueName = orgId + dateString + randomInt;
        
        Contact contact1 = new Contact(LastName='Test',
                                       AccountId=acct1.Id,
                                       Email=uniqueName+'test@test.com');
        insert contact1;
        

        
        AnypointOrganization__c org = new AnypointOrganization__c(Name='Test',
                                                                  CSId__c='123');
        insert org;
        
        // Did account get linked?
        Account[] accts = 
           [SELECT Id from Account  
                where Account.Anypoint_Organization__r.Id = :org.Id];
        System.assertEquals(1, accts.size());
        System.assertEquals(acct1.Id, accts.get(0).Id);
       
        // test that we link the account with the matching CS Id
        AnypointUser__c user = new AnypointUser__c(Anypoint_Organization_Id__c=org.Id,
                                                   Name='test',
                                                   CSId__c='userid',
                                                   Email__c=uniqueName+'test@test.com');     
        insert user; 
        
        // Did the user get linked correctly?
        AnypointUser__c result = [SELECT Id, Contact__r.Id from AnypointUser__C where Id = :user.Id LIMIT 1];
        System.assertEquals(contact1.Id, result.Contact__r.Id);

    } 
    
    static testMethod void populateContact_InsertContactAfter() 
    {   
        AnypointOrganization__c org = new AnypointOrganization__c(Name='Test',
                                                                  CSId__c='123');
        insert org;
        
        Account acct1 = new Account(Name='Mulesoft', 
                                   AnypointPlatformOrganizationId__c='123',
                                   BillingCountry='USA');
        insert acct1;
        
        // Did account get linked?
        Account[] accts = 
           [SELECT Id from Account  
                where Account.Anypoint_Organization__r.Id = :org.Id];
        System.assertEquals(1, accts.size());
        System.assertEquals(acct1.Id, accts.get(0).Id);
       
        // test that we link the account with the matching CS Id
        AnypointUser__c user = new AnypointUser__c(Anypoint_Organization_Id__c=org.Id,
                                                   Name='test',
                                                   CSId__c='userid',
                                                   Email__c='test@test.com');     
        insert user; 
        
        Contact contact1 = new Contact(LastName='Test',
                                       AccountId=acct1.Id,
                                       Email='test@test.com');
        insert contact1;
        
        
        // Did the user get linked correctly?
        AnypointUser__c result = [SELECT Id, Contact__r.Id from AnypointUser__C where Id = :user.Id LIMIT 1];
        System.assertEquals(contact1.Id, result.Contact__r.Id);
    } 
    
    static testMethod void populateAccountTest() 
    { 
        // Test that the account and org get linked based on the core services ID
        
        Account acct = new Account(Name='Mulesoft', 
                                   AnypointPlatformOrganizationId__c='123',
                                   BillingCountry='USA');
        insert acct;
        
        AnypointOrganization__c org = new AnypointOrganization__c(Name='Test',
                                                                  CSId__c='123');
        insert org;
        
        Account acct2 = [SELECT Id, Anypoint_Organization__c from Account where Id = :acct.Id LIMIT 1];
        System.assertEquals(org.Id, acct2.Anypoint_Organization__c);
    } 
    
    static testMethod void testInsertsWithNoLookups() 
    { 
        AnypointOrganization__c org = new AnypointOrganization__c(Name='Test',
                                                                  CSId__c='123');
        insert org;
        
        AnypointUser__c user = new AnypointUser__c(Anypoint_Organization_Id__c=org.Id,
                                                   Name='test',
                                                   CSId__c='123',
                                                   Email__c='test@test.com');     
        insert user; 
    } 
}