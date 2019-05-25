@isTest(SeeAllData=True)
private class CaseTeamManagerTests{
    public static testmethod void testUserInsert(){
        String strUserRole ='{"attributes":{"type":"UserRole"},"Name":"WW-Sales1","RollupDescription":"WWSales1","DeveloperName":"WW_Sales1"}';
        UserRole uRole =(UserRole )JSON.deserialize(strUserRole,userRole.class);
        insert uRole ;
        
        Profile pf =[
            SELECT id FROM Profile WHERE Name='System Administrator'
        ];
        User us = new User();
        us.EmailEncodingKey='ISO-8859-1';
        us.Alias ='rmart';
        us.Email= UserInfo.getUserEmail();
        us.IsActive=true;
        us.FirstName='Robert';
        us.LastName='Martinez';
        us.CommunityNickname='testavi1231';
        us.userRoleId =uRole.Id;
        us.UserName='testuser@CaseTeamManagerTests.com';
        us.TimeZoneSidKey ='America/Los_Angeles';
        us.LocaleSidKey ='en_US';
        us.ProfileId=pf.Id;
        us.LanguageLocaleKey ='en_US';
        insert us;

    }
    public static testmethod void testCaseInsert(){
        UserRole URole =[SELECT id FROM UserRole WHERE Name ='WW Sales'];
        Account testAccount = TestDataFactory.createAccounts(1, true, new Map<String,Object>{})[0];
        /*        
        Profile pf =[SELECT id FROM profile WHERE name='System Administrator'];
        Test.StartTest();
        User us = new User();
        us.EmailEncodingKey='ISO-8859-1';
        us.Alias ='rmart';
        us.Email= 'robert=shrewdesigns.com@example.com';
        us.IsActive=true;
        us.FirstName='Robert';
        us.LastName='Martinez';
        us.CommunityNickname='testavi1231';
        us.userRoleId =uRole.Id;
        us.UserName='test@fulltest.com';
        us.TimeZoneSidKey ='America/Los_Angeles';
        us.LocaleSidKey ='en_US';
        us.ProfileId=pf.Id;
        us.LanguageLocaleKey ='en_US';
        insert us;
        Test.StopTest();
        */
        String strCase='{"attributes":{"type":"Case"},"Status":"Closed","SuppliedEmail":"robert=shrewdesigns.com@example.com","Subject":"Quote Q-01834 for Anheuser-Busch Companies, LLC requires approval","Origin":"Email","SuppliedName":"Danielle Hedden","Found_Answer_In__c":"Test","Outcome__c": "Test"}';
        Case cs = (case)json.deserialize(strCase,case.class);
        cs.AccountId = testAccount.Id;
        insert cs;
        
    }
}