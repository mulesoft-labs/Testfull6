@isTest
private class CaseConnectorsListTest
{
  public static testMethod void TestController()
  {
    //create test Account
    List<Account> testAccountList = TestdataFactory.createAccounts(1, true, null);
    Case testCase = new Case(Subject = 'Test Case', AccountId = testAccountList[0].Id);
    insert testCase;

    //create an extension
    Extension__c ext = new Extension__c();
    ext.Name = 'Test Ext';
    ext.Function__c = 'B2B';
    ext.Status__c = 'Available';
    insert ext;

    //creat an Extension Version
    Extension_Version__c extVer = new Extension_Version__c();
    extver.Name = 'test ext ver';
    extVer.Extension__c = ext.Id;
    extVer.Encryption__c = 'test';
    extVer.Export_Compliance__c = 'test';
    insert extVer;

    ApexPages.StandardController standardController = new ApexPages.StandardController(testCase);
    CaseConnectorsList controller = new CaseConnectorsList(standardController);


    controller.selectedConnectors = new string [] {extVer.Id};
    controller.AddConnectors();
    System.assert(controller.getChildCount() == 1);

    controller.selectedConnectorId = controller.caseConnectors[0].Id;
    controller.DeleteConnector();

    controller.closePopup();
    System.assert(controller.displayPopup == false);

    controller.showPopup();
    System.assert(controller.displayPopup == true);
  }

}