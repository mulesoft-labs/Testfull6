@isTest
public class CMsAccountTriggerHandlerTest {


	/*
	static testMethod void test_Account_Update_SALClassificationTest() {
		List<Decimal> revs = new List<Decimal>{
				4000000000.00, 5000000000.00, 400000000.00, 500000000.00, 50000000.00, 3000000000.00
		};
		Test.startTest();
		List<Account> acts = TestDataFactory.createAccounts(revs.size(), true, new Map<String, Object>{
				'AnnualRevenue' => revs
		});
		Test.stopTest();
		acts = [SELECT SAL_Classification__c FROM Account ORDER BY NAME];
		System.assertEquals(acts[0].SAL_Classification__c, 'Strategic');
		System.assertEquals(acts[1].SAL_Classification__c, 'Strategic');
		System.assertEquals(acts[2].SAL_Classification__c, 'Mid-Market');
		System.assertEquals(acts[3].SAL_Classification__c, 'Mid-Market');
		System.assertEquals(acts[4].SAL_Classification__c, 'Commercial');
		System.assertEquals(acts[5].SAL_Classification__c, 'Enterprise');

	}

	static testMethod void testARRPotentialProspectInsert() {
		Account testAccount = createAccount();
		createTestIndustries();
		insert testAccount;
		List<Account> accounts = [SELECT Account_Assignability__c, Expansion_Readiness__c,Strategic_Account_Level__c
		FROM Account WHERE Id =: testAccount.Id];
		//Validate that the ARR Potential is computed correctly
		//System.assertEquals(0.335, accounts[0].ARR_potential__c.setScale(3));
		//Validate that the Customer Tier is computed correctly
		System.assertEquals('N/A', accounts[0].Strategic_Account_Level__c);
		//Validate that the Expansion Readiness is computed correctly
		//System.assertEquals('Medium', accounts[0].Expansion_Readiness__c);
		//Validate that the Account classification is computed correctly
		//System.assertEquals('6. Commercial', accounts[0].Account_Classification__c);

		//Validate that the Account Assignability is computed correctly
		//System.assertEquals('Don\'t Assign', accounts[0].Account_Assignability__c);
	}

	static testMethod void testARRPotentialCustomerInsert() {
		Account accCustomerTest = createAccount();
		createTestIndustries();
		accCustomerTest.Status__c = 'Current';
		accCustomerTest.X1st_Transaction_Date__c = Date.valueOf('2013-09-27');
		insert accCustomerTest;

		List<Account> accounts = [SELECT Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id =:accCustomerTest.Id];
		//Validate that the ARR Potential is computed correctly
		//System.assertEquals(0.335, accounts[0].ARR_potential__c.setScale(3));
		//Validate that the Customer Tier is computed correctly
		System.assertEquals('C', accounts[0].Strategic_Account_Level__c);
		//Validate that the Expansion Readiness is computed correctly
		//System.assertEquals(null, accounts[0].Expansion_Readiness__c);
		//Validate that the Account classification is computed correctly
		//System.assertEquals('6. Commercial', accounts[0].Account_Classification__c);
	}

	static testMethod void testARRPotentialChangeToRevenueOrIndustry() {
		Account testAccount = createAccount();
		createTestIndustries();
		insert testAccount;
		//Revenue Changes
		testAccount.AnnualRevenue = 600000000;
		update testAccount;

		Account testAccountValidation1 = [SELECT Status__c, Industry, AnnualRevenue, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account  WHERE Id =:testAccount.Id];

		//Validate that the ARR Potential is computed correctly
		System.assertEquals('High Tech', testAccountValidation1.Industry);
		System.assertEquals(600000000, testAccountValidation1.AnnualRevenue);
		//System.assertEquals(1.015, testAccountValidation1.ARR_potential__c.setScale(3));
		System.assertEquals('N/A', testAccountValidation1.Strategic_Account_Level__c);
		//System.assertEquals('Medium', testAccountValidation1.Expansion_Readiness__c);
		//System.assertEquals('4. Enterprise', testAccountValidation1.Account_Classification__c);

		//Industry Changes
		testAccount.Industry = 'Public Sector';
		testAccount.AnnualRevenue = 726700032;
		update testAccount;

		Account testAccountValidation2 = [SELECT Status__c, Industry, AnnualRevenue, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id =:testAccount.Id];

		//System.assertEquals(1.001, testAccountValidation2.ARR_potential__c.setScale(3));
		//System.assertEquals('Medium', testAccountValidation1.Expansion_Readiness__c);
		//System.assertEquals('4. Enterprise', testAccountValidation1.Account_Classification__c);
	}

	static testMethod void testConvertProspectToCustomer() {
		Account convertToCustAcc = createAccount();
		createTestIndustries();
		insert convertToCustAcc;

		Account testAccount = [SELECT Status__c, Account_Assignability__c, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id =:convertToCustAcc.Id];
		System.assertEquals('Prospect', testAccount.Status__c);
		//System.assertEquals('Medium', testAccount.Expansion_Readiness__c);
		//System.assertEquals('Don\'t Assign', testAccount.Account_Assignability__c);
		//System.assertEquals('6. Commercial', testAccount.Account_Classification__c);
		System.assertEquals('N/A', testAccount.Strategic_Account_Level__c);
		testAccount.Status__c = 'Current';
		Test.startTest();
		update testAccount;
		Test.stopTest();
		Account testAccountValidation = [SELECT Status__c, Account_Assignability__c, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id = :convertToCustAcc.Id];
		//Validate here
		System.assertEquals('Current', testAccountValidation.Status__c);
		//System.assertEquals('Low', testAccountValidation.Expansion_Readiness__c);
		//System.assertEquals('Assigned', testAccountValidation.Account_Assignability__c);
		//System.assertEquals('6. Commercial', testAccount.Account_Classification__c);
		System.assertEquals('C', testAccountValidation.Strategic_Account_Level__c);
	}

	static testMethod void testUpdateCustomer() {
		Account convertToCustAcc = createAccount();
		createTestIndustries();
		convertToCustAcc.Status__c = 'Current';
		insert convertToCustAcc;
		convertToCustAcc.AnnualRevenue = 12000000;

		Test.startTest();
		update convertToCustAcc;
		Test.stopTest();
		Account testAccountValidation = [SELECT Status__c, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id = :convertToCustAcc.Id];
		//Validate here
		System.assertEquals('Current', testAccountValidation.Status__c);
		//System.assertEquals('Low', testAccountValidation.Expansion_Readiness__c);
		//System.assertEquals('6. Commercial', testAccountValidation.Account_Classification__c);
		System.assertEquals('C', testAccountValidation.Strategic_Account_Level__c);
	}

	static testMethod void testExpansionReadiness() {
		Account ExpReadinessAccount = createAccount();
		createTestIndustries();
		insert ExpReadinessAccount;

		Account testAccount = [SELECT Status__c, Expansion_Readiness__c,Account_Classification__c,
				Has_Atlassian_JIRA__c,Has_AppDynamics__c,Has_Puppet_Labs__c,Cloud_Service_Tier_1__c,
				Binary_Cloud_Services__c, Propsensity_Score_Raw_Tech_Landscape__c
		FROM Account WHERE Id  =:ExpReadinessAccount.Id];

		testAccount.Has_Atlassian_JIRA__c = 'Yes';
		testAccount.Has_AppDynamics__c = 'Yes';
		testAccount.Has_Puppet_Labs__c = 'Yes';
		testAccount.Cloud_Service_Tier_1__c = 11;
		Test.startTest();
		update testAccount;
		Test.stopTest();

		Account testAccountValidation = [SELECT Status__c, Expansion_Readiness__c,Account_Classification__c,
				Has_Atlassian_JIRA__c,Has_AppDynamics__c,Has_Puppet_Labs__c,Cloud_Service_Tier_1__c,
				Binary_Cloud_Services__c, Propsensity_Score_Raw_Tech_Landscape__c
		FROM Account WHERE Id  =:ExpReadinessAccount.Id];

		//Validate here
		System.assertEquals(1, testAccountValidation.Binary_Cloud_Services__c);
		System.assertEquals(4, testAccountValidation.Propsensity_Score_Raw_Tech_Landscape__c);
		//System.assertEquals('High', testAccountValidation.Expansion_Readiness__c);


		testAccount.Has_Atlassian_JIRA__c = 'Yes';
		testAccount.Has_AppDynamics__c = 'No';
		testAccount.Has_Puppet_Labs__c = 'No';
		testAccount.Cloud_Service_Tier_1__c = 5;
		update testAccount;

		Account testAccountValidation1 = [SELECT Status__c, Expansion_Readiness__c,Account_Classification__c,
				Has_Atlassian_JIRA__c,Has_AppDynamics__c,Has_Puppet_Labs__c,Cloud_Service_Tier_1__c,
				Binary_Cloud_Services__c, Propsensity_Score_Raw_Tech_Landscape__c
		FROM Account WHERE Id  =:ExpReadinessAccount.Id];

		//Validate here
		System.assertEquals(0, testAccountValidation1.Binary_Cloud_Services__c);
		System.assertEquals(1, testAccountValidation1.Propsensity_Score_Raw_Tech_Landscape__c);
		//System.assertEquals('Medium', testAccountValidation1.Expansion_Readiness__c);
	}

	static testMethod void testAccountClassificationForProspect() {
		Account accountClassificationTestAccount = createAccount();
		createTestIndustries();
		insert accountClassificationTestAccount;

		List<Account> accounts = [SELECT Industry, AnnualRevenue, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id =:accountClassificationTestAccount.Id];
		//Revenue Changes
		accounts[0].AnnualRevenue = 600000000;
		update accounts[0];

		Account testAccountValidation1 = [SELECT Status__c, Industry, AnnualRevenue, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id =:accountClassificationTestAccount.Id];

		//Validate that the ARR Potential is computed correctly
		System.assertEquals('High Tech', testAccountValidation1.Industry);
		System.assertEquals(600000000, testAccountValidation1.AnnualRevenue);
		//System.assertEquals(1.015, testAccountValidation1.ARR_potential__c.setScale(3));
		System.assertEquals('N/A', testAccountValidation1.Strategic_Account_Level__c);
		//System.assertEquals('Medium', testAccountValidation1.Expansion_Readiness__c);
		//System.assertEquals('4. Enterprise', testAccountValidation1.Account_Classification__c);
	}

	//If a "8. Don't assign" account has a SQL created, SFDC should run the Account Classification formula on it
	//but bypass the lattice score part (e.g., force it to classify as something other than don't assign)
	static testMethod void testAccountDoNotAssignWhenSQLCreated() {
		Account testAcc = createAccount();
		createTestIndustries();
		insert testAcc;

		testAcc.AnnualRevenue = 30000000.00;
		update testAcc;

		Account testAccountValidation1 = [SELECT Account_Assignability__c FROM Account WHERE Id =:testAcc.Id];
		//System.assertEquals('Don\'t Assign', testAccountValidation1.Account_Assignability__c);
		//Create an Opp with stage "0. Sales qualified Lead"
		Opportunity opp = TestDataFactory.createOpportunity(1, true, new Map<String, Object>{ 'AccountId' => testAcc.Id })[0];
		Account testAccountValidation2 = [SELECT Account_Classification__c,Account_Assignability__c
		FROM Account WHERE Id =:testAcc.Id];

		//System.assertNotEquals('8. Don\'t assign', testAccountValidation2.Account_Classification__c);
		//System.assertEquals('Ready to Assign', testAccountValidation2.Account_Assignability__c);
	}

	static testMethod void testAccountAssignability() {
		Account testAccount = createAccount();
		createTestIndustries();
		insert testAccount;
		//Revenue Changes
		testAccount.AnnualRevenue = 600000000;
		update testAccount;

		Account testAccountValidation1 = [SELECT Account_Assignability__c, Status__c, Industry, AnnualRevenue, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account  WHERE Id =:testAccount.Id];
		//Validate that the ARR Potential is computed correctly
		System.assertEquals('High Tech', testAccountValidation1.Industry);
		System.assertEquals(600000000, testAccountValidation1.AnnualRevenue);
		//System.assertEquals(1.015, testAccountValidation1.ARR_potential__c.setScale(3));
		System.assertEquals('N/A', testAccountValidation1.Strategic_Account_Level__c);
		//System.assertEquals('Medium', testAccountValidation1.Expansion_Readiness__c);
		//System.assertEquals('4. Enterprise', testAccountValidation1.Account_Classification__c);
		//System.assertEquals('Don\'t Assign', testAccountValidation1.Account_Assignability__c);

		//Industry Changes
		testAccount.Industry = 'Public Sector';
		testAccount.AnnualRevenue = 800000000;
		testAccount.Has_Atlassian_JIRA__c = 'Yes';
		testAccount.Has_AppDynamics__c = 'Yes';
		testAccount.Has_Puppet_Labs__c = 'Yes';
		testAccount.Cloud_Service_Tier_1__c = 11;
		update testAccount;

		Account testAccountValidation2 = [SELECT Account_Assignability__c , Status__c, Industry, AnnualRevenue, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id =:testAccount.Id];

		//System.assertEquals(1.013, testAccountValidation2.ARR_potential__c.setScale(3));
		//System.assertEquals('High', testAccountValidation2.Expansion_Readiness__c);
		//System.assertEquals('3. Enterprise Customer', testAccountValidation2.Account_Classification__c);
		//System.assertEquals('Don\'t Assign', testAccountValidation2.Account_Assignability__c);

		testAccount.Has_Atlassian_JIRA__c = 'No';
		testAccount.Has_AppDynamics__c = 'No';
		testAccount.Has_Puppet_Labs__c = 'No';
		testAccount.Cloud_Service_Tier_1__c = 5;
		testAccount.Account_Assignability__c ='Assigned';
		update testAccount;

		//Since Account is "Assigned", the Account Classification won't change
		Account testAccountValidation3 = [SELECT Account_Assignability__c , Status__c, Industry, AnnualRevenue, Expansion_Readiness__c,Account_Classification__c,Strategic_Account_Level__c
		FROM Account WHERE Id =:testAccount.Id];
		//System.assertEquals('3. Enterprise Customer', testAccountValidation3.Account_Classification__c);

	}
	/**
    *Create Test Account data
    */
    
