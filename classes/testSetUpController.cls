@isTest
private class testSetUpController {

    public static testmethod void testSetUpController(){
        System.debug('########SetupController -Start '); 
        SetupController controller1 = new SetupController();    
        controller1.strRecordType = controller1.stringToList(controller1.atstsettings.Lead_Record_Types__c);        
        controller1.onSave();
        //Util.createSettings();       
        SetupController controller = new SetupController(); 
        //controller.atstSettings =  Util.getSettings(); 
        controller.atstSettings = new ATST_Settings__c(Name=Util.CONFIG_NAME);
        controller.getRecordTypeList();
        controller.getInternalAccessList();
        controller.getPartnerAccessList();        
        //controller.onSave();
        PageReference objPage2=controller.onCancel();         
        System.assertEquals(new PageReference('/0A3').getURL(),objPage2.getURL());
        System.debug('########SetupController -End'); 
    }
   /* public static testmethod Void testUtil(){
    
        //return atstSettings;
       Util.getSettings();
       }*/
}