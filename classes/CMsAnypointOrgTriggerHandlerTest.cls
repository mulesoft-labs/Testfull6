@isTest
public class CMsAnypointOrgTriggerHandlerTest {
	static testMethod void testCoreUsagesOneLevel() {

		AnypointOrganization__c orgMasterParent = new AnypointOrganization__c(Name='MasterParent', CSId__c='1111',
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 1, SandboxVcoresUsed__c=1, SandboxVcoresReassigned__c=1);
		insert orgMasterParent;
		System.debug(LoggingLevel.ERROR, 'orgMasterParent ---> '+orgMasterParent);

		Account acct = TestDataFactory.createAccounts(1, false, null)[0];
		acct.Anypoint_Organization__c = orgMasterParent.Id;
		insert acct;
		System.debug(LoggingLevel.ERROR, 'acct ---> '+acct);

		AnypointOrganization__c orgParent = new AnypointOrganization__c(Name='Parent', CSId__c='2222', Master_Parent_Anypoint_Organization__c = orgMasterParent.Id,
				AnypointParentOrganizationId__c = orgMasterParent.Id,
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 2, SandboxVcoresUsed__c=2, SandboxVcoresReassigned__c=2);

		Test.startTest();
		insert orgParent;
		Test.stopTest();
		List<AnypointOrganization__c> masterParent = [SELECT Master_Parent_PreProd_Vcores_Total__c,
				Master_Parent_PreProd_Vcores_Used__c,
				Master_Parent_Prod_Vcores_Total__c,Master_Parent_Prod_Vcores_Used__c
		FROM AnypointOrganization__c
		WHERE Id =:orgMasterParent.Id];
		System.debug(LoggingLevel.ERROR, 'masterParent ---> '+masterParent);
		System.assertEquals(1,masterParent[0].Master_Parent_Prod_Vcores_Total__c);
		System.assertEquals(2,masterParent[0].Master_Parent_Prod_Vcores_Used__c);
		System.assertEquals(1,masterParent[0].Master_Parent_PreProd_Vcores_Total__c);
		System.assertEquals(3,masterParent[0].Master_Parent_PreProd_Vcores_Used__c);

		List<Account> acc = [SELECT  Master_Parent_PreProd_Vcores_Total__c,
				Master_Parent_PreProd_Vcores_Used__c,
				Master_Parent_Prod_Vcores_Total__c,Master_Parent_Prod_Vcores_Used__c
		FROM Account
		WHERE Id =:acct.Id];
		System.debug(LoggingLevel.ERROR, 'acc ---> '+acc);
		System.assertEquals(1,acc[0].Master_Parent_Prod_Vcores_Total__c);
		System.assertEquals(2,acc[0].Master_Parent_Prod_Vcores_Used__c);
		System.assertEquals(1,acc[0].Master_Parent_PreProd_Vcores_Total__c);
		System.assertEquals(3,acc[0].Master_Parent_PreProd_Vcores_Used__c);
	}

	static testMethod void testCoreUsagesTwoLevel() {

		AnypointOrganization__c orgMasterParent = new AnypointOrganization__c(Name='MasterParent', CSId__c='1111',
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 1, SandboxVcoresUsed__c=1, SandboxVcoresReassigned__c=1);
		insert orgMasterParent;
		AnypointOrganization__c orgParent = new AnypointOrganization__c(Name='Parent', CSId__c='2222', Master_Parent_Anypoint_Organization__c = orgMasterParent.Id,
				AnypointParentOrganizationId__c = orgMasterParent.Id,
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 2, SandboxVcoresUsed__c=2, SandboxVcoresReassigned__c=2);

		insert orgParent;

		AnypointOrganization__c orgChild = new AnypointOrganization__c(Name='Child', CSId__c='3333', Master_Parent_Anypoint_Organization__c = orgMasterParent.Id,
				AnypointParentOrganizationId__c = orgParent.Id,
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 2, SandboxVcoresUsed__c=2, SandboxVcoresReassigned__c=2);

		insert orgChild;


		List<AnypointOrganization__c> masterParent = [SELECT Master_Parent_PreProd_Vcores_Total__c,
				Master_Parent_PreProd_Vcores_Used__c,
				Master_Parent_Prod_Vcores_Total__c,Master_Parent_Prod_Vcores_Used__c
		FROM AnypointOrganization__c
		WHERE Id =:orgMasterParent.Id];
		System.debug(LoggingLevel.ERROR, 'masterParent ---> '+masterParent);
		System.assertEquals(1,masterParent[0].Master_Parent_Prod_Vcores_Total__c);
		System.assertEquals(3,masterParent[0].Master_Parent_Prod_Vcores_Used__c);
		System.assertEquals(1,masterParent[0].Master_Parent_PreProd_Vcores_Total__c);
		System.assertEquals(5,masterParent[0].Master_Parent_PreProd_Vcores_Used__c);

		orgChild.Master_Parent_Anypoint_Organization__c = null;
		update orgChild;
		List<AnypointOrganization__c> updatedParent = [SELECT Master_Parent_PreProd_Vcores_Total__c,
				Master_Parent_PreProd_Vcores_Used__c,
				Master_Parent_Prod_Vcores_Total__c,Master_Parent_Prod_Vcores_Used__c
		FROM AnypointOrganization__c
		WHERE Id =:orgMasterParent.Id];
		System.debug(LoggingLevel.ERROR, 'updatedParent ---> '+updatedParent);
		System.assertEquals(1,updatedParent[0].Master_Parent_Prod_Vcores_Total__c);
		System.assertEquals(2,updatedParent[0].Master_Parent_Prod_Vcores_Used__c);
		System.assertEquals(1,updatedParent[0].Master_Parent_PreProd_Vcores_Total__c);
		System.assertEquals(3,updatedParent[0].Master_Parent_PreProd_Vcores_Used__c);
	}

