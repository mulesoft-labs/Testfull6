/*********************************************************************
*
*   File Name: SCNotificationsTest
*
*   File Description: Test class to test SC Notification functionality
*
**********************************************************************
*
*   Date        Author                      Change
*   08/30/14    Rob                         Initial Creation                        
*
*********************************************************************/
@isTest
private class SCNotificationsTest
{
    private testmethod static void testCreate10PercentChatterPost()
    {
    /*********************************************************************
        User emeaUser = MuleSoftInf_TestDataUtility.buildUser('EMEA-Sales', 'Standard User', 'testEMEAUser1@mulesofttest.com');
        insert emeaUser;
        
        System.runAs(emeaUser)
        {
            Account acc = MuleSoftInf_TestDataUtility.buildAccountRecord();            
            insert acc;
            Opportunity opp = MuleSoftInf_TestDataUtility.buildOpportunityRecord(acc.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 100, Date.Today(), 'Likely');            
            insert opp;
             List<Pricebook2> standardPB = [select id from Pricebook2 where isStandard=true];
    

    Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', IsActive = true);
    insert prod;


    PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert pbe;

    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 7500, Description = '2007 CMR #4 - Anti-Infectives');
    insert oli;

            Test.startTest();
                opp.StageName = ConstantDeclarations.OPP_STAGE_IDENTIFY_CONNECTIVITY;                
                update opp;                
            Test.stopTest();
        }

        // Assert that chatter post created for Pablo Luna
        List<FeedItem> newPost = new List<FeedItem>();
        newPost = [select Id from FeedItem where ParentId = '00580000003q1Bz'];
        System.assert(!newPost.isEmpty());
        
        *********************************************************************/
    }
}