	private static Account createAccount(){
		Account testAccount= new Account();
		testAccount.Name= 'testName';

		testAccount.BillingCountry='US';
		testAccount.Industry = 'High Tech';
		testAccount.AnnualRevenue = 11000000;
		return testAccount;
	}
	/*
	private static void createTestIndustries(){
		List<Industry__c> industries = new List<Industry__c>();
		Industry__c testIndustry1 = new Industry__c();
		testIndustry1.MuleSoft_Industry__c= 'High Tech';
		testIndustry1.Industry_Group__c='High Tech';
		testIndustry1.Industry__c='High Tech';
		testIndustry1.m__c =  0.277429;
		testIndustry1.b__c = 7.30703;
		industries.add(testIndustry1);

		Industry__c testIndustry2 = new Industry__c();
		testIndustry2.MuleSoft_Industry__c= 'Public Sector';
		testIndustry2.Industry_Group__c='Public Sector';
		testIndustry2.Industry__c='Public Sector';
		testIndustry2.m__c =  0.12556;
		testIndustry2.b__c = 10.3383;
		industries.add(testIndustry2);

		insert industries;
	}
    */
	static testMethod void testCustomerTierForNA() {
		Account acc1 = createAccount();
 		acc1.Account_classification__c = '6. CAM';        
		acc1.Territory__c = 'NA';
        acc1.CAM__c = true;
        insert acc1;

        Account testAccountValidation0 = [SELECT CAM__c,Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation0 --> '+testAccountValidation0);
        //Validate here
		System.assertEquals('D', testAccountValidation0.Customer_Tier__c);        
        
        acc1.CAM__c = false;
 		acc1.Account_classification__c = '1. Strategic';       
		update acc1;
		Account testAccountValidation1 = [SELECT CAM__c,Customer_Tier__c,ARR__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation1 --> '+testAccountValidation1);
        //Validate here
		System.assertEquals('A', testAccountValidation1.Customer_Tier__c);

        acc1.Account_classification__c = '2. Key';        
		update acc1;
		Account testAccountValidation2 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation2 --> '+testAccountValidation2);
        //Validate here
		System.assertEquals('B', testAccountValidation2.Customer_Tier__c);

        acc1.Account_classification__c = '4. Mid Market';        
		update acc1;
		Account testAccountValidation3 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation3 --> '+testAccountValidation3);
        //Validate here
		System.assertEquals('C', testAccountValidation3.Customer_Tier__c);
		
        acc1.Account_classification__c = '5. Commercial';        
		update acc1;
		Account testAccountValidation4 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation4 --> '+testAccountValidation4);
        //Validate here
		System.assertEquals('C', testAccountValidation4.Customer_Tier__c);  
	}
    
	static testMethod void testCustomerTierForEMEA() {
		Account acc1 = createAccount();
 		acc1.Account_classification__c = '6. CAM';        
		acc1.Territory__c = 'EMEA';
        acc1.CAM__c = true;
        insert acc1;

        Account testAccountValidation0 = [SELECT CAM__c,Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation0 --> '+testAccountValidation0);
        //Validate here
		System.assertEquals('D', testAccountValidation0.Customer_Tier__c);        
        
        acc1.CAM__c = false;
 		acc1.Account_classification__c = '1. Strategic';       
		update acc1;
		Account testAccountValidation1 = [SELECT CAM__c,Customer_Tier__c,ARR__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation1 --> '+testAccountValidation1);
        //Validate here
		System.assertEquals('A', testAccountValidation1.Customer_Tier__c);

        acc1.Account_classification__c = '2. Key';        
		update acc1;
		Account testAccountValidation2 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation2 --> '+testAccountValidation2);
        //Validate here
		System.assertEquals('B', testAccountValidation2.Customer_Tier__c);

        acc1.Account_classification__c = '4. Mid Market';        
		update acc1;
		Account testAccountValidation3 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation3 --> '+testAccountValidation3);
        //Validate here
		System.assertEquals('C', testAccountValidation3.Customer_Tier__c);
		
        acc1.Account_classification__c = '5. Commercial';        
		update acc1;
		Account testAccountValidation4 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation4 --> '+testAccountValidation4);
        //Validate here
		System.assertEquals('C', testAccountValidation4.Customer_Tier__c);
	}
    
	static testMethod void testCustomerTierForAPAC() {
		Account acc1 = createAccount();
 		acc1.Account_classification__c = '6. CAM';        
		acc1.Territory__c = 'APAC';
        acc1.CAM__c = true;
        insert acc1;

        Account testAccountValidation0 = [SELECT CAM__c,Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation0 --> '+testAccountValidation0);
        //Validate here
		System.assertEquals('D', testAccountValidation0.Customer_Tier__c);        
        
        acc1.CAM__c = false;
 		acc1.Account_classification__c = '1. Strategic';       
		update acc1;
		Account testAccountValidation1 = [SELECT CAM__c,Customer_Tier__c,ARR__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation1 --> '+testAccountValidation1);
        //Validate here
		System.assertEquals('A', testAccountValidation1.Customer_Tier__c);

        acc1.Account_classification__c = '2. Key';        
		update acc1;
		Account testAccountValidation2 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation2 --> '+testAccountValidation2);
        //Validate here
		System.assertEquals('A', testAccountValidation2.Customer_Tier__c);

        acc1.Account_classification__c = '4. Mid Market';        
		update acc1;
		Account testAccountValidation3 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation3 --> '+testAccountValidation3);
        //Validate here
		System.assertEquals('C', testAccountValidation3.Customer_Tier__c);
		
        acc1.Account_classification__c = '5. Commercial';        
		update acc1;
		Account testAccountValidation4 = [SELECT Customer_Tier__c FROM Account WHERE Id = :acc1.Id];
		System.debug(LoggingLevel.ERROR, 'testAccountValidation4 --> '+testAccountValidation4);
        //Validate here
		System.assertEquals('C', testAccountValidation4.Customer_Tier__c);		        
	}        
}