	static testMethod void testCoreUsagesDeletion() {

		AnypointOrganization__c orgMasterParent = new AnypointOrganization__c(Name='MasterParent', CSId__c='1111',
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 1, SandboxVcoresUsed__c=1, SandboxVcoresReassigned__c=1);
		insert orgMasterParent;
		AnypointOrganization__c orgParent = new AnypointOrganization__c(Name='Parent', CSId__c='2222', Master_Parent_Anypoint_Organization__c = orgMasterParent.Id,
				AnypointParentOrganizationId__c = orgMasterParent.Id,
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 2, SandboxVcoresUsed__c=2, SandboxVcoresReassigned__c=2);

		insert orgParent;

		AnypointOrganization__c orgChild = new AnypointOrganization__c(Name='Child', CSId__c='3333', Master_Parent_Anypoint_Organization__c = orgMasterParent.Id,
				AnypointParentOrganizationId__c = orgParent.Id,
				ProductionVcoresTotal__c = 1, ProductionVcoresUsed__c =1, ProductionVcoresReassigned__c = 1,
				SandboxVcoresTotal__c = 2, SandboxVcoresUsed__c=2, SandboxVcoresReassigned__c=2);

		insert orgChild;


		List<AnypointOrganization__c> masterParent = [SELECT Master_Parent_PreProd_Vcores_Total__c,
				Master_Parent_PreProd_Vcores_Used__c,
				Master_Parent_Prod_Vcores_Total__c,Master_Parent_Prod_Vcores_Used__c
		FROM AnypointOrganization__c
		WHERE Id =:orgMasterParent.Id];
		System.debug(LoggingLevel.ERROR, 'masterParent ---> '+masterParent);
		System.assertEquals(1,masterParent[0].Master_Parent_Prod_Vcores_Total__c);
		System.assertEquals(3,masterParent[0].Master_Parent_Prod_Vcores_Used__c);
		System.assertEquals(1,masterParent[0].Master_Parent_PreProd_Vcores_Total__c);
		System.assertEquals(5,masterParent[0].Master_Parent_PreProd_Vcores_Used__c);

		delete orgChild;

		List<AnypointOrganization__c> afterDelete = [SELECT  Master_Parent_PreProd_Vcores_Total__c,
				Master_Parent_PreProd_Vcores_Used__c,
				Master_Parent_Prod_Vcores_Total__c,Master_Parent_Prod_Vcores_Used__c
		FROM AnypointOrganization__c
		WHERE Id =:orgMasterParent.Id];
		System.debug(LoggingLevel.ERROR, 'afterDelete ---> '+afterDelete);
		System.assertEquals(1,afterDelete[0].Master_Parent_Prod_Vcores_Total__c);
		System.assertEquals(2,afterDelete[0].Master_Parent_Prod_Vcores_Used__c);
		System.assertEquals(1,afterDelete[0].Master_Parent_PreProd_Vcores_Total__c);
		System.assertEquals(3,afterDelete[0].Master_Parent_PreProd_Vcores_Used__c);
	}
}