/*
* Name : SetupController
* Author : Rohit Mehta (Apprivo)
* Date : 12/8/2010 
* Updated :2/9/2010
* Usage : This class saves fields value in custom settings
*/
public with sharing class SetupController {
    //get set of object ATST_Settings__c
    public ATST_Settings__c atstSettings {get;set;}
    public String strRecordArr{get;set;}    
    public List<String> strRecordType{get;set;}
    public string str{get;set;}
    //Constructor to get values from util class FOR ATST_Settings__c value
    public SetupController() {
        this.atstSettings =  Util.getSettings();
        List<ATST_Settings__c> l = [select Lead_Record_Types__c,Internal_Team_Member_Role__c, 
        	Partner_Team_Member_Role__c, Partner_Team_Member_Access__c, Internal_Team_Member_Access__c  
        	from ATST_Settings__c where Name = 'Default' ];
        if (l.size() > 0)
            atstSettings = l.get(0);
        if (this.atstSettings == null) {
            atstSettings = new ATST_Settings__c(Name=Util.CONFIG_NAME);           
        }
        strRecordType = csvToList(this.atstSettings.Lead_Record_Types__c);
        //strRecordType = this.atstSettings.Lead_Record_Types__c;
/*        System.debug('strRecordType'+ strRecordType ); 
        List<RecordType> recordID =[select name from RecordType where id =:strRecordType  and sObjecttype = 'Lead'];
        System.debug('record type for name='+ recordID);
        List<RecordType> recordIDd =[select name from RecordType where id =:'012A0000000CzIrIAK' and sObjecttype = 'Lead'];            
        System.debug('record type for name='+ recordIDd);*/
    }
        
    //Upsert record ATST_Settings__c records       
    public PageReference onSave(){
      System.debug('onSave');
      if (strRecordType != null && strRecordType.size() > 0) {
          this.atstSettings.Lead_Record_Types__c = listToCsv(strRecordType);
      } else {
          this.atstSettings.Lead_Record_Types__c = null;
      }
      if (this.atstSettings.Lead_Record_Types__c == null) {
      	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lead Record Type is required.'));
      	return null;
      }
      upsert this.atstSettings ;       
      System.debug('this.atstSettings'+this.atstSettings);
      return new PageReference('/0A3');  
    }
    
    //method for cancel button
    public PageReference onCancel() {   
        return new PageReference('/0A3');  
    }
    
    //method for Lead Record Types picklist
    public List<SelectOption> getRecordTypeList() {    
        List<RecordType> recordID=[select id,name from RecordType where sObjecttype = 'Lead'];
        List<SelectOption> options = new List<SelectOption>();
        for(RecordType r : recordID){                
            options.add(new SelectOption(r.id ,r.name));
        }
        return options;
    }
    
    //method for Internal Access team picklist
    public List<SelectOption> getInternalAccessList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None' ,'None')); 
        options.add(new SelectOption('Read' ,'Read' ));
        options.add(new SelectOption('Edit' ,'Edit')); 
        return options;
    }
    
    // method for PartnerAccess team picklist  
    public List<SelectOption> getPartnerAccessList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Read' ,'Read' ));
        options.add(new SelectOption('Edit' ,'Edit')); 
        return options;
    } 
    public List<String> stringToList(String strRecord){        
        List<String> strRecordArr = new  List<String>();
        if(strRecord !=null){
            strRecordArr = strRecord.split(';');
        }
        else{
            strRecordArr = new  List<String>();
        }
        return strRecordArr;
    }
    public List<String> csvToList(String strRecord){
        //string strRecord = this.atstSettings.Lead_Record_Types__c;
        List<String> strRecordArr = new  List<String>();
        if(strRecord !=null){
            strRecordArr = strRecord.split(';');
        }               
        return strRecordArr;
    }
    public String listToCsv(List<String> recordList){   
        if ( recordList == null || recordList.isEmpty()) return '';    
        String strRecord='';
        for(String s : recordList){                
            strRecord = strRecord + s + ';' ;
        }
        System.debug('strRecord='+strRecord );
        strRecord = strRecord.subString(0, strRecord.length()-1);
        System.debug('new strRecord='+strRecord );
        return strRecord ;
    }
}