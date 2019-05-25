@isTest
public class CMsOrg62AccWidgetOnAccControllerTest { 
    
    /*public static testMethod void createAccount(){
		Account acc = new Account();
        acc.ORG62_Account_ID__c = '001300000076v5SAAQ';
        acc.Name = 'Org62 COV Test Account';
        acc.Sales_Ready__c = true;
        acc.Type = 'Distributor';
        acc.BillingCountry = 'US';
        insert acc;   
    } */

    public static testMethod void testOrg62AccountVisibility(){
        Account acc = new Account();
        acc.ORG62_Account_ID__c = '001300000076v5SAAQ';
        acc.Name = 'Org62 COV Test Account';
        acc.Sales_Ready__c = true;
        acc.Type = 'Distributor';
        acc.BillingCountry = 'US';
        insert acc;              
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        CMsOrg62AccountWidgetOnAccController controller = new CMsOrg62AccountWidgetOnAccController(stdController);
        //controller.currentAccount = acc;
        controller.testCoverage(acc.id); 
        controller.getOrg62Accounts();        
        
       /* CMsOrg62OpptyWidgetOnAccController opptyController = new CMsOrg62OpptyWidgetOnAccController(stdController);
        opptyController.testCoverage(acc.id); 
        opptyController.getOrg62Opportunities();  

        CMsOrg62RedAccountWidgetOnAccController redController = new CMsOrg62RedAccountWidgetOnAccController(stdController);
        redController.testCoverage(acc.id); 
        redController.getorg62RedAccounts();  */        

    }
    
    public static testMethod void testOrg62OpptyVisibility(){
        Account acc = new Account();
        acc.ORG62_Account_ID__c = '001300000076v5SAAQ';
        acc.Name = 'Org62 COV Test Account';
        acc.Sales_Ready__c = true;
        acc.Type = 'Distributor';
        acc.BillingCountry = 'US';
        insert acc;                            
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        CMsOrg62OpptyWidgetOnAccController opptyController = new CMsOrg62OpptyWidgetOnAccController(stdController);
        opptyController.testCoverage(acc.id); 
        opptyController.getOrg62Opportunities();  
    
    }
    
    public static testMethod void testOrg62RedAccountVisibility(){
        Account acc = new Account();
        acc.ORG62_Account_ID__c = '001300000076v5SAAQ';
        acc.Name = 'Org62 COV Test Account';
        acc.Sales_Ready__c = true;
        acc.Type = 'Distributor';
        acc.BillingCountry = 'US';
        insert acc;               

        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        CMsOrg62RedAccountWidgetOnAccController redController = new CMsOrg62RedAccountWidgetOnAccController(stdController);
        redController.testCoverage(acc.id); 
        redController.getorg62RedAccounts();  
    }
}