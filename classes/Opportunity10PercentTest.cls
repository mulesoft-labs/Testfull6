/*********************************************************************
*
*   File Name: Opportunity10PercentTest.cls
*
*   File Description: Test class for the Opportunity10Percent class
*
**********************************************************************
*
*   Date        Author            Change
*   08/01/14    Rob               Initial Creation                          
*
*********************************************************************/

@isTest
private class Opportunity10PercentTest
{
    
    /**
     * Method to test the setLeadSourceToPrimaryContactLeadSource method
     */
    private static testMethod void testSetLeadSourceToPrimaryContactLeadSource()
    {
        // Create test data
        Account newAccount = MuleSoftInf_TestDataUtility.buildAccountRecord();
        insert newAccount;

        Contact newContact = MuleSoftInf_TestDataUtility.buildContactRecord(newAccount.Id, 'Inbound - Email');
        insert newContact;

        Opportunity newOpportunity = MuleSoftInf_TestDataUtility.buildOpportunityRecord(newAccount.Id, ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED, 'New Business', 100.00, Date.today(), 'Likely');
        newOpportunity.LeadSource = 'Partner - Field Referral';     
        insert newOpportunity;

        OpportunityContactRole newContactRole = MuleSoftInf_TestDataUtility.buildOpportunityContactRoleRecord(newOpportunity.Id, newContact.Id, true);
        insert newContactRole;
        
         Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', IsActive = true);
    insert prod;


    PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert pbe;

    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = newOpportunity.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 7500, Description = '2007 CMR #4 - Anti-Infectives');
    insert oli;

        Test.startTest();
        // Increase Probability to 10% by changing stage
        newOpportunity.StageName = ConstantDeclarations.OPP_STAGE_ID_BUSINESS_INITIATIVE;
        update newOpportunity;
        Test.stopTest();
        
        // Assert that Opportunity lead source now matches primary contact lead source
        Opportunity updatedOpportunity = [select LeadSource from Opportunity where Id =: newOpportunity.Id];
        System.assert(updatedOpportunity.LeadSource == newContact.LeadSource);
    }
    
}