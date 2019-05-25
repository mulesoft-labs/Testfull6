@isTest
public class CMsUserTriggerHandlerTest {

    static testMethod void testApprovalRecordCreated() {
        User testUser =  TestDataFactory.createUser('2_18 Sales Hybrid','EMEA-Sales-UK-RMT-Commercial',false);
        testUser.FirstName = 'MrUser First Name';
        Test.startTest();
        insert testUser;
        Test.stopTest();
		System.debug(LoggingLevel.ERROR, ' --> testUser --> '+testUser);

        //Validate that the Approval Record created successfully
        List<sbaa__Approver__c> approversInsert = [SELECT Name, sbaa__User__c, sbaa__NextApprover__c FROM sbaa__Approver__c];
        System.assertEquals('MrUser First Name MrUser Last Name',approversInsert[0].Name);
        System.assertEquals(testUser.Id,approversInsert[0].sbaa__User__c);

        //Validate "Allow forecasting" flag is checked
        User u = [SELECT ForecastEnabled FROM User where id = :testUser.Id];
        System.assertEquals(true,u.ForecastEnabled);
    }

    static testMethod void testPermissionSetAssignmentTo2_18_profiles() {
        User testUser =  TestDataFactory.createUser('2_18 Sales Hybrid','EMEA-Sales-UK-RMT-Commercial',false);
        Test.startTest();
        insert testUser;
        Test.stopTest();
        //Validate that the below Permission Sets are assigned to the user:
        //- ReferenceView - User
        //- ReferenceView - User Supplemental
        List<PermissionSetAssignment> permissionSets = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:testUser.Id];
        System.assertEquals(3,permissionSets.size());
    }

    static testMethod void testPermissionSetAssignmentToRVP() {
        User testUser =  TestDataFactory.createUser('2_18 Manager','NA-Sales-East-RVP',false);
        Test.startTest();
        insert testUser;
        Test.stopTest();
        // Validate that the below Permission Sets are assigned to the user:
        //For RVP —> assign —> Forecasting - Access to Override Forecast.
        List<PermissionSetAssignment> permissionSets = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:testUser.Id];
        System.assertEquals(4,permissionSets.size());
    }

    static testMethod void testPermissionSetAssignmentToVP() {
        User testUser =  TestDataFactory.createUser('2_18 Manager','NA-Sales-VP',false);
        Test.startTest();
        insert testUser;
        Test.stopTest();
        //Validate that the below Permission Sets are assigned to the user:
        //For VP —> assign —> "Forecasting - Access to View All Forecast" and "Forecasting - Access to Override Forecast."
        List<PermissionSetAssignment> permissionSets = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:testUser.Id];
        System.assertEquals(5,permissionSets.size());
    }

    static testMethod void testPermissionSetAssignmentToScLead() {
        User testUser =  TestDataFactory.createUser('2_18 Solution Consultant','EMEA-SC Lead',false);
        Test.startTest();
        insert testUser;
        Test.stopTest();
        // Validate that the below Permission Sets are assigned to the user:
        //For SC Lead Role—> assign —> SC Leads Update Opp Teams
        List<PermissionSetAssignment> permissionSets = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:testUser.Id];
        System.assertEquals(4,permissionSets.size());
    }

    static testMethod void testValidateManagedPackageLicensesRemoved() {
        User testUser =  TestDataFactory.createUser('2_18 ADR',Label.TestClassRoleName,false);
        testUser.IsActive = true;
        insert testUser;
        List<PackageLicense> mpLicenses = [SELECT Id FROM PackageLicense where NamespacePrefix IN ('SBQQ')];
        List<UserPackageLicense> upls = new List<UserPackageLicense>();
        for(PackageLicense pl: mpLicenses){
            UserPackageLicense upl = new UserPackageLicense();
            upl.PackageLicenseid = pl.Id;
            upl.Userid = testUser.Id;
            upls.add(upl);
        }

        insert upls;

        List<UserPackageLicense> mplicensesAssignedToUser = [SELECT id,PackageLicenseid,Userid FROM UserPackageLicense WHERE Id =:upls];
        System.assertEquals(1,mplicensesAssignedToUser.size());

        testUser.IsActive = false;
        Test.startTest();
        update testUser; //This will execute the update Trigger and remove all licenses
        Test.stopTest();
        //Validate that the ManagedPackage License is Removed
        List<UserPackageLicense> mplicensesAssignedToUserLatest = [SELECT id,PackageLicenseid,Userid FROM UserPackageLicense WHERE Id =:upls];
        System.assertEquals(0,mplicensesAssignedToUserLatest.size());
    }

    static testMethod void testValidateChangeInRoleFromRvpToVP() {
        User testUser =  TestDataFactory.createUser('2_18 Manager','NA-Sales-East-RVP',false);
        insert testUser;
        // Validate that the below Permission Sets are assigned to the user:
        //For RVP —> assign —> Forecasting - Access to Override Forecast.
        List<PermissionSetAssignment> permissionSets = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:testUser.Id];
        System.assertEquals(4,permissionSets.size());
        testUser.UserRoleId = [SELECT id, name from userrole WHERE name = 'NA-Sales-VP'].Id;
        Test.startTest();
        update testUser; //This will execute the update Trigger and add "Forecasting - Access to View All Forecast" permissionset
        Test.stopTest();
        //Validate that the ManagedPackage License is Removed
        List<PermissionSetAssignment> permissionSetsNew = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:testUser.Id];
        System.assertEquals(5,permissionSetsNew.size());
    }
    static testMethod void testValidatePopulationOfFieldsBasedOnRole() {
        User sysAdmin = [Select Id FROM User WHERE Profile.Name='System Administrator' and isactive=true limit 1];
        System.runas(sysAdmin){
            createUserRoleMapping();
            User testUser =  TestDataFactory.createUser('2_18 Manager','NA-Sales-East-RVP',false);
            Test.startTest();
            insert testUser;
            Test.stopTest();

            User u = [SELECT Territory__c,Sales_Region__c, Function__c,
                    User_Function_Detail__c,Sales_Manager__c
            FROM User WHERE id = :testUser.Id];
            System.debug(LoggingLevel.ERROR,'u --> '+u);

            System.assertEquals('APAC',u.Territory__c);
            System.assertEquals('ASIA',u.Sales_Region__c);
            System.assertEquals('Sales',u.Function__c);
            System.assertEquals('RVP',u.User_Function_Detail__c);
            System.assertEquals(true,u.Sales_Manager__c);
        }
    }

    public Static void createUserRoleMapping(){
        User_Role_Mapping__c urm = new User_Role_Mapping__c();
        urm.Name ='NA-Sales-East-RVP';
        urm.Role_Developer_Name__c ='NA_Sales_East_RVP';
        urm.Theater__c = 'APAC';
        urm.User_Sales_Region__c ='ASIA';
        urm.User_Function__c ='Sales';
        urm.User_Function_Detail__c  ='RVP';
        urm.Sales_Manager_Indicator__c   = true;
        insert urm;
    }

}