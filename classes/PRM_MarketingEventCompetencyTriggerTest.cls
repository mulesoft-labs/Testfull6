@isTest
private class PRM_MarketingEventCompetencyTriggerTest{

    static testMethod void myCompetencyTest() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'brucetest2@test.com'+System.now().millisecond(),
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
            user1 = new User(  Username = System.now().millisecond() + 'test12345@test.com'+System.now().millisecond(),
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
          
            user2 = new User(  Username = System.now().millisecond() + 'test12345@test.com'+System.now().millisecond(),
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
            test.starttest();
            Competency__c c= new Competency__c();
             
            Database.insert(c);
            c.Rejected__c= true;
            try{
            Database.update(c);
            } catch(Exception e){}
            
            test.stoptest();
                      
        } 
    }   
    
           static testMethod void myMarketingEventTest() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com'+System.now().millisecond(),
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
			string orgId = UserInfo.getOrganizationId();
	    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
	    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
      	String uniqueName = orgId + dateString + randomInt;
            //Create contact
            Contact contact1 = new Contact( FirstName = 'Test',
                                            Lastname = 'McTesty',
                                            AccountId = portalAccount1.Id,
                                            Email = uniqueName + 'test@test.com'
            );
            Database.insert(contact1);
                
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile WHERE UserType='PowerPartner' OR UserType='PowerPartner' Limit 1];
            user1 = new User(  Username = System.now().millisecond() + 'testnow98765432112345@test.com'+System.now().millisecond(),
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
          
            user2 = new User(  Username = System.now().millisecond() + 'test123456789012345678@test.com'+System.now().millisecond(),
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
            test.starttest();
            Marketing_Event__c m= new Marketing_Event__c();
             
            Database.insert(m);
            m.Rejected__c= true;
            try{
            Database.update(m);
            } catch(Exception e){}
            
            test.stoptest();
                      
        } 
    }  
}