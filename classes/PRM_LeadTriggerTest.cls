/*********************************************************************
*
*   Class Name: PRM_LeadTriggerTest
*
*   Description: Test class for trigger on lead when handle 
*                populate the Lead.Channel_Account_Maanger__c 
*                field with the Owner of the Partner's Account.
*
**********************************************************************
*
*   Date        Author            Change
*
*   07/04/14    Chris             Initial Creation                          
*
*********************************************************************/
@isTest
private class PRM_LeadTriggerTest{

    static testMethod void myUnitTest() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2mulesoft@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        User user1, user2;
        system.runAs(portalAccountOwner1){
            //Create account
            Account portalAccount1 = new Account(Name = 'TestAccount1', BillingCountry = 'US');
            Database.insert(portalAccount1);
            portalAccount1.IsPartner = True;
            Database.update(portalAccount1);

            //Create contact
            Contact contact1 = new Contact( FirstName = 'Test',
                                            Lastname = 'McTesty',
                                            AccountId = portalAccount1.Id,
                                            Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
                
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile WHERE UserType='PowerPartner' OR UserType='PowerPartner' Limit 1];
            user1 = new User(  Username = System.now().millisecond() + 'test12345@test.com',
                                ContactId = contact1.Id,
                                ProfileId = portalProfile.Id,
                                Alias = 'test123',
                                Email = 'test12345@test.com',
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'McTesty',
                                CommunityNickname = 'test12345',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US'                                           
            );
            Database.insert(user1); 
            
            //Create account
            Account portalAccount2 = new Account(Name = 'TestAccount2', BillingCountry = 'US');
            Database.insert(portalAccount2);
            portalAccount1.IsPartner = True;
            Database.update(portalAccount2);

            //Create contact
            Contact contact2 = new Contact( FirstName = 'Test2',
                                            Lastname = 'McTesty2',
                                            AccountId = portalAccount1.Id,
                                            Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact2);
                
            //Create user
          
            user2 = new User(  Username = System.now().millisecond() + 'test12345@test.com',
                                ContactId = contact2.Id,
                                ProfileId = portalProfile.Id,
                                Alias = 'test1232',
                                Email = 'test123452@test.com',
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'McTesty2',
                                CommunityNickname = 'test123452',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US'                                           
            );
            Database.insert(user2); 
           
        }
        system.runAs(user1){
            Id rtId = [SELECT Id FROM RecordType WHERE Name='PRM Deal Registration' limit 1].Id;
            Lead lead = new Lead( Company='Perficient',LastName='test',RecordTypeId=rtId,Country='US',DiscoverOrg_Industry__c='Automotive',Industry='Automotive');
             
            Database.insert(lead);
            lead.OwnerId = user2.Id;
            
            //Database.update(lead);
            Lead lead1 = new Lead( Company='Perficient1',LastName='test1',RecordTypeId=rtId,Country='US',DiscoverOrg_Industry__c='Automotive',Industry='Automotive');
            //Database.insert(lead1);
            System.debug('=='+portalAccountOwner1.Id);
            lead1.OwnerId = portalAccountOwner1.Id;
            //Database.update(lead1);
           
            
        } 
    }   
}