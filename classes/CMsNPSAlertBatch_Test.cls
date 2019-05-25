@isTest
public class CMsNPSAlertBatch_Test {
    @testSetup
    static void setup(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        // Insert account as current user
        System.runAs (thisUser) {
            List<Account> accounts = new List<Account>();
            List<NPS_Response__c> unpNPS = new List<NPS_Response__c>();
            List<UserRole> userRoles = new List<UserRole>();
            List<User> users = new List<User>();
            List<User> users2 = new List<User>();
            
            //Create roles
            UserRole Mulesoft_WW = new UserRole();
            Mulesoft_WW.Name = 'Mulesoft_WW';
            userRoles.add(Mulesoft_WW);
			insert Mulesoft_WW;
			
            UserRole WW_Sales = new UserRole();
            WW_Sales.Name = 'WW_Sales';
            WW_Sales.ParentRoleId = Mulesoft_WW.Id;
            userRoles.add(WW_Sales);
            insert WW_Sales;
			
            UserRole csmManager3_Role = new UserRole();
            csmManager3_Role.Name = 'WW-CS-VP';
            csmManager3_Role.ParentRoleId = WW_Sales.Id;
            userRoles.add(csmManager3_Role);
            insert csmManager3_Role;
			
            UserRole csmManager2_Role = new UserRole();
            csmManager2_Role.Name = 'EMEA-CS-TD';
            csmManager2_Role.ParentRoleId = csmManager3_Role.Id;
            userRoles.add(csmManager2_Role);
            insert csmManager2_Role;
			
            UserRole csmManager_Role = new UserRole();
            csmManager_Role.Name = 'EMEA-CS-NE-RD';
            csmManager_Role.ParentRoleId = csmManager2_Role.Id;
            userRoles.add(csmManager_Role);
			insert csmManager_Role;
			
            UserRole csm_Role = new UserRole();
            csm_Role.Name = 'EMEA-CS-NE-CSM';
            csm_Role.ParentRoleId = csmManager_Role.Id;
            userRoles.add(csm_Role);
            insert csm_Role;
			
            UserRole owner3_Role = new UserRole();
            owner3_Role.Name = 'NA-Sales-VP';
            owner3_Role.ParentRoleId = WW_Sales.Id;
            userRoles.add(owner3_Role);
            insert owner3_Role;
			
            UserRole owner2_Role = new UserRole();
            owner2_Role.Name = 'NA-Sales-North-RVP';
            owner2_Role.ParentRoleId =owner3_Role.Id;
            userRoles.add(owner2_Role);
            insert owner2_Role;
			
            UserRole owner1_Role = new UserRole();
            owner1_Role.Name = 'NA-Sales-North-Midwest-RSD';
            owner1_Role.ParentRoleId = owner2_Role.Id;
            userRoles.add(owner1_Role);
            insert owner1_Role;
			
            UserRole owner_Role = new UserRole();
            owner_Role.Name = 'NA-Sales-North-Midwest-Enterprise';
            owner_Role.ParentRoleId = owner1_Role.Id;
            userRoles.add(owner_Role);
            insert owner_Role;
			
            UserRole em1_Role = new UserRole();
            em1_Role.Name = 'EMEA-Services-VP';
            em1_Role.ParentRoleId = Mulesoft_WW.Id;
            userRoles.add(em1_Role);
            insert em1_Role;
			
            UserRole em_Role = new UserRole();
            em_Role.Name = 'NA-Services-North-RSD';
            em_Role.ParentRoleId = em1_Role.Id;
            userRoles.add(em_Role);
            insert em_Role;
			
            UserRole pe_Role = new UserRole();
            pe_Role.Name = 'NA-Channel-VP';
            pe_Role.ParentRoleId = WW_Sales.Id;
            userRoles.add(pe_Role);
            insert pe_Role;
            
            //Query profile
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
            
            //Create users

            User mulesoftww = new User();
            mulesoftww.LastName = 'MulessoftWW';
            mulesoftww.Alias = 'Mule';
            mulesoftww.Email = mulesoftww.Lastname + '@email.com';
            mulesoftww.Username = mulesoftww.Lastname + 'test@email.com';
            mulesoftww.CommunityNickname = mulesoftww.LastName;
            mulesoftww.UserRoleId = Mulesoft_WW.Id;
            mulesoftww.ProfileId = profileId.Id;
            mulesoftww.EmailEncodingKey = 'ISO-8859-1';
            mulesoftww.TimeZoneSidKey = 'Europe/Lisbon';
            mulesoftww.LocaleSidKey = 'nl_NL';
            mulesoftww.LanguageLocaleKey = 'en_US';
            mulesoftww.CurrencyIsoCode = 'USD';
            users2.add(mulesoftww);
            
            User wwsales = new User();
            wwsales.LastName = 'WWSales';
            wwsales.Alias = 'WWSa';
            wwsales.Email = wwsales.Lastname + '@email.com';
            wwsales.Username = wwsales.Lastname + 'test@email.com';
            wwsales.CommunityNickname = wwsales.LastName;
            wwsales.UserRoleId = WW_Sales.Id;
            wwsales.ProfileId =profileId.Id;
            wwsales.EmailEncodingKey = 'ISO-8859-1';
            wwsales.TimeZoneSidKey = 'Europe/Lisbon';
            wwsales.LocaleSidKey = 'nl_NL';
            wwsales.LanguageLocaleKey = 'en_US';
            wwsales.CurrencyIsoCode = 'USD';
            users2.add(wwsales);
			
			User cstl = new User();
            cstl.LastName = 'CSTheaterLead';
            cstl.Alias = 'CSTh';
            cstl.Email = cstl.Lastname + '@email.com';
            cstl.Username = cstl.Lastname + 'test@email.com';
            cstl.CommunityNickname = cstl.LastName;
            cstl.UserRoleId = csmManager2_Role.Id;
            cstl.ProfileId =profileId.Id;
            cstl.EmailEncodingKey = 'ISO-8859-1';
            cstl.TimeZoneSidKey = 'Europe/Lisbon';
            cstl.LocaleSidKey = 'nl_NL';
            cstl.LanguageLocaleKey = 'en_US';
            cstl.CurrencyIsoCode = 'USD';
            users2.add(cstl);
			
			User csrl = new User();
            csrl.LastName = 'CSRegionalLead';
            csrl.Alias = 'CSRe';
            csrl.Email = csrl.Lastname + '@email.com';
            csrl.Username = csrl.Lastname + 'test@email.com';
            csrl.CommunityNickname = csrl.LastName;
            csrl.UserRoleId = csmManager_Role.Id;
            csrl.ProfileId =profileId.Id;
            csrl.EmailEncodingKey = 'ISO-8859-1';
            csrl.TimeZoneSidKey = 'Europe/Lisbon';
            csrl.LocaleSidKey = 'nl_NL';
            csrl.LanguageLocaleKey = 'en_US';
            csrl.CurrencyIsoCode = 'USD';
            users2.add(csrl);
			
			User csmdm = new User();
            csmdm.LastName = 'CSMDirectManager';
            csmdm.Alias = 'CSMD';
            csmdm.Email = csmdm.Lastname + '@email.com';
            csmdm.Username = csmdm.Lastname + 'test@email.com';
            csmdm.CommunityNickname = csmdm.LastName;
            csmdm.UserRoleId = csm_Role.Id;
            csmdm.ProfileId =profileId.Id;
            csmdm.EmailEncodingKey = 'ISO-8859-1';
            csmdm.TimeZoneSidKey = 'Europe/Lisbon';
            csmdm.LocaleSidKey = 'nl_NL';
            csmdm.LanguageLocaleKey = 'en_US';
            csmdm.CurrencyIsoCode = 'USD';
            users2.add(csmdm);
			
			User ownerrl = new User();
            ownerrl.LastName = 'Ownerrl';
            ownerrl.Alias = 'Owrl';
            ownerrl.Email = ownerrl.Lastname + '@email.com';
            ownerrl.Username = ownerrl.Lastname + 'test@email.com';
            ownerrl.CommunityNickname = ownerrl.LastName;
            ownerrl.UserRoleId = owner2_Role.Id;
            ownerrl.ProfileId = profileId.Id;
            ownerrl.EmailEncodingKey = 'ISO-8859-1';
            ownerrl.TimeZoneSidKey = 'Europe/Lisbon';
            ownerrl.LocaleSidKey = 'nl_NL';
            ownerrl.LanguageLocaleKey = 'en_US';
            ownerrl.CurrencyIsoCode = 'USD';
            users2.add(ownerrl);
			
			User ownerdm = new User();
            ownerdm.LastName = 'Ownerdm';
            ownerdm.Alias = 'Owdm';
            ownerdm.Email = ownerdm.Lastname + '@email.com';
            ownerdm.Username = ownerdm.Lastname + 'test@email.com';
            ownerdm.CommunityNickname = ownerdm.LastName;
            ownerdm.UserRoleId = owner1_Role.Id;
            ownerdm.ProfileId = profileId.Id;
            ownerdm.EmailEncodingKey = 'ISO-8859-1';
            ownerdm.TimeZoneSidKey = 'Europe/Lisbon';
            ownerdm.LocaleSidKey = 'nl_NL';
            ownerdm.LanguageLocaleKey = 'en_US';
            ownerdm.CurrencyIsoCode = 'USD';
            users2.add(ownerdm);
			
			User enmadm = new User();
            enmadm.LastName = 'EngagementDM';
            enmadm.Alias = 'Endm';
            enmadm.Email = enmadm.Lastname + '@email.com';
            enmadm.Username = enmadm.Lastname + 'test@email.com';
            enmadm.CommunityNickname = enmadm.LastName;
            enmadm.UserRoleId = em_Role.Id;
            enmadm.ProfileId = profileId.Id;
            enmadm.EmailEncodingKey = 'ISO-8859-1';
            enmadm.TimeZoneSidKey = 'Europe/Lisbon';
            enmadm.LocaleSidKey = 'nl_NL';
            enmadm.LanguageLocaleKey = 'en_US';
            enmadm.CurrencyIsoCode = 'USD';
            users2.add(enmadm);
			
			User pamadm = new User();
            pamadm.LastName = 'PartnerDM';
            pamadm.Alias = 'Padm';
            pamadm.Email = pamadm.Lastname + '@email.com';
            pamadm.Username = pamadm.Lastname + 'test@email.com';
            pamadm.CommunityNickname = pamadm.LastName;
            pamadm.UserRoleId = pe_Role.Id;
            pamadm.ProfileId = profileId.Id;
            pamadm.EmailEncodingKey = 'ISO-8859-1';
            pamadm.TimeZoneSidKey = 'Europe/Lisbon';
            pamadm.LocaleSidKey = 'nl_NL';
            pamadm.LanguageLocaleKey = 'en_US';
            pamadm.CurrencyIsoCode = 'USD';
            users2.add(pamadm);
			
			insert users2;
			
			User csgl = new User();
            csgl.LastName = 'CSGlobalLead';
            csgl.Alias = 'CSGl';
            csgl.Email = csgl.Lastname + '@email.com';
            csgl.Username = csgl.Lastname + 'test@email.com';
            csgl.CommunityNickname = csgl.LastName;
            csgl.UserRoleId = csmManager3_Role.Id;
            csgl.ProfileId =profileId.Id;
            csgl.EmailEncodingKey = 'ISO-8859-1';
            csgl.TimeZoneSidKey = 'Europe/Lisbon';
            csgl.LocaleSidKey = 'nl_NL';
            csgl.LanguageLocaleKey = 'en_US';
            csgl.CurrencyIsoCode = 'USD';
			csgl.ManagerId = wwsales.Id;
            users.add(csgl);
			
			User csm = new User();
            csm.LastName = 'CSM';
            csm.Alias = 'CSM';
            csm.Email = csm.Lastname + '@email.com';
            csm.Username = csm.Lastname + 'test@email.com';
            csm.CommunityNickname = csm.LastName;
            csm.UserRoleId = csm_Role.Id;
            csm.ProfileId =profileId.Id;
            csm.EmailEncodingKey = 'ISO-8859-1';
            csm.TimeZoneSidKey = 'Europe/Lisbon';
            csm.LocaleSidKey = 'nl_NL';
            csm.LanguageLocaleKey = 'en_US';
            csm.CurrencyIsoCode = 'USD';
			csm.ManagerId = csmdm.Id;
            users.add(csm);
			
			User ownertl = new User();
            ownertl.LastName = 'ownertl';
            ownertl.Alias = 'Owrl';
            ownertl.Email = ownertl.Lastname + '@email.com';
            ownertl.Username = ownertl.Lastname + 'test@email.com';
            ownertl.CommunityNickname = ownertl.LastName;
            ownertl.UserRoleId = owner3_Role.Id;
            ownertl.ProfileId =profileId.Id;
            ownertl.EmailEncodingKey = 'ISO-8859-1';
            ownertl.TimeZoneSidKey = 'Europe/Lisbon';
            ownertl.LocaleSidKey = 'nl_NL';
            ownertl.LanguageLocaleKey = 'en_US';
            ownertl.CurrencyIsoCode = 'USD';
			ownertl.ManagerId = wwsales.Id;
            users.add(ownertl);
			
			User owner = new User();
            owner.LastName = 'Owner';
            owner.Alias = 'Owne';
            owner.Email = owner.Lastname + '@email.com';
            owner.Username = owner.Lastname + 'test@email.com';
            owner.CommunityNickname = owner.LastName;
            owner.UserRoleId = owner_Role.Id;
            owner.ProfileId = profileId.Id;
            owner.EmailEncodingKey = 'ISO-8859-1';
            owner.TimeZoneSidKey = 'Europe/Lisbon';
            owner.LocaleSidKey = 'nl_NL';
            owner.LanguageLocaleKey = 'en_US';
            owner.CurrencyIsoCode = 'USD';
			owner.ManagerId = ownerdm.Id;
            users.add(owner);
			
			User enma = new User();
            enma.LastName = 'Engagement';
            enma.Alias = 'Enga';
            enma.Email = enma.Lastname + '@email.com';
            enma.Username = enma.Lastname + 'test@email.com';
            enma.CommunityNickname = enma.LastName;
            enma.UserRoleId = em_Role.Id;
            enma.ProfileId = profileId.Id;
            enma.EmailEncodingKey = 'ISO-8859-1';
            enma.TimeZoneSidKey = 'Europe/Lisbon';
            enma.LocaleSidKey = 'nl_NL';
            enma.LanguageLocaleKey = 'en_US';
            enma.CurrencyIsoCode = 'USD';
            enma.ManagerId = enmadm.Id;
            users.add(enma);
			
			User pama = new User();
            pama.LastName = 'Partner';
            pama.Alias = 'Part';
            pama.Email = pama.Lastname + '@email.com';
            pama.Username = pama.Lastname + 'test@email.com';
            pama.CommunityNickname = pama.LastName;
            pama.UserRoleId = em_Role.Id;
            pama.ProfileId =profileId.Id;
            pama.EmailEncodingKey = 'ISO-8859-1';
            pama.TimeZoneSidKey = 'Europe/Lisbon';
            pama.LocaleSidKey = 'nl_NL';
            pama.LanguageLocaleKey = 'en_US';
            pama.CurrencyIsoCode = 'USD';
            pama.ManagerId = pamadm.Id;
            users.add(pama); 
            
            User emtl = new User();
            emtl.LastName = 'EngagementTL';
            emtl.Alias = 'Emtl';
            emtl.Email = emtl.Lastname + '@email.com';
            emtl.Username = emtl.Lastname + 'test@email.com';
            emtl.CommunityNickname = emtl.LastName;
            emtl.UserRoleId = em1_Role.Id;
            emtl.ProfileId = profileId.Id;
            emtl.EmailEncodingKey = 'ISO-8859-1';
            emtl.TimeZoneSidKey = 'Europe/Lisbon';
            emtl.LocaleSidKey = 'nl_NL';
            emtl.LanguageLocaleKey = 'en_US';
            emtl.CurrencyIsoCode = 'USD';
            pama.ManagerId = mulesoftww.Id;
            users.add(emtl);

            insert users;
                        
            //insert 50 records of Account and NPS Response
            //for(Integer i=0; i<50; i++ ){
                Account acc = new Account();
                acc.Name = 'Test Account '; //+ i;
                acc.CurrencyIsoCode = 'USD';
                acc.Customer_Success_Manager_new__c = csm.Id;
                acc.OwnerId = owner.Id;
                acc.Partner_Enablement_Manager__c = pama.Id;
                acc.Engagement_Manager__c = enma.Id;
                acc.BillingCountry = 'Sweden';
            	acc.Region__c = 'NE';
                accounts.add(acc);
                
                //i++;
            //}
            insert accounts;
            
            //for(Integer i=0; i< accounts.size(); i++ ){
                NPS_Response__c nps = new NPS_Response__c();
                nps.CurrencyIsoCode = 'USD';
                nps.Account__c = accounts[0].Id;
                nps.Processed__c = False;
                unpNPS.add(nps);
                //i++;
            //}
            insert unpNPS;
            
            OrgWideEmailAddress[] addresses = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Simplus-Mulesoft OrgWide' LIMIT 1];
        }   
    }
    @isTest
    static void testSendingEmail(){
        List<NPS_Response__c> npsList = [SELECT Id, CSM_Email__c, Category__c,Account__r.Engagement_Manager__c, Account__r.OwnerId, Account__r.Customer_Success_Manager_new__c, Roles_and_Users__c,Processed__c,Account__r.Engagement_Manager__r.ManagerId, 
                                         Account__r.Partner_Enablement_Manager__r.ManagerId, CSM__c, CSM_Direct_Manager__c, CS_Ops__c,CS_Regional_Lead__c,CS_Theater_Lead__c,CS_Global_Lead__c, AE__c, AE_Direct_Manager_RSD__c, 
                                         AE_Regional_Lead_RVP__c, AE_Theater_Lead__c, AE_Global_Lead__c, Services_Regional_Lead__c,Services_Theater_Lead__c, Services_Global_Lead__c,Channels_Theater_Lead__c, Channels_Global_Lead__c, 
                                         Marketing__c, Product__c, Support__c, Account_Region__c FROM NPS_Response__c WHERE Processed__c = False LIMIT 1] ;
        Test.startTest();
        CMsNPSAlertBatch batch = new CMsNPSAlertBatch();
        Database.QueryLocator ql = batch.start(null);
        batch.execute(null,npsList);
        batch.Finish(null);
        System.assertnotEquals(0,[select count() from NPS_Response__c where Processed__c = True]);
		String sch = '0 0 23 * * ?'; 
        system.schedule('Test NPS alert', sch, batch); 
        Test.stopTest();
        
    }
}