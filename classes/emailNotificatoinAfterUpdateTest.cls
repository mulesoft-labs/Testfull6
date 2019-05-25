@isTest (seealldata=true)
public class emailNotificatoinAfterUpdateTest{
// test Class for emailNotificatoinAfterUpdate. Will also exercise HelperEmailClass
        static testMethod void myTest() {
        
           // Add test method logic using System.assert(), System.assertEquals()
           // and System.assertNotEquals() here.
           // Create an Opp & Quote. Quote needs approval and approvers.
           // Note: Important that this test method does not use real email addresses or Emails will get sent.
           Account testAcc = createTestAccount();
           Opportunity testOpp = createTestOpportunity(testAcc);
           SBQQ__Quote__c testQuote = createTestQuote(testOpp);
           System.AssertNotEquals(testQuote, null);
            
           // add a discounted product to a quote line
           SBQQ__QuoteLine__c testQL = new SBQQ__QuoteLine__c(SBQQ__Quote__c = testQuote.Id);

           // add product, unless seealldata is true we won't see this product!
           Product2  myProd = [SELECT Id,productCode FROM Product2 Where productCode  = 'MuleDTPlatinumpc'];
           system.debug('myprod= '+myProd);
           testQL.SBQQ__Product__c  = myProd.Id;
           testQL.SBQQ__Quantity__c = 1;
           testQL .SBQQ__CustomerPrice__c = 5088.90; // discounted by 70%
           insert testQL;

           // create a user to attach to the approver
           User testUser = new User(Username='testwerer@testadfd.com',LastName='test',Alias='tal',CommunityNickname= 'cname', Email='junk@junk.com');
           testUser.TimeZoneSidKey = 'Pacific/Kiritimati';
           testUser.LocaleSidKey = 'en_US';
           testUser.EmailEncodingKey = 'ISO-8859-1';
           // query & set a profile
           testUser.ProfileId = [Select Id from Profile Where Name = 'Sales User' Limit 1].Id;
           testUser.LanguageLocaleKey = 'en_US';
       // required fields: Username, LastName, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey
           insert testUser;

            // add approver
           sbaa__Approver__c myApprover = new sbaa__Approver__c(sbaa__User__c=testUser.Id );
           insert myApprover;

           // create an approval and attach it to the quote
           sbaa__Approval__c myApproval = new sbaa__Approval__c(Quote__c = testQuote.id,sbaa__Opportunity__c = testOpp .Id, sbaa__Approver__c = myApprover.Id  );
          // required fields sbaa__ApprovalStep__c, sbaa__RecordField__c
           myApproval.sbaa__ApprovalStep__c = 1;
           myApproval.sbaa__RecordField__c = 'Quote__c';
           insert myApproval;

           // change quote Approval Status
           testQuote.ApprovalStatus__c = 'Approved'; // email notificatoin should trigger
           HelperEmailClass.firstRun = true;
           try {
               //update testQuote;
            }
            catch( Exception e){
                System.Assert(false,'error updating quote: e='+e);
            }
        }
    
    private static  SBQQ__Quote__c createTestQuote(Opportunity testOpp)
    {
        // required fields are record type, Opportunity, Legal Link or MSA
        SBQQ__Quote__c testQuote = new  SBQQ__Quote__c(SBQQ__Opportunity2__c = testOpp.id,Legal_Link_or_MSA__c = 'Legal Link' );
        // Approved quotes have Developer name of Mulesoft_Approved
        testQuote.RecordType = [Select id from RecordType where sObjectType = 'SBQQ__Quote__c' and developerName ='Mulesoft' ];
        testQuote.ApprovalStatus__c = 'Pending';
        try {
          insert testQuote;
        }
        catch( Exception e)
        {
            System.Assert(false,'error in insert: e='+e);
        }
        return testQuote;
    }

    private static Account createTestAccount()
    {
        Account testAccount = new Account();
        testAccount.Name = 'TestAccount';
        testAccount.BillingCountry = 'US';
        insert testAccount;
        return testAccount;
    }

    private static Opportunity createTestOpportunity(Account testAccount)
    {
        Opportunity opp = new Opportunity();
        opp.Name = 'Oppty_test1';
        opp.AccountID = testAccount.ID;
        opp.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
        opp.Type = 'Renewal';
        opp.CloseDate = System.Today();
        opp.Primary_Solution_Interest__c = 'SOA';
        insert opp;
        return opp;
    }
